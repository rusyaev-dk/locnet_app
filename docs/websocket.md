# WebSocket для фронтенда (Gateway, приватный чат)

Документ для интеграции **real-time уведомлений** о личных сообщениях. Полный REST (отправка, история, ошибки) — в [FRONTEND_GATEWAY_API.md](./FRONTEND_GATEWAY_API.md).

### Главная страница «как в Telegram»

Целевой UX — **один экран со списком всех разговоров** (лички, позже группы и каналы), где строки **живут обновлениями** без полного рефетча: новый чат, новое сообщение, превью текста, порядок по времени.

**Сейчас в gateway реализован только блок личных чатов** (`/private-chats` + события ниже). **Группы и каналы** в API поиска пока пустые резервы; для них понадобятся отдельные сервисы и **свои** Socket.IO-события (по тому же принципу: персональная комната `user_<id>`, push после успешного HTTP). Клиент главной может уже сейчас держать **один** сокет и вешать обработчики на `private_*`; позже рядом добавятся, например, `group_*` / `channel_*`.

**Кратко:**

- Сокет нужен только чтобы **слушать** события от сервера (`socket.on`).
- **Создание, правка и удаление сообщений** делайте **только через HTTP**. После успешного ответа gateway сам рассылает события в Socket.IO — отдельно `emit` с клиента для этого не предусмотрено.
- **Список личных чатов на главной:** подпишитесь на **`private_conversation_upsert`** (появление/обновление диалога) и на **`new_private_message`** (превью последнего сообщения и сортировка по **`conversationUpdatedAt`**).
- После успешного `connect` сервер уже поместил сокет в персональную комнату; **ручного `join` с клиента не требуется** и отдельного события «подписаться на диалог» нет.

---

## Как это устроено

```mermaid
sequenceDiagram
  participant ClientA as Client_A
  participant Gateway as Gateway_HTTP_WS
  participant Backend as Private_service
  participant ClientB as Client_B

  ClientA->>Gateway: POST messages
  Gateway->>Backend: gRPC
  Backend-->>Gateway: OK
  Gateway-->>ClientA: HTTP 200
  Gateway->>ClientA: new_private_message user_room_A
  Gateway->>ClientB: new_private_message user_room_B
```

Оба участника диалога получают одни и те же типы событий в своей комнате `user_<userId>` — удобно для нескольких вкладок и устройств.

---

## 1. Зависимость и подключение

Установите клиент Socket.IO v4:

```bash
npm install socket.io-client
```

**Базовый URL** — тот же хост/порт, что и у REST gateway (например `http://localhost:3000`). В первый аргумент `io()` передавайте **`http://` или `https://`**. Схема `ws://` для handshake не рекомендуется. Путь по умолчанию: **`/socket.io/`**.

Рекомендуемый вариант авторизации — поле **`auth.token`** (сырой JWT **без** префикса `Bearer`):

```javascript
import { io } from 'socket.io-client';

const socket = io('http://localhost:3000', {
  auth: {
    token: accessToken,
  },
  transports: ['websocket'],
});
```

**Альтернатива** — заголовок (удобно не в браузере, а в Node/нативных клиентах; в браузере `extraHeaders` может быть недоступен):

```javascript
const socket = io('http://localhost:3000', {
  extraHeaders: {
    Authorization: `Bearer ${accessToken}`,
  },
  transports: ['websocket'],
});
```

На сервере префикс `Bearer ` снимается только с заголовка; в `auth.token` передавайте токен как есть.

После успешной верификации JWT пользователь из `sub` попадает в комнату **`user_<userId>`** автоматически — **ничего дополнительно вызывать не нужно**.

---

## 2. Жизненный цикл сокета

Подпишитесь на служебные события до или сразу после создания `socket` (порядок регистрации обработчиков до `connect` нормален).

| Событие | Что делать |
|--------|------------|
| **`connect`** | Считать канал готовым к приёму `private_conversation_upsert`, `new_private_message` и др. Можно снять флаг «переподключаемся». |
| **`disconnect`** | По желанию: индикатор офлайна, отложенный рефетч списков при возврате в `connect`. |
| **`connect_error`** | Сеть, неверный URL, CORS, недоступный сервер — до успешного handshake. Показать ошибку / повтор с backoff. |
| **`error`** | Отказ при подключении (часто невалидный или просроченный JWT). Тело см. ниже; соединение обычно закрывается. |

