# Система кэширования — план реализации

## Контекст проекта

Проект `locnet_app` — Flutter-мессенджер. Архитектура трёхслойная: **Data → Domain → Presentation (BLoC/Cubit)**. DI строится через `AppProvidersWrapper` и `IAppEnvPreset`. Хранилища сейчас: `SharedPreferences` (KV для настроек) и `FlutterSecureStorage` (токены, кэш пользователя). SQLite-базы нет.

Цель: добавить персистентный кэш для списка диалогов, сообщений (private), и download-info медиафайлов. Бэкенд не меняется. BLoC и Interactor-классы не меняются.

---

## Выбор технологии: Drift

Использовать **Drift** (пакет `drift` + `drift_flutter`). Причины:
- Реляционные данные: диалог → сообщения → вложения — естественная схема с FK
- Типизированные compile-time запросы, DAO-паттерн
- Поддержка `Stream<List<T>>` из коробки (пригодится в дальнейшем)
- Легко интегрируется в текущий DI без переписывания слоёв

---

## Ключевые архитектурные решения

### 1. Паттерн: Decorator на уровне репозитория

Кэш не видят ни BLoC, ни Interactor. Создаются `Cached*`-обёртки, реализующие те же интерфейсы, что и `Http*`-репозитории. В `AppProvidersWrapper` / `IAppEnvPreset` подставляется обёртка вместо голого HTTP-репо. Всё остальное не трогается.

### 2. Стратегия чтения: cache-first

```
loadMessages(page: 1):
  есть кэш?
    да → вернуть немедленно + фоновый refresh сети
    нет → сеть → записать в кэш → вернуть

loadMessages(page: N > 1):
  есть кэш?
    да → вернуть (пагинация уже загружена)
    нет → сеть → записать в кэш → вернуть
```

### 3. Синхронизация write-through через WebSocket-стрим

Стрим `messagesUpdates` и `conversationsUpdates` пробрасывается через `asyncMap`, который параллельно пишет в БД перед тем как событие уходит в BLoC.

### 4. MediaDownloadInfo — кэш с TTL в БД

`MessageBubble._downloadInfoCache` (Map в State виджета, теряется при скролле) убирается. Кэш переносится в `MediaInteractor` через новый `IMediaDownloadCacheRepo` с персистентностью в Drift и TTL на основе поля `expiresAt` из ответа сервера.

---

## Шаг 1: Добавить зависимости

Файл: `pubspec.yaml`

Добавить в секцию `dependencies`:
```yaml
drift: ^2.22.0
drift_flutter: ^0.2.4
```

Добавить в секцию `dev_dependencies`:
```yaml
drift_dev: ^2.22.0
```

`build_runner` уже есть. После правки запустить:
```bash
flutter pub get
```

---

## Шаг 2: Создать схему базы данных

### 2.1 Таблица тайлов диалогов

Создать файл `lib/core/data/storage/db/tables/conversation_tiles_table.dart`:

```dart
import 'package:drift/drift.dart';

class ConversationTilesTable extends Table {
  @override
  String get tableName => 'conversation_tiles';

  TextColumn get id => text()();
  TextColumn get type => text()(); // 'private' | 'group' | 'channel'
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();

  // Companion fields (for private chats)
  TextColumn get companionId => text().nullable()();
  TextColumn get companionUsername => text().nullable()();
  TextColumn get companionFirstName => text().nullable()();
  TextColumn get companionLastName => text().nullable()();
  TextColumn get companionAvatarId => text().nullable()();

  // Last message preview
  TextColumn get lastMessageText => text().nullable()();
  TextColumn get lastMessageSenderId => text().nullable()();
  IntColumn get lastMessageAtMs => integer().nullable()();

  IntColumn get updatedAtMs => integer()();
  IntColumn get cachedAtMs => integer()(); // when we wrote this row

  @override
  Set<Column> get primaryKey => {id};
}
```

### 2.2 Таблица приватных сообщений

Создать файл `lib/core/data/storage/db/tables/private_messages_table.dart`:

```dart
import 'package:drift/drift.dart';

class PrivateMessagesTable extends Table {
  @override
  String get tableName => 'private_messages';

  TextColumn get id => text()();
  TextColumn get clientMessageId => text().nullable()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get text => text()();
  TextColumn get deliveryStatus => text()(); // 'sending'|'sent'|'delivered'|'read'
  TextColumn get replyToMessageId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get deletedById => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();
  IntColumn get editedAtMs => integer().nullable()();
  IntColumn get readAtMs => integer().nullable()();
  IntColumn get cachedAtMs => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 2.3 Таблица вложений сообщений

Создать файл `lib/core/data/storage/db/tables/private_message_attachments_table.dart`:

```dart
import 'package:drift/drift.dart';

