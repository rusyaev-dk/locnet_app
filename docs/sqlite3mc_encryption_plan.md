# Внедрение шифрования БД через sqlite3mc

**Подход:** полнодисковое шифрование SQLite-файла (AES-256) через SQLite3MultipleCiphers.  
**Область изменений:** только `data`-слой. Domain и presentation не трогаются.  
**Текущие версии:** `sqlite3 2.9.4` → нужен апгрейд до `^3.0.0`.

---

## Как это работает

```
pubspec.yaml (hooks)
  └─► sqlite3 v3 скачивает sqlite3mc.c вместо sqlite3.c
        └─► NativeDatabase.createInBackground(file, setup: ...)
              └─► PRAGMA key = '...' — весь файл .sqlite зашифрован AES-256
                    └─► Drift, DAO, Mappers — без изменений
```

Ключ (32 байта, hex) генерируется один раз через `Random.secure()` и хранится в `FlutterSecureStorage`.

---

## Шаг 1 — Зависимости (`pubspec.yaml`)

### 1.1 Апгрейд sqlite3 и добавление утилит

```yaml
dependencies:
  # Апгрейд с 2.9.4 → 3.x
  sqlite3: ^3.0.0

  # Нужны для построения пути к файлу БД
  path_provider: ^2.1.5   # скорее всего уже есть транзитивно — добавить явно
  path: ^1.9.1            # то же самое
```

### 1.3 Включить sqlite3mc через hooks

В корень `pubspec.yaml` (не в `dependencies`, а на верхнем уровне):

```yaml
# pubspec.yaml — добавить в конец файла, на верхнем уровне
hooks:
  user_defines:
    sqlite3:
      source: sqlite3mc
```

Это единственное изменение, которое переключает движок с vanilla SQLite на SQLite3MultipleCiphers.  
Никаких нативных подпроектов, никаких Podfile-правок — hooks делают всё сами при сборке.

### 1.4 Полный diff зависимостей

```
+ sqlite3: ^3.0.0       (апгрейд с 2.9.4)
+ path_provider: ^2.1.5 (добавить явно)
+ path: ^1.9.1          (добавить явно)
```

---

## Шаг 2 — Провайдер ключа шифрования

**Новые файлы в:** `lib/core/data/storage/db/encryption/`

### `i_db_encryption_key_provider.dart`

```dart
abstract interface class IDbEncryptionKeyProvider {
  /// Возвращает hex-ключ шифрования БД.
  /// При первом вызове — генерирует и сохраняет в SecureStorage.
  /// При последующих — читает из SecureStorage.
  Future<String> getOrCreateKey();
}
```

### `db_encryption_key_provider.dart`

```dart
import 'dart:math';
import 'package:locnet_app/core/data/storage/key_value_storage/i_key_value_storage.dart';
import 'i_db_encryption_key_provider.dart';

class DbEncryptionKeyProvider implements IDbEncryptionKeyProvider {
  DbEncryptionKeyProvider({required IKeyValueStorage secureStorage})
      : _secureStorage = secureStorage;

  final IKeyValueStorage _secureStorage;

  // Ключ версионирован — при смене алгоритма меняем суффикс
  static const String _storageKey = 'db_encryption_key_v1';

  @override
  Future<String> getOrCreateKey() async {
    final existing = await _secureStorage.read<String>(key: _storageKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final newKey = _generateHexKey();
    await _secureStorage.write(key: _storageKey, value: newKey);
    return newKey;
  }

  /// CSPRNG, 32 байта = 256 бит, hex-encoded (64 символа).
  String _generateHexKey() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
```

### `encryption.dart` (barrel-экспорт)

```dart
export 'i_db_encryption_key_provider.dart';
export 'db_encryption_key_provider.dart';
export 'db_migration_helper.dart';
```

---

## Шаг 3 — Изменение `AppDatabase`

**Файл:** `lib/core/data/storage/db/app_database.dart`

