# Спецификация API и моделей для бэкенда (LocNet App)

Документ описывает DTO-модели (в соответствии с `lib/**/data/models/*.dart`) и необходимые HTTP endpoint'ы по фичам приложения.

---

## 1. Модели (DTO)

### 1.1 Auth

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **SessionDto** | sessionId | sessionId | string |
| | userId | userId | string |
| | refreshToken | refreshToken | string |
| | accessToken | accessToken | string |
| | expiresAt | expiresAt | datetime (ISO8601) |
| | isExpired | isExpired | bool |
| | isTerminated | isTerminated | bool? |
| | terminatedAt | terminatedAt | datetime? |
| | ipAddress | IPAddress или ipAddress | string? |
| | macAddress | macAddress | string? |
| | deviceName | deviceName | string? |
| | deviceType | deviceType | string? |
| | os | OS или os | string? |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **DeviceInfoDto** | ipAddress | IPAddress | string? |
| | macAddress | macAddress | string? |
| | deviceName | deviceName | string? |
| | deviceType | deviceType | string? |
| | operatingSystem | OS | string? |

### 1.2 Core (User, Bans)

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **UserDto** | userId | userId | string |
| | username | username | string |
| | firstName | firstName | string |
| | lastName | lastName | string |
| | patronymic | patronymic | string? |
| | languageCode | languageCode | string |
| | description | description | string? |
| | avatarId | avatarId | string? |
| | isDeleted | isDeleted | bool |
| | isBanned | isBanned | bool |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **BannedUserDto** | id | id | string |
| | userId | userId | string |
| | scope | scope | string ("global" \| "conversation") |
| | bannedBy | bannedBy | string |
| | conversationId | conversationId | string? |
| | reason | reason | string? |
| | createdAt | createdAt | datetime |

### 1.3 Messages (общие)

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **MessageDto** | messageId | messageId | string |
| | clientMessageId | clientMessageId | string |
| | conversationId | conversationId | string |
| | senderId | senderId | string |
| | text | text | string? |
| | hasAttachments | hasAttachments | bool |
| | attachments | attachments | MessageAttachmentDto[] |
| | replyToMessageId | replyToMessageId | string? |
| | isPinned | isPinned | bool? |
| | editedAt | editedAt | datetime? |
| | isDeleted | isDeleted | bool? |
| | deletedAt | deletedAt | datetime? |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | deliveryStatus | deliveryStatus | string |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **MessageAttachmentDto** | clientAttachmentId | clientAttachmentId | string |
| | attachmentId | attachmentId | string? |
| | messageId | messageId | string? |
| | fileId | fileId | string? |
| | position | position | int? |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **MessageReadDto** | messageReadId | messageReadId | string |
| | messageId | messageId | string |
| | userId | userId | string |
| | readAt | readAt | datetime |

### 1.4 Conversations list

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **ConversationTileDto** | id | id | string |
| | type | type | string ("private" \| "group" \| "channel") |
| | title | title | string |
| | description | description | string? |
| | companion | companion | UserDto? |
| | lastMessageText | lastMessageText | string? |
| | lastMessageSenderId | lastMessageSenderId | string? |
| | lastMessageAt | lastMessageAt | datetime? |
| | updatedAt | updatedAt | datetime |

### 1.5 Unified search

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **UnifiedSearchResultDto** | users | users | UserDto[] |
| | conversations | conversations | UnifiedSearchConversationDto[] |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **UnifiedSearchConversationDto** | id | id | string |
| | type | type | string ("private" \| "group" \| "channel") |
| | title | title | string |
| | description | description | string? |

### 1.6 Private conversations

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **PrivateConversationDto** | conversationId | conversationId | string |
| | user1Id | user1 | string |
| | user2Id | user2 | string |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | isDeleted | isDeleted | bool |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **PrivateMessageDto** | id | id | string |
| | conversationId | conversationId | string |
| | senderId | senderId | string |
| | text | text | string |
| | attachments | attachments | PrivateMessageAttachmentDto[] |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | isDeleted | isDeleted | bool |
| | deletedById | deletedById | string? |
| | replyToMessageId | replyToMessageId | string? |
| | deliveryStatus | deliveryStatus | string |
| | clientMessageId | clientMessageId | string? |
| | isPinned | isPinned | bool |
| | editedAt | editedAt | datetime? |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **PrivateMessageAttachmentDto** | id | id | string |
| | messageId | messageId | string |
| | fileId | fileId | string |
| | order | order | int |
| | createdAt | createdAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **LastReadPrivateMessageDto** | id | id | string |
| | userId | userId | string |
| | messageId | messageId | string |
| | conversationId | conversationId | string |

### 1.7 Groups

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **GroupDto** | groupId | groupId | string |
| | createdById | createdById | string |
| | title | title | string |
| | description | description | string? |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | avatarFileId | avatarFileId | string? |
| | isDeleted | isDeleted | bool |
| | deletedAt | deletedAt | datetime? |
| | isPublic | isPublic | bool |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **GroupMessageDto** | id | id | string |
| | senderId | senderId | string |
| | groupId | groupId | string |
| | text | text | string |
| | attachments | attachments | GroupMessageAttachmentDto[] |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | isDeleted | isDeleted | bool |
| | deletedById | deletedById | string? |
| | replyToMessageId | replyToMessageId | string? |
| | deliveryStatus | deliveryStatus | string |
| | clientMessageId | clientMessageId | string? |
| | isPinned | isPinned | bool |
| | editedAt | editedAt | datetime? |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **GroupMessageAttachmentDto** | id | id | string |
| | messageId | messageId | string |
| | fileId | fileId | string |
| | order | order | int |
| | createdAt | createdAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **GroupParticipantDto** | id | id | string |
| | groupId | groupId | string |
| | userId | userId | string |
| | joinedAt | joinedAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **GroupAdminDto** | id | id | string |
| | groupId | groupId | string |
| | userId | userId | string |
| | role | role | string |
| | createdAt | createdAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **GroupMessageReadDto** | id | id | string |
| | messageId | messageId | string |
| | userId | userId | string |
| | readAt | readAt | datetime |

### 1.8 Channels

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **ChannelDto** | channelId | channelId | string |
| | ownerId | ownerId | string |
| | title | title | string |
| | description | description | string? |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | avatarFileId | avatarFileId | string? |
| | isDeleted | isDeleted | bool |
| | deletedAt | deletedAt | datetime? |
| | isPublic | isPublic | bool |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **ChannelPublicationDto** | publicationId | id | string |
| | channelId | channelId | string |
| | publishedById | publishedById | string |
| | text | text | string? |
| | attachments | attachments | ChannelPublicationAttachmentDto[] |
| | avatarFileId | avatarFileId | string? |
| | replyToPublicationId | replyToPublicationId | string? |
| | isDeleted | isDeleted | bool |
| | deletedById | deletedById | string? |
| | createdAt | createdAt | datetime |
| | updatedAt | updatedAt | datetime |
| | deliveryStatus | deliveryStatus | string |
| | clientPublicationId | clientPublicationId | string? |
| | isPinned | isPinned | bool |
| | editedAt | editedAt | datetime? |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **ChannelPublicationAttachmentDto** | id | id | string |
| | publicationId | publicationId | string |
| | fileId | fileId | string |
| | order | order | int |
| | createdAt | createdAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **ChannelSubscriberDto** | id | id | string |
| | userId | userId | string |
| | channelId | channelId | string |
| | joinedAt | joinedAt | datetime |

| Модель | Поле (property) | JSON ключ | Тип |
|--------|------------------|-----------|-----|
| **ChannelAdminDto** | id | id | string |
| | channelId | channelId | string |
| | userId | userId | string |
| | role | role | string |
| | createdAt | createdAt | datetime |

---

## 2. Endpoints

Авторизация: все запросы, кроме auth, ожидают заголовок `Authorization: Bearer <accessToken>`.

### 2.1 Auth (уже в ApiEndpoints)

| Метод | Путь | Описание | Request body | Response |
|-------|------|----------|--------------|----------|
| POST | /auth/register | Регистрация | username, firstName, lastName, patronymic?, description?, password, deviceInfo?: DeviceInfoDto | SessionDto |
| POST | /auth/login | Вход | username, password, deviceInfo?: DeviceInfoDto | SessionDto |
| POST | /auth/refresh | Обновление токена | refreshToken, sessionId, deviceInfo?: DeviceInfoDto | SessionDto |
| POST | /auth/logout | Выход | sessionId | — |

### 2.2 Users

| Метод | Путь | Описание | Response |
|-------|------|----------|----------|
| GET | /users | Список (при необходимости) | UserDto[] |
| GET | /users/{userId} | Профиль пользователя | UserDto |

### 2.3 Conversations list

| Метод | Путь | Описание | Query | Response |
|-------|------|----------|-------|----------|
| GET | /conversations | Список диалогов (private/group/channel) | page (int) | ConversationTileDto[] |

### 2.4 Unified search

| Метод | Путь | Описание | Query | Response |
|-------|------|----------|-------|----------|
| GET | /search/unified | Поиск по пользователям и диалогам | query, page | UnifiedSearchResultDto |

### 2.5 Private conversations

| Метод | Путь | Описание | Body/Query | Response |
|-------|------|----------|------------|----------|
| GET | /conversations/private/{conversationId} | Получить приватный диалог | — | PrivateConversationDto |
| GET | /conversations/private/{conversationId}/companion | Компаньон по диалогу | — | UserDto |
| POST | /conversations/private/{conversationId}/notifications | Вкл/выкл уведомления | enabled: bool | success |
| DELETE | /conversations/private/{conversationId} | Удалить диалог | deleteAtRecipient: bool | success |
| POST | /conversations/private/block | Заблокировать пользователя | companionId, reason | success |
| GET | /conversations/private/{conversationId}/messages | Страница сообщений | page | PrivateMessageDto[] |
| POST | /conversations/private/{conversationId}/messages | Отправить сообщение | PrivateMessageDto (create) | PrivateMessageDto |
| PUT | /conversations/private/messages/{messageId} | Редактировать сообщение | PrivateMessageDto (частично) | PrivateMessageDto |
| DELETE | /conversations/private/messages/{messageId} | Удалить сообщение | deleteAtRecipient: bool | success |

### 2.6 Groups

| Метод | Путь | Описание | Body | Response |
|-------|------|----------|------|----------|
| POST | /groups | Создать группу | creatorId, recipientsIds[], title, description?, avatarFileId? | GroupDto |
| GET | /groups/{groupId} | Получить группу | — | GroupDto |
| PUT | /groups/{groupId} | Обновить группу | GroupDto (частично) | GroupDto |
| DELETE | /groups/{groupId} | Удалить группу | — | success |
| POST | /groups/{groupId}/notifications | Уведомления | enabled: bool | success |
| GET | /groups/{groupId}/participants | Участники | — | UserDto[] или GroupParticipantDto[] |
| POST | /groups/{groupId}/participants | Добавить участника | userId | success |
| DELETE | /groups/{groupId}/participants/{userId} | Исключить / выйти | — | success |
| POST | /groups/{groupId}/bans | Забанить в группе | userId, reason? | BannedUserDto |
| GET | /groups/{groupId}/messages | Сообщения | page | GroupMessageDto[] |
| POST | /groups/{groupId}/messages | Отправить сообщение | GroupMessageDto (create) | GroupMessageDto |
| PUT | /groups/messages/{messageId} | Редактировать сообщение | GroupMessageDto (частично) | GroupMessageDto |
| DELETE | /groups/messages/{messageId} | Удалить сообщение | — | success |

### 2.7 Channels

| Метод | Путь | Описание | Body | Response |
|-------|------|----------|------|----------|
| POST | /channels | Создать канал | creatorId, subscribersIds[], title, description?, avatarFileId? | ChannelDto |
| GET | /channels/{channelId} | Получить канал | — | ChannelDto |
| PUT | /channels/{channelId} | Обновить канал | ChannelDto (частично) | ChannelDto |
| DELETE | /channels/{channelId} | Удалить канал | — | success |
| POST | /channels/{channelId}/notifications | Уведомления | enabled: bool | success |
| GET | /channels/{channelId}/subscribers | Подписчики | — | UserDto[] или ChannelSubscriberDto[] |
| POST | /channels/{channelId}/subscribers | Подписать | userId | success |
| DELETE | /channels/{channelId}/subscribers/{userId} | Отписать | — | success |
| POST | /channels/{channelId}/bans | Забанить в канале | userId, reason? | BannedUserDto |
| GET | /channels/{channelId}/publications | Публикации | page | ChannelPublicationDto[] |
| POST | /channels/{channelId}/publications | Создать публикацию | ChannelPublicationDto (create) | ChannelPublicationDto |
| PUT | /channels/publications/{publicationId} | Редактировать публикацию | ChannelPublicationDto (частично) | ChannelPublicationDto |
| DELETE | /channels/publications/{publicationId} | Удалить публикацию | — | success |

### 2.8 Bans (глобальные / по контексту)

| Метод | Путь | Описание | Body | Response |
|-------|------|----------|------|----------|
| POST | /bans | Забанить пользователя | userId, scope, conversationId?, reason? | BannedUserDto |
| GET | /bans | Список банов (при необходимости) | — | BannedUserDto[] |

### 2.9 Files (загрузка аватаров/вложений)

| Метод | Путь | Описание | Request | Response |
|-------|------|----------|--------|----------|
| POST | /files | Загрузить файл | multipart/form-data (файл) | fileId: string или объект с fileId |

---

*Модели и ключи приведены в соответствии с DTO в `lib/**/data/models/`. Даты в JSON — ISO8601 строки.*