class PrivateMessageAttachmentsTable extends Table {
  @override
  String get tableName => 'private_message_attachments';

  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get fileId => text()();
  TextColumn get fileType => text().nullable()();
  IntColumn get order => integer()();
  IntColumn get createdAtMs => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 2.4 Таблица кэша download-info медиафайлов

Создать файл `lib/core/data/storage/db/tables/media_download_cache_table.dart`:

```dart
import 'package:drift/drift.dart';

class MediaDownloadCacheTable extends Table {
  @override
  String get tableName => 'media_download_cache';

  TextColumn get mediaId => text()();
  TextColumn get downloadUrl => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get status => text()();
  TextColumn get scope => text()();
  TextColumn get scopeId => text()();
  TextColumn get ownerUserId => text()();
  IntColumn get expiresAtMs => integer()(); // TTL: unix ms из ответа сервера
  IntColumn get cachedAtMs => integer()();

  @override
  Set<Column> get primaryKey => {mediaId};
}
```

---

## Шаг 3: Создать DAO-классы

### 3.1 DAO для тайлов диалогов

Создать файл `lib/core/data/storage/db/daos/conversation_tiles_dao.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/app_database.dart';

part 'conversation_tiles_dao.g.dart';

@DriftAccessor(tables: [ConversationTilesTable])
class ConversationTilesDao extends DatabaseAccessor<AppDatabase>
    with _$ConversationTilesDaoMixin {
  ConversationTilesDao(super.db);

  Future<List<ConversationTilesTableData>> getAllTiles() =>
      (select(conversationTilesTable)
            ..orderBy([
              (t) => OrderingTerm.desc(t.updatedAtMs),
            ]))
          .get();

  Future<void> upsertTile(ConversationTilesTableCompanion entry) =>
      into(conversationTilesTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<ConversationTilesTableCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(conversationTilesTable, entries));

  Future<int> deleteTile(String id) =>
      (delete(conversationTilesTable)..where((t) => t.id.equals(id))).go();

  /// Оставить только [limit] самых свежих тайлов (по updatedAt).
  Future<void> keepOnlyRecent({int limit = 50}) async {
    final all = await getAllTiles();
    if (all.length <= limit) return;
    final toDelete = all.skip(limit).map((e) => e.id).toList();
    await (delete(conversationTilesTable)
          ..where((t) => t.id.isIn(toDelete)))
        .go();
  }
}
```

### 3.2 DAO для приватных сообщений

Создать файл `lib/core/data/storage/db/daos/private_messages_dao.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/app_database.dart';

part 'private_messages_dao.g.dart';

const int _pageSize = 30;

@DriftAccessor(tables: [PrivateMessagesTable, PrivateMessageAttachmentsTable])
class PrivateMessagesDao extends DatabaseAccessor<AppDatabase>
    with _$PrivateMessagesDaoMixin {
  PrivateMessagesDao(super.db);

  Future<List<PrivateMessagesTableData>> getPage({
    required String conversationId,
    int page = 1,
  }) {
    final int offset = (page - 1) * _pageSize;
    return (select(privateMessagesTable)
          ..where((t) =>
              t.conversationId.equals(conversationId) &
              t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAtMs)])
          ..limit(_pageSize, offset: offset))
        .get();
  }

  Future<List<PrivateMessageAttachmentsTableData>> getAttachments(
      String messageId) =>
      (select(privateMessageAttachmentsTable)
            ..where((t) => t.messageId.equals(messageId))
            ..orderBy([(t) => OrderingTerm.asc(t.order)]))
          .get();

  Future<void> upsertMessage(PrivateMessagesTableCompanion entry) =>
      into(privateMessagesTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<PrivateMessagesTableCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(privateMessagesTable, entries));

  Future<void> upsertAttachments(
          List<PrivateMessageAttachmentsTableCompanion> entries) =>
      batch((b) =>
          b.insertAllOnConflictUpdate(privateMessageAttachmentsTable, entries));

  Future<void> markDeleted(String messageId) =>
      (update(privateMessagesTable)..where((t) => t.id.equals(messageId)))
          .write(PrivateMessagesTableCompanion(
        isDeleted: const Value(true),
      ));

  /// Оставить последние [limit] сообщений для каждого диалога
  /// (удалить всё, что старше). Вызывается при evict.
  Future<void> keepRecentPerConversation({
    required String conversationId,
    int limit = 60,
  }) async {
    final rows = await getPage(conversationId: conversationId, page: 1);
    if (rows.length < limit) return;
    final cutoffMs = rows[limit - 1].createdAtMs;
    await (delete(privateMessagesTable)
          ..where((t) =>
              t.conversationId.equals(conversationId) &
              t.createdAtMs.isSmallerThanValue(cutoffMs)))
        .go();
  }

  Future<void> deleteByConversation(String conversationId) =>
      (delete(privateMessagesTable)
            ..where((t) => t.conversationId.equals(conversationId)))
          .go();
}
```

### 3.3 DAO для кэша медиа

Создать файл `lib/core/data/storage/db/daos/media_download_cache_dao.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/app_database.dart';

part 'media_download_cache_dao.g.dart';

@DriftAccessor(tables: [MediaDownloadCacheTable])
class MediaDownloadCacheDao extends DatabaseAccessor<AppDatabase>
    with _$MediaDownloadCacheDaoMixin {
  MediaDownloadCacheDao(super.db);

  Future<MediaDownloadCacheTableData?> get(String mediaId) =>
      (select(mediaDownloadCacheTable)
            ..where((t) => t.mediaId.equals(mediaId)))
          .getSingleOrNull();

  Future<void> put(MediaDownloadCacheTableCompanion entry) =>
      into(mediaDownloadCacheTable).insertOnConflictUpdate(entry);

  Future<int> deleteExpired() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    return (delete(mediaDownloadCacheTable)
          ..where((t) => t.expiresAtMs.isSmallerThanValue(nowMs)))
        .go();
  }
}
```

---

## Шаг 4: Создать AppDatabase

Создать файл `lib/core/data/storage/db/app_database.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:locnet_app/core/data/storage/db/daos/conversation_tiles_dao.dart';
import 'package:locnet_app/core/data/storage/db/daos/media_download_cache_dao.dart';
import 'package:locnet_app/core/data/storage/db/daos/private_messages_dao.dart';
import 'package:locnet_app/core/data/storage/db/tables/conversation_tiles_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/media_download_cache_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_message_attachments_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_messages_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ConversationTilesTable,
    PrivateMessagesTable,
    PrivateMessageAttachmentsTable,
    MediaDownloadCacheTable,
  ],
  daos: [
    ConversationTilesDao,
    PrivateMessagesDao,
    MediaDownloadCacheDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'locnet_cache');
  }

  /// Вызывать при старте после восстановления сессии.
  Future<void> evictStale() async {
    await mediaDownloadCacheDao.deleteExpired();
    await conversationTilesDao.keepOnlyRecent(limit: 50);
    // При необходимости добавить keepRecentPerConversation для активных диалогов
  }

  /// Вызывать при logout: полная очистка всех таблиц.
  Future<void> clearAll() async {
    await delete(mediaDownloadCacheTable).go();
    await delete(privateMessageAttachmentsTable).go();
    await delete(privateMessagesTable).go();
    await delete(conversationTilesTable).go();
  }
}
```

Создать barrel-файл `lib/core/data/storage/db/db.dart`:

```dart
export 'app_database.dart';
export 'daos/conversation_tiles_dao.dart';
export 'daos/private_messages_dao.dart';
export 'daos/media_download_cache_dao.dart';
export 'tables/conversation_tiles_table.dart';
export 'tables/private_messages_table.dart';
export 'tables/private_message_attachments_table.dart';
export 'tables/media_download_cache_table.dart';
```

---

## Шаг 5: Генерация кода

После создания всех файлов из шагов 2–4 выполнить:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Это создаст `.g.dart`-файлы рядом с `app_database.dart` и DAO-файлами.

---

## Шаг 6: Зарегистрировать AppDatabase через StorageAggregator

`AppDatabase` не добавляется напрямую в `AppScope`. Вместо этого он хранится внутри `StorageAggregator`, который уже есть в `AppScope`. Это позволяет держать все хранилища в одном месте.

### 6.1 Добавить поле в StorageAggregator

Файл: `lib/core/data/storage/storage_aggregator.dart`

Добавить импорт и поле `db`:

```dart
import 'package:locnet_app/core/data/storage/db/db.dart';

class StorageAggregator {
  StorageAggregator({
    required this.secureStorage,
    required this.localKeyValueStorage,
    required this.db, // ДОБАВИТЬ
  });

  final IKeyValueStorage secureStorage;
  final IKeyValueStorage localKeyValueStorage;
  final AppDatabase db; // ДОБАВИТЬ

  IKeyValueStorage get secure => secureStorage;
  IKeyValueStorage get prefs => localKeyValueStorage;
}
```

### 6.2 Создать AppDatabase в AppRunner и передать в StorageAggregator

Файл: `lib/runners/app_runner.dart`

В методе `_initDependencies` добавить импорт и создание `AppDatabase` прямо перед созданием `StorageAggregator`:

```dart
import 'package:locnet_app/core/data/storage/db/db.dart';

// В методе _initDependencies, перед созданием storageAggregator:
final db = AppDatabase();

final storageAggregator = StorageAggregator(
  secureStorage: secureStorage,
  localKeyValueStorage: localKeyValueStorage,
  db: db, // ДОБАВИТЬ
);
```

`AppScope` не меняется — `AppDatabase` доступен через `appScope.storageAggregator.db`.

---

## Шаг 7: Создать вспомогательные маперы

Создать файл `lib/core/data/storage/db/mappers/conversation_tile_mapper.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

final class ConversationTileMapper {
  static ConversationTilesTableCompanion toCompanion(ConversationTile tile) {
    final User? c = tile.companion;
    return ConversationTilesTableCompanion(
      id: Value(tile.id),
      type: Value(tile.type.name),
      title: Value(tile.title),
      description: Value(tile.description),
      companionId: Value(c?.userId),
      companionUsername: Value(c?.username),
      companionFirstName: Value(c?.firstName),
      companionLastName: Value(c?.lastName),
      companionAvatarId: Value(c?.avatarId),
      lastMessageText: Value(tile.lastMessageText),
      lastMessageSenderId: Value(tile.lastMessageSenderId),
      lastMessageAtMs: Value(tile.lastMessageAt?.millisecondsSinceEpoch),
      updatedAtMs: Value(tile.updatedAt.millisecondsSinceEpoch),
      cachedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
    );
  }

  static ConversationTile fromRow(ConversationTilesTableData row) {
    User? companion;
    if (row.companionId != null) {
      companion = User(
        userId: row.companionId!,
        username: row.companionUsername ?? '',
        firstName: row.companionFirstName ?? '',
        lastName: row.companionLastName ?? '',
        avatarId: row.companionAvatarId,
        languageCode: 'ru',
        isDeleted: false,
        isBanned: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return ConversationTile(
      id: row.id,
      type: ConversationTileType.values.firstWhere(
        (e) => e.name == row.type,
        orElse: () => ConversationTileType.private,
      ),
      title: row.title,
      description: row.description,
      companion: companion,
      lastMessageText: row.lastMessageText,
      lastMessageSenderId: row.lastMessageSenderId,
      lastMessageAt: row.lastMessageAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(row.lastMessageAtMs!)
          : null,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtMs),
    );
  }
}
```

Создать файл `lib/core/data/storage/db/mappers/private_message_mapper.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

final class PrivateMessageMapper {
  static PrivateMessagesTableCompanion toCompanion(PrivateMessage msg) {
    return PrivateMessagesTableCompanion(
      id: Value(msg.id.isEmpty ? msg.clientMessageId ?? '' : msg.id),
      clientMessageId: Value(msg.clientMessageId),
      conversationId: Value(msg.conversationId),
      senderId: Value(msg.senderId),
      text: Value(msg.text),
      deliveryStatus: Value(msg.deliveryStatus.value),
      replyToMessageId: Value(msg.replyToMessageId),
      isDeleted: Value(msg.isDeleted),
      deletedById: Value(msg.deletedById),
      isPinned: Value(msg.isPinned),
      createdAtMs: Value(msg.createdAt.millisecondsSinceEpoch),
      updatedAtMs: Value(msg.updatedAt.millisecondsSinceEpoch),
      editedAtMs: Value(msg.editedAt?.millisecondsSinceEpoch),
      readAtMs: Value(msg.readAt?.millisecondsSinceEpoch),
      cachedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
    );
  }

  static List<PrivateMessageAttachmentsTableCompanion> attachmentsToCompanions(
      PrivateMessage msg) {
    return msg.attachments
        .map((a) => PrivateMessageAttachmentsTableCompanion(
              id: Value(a.id),
              messageId: Value(msg.id.isEmpty ? msg.clientMessageId ?? '' : msg.id),
              fileId: Value(a.fileId),
              fileType: Value(a.fileType),
              order: Value(a.order),
              createdAtMs: Value(a.createdAt.millisecondsSinceEpoch),
            ))
        .toList();
  }

  static PrivateMessage fromRow(
    PrivateMessagesTableData row,
    List<PrivateMessageAttachmentsTableData> attachmentRows,
  ) {
    return PrivateMessage(
      id: row.id,
      clientMessageId: row.clientMessageId,
      conversationId: row.conversationId,
      senderId: row.senderId,
      text: row.text,
      deliveryStatus: MessageDeliveryStatus.fromString(row.deliveryStatus),
      replyToMessageId: row.replyToMessageId,
      isDeleted: row.isDeleted,
      deletedById: row.deletedById,
      isPinned: row.isPinned,
      editedAt: row.editedAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(row.editedAtMs!)
          : null,
      readAt: row.readAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(row.readAtMs!)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtMs),
      attachments: attachmentRows
          .map((a) => PrivateMessageAttachment(
                id: a.id,
                messageId: a.messageId,
                fileId: a.fileId,
                fileType: a.fileType,
                order: a.order,
                createdAt:
                    DateTime.fromMillisecondsSinceEpoch(a.createdAtMs),
              ))
          .toList(),
    );
  }
}
```

Создать файл `lib/core/data/storage/db/mappers/media_download_info_mapper.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_download_info.dart';

final class MediaDownloadInfoMapper {
  static MediaDownloadCacheTableCompanion toCompanion(
    String mediaId,
    MediaDownloadInfo info,
  ) {
    return MediaDownloadCacheTableCompanion(
      mediaId: Value(mediaId),
      downloadUrl: Value(info.downloadUrl),
      mimeType: Value(info.mimeType),
      sizeBytes: Value(info.sizeBytes),
      status: Value(info.status),
      scope: Value(info.scope),
      scopeId: Value(info.scopeId),
      ownerUserId: Value(info.ownerUserId),
      expiresAtMs: Value(info.expiresAt.millisecondsSinceEpoch),
      cachedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
    );
  }

  static MediaDownloadInfo fromRow(MediaDownloadCacheTableData row) {
    return MediaDownloadInfo(
      downloadUrl: row.downloadUrl,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(row.expiresAtMs),
      mimeType: row.mimeType,
      sizeBytes: row.sizeBytes,
      status: row.status,
      scope: row.scope,
      scopeId: row.scopeId,
      ownerUserId: row.ownerUserId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.cachedAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.cachedAtMs),
      etag: null,
    );
  }

  static bool isExpired(MediaDownloadCacheTableData row) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    return row.expiresAtMs <= nowMs;
  }
}
```

---

## Шаг 8: Создать Cached-репозитории

### 8.1 Кэшированный репозиторий списка диалогов

Создать файл:
`lib/features/conversations_list/data/repositories/conversations_list_repo/drift_cached_conversations_list_repo.dart`

```dart
import 'dart:async';

import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/data/storage/db/mappers/conversation_tile_mapper.dart';
import 'package:locnet_app/features/conversations_list/data/repositories/conversations_list_repo/i_conversations_list_repo.dart';
import 'package:locnet_app/features/conversations_list/domain/models/conversation_tile.dart';

final class DriftCachedConversationsListRepo implements IConversationsListRepo {
  DriftCachedConversationsListRepo({
    required IConversationsListRepo network,
    required ConversationTilesDao tilesDao,
  })  : _network = network,
        _tilesDao = tilesDao;

  final IConversationsListRepo _network;
  final ConversationTilesDao _tilesDao;

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    // Пытаемся вернуть кэш немедленно
    final cachedRows = await _tilesDao.getAllTiles();
    if (cachedRows.isNotEmpty) {
      // Фоновый refresh только для первой страницы
      if (page == 1) unawaited(_refreshFromNetwork(page));
      return cachedRows.map(ConversationTileMapper.fromRow).toList();
    }

    // Кэша нет — загружаем из сети и сохраняем
    final fresh = await _network.loadConversationsList(page: page);
    await _saveToCache(fresh);
    return fresh;
  }

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      _network.conversationsUpdates.asyncMap((update) async {
        // Write-through: каждое событие от WS синхронно пишем в кэш
        await _applyUpdateToCache(update);
        return update;
      });

  Future<void> _refreshFromNetwork(int page) async {
    try {
      final fresh = await _network.loadConversationsList(page: page);
      await _saveToCache(fresh);
    } catch (_) {
      // Фоновый refresh не должен ронять приложение
    }
  }

  Future<void> _saveToCache(List<ConversationTile> tiles) async {
    final companions =
        tiles.map(ConversationTileMapper.toCompanion).toList();
    await _tilesDao.upsertAll(companions);
  }

  Future<void> _applyUpdateToCache(ConversationsListUpdateRec update) async {
    switch (update.updateType) {
      case ConversationTileUpdateType.created:
      case ConversationTileUpdateType.updated:
        await _tilesDao
            .upsertTile(ConversationTileMapper.toCompanion(update.conversationTile));
      case ConversationTileUpdateType.deleted:
        await _tilesDao.deleteTile(update.conversationTile.id);
    }
  }
}
```

### 8.2 Кэшированный репозиторий приватных диалогов

Создать файл:
`lib/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/drift_cached_private_conversation_repo.dart`

```dart
import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/data/storage/db/mappers/private_message_mapper.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/i_private_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

final class DriftCachedPrivateConversationRepo implements IPrivateConversationRepo {
  DriftCachedPrivateConversationRepo({
    required IPrivateConversationRepo network,
    required PrivateMessagesDao messagesDao,
  })  : _network = network,
        _messagesDao = messagesDao;

  final IPrivateConversationRepo _network;
  final PrivateMessagesDao _messagesDao;

  @override
  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    // Cache-first
    final cachedRows = await _messagesDao.getPage(
      conversationId: conversationId,
      page: page,
    );

    if (cachedRows.isNotEmpty) {
      // Для каждого сообщения подгружаем вложения из БД
      final messages = await _hydrateMessages(cachedRows);

      // Фоновый refresh только для первой страницы
      if (page == 1) {
        unawaited(_refreshMessagesFromNetwork(conversationId: conversationId));
      }
      return messages;
    }

    // Кэша нет — идём в сеть
    final fresh = await _network.loadMessagesPage(
      conversationId: conversationId,
      page: page,
    );
    await _saveMessages(fresh);
    return fresh;
  }

  @override
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _network.messagesUpdates.asyncMap((update) async {
        await _applyUpdateToCache(update);
        return update;
      });

  // ── Методы без кэша: делегируем в network ──────────────────────────────────

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) => _network.blockCompanion(
        companionId: companionId,
        blockedByUserId: blockedByUserId,
        reason: reason,
      );

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    final result = await _network.deleteConversation(
      conversationId: conversationId,
      deleteAtRecipient: deleteAtRecipient,
    );
    if (result) {
      await _messagesDao.deleteByConversation(conversationId);
    }
    return result;
  }

  @override
  Future<PrivateConversation> getOrCreateByCompanion({
    required String companionId,
  }) => _network.getOrCreateByCompanion(companionId: companionId);

  @override
  Future<List<PrivateConversation>> listConversations({int page = 1}) =>
      _network.listConversations(page: page);

  @override
  Future<User> getCompanion({required String conversationId}) =>
      _network.getCompanion(conversationId: conversationId);

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) => _network.toggleNotifications(
        conversationId: conversationId,
        newNotificationsStatus: newNotificationsStatus,
      );

  // ── Вспомогательные методы ─────────────────────────────────────────────────

  Future<void> _refreshMessagesFromNetwork({
    required String conversationId,
  }) async {
    try {
      final fresh = await _network.loadMessagesPage(
        conversationId: conversationId,
        page: 1,
      );
      await _saveMessages(fresh);
    } catch (_) {
      // Фоновый refresh не должен ронять UI
    }
  }

  Future<void> _saveMessages(List<PrivateMessage> messages) async {
    final msgCompanions =
        messages.map(PrivateMessageMapper.toCompanion).toList();
    final attachCompanions = messages
        .expand(PrivateMessageMapper.attachmentsToCompanions)
        .toList();
    await _messagesDao.upsertAll(msgCompanions);
    if (attachCompanions.isNotEmpty) {
      await _messagesDao.upsertAttachments(attachCompanions);
    }
  }

  Future<List<PrivateMessage>> _hydrateMessages(
    List<PrivateMessagesTableData> rows,
  ) async {
    final List<PrivateMessage> result = [];
    for (final row in rows) {
      final attachRows = await _messagesDao.getAttachments(row.id);
      result.add(PrivateMessageMapper.fromRow(row, attachRows));
    }
    return result;
  }

  Future<void> _applyUpdateToCache(
      PrivateConversationMessageUpdateRec update) async {
    switch (update.updateType) {
      case PrivateConversationMessageUpdateType.created:
      case PrivateConversationMessageUpdateType.updated:
        final companion = PrivateMessageMapper.toCompanion(update.message);
        await _messagesDao.upsertMessage(companion);
        final attachCompanions =
            PrivateMessageMapper.attachmentsToCompanions(update.message);
        if (attachCompanions.isNotEmpty) {
          await _messagesDao.upsertAttachments(attachCompanions);
        }
      case PrivateConversationMessageUpdateType.deleted:
        await _messagesDao.markDeleted(update.message.id);
    }
  }
}
```

---

## Шаг 9: Кэш MediaDownloadInfo в MediaInteractor

### 9.1 Интерфейс кэша медиа

Создать файл:
`lib/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart`

```dart
import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_download_info.dart';

abstract interface class IMediaDownloadCacheRepo {
  Future<MediaDownloadInfo?> get(String mediaId);
  Future<void> put(String mediaId, MediaDownloadInfo info);
  Future<void> evictExpired();
}
```

### 9.2 Drift-реализация кэша медиа

Создать файл:
`lib/features/message/subfeatures/media/data/repositories/media_download_cache_repo/drift_media_download_cache_repo.dart`

```dart
import 'package:locnet_app/core/data/storage/db/daos/media_download_cache_dao.dart';
import 'package:locnet_app/core/data/storage/db/mappers/media_download_info_mapper.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_download_info.dart';

final class DriftMediaDownloadCacheRepo implements IMediaDownloadCacheRepo {
  DriftMediaDownloadCacheRepo({required MediaDownloadCacheDao dao})
      : _dao = dao;

  final MediaDownloadCacheDao _dao;

  @override
  Future<MediaDownloadInfo?> get(String mediaId) async {
    final row = await _dao.get(mediaId);
    if (row == null) return null;
    if (MediaDownloadInfoMapper.isExpired(row)) {
      return null; // Истёкший URL не возвращаем
    }
    return MediaDownloadInfoMapper.fromRow(row);
  }

  @override
  Future<void> put(String mediaId, MediaDownloadInfo info) async {
    await _dao.put(MediaDownloadInfoMapper.toCompanion(mediaId, info));
  }

  @override
  Future<void> evictExpired() => _dao.deleteExpired();
}
```

### 9.3 Обновить MediaInteractor

Файл: `lib/features/message/subfeatures/media/domain/interactors/media_interactor.dart`

Добавить поле `_downloadCache` и изменить метод `getDownloadInfo`:

```dart
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart';

final class MediaInteractor {
  MediaInteractor({
    required IMediaRepo mediaRepo,
    required IMediaDownloadCacheRepo downloadCache, // ДОБАВИТЬ параметр
  })  : _mediaRepo = mediaRepo,
        _downloadCache = downloadCache;             // ДОБАВИТЬ поле

  final IMediaRepo _mediaRepo;
  final IMediaDownloadCacheRepo _downloadCache; // ДОБАВИТЬ

  // ... остальные методы без изменений ...

  Future<MediaDownloadInfo> getDownloadInfo({
    required String mediaId,
    String? scope,
    String? scopeId,
  }) async {
    // Проверяем персистентный кэш
    final cached = await _downloadCache.get(mediaId);
    if (cached != null) return cached;

    // Кэша нет или истёк — запрашиваем у сервера
    final MediaDownloadInfoDto dto = await _mediaRepo.getDownloadInfo(
      mediaId: mediaId,
      scope: scope,
      scopeId: scopeId,
    );
    final info = MediaDownloadInfo.fromDto(dto);

    // Сохраняем в кэш
    await _downloadCache.put(mediaId, info);
    return info;
  }
}
```

---

## Шаг 10: Подключить всё в DI

### 10.1 Обновить IAppEnvPreset

Файл: `lib/app/env_build_presets/i_env_preset.dart`

Добавить метод в интерфейс:

```dart
// Добавить импорт:
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart';

abstract interface class IAppEnvPreset {
  // ... существующие методы ...
  IMediaDownloadCacheRepo createMediaDownloadCacheRepo(); // ДОБАВИТЬ
}
```

### 10.2 Реализовать в DevEnvPreset

Файл: `lib/app/env_build_presets/dev_env_preset.dart`

```dart
// Добавить импорты:
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/drift_media_download_cache_repo.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart';

// DevEnvPreset — добавить поле _db:
final class DevEnvPreset implements IAppEnvPreset {
  DevEnvPreset({required AppScope appScope, required MockInMemoryBackend mockBackend})
      : _appScope = appScope,
        _mockBackend = mockBackend;

  final AppScope _appScope;
  final MockInMemoryBackend _mockBackend;

  // Добавить геттер:
  AppDatabase get _db => _appScope.db;

  // Добавить метод:
  @override
  IMediaDownloadCacheRepo createMediaDownloadCacheRepo() =>
      DriftMediaDownloadCacheRepo(dao: _db.mediaDownloadCacheDao);

  // Переопределить createConversationsListRepo:
  @override
  IConversationsListRepo createConversationsListRepo() {
    return DriftCachedConversationsListRepo(
      network: MockConversationsListRepo(backendStorage: _mockBackend),
      tilesDao: _db.conversationTilesDao,
    );
  }

  // Переопределить createPrivateConversationRepo:
  @override
  IPrivateConversationRepo createPrivateConversationRepo() {
    return DriftCachedPrivateConversationRepo(
      network: MockPrivateConversationRepo(backendStorage: _mockBackend),
      messagesDao: _db.privateMessagesDao,
    );
  }
}
```

Аналогично добавить реализацию методов в `StageEnvPreset` и `ProdEnvPreset`, используя Http-репозитории вместо Mock.

### 10.3 Обновить AppProvidersWrapper

Файл: `lib/app/app_providers_wrapper.dart`

Найти блок с `RepositoryProvider<MediaInteractor>` и заменить:

```dart
// БЫЛО:
RepositoryProvider<MediaInteractor>(
  create: (BuildContext context) => MediaInteractor(
    mediaRepo: context.read<IAppEnvPreset>().createMediaRepo(),
  ),
),

// СТАЛО:
RepositoryProvider<IMediaDownloadCacheRepo>(
  create: (context) =>
      context.read<IAppEnvPreset>().createMediaDownloadCacheRepo(),
),
RepositoryProvider<MediaInteractor>(
  create: (BuildContext context) => MediaInteractor(
    mediaRepo: context.read<IAppEnvPreset>().createMediaRepo(),
    downloadCache: context.read<IMediaDownloadCacheRepo>(),
  ),
),
```

Этот блок встречается в нескольких местах — в `PrivateConversationScreenWrapper`, `GroupConversationScreenWrapper`, `ChannelConversationScreenWrapper`. Во всех них `MediaInteractor` создаётся локально. Их нужно обновить аналогично.

---

## Шаг 11: Убрать _downloadInfoCache из MessageBubble

Файл: `lib/features/message/presentation/components/message_bubble.dart`

Удалить строку:
```dart
final Map<String, Future<MediaDownloadInfo>> _downloadInfoCache =
    <String, Future<MediaDownloadInfo>>{};
```

Метод `_resolveDownloadInfo` упростить — убрать кэш, кэш теперь внутри `MediaInteractor`:

```dart
// БЫЛО:
Future<MediaDownloadInfo> _resolveDownloadInfo({
  required String mediaId,
  required String conversationId,
}) {
  return _downloadInfoCache.putIfAbsent(mediaId, () {
    return context.read<MediaInteractor>().getDownloadInfo(
      mediaId: mediaId,
      scope: 'private_conversation',
      scopeId: conversationId,
    );
  });
}

// СТАЛО:
Future<MediaDownloadInfo> _resolveDownloadInfo({
  required String mediaId,
  required String conversationId,
}) {
  return context.read<MediaInteractor>().getDownloadInfo(
    mediaId: mediaId,
    scope: 'private_conversation',
    scopeId: conversationId,
  );
}
```

---

## Шаг 12: Evict при старте и очистка при logout

### 12.1 Evict при старте

Файл: `lib/features/auth/presentation/blocs/auth_cubit.dart` (или аналогичный файл, где обрабатывается успешное восстановление сессии).

После успешного `tryRestoreSession()` добавить вызов evict в фоне:

```dart
// В методе tryRestoreSession() после успешного emit authenticated-состояния:
unawaited(context.read<AppScope>().db.evictStale());
```

Альтернативно — вызвать в `AppRunner._initDependencies` сразу после создания `AppDatabase`:

```dart
final db = AppDatabase();
unawaited(db.evictStale());
```

### 12.2 Очистка при logout

Файл: `lib/features/auth/domain/interactors/auth_interactor.dart` (или аналог).

В методе logout после очистки токенов добавить:

```dart
await appScope.db.clearAll();
```

---

## Итоговая структура новых файлов

```
lib/
├── core/
│   └── data/
│       └── db/
│           ├── app_database.dart          ← @DriftDatabase, evictStale, clearAll
│           ├── db.dart                    ← barrel export
│           ├── tables/
│           │   ├── conversation_tiles_table.dart
│           │   ├── private_messages_table.dart
│           │   ├── private_message_attachments_table.dart
│           │   └── media_download_cache_table.dart
│           ├── daos/
│           │   ├── conversation_tiles_dao.dart
│           │   ├── private_messages_dao.dart
│           │   └── media_download_cache_dao.dart
│           └── mappers/
│               ├── conversation_tile_mapper.dart
│               ├── private_message_mapper.dart
│               └── media_download_info_mapper.dart
├── features/
│   ├── conversations_list/
│   │   └── data/repositories/conversations_list_repo/
│   │       └── drift_cached_conversations_list_repo.dart
│   ├── conversation/subfeatures/private/
│   │   └── data/repositories/private_conversation_repo/
│   │       └── drift_cached_private_conversation_repo.dart
│   └── message/subfeatures/media/
│       └── data/repositories/media_download_cache_repo/
│           ├── i_media_download_cache_repo.dart
│           └── drift_media_download_cache_repo.dart
```

## Файлы, которые редактируются (не создаются)

| Файл | Что меняется |
|------|-------------|
| `pubspec.yaml` | Добавить `drift`, `drift_flutter`, `drift_dev` |
| `lib/di/app_scope.dart` | Добавить поле `AppDatabase db` |
| `lib/runners/app_runner.dart` | Создать `AppDatabase` в `_initDependencies`, передать в `AppScope` |
| `lib/app/env_build_presets/i_env_preset.dart` | Добавить метод `createMediaDownloadCacheRepo()` |
| `lib/app/env_build_presets/dev_env_preset.dart` | Обернуть repos в Cached*, реализовать новый метод |
| `lib/app/env_build_presets/stage_env_preset.dart` | Аналогично dev |
| `lib/app/env_build_presets/prod_env_preset.dart` | Аналогично dev |
| `lib/app/app_providers_wrapper.dart` | Добавить `IMediaDownloadCacheRepo`, обновить создание `MediaInteractor` |
| `lib/features/message/subfeatures/media/domain/interactors/media_interactor.dart` | Добавить `_downloadCache`, изменить `getDownloadInfo` |
| `lib/features/message/presentation/components/message_bubble.dart` | Удалить `_downloadInfoCache`, упростить `_resolveDownloadInfo` |
| `lib/features/auth/...` (logout) | Вызвать `db.clearAll()` при logout |

---

## Важные замечания для исполнителя

1. **Генерация кода обязательна** после шагов 2–4: `dart run build_runner build --delete-conflicting-outputs`. Без `.g.dart`-файлов код не скомпилируется.

2. **`MessageDeliveryStatus.value`** — проверить, что у enum `MessageDeliveryStatus` есть геттер `value` (строковое представление) и фабрика `fromString`. Файл: `lib/features/message/domain/models/enums.dart`. Если нет — добавить.

3. **Маппер `ConversationTileMapper`** использует конструктор `User(...)` напрямую. Проверить сигнатуру конструктора `User` в `lib/core/domain/models/user.dart` и при необходимости скорректировать поля (особенно `patronymic`, `description`).

4. **`unawaited`** требует импорт `dart:async` или `package:meta/meta.dart`. Использовать `// ignore: unawaited_futures` или явный импорт там, где нужно.

5. **Порядок выполнения шагов строго соблюдать**: сначала таблицы → DAO → AppDatabase → генерация кода → маперы → Cached-репо → DI-подключение.

6. **Приоритет реализации по env**: начать с `dev` (DevEnvPreset), убедиться что работает, затем stage и prod.