Текущее состояние: конструктор создаёт `QueryExecutor` внутри себя через `driftDatabase()`.  
После изменения: `AppDatabase` принимает готовый `executor` снаружи — это единственное изменение в классе.

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';                          // ← новый импорт
import 'package:drift_flutter/drift_flutter.dart';           // ← оставляем для web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;                        // ← новый импорт
import 'package:path_provider/path_provider.dart';           // ← новый импорт
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
  daos: [ConversationTilesDao, PrivateMessagesDao, MediaDownloadCacheDao],
)
class AppDatabase extends _$AppDatabase {
  // ↓ Было: AppDatabase() : super(_openConnection());
  // ↓ Стало: executor передаётся снаружи (из app_runner.dart)
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1; 

  /// Открывает зашифрованную БД для нативных платформ.
  /// Вызывается из app_runner.dart после получения ключа.
  static Future<QueryExecutor> openEncrypted(String encryptionKey) async {
    assert(!kIsWeb, 'Encrypted NativeDatabase не поддерживается на web');

    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'locnet_app_cache.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        // sqlite3mc: совместимый с SQLCipher режим
        db.execute("PRAGMA cipher = 'sqlcipher'");
        db.execute('PRAGMA legacy = 4');
        // Ключ устанавливается ДО любых других операций с БД
        db.execute("PRAGMA key = '$encryptionKey'");
      },
    );
  }

  /// Web-путь: без шифрования, через drift_flutter (IndexedDB).
  static QueryExecutor openWeb() {
    return driftDatabase(
      name: 'locnet_app_cache',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  Future<void> evictStale() async {
    await mediaDownloadCacheDao.deleteExpired();
    await conversationTilesDao.keepOnlyRecent();
  }

  Future<void> clearAll() async {
    await delete(mediaDownloadCacheTable).go();
    await delete(privateMessageAttachmentsTable).go();
    await delete(privateMessagesTable).go();
    await delete(conversationTilesTable).go();
  }
}
```

> **DAOs, Mappers, Tables — не изменяются.**

---

## Шаг 4 — Изменение `app_runner.dart`

**Файл:** `lib/runners/app_runner.dart`

`_initDependencies` уже `async` — нужно только добавить три вещи до создания `AppDatabase`.

Найти этот блок:

```dart
// БЫЛО:
final db = AppDatabase();
unawaited(db.evictStale());
final storageAggregator = StorageAggregator(
  secureStorage: secureStorage,
  localKeyValueStorage: localKeyValueStorage,
  db: db,
);
```

Заменить на:

```dart
// СТАЛО:
// 1. Миграция: удалить незашифрованную БД при первом запуске
final migrationHelper = DbMigrationHelper(localStorage: localKeyValueStorage);
await migrationHelper.runIfNeeded();

// 2. Получить/сгенерировать ключ шифрования
final keyProvider = DbEncryptionKeyProvider(secureStorage: secureStorage);
final encryptionKey = await keyProvider.getOrCreateKey();

// 3. Открыть зашифрованную БД
final QueryExecutor executor = kIsWeb
    ? AppDatabase.openWeb()
    : await AppDatabase.openEncrypted(encryptionKey);

final db = AppDatabase(executor);
unawaited(db.evictStale());

final storageAggregator = StorageAggregator(
  secureStorage: secureStorage,
  localKeyValueStorage: localKeyValueStorage,
  db: db,
);
```

Добавить импорты в начало файла:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:locnet_app/core/data/storage/db/encryption/encryption.dart';
```

---

## Итоговая структура новых файлов

```
lib/core/data/storage/db/
├── encryption/
│   ├── encryption.dart                     ← barrel-экспорт
│   ├── i_db_encryption_key_provider.dart   ← интерфейс
│   ├── db_encryption_key_provider.dart     ← реализация (SecureStorage)
│   └── db_migration_helper.dart            ← удаление старой БД
├── app_database.dart                       ← изменён (конструктор + 2 фабрики)
└── ... (всё остальное без изменений)
```

---

## Что не изменяется


| Слой             | Файлы                               | Статус          |
| ---------------- | ----------------------------------- | --------------- |
| **Data**         | DAOs, Mappers, Tables, Repositories | ✅ без изменений |
| **Domain**       | Все интерфейсы и сущности           | ✅ без изменений |
| **Presentation** | BLoC, Cubit, UI                     | ✅ без изменений |
| **DI**           | `AppScope`, `AppProvidersWrapper`   | ✅ без изменений |