**Просроченный access token:** после `POST /auth/refresh` переподключите сокет с новым токеном. Практичные варианты:

- создать **новый** клиент: `oldSocket.disconnect()`, затем `io(url, { auth: { token: newAccess }, transports: ['websocket'] })`;
- или у одного инстанса: `socket.auth = { token: newAccess }; socket.disconnect(); socket.connect();` (актуально для версий клиента, где поддерживается смена `auth`).

---

## 3. События чата: скелет подписок

Все имена совпадают с [`ws-events.constant.ts`](../apps/gateway-service/src/messenger/constants/ws-events.constant.ts).

```javascript
socket.on('private_conversation_upsert', (payload) => {
  // Список чатов: вставить или обновить карточку по payload.conversationId
  // Собеседник: тот из user1Id / user2Id, кто не равен текущему user.id
});

socket.on('new_private_message', (payload) => {
  // Лента чата: сообщение по conversationId
  // Список чатов: обновить превью (text, senderId, createdAt), поднять чат вверх по payload.conversationUpdatedAt
});

socket.on('private_message_edited', (payload) => {
  // Обновить текст и признак «изменено» для payload.messageId
});

socket.on('private_message_deleted', (payload) => {
  // Плейсхолдер «удалено» для payload.messageId или сверка с GET истории
});
```

| Событие | Когда приходит | Действие в UI |
|--------|----------------|---------------|
| **`private_conversation_upsert`** | После успешного **`POST /private-chats/conversations`** (создание или восстановление), **`PUT .../conversations/:id`** (в т.ч. soft-delete), **`DELETE .../conversations/:id`** | Обновить или добавить строку в списке чатов: `conversationId`, `user1Id`, `user2Id`, `createdAt`, `updatedAt`, `isDeleted`. Оба участника получают одно и то же тело (как в gRPC `ConversationResponse`). |
| **`new_private_message`** | После успешного `POST /private-chats/conversations/:conversationId/messages` | Вставить сообщение в ленту; по `senderId` отличать входящее/исходящее. На главной: обновить превью и сортировку (`conversationUpdatedAt`, `text`, `createdAt`). |
| **`private_message_edited`** | После успешного `PATCH /private-chats/conversations/:conversationId/messages/:messageId` | Обновить текст/`editedAt` для `messageId` (редактировать может только автор). Превью в списке, если это последнее сообщение, можно обновить по этому событию или перезапросить плитки. |
| **`private_message_deleted`** | После успешного `DELETE /private-chats/conversations/:conversationId/messages/:messageId` | Soft-delete в UI; при необходимости уточнить поля через `GET .../messages`. |

Для этих событий в payload может приходить опциональное поле **`correlationId`** (UUID v4) — то же значение, что в заголовке **`X-Correlation-Id`** HTTP-ответа, который инициировал рассылку. Его можно использовать для связки REST и push в логах/аналитике; клиенты без поддержки поля могут игнорировать его.

Событие **`error`** при отказе в подключении:

```json
{
  "message": "Unauthorized connection",
  "details": "jwt expired",
  "correlationId": "550e8400-e29b-41d4-a716-446655440000"
}
```

Поле **`correlationId`** здесь генерируется отдельно на попытку подключения (нет привязки к HTTP-запросу).

---

## 4. Гонки, HTTP и дедупликация

- Push уходит **после** успешного HTTP. Если в этот момент сокет **ещё не подключён**, событие **не буферизуется** для клиента — его вы не получите позже.
- **Источник истины при открытии экрана чата** — `GET /private-chats/conversations/:conversationId/messages` (и ответ `POST` при отправке). Сокет дополняет live-обновлениями.
- **Оптимистичный UI:** привяжите черновик к `clientMessageId`, после ответа `POST` подставьте `messageId`. Со своей же отправки вы можете получить **`new_private_message` с тем же `messageId`** — храните сообщения по **`messageId`** и не дублируйте запись.

---

## 5. Поля payload (справка)

Типы на сервере: [`ws-message.dto.ts`](../apps/gateway-service/src/messenger/dtos/ws-message.dto.ts). Даты часто приходят **строками в Go-формате**; опциональные поля иногда как **пустые строки** `""` — закладывайте парсинг/проверку на пустоту.

**`private_conversation_upsert`:** `conversationId`, `user1Id`, `user2Id`, `createdAt`, `updatedAt`, `isDeleted`, опционально **`correlationId`**.

