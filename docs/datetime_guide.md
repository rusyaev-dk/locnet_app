# Работа с датой и временем в locnet_app

## Главное правило

```
Парсинг → UTC  |  Хранение → UTC  |  Сравнения → UTC  |  UI → toLocal()
```

Сервер всегда отдаёт время в UTC. Клиентский часовой пояс не важен
вплоть до момента отображения пользователю.

---

## DateTimeFormatter.parse

Используется во всём проекте для парсинга дат с сервера.

**Для строк** (`"2026-05-11T14:30:00Z"`) вызывает `DateTime.parse()`,
который корректно возвращает UTC если строка содержит `Z` или `+00:00`.  
⚠️ Если сервер вернёт строку **без timezone-суффикса** (`"2026-05-11T14:30:00"`),
`DateTime.parse` вернёт **локальное** время — баг на стороне сервера,
но клиент должен это учитывать. При нормализации Go-формата в репозиториях
всегда добавлять `.toUtc()` после парсинга.

**Для int (Unix timestamp)** — уже использует `isUtc: true`. ✓

**Правило при вызове:** результат `DateTimeFormatter.parse` всегда
гарантированно UTC, если строка пришла с сервера с суффиксом `Z`.
Для защиты можно добавить `.toUtc()` явно:

```dart
createdAt: DateTimeFormatter.parse(json['createdAt']).toUtc(),
```

---

## DateTime.now()

`DateTime.now()` возвращает **локальное** время устройства.  
Для любых бизнес-операций (сравнения, запись в БД, создание pending-объектов)
всегда использовать `.toUtc()`:

```dart
// ✗ Неправильно
final DateTime now = DateTime.now();

// ✓ Правильно
final DateTime now = DateTime.now().toUtc();
```

**Где это нарушено в проекте сейчас:**
- `private_conversation_bloc.dart` — несколько вхождений `DateTime.now()` без `.toUtc()`
- `jwt_interceptor.dart` — `DateTime.now()` при сравнении с `accessExpiresAt`
- `mock_auth_repo.dart` — `DateTime.now()` при создании сессии
- `conversation_tile_mapper.dart` — `createdAt: DateTime.now()` при fallback

---

## Сравнения (session expiry, cache expiry)

В Dart сравнение UTC и local DateTime технически работает корректно
(Dart преобразует оба к UTC внутри), но для явности и безопасности
всегда приводить оба операнда к UTC:

```dart
// jwt_interceptor.dart — как должно быть
final DateTime now = DateTime.now().toUtc();
if (session.accessExpiresAt.toUtc().isAfter(now)) { ... }

// Проверка истечения refresh token
if (!session.refreshExpiresAt.toUtc().isAfter(now)) {
  throw ApiUnauthorizedException(message: 'Refresh token expired');
}
```

---

## Хранение в Drift

Drift хранит даты как `INTEGER` (milliseconds since epoch) — это
**timezone-agnostic**, что само по себе правильно.

⚠️ Проблема при **чтении**: `DateTime.fromMillisecondsSinceEpoch(ms)`
без `isUtc: true` возвращает **локальное** время, хотя данные UTC.
Это означает, что `dateTime.isUtc == false`, и если потом передать
такой объект в функцию форматирования — получим правильное значение
только случайно (потому что Dart сравнивает через epoch).

**Правило:** при чтении из Drift всегда использовать `isUtc: true`:

```dart
// ✗ Сейчас в private_message_mapper.dart
createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs),

// ✓ Должно быть
createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs, isUtc: true),
```

При **записи** в Drift `.millisecondsSinceEpoch` не зависит от timezone,
поэтому `DateTime.now().toUtc().millisecondsSinceEpoch` и
`DateTime.now().millisecondsSinceEpoch` дают одно и то же число.
Тем не менее для консистентности писать с `.toUtc()`.

---

## Отображение в UI

Только здесь конвертировать в локальное время пользователя:

```dart
// DateTimeFormatter.formatLocalized — добавить toLocal() перед форматированием
static String formatLocalized(DateTime dateTime, {String? locale}) {
  final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm', locale);
  return formatter.format(dateTime.toLocal()); // ← toLocal() обязательно
}

// formatConversationTime — передавать уже локальное время
timeText = DateTimeFormatter.formatConversationTime(
  dateTime: lastAt.toLocal(), // ← конвертируем перед передачей
  now: DateTime.now(),        // DateTime.now() — уже локальное, ОК для UI
  ...
);
```

---

## Итоговая шпаргалка

| Ситуация | Что делать |
|---|---|
| Парсинг JSON с сервера | `DateTimeFormatter.parse(raw).toUtc()` |
| Текущий момент для бизнес-логики | `DateTime.now().toUtc()` |
| Текущий момент для UI | `DateTime.now()` (local — ОК) |
| Запись в Drift | `.millisecondsSinceEpoch` от UTC DateTime |
| Чтение из Drift | `DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true)` |
| Сравнение двух дат | `a.toUtc().isAfter(b.toUtc())` |
| Передача во Flutter-форматтер | `.toLocal()` перед вызовом |
| Сохранение в `toIso8601String()` | Вызывать на UTC DateTime — строка будет с `Z` |