**`new_private_message`** — ключевые поля: `messageId`, `clientMessageId`, `conversationId`, `senderId`, `text`, `hasAttachments`, `attachments`, `replyToMessageId`, `isPinned`, `editedAt`, `isDeleted`, `deletedAt`, `createdAt`, `updatedAt`, `deliveryStatus` (аналог `status` в HTTP-ответе отправки), опционально **`conversationUpdatedAt`** (время строки диалога после отправки — для сортировки списка), опционально **`correlationId`**.

**`private_message_edited`:** `messageId`, `conversationId`, `senderId`, `text`, `editedAt`, `updatedAt`, `clientMessageId` (опционально), опционально **`correlationId`**.

**`private_message_deleted`:** `messageId`, `conversationId`, `deletedById`, `deletedAt`, `isDeleted`, опционально **`correlationId`**.

Компактные примеры:

```json
{
  "messageId": "91ca086a-645d-43d6-825b-b829c0ab2e88",
  "clientMessageId": "",
  "conversationId": "80068ed0-e7fc-4e33-a4a8-3d0cc3965de2",
  "senderId": "fea175c6-a326-4400-bcc2-ce73b88634c5",
  "text": "привет",
  "hasAttachments": false,
  "attachments": [],
  "replyToMessageId": "",
  "isPinned": false,
  "editedAt": "",
  "isDeleted": false,
  "deletedAt": "",
  "createdAt": "2026-03-25 15:02:32.271023728 +0000 UTC",
  "updatedAt": "2026-03-25 15:02:32.271023728 +0000 UTC",
  "deliveryStatus": "SENT",
  "conversationUpdatedAt": "2026-03-25 15:02:32.271023728 +0000 UTC",
  "correlationId": "550e8400-e29b-41d4-a716-446655440000"
}
```

```json
{
  "conversationId": "80068ed0-e7fc-4e33-a4a8-3d0cc3965de2",
  "user1Id": "fea175c6-a326-4400-bcc2-ce73b88634c5",
  "user2Id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "createdAt": "2026-03-25 14:00:00.000000000 +0000 UTC",
  "updatedAt": "2026-03-25 15:02:32.271023728 +0000 UTC",
  "isDeleted": false,
  "correlationId": "550e8400-e29b-41d4-a716-446655440001"
}
```

```json
{
  "messageId": "6e3bf45a-b57c-4aeb-9bf2-18146403a294",
  "conversationId": "80068ed0-e7fc-4e33-a4a8-3d0cc3965de2",
  "senderId": "fea175c6-a326-4400-bcc2-ce73b88634c5",
  "text": "исправленный текст",
  "editedAt": "2026-03-25 15:02:40.708829978 +0000 UTC",
  "updatedAt": "2026-03-25 15:02:40.709045423 +0000 UTC",
  "clientMessageId": ""
}
```

```json
{
  "messageId": "6e3bf45a-b57c-4aeb-9bf2-18146403a294",
  "conversationId": "80068ed0-e7fc-4e33-a4a8-3d0cc3965de2",
  "deletedById": "fea175c6-a326-4400-bcc2-ce73b88634c5",
  "deletedAt": "2026-03-25 15:02:40.731739972 +0000 UTC",
  "isDeleted": true
}
```

---

## 6. Что не слать через сокет

Не используйте **`emit`** для отправки, правки или удаления сообщений — обработчиков под это на gateway нет.

| Действие | HTTP |
|----------|------|
| Новое сообщение | `POST /private-chats/conversations/:conversationId/messages` |
| Редактирование | `PATCH /private-chats/conversations/:conversationId/messages/:messageId` |
| Удаление | `DELETE /private-chats/conversations/:conversationId/messages/:messageId` |

---

## 7. Масштабирование и отладка

Между инстансами gateway используется **Redis**-адаптер Socket.IO: клиенту всё равно, к какому инстансу пришёл HTTP — push дойдёт в нужную комнату.

Реализация: [`chat.gateway.ts`](../apps/gateway-service/src/messenger/chat.gateway.ts). Скрипты для проверки: [`scripts/ws-sniff.js`](../scripts/ws-sniff.js), [`scripts/ws-sniff-edit-delete.js`](../scripts/ws-sniff-edit-delete.js), сценарий [`scripts/e2e-full-flow.sh`](../scripts/e2e-full-flow.sh).