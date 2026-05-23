import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:locnet_app/core/data/storage/db/daos/conversation_tiles_dao.dart';
import 'package:locnet_app/core/data/storage/db/daos/media_download_cache_dao.dart';
import 'package:locnet_app/core/data/storage/db/daos/private_messages_dao.dart';
import 'package:locnet_app/core/data/storage/db/tables/conversation_tiles_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/media_download_cache_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_message_attachments_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_messages_table.dart';

import 'package:locnet_app/core/data/storage/db/open_native_encrypted_executor_stub.dart'
    if (dart.library.io) 'package:locnet_app/core/data/storage/db/open_native_encrypted_executor_io.dart'
    as open_native_encrypted_executor;

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
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  static Future<QueryExecutor> openEncrypted(String encryptionKey) async {
    assert(!kIsWeb, 'Encrypted NativeDatabase is not supported on web');
    return open_native_encrypted_executor.openNativeEncryptedExecutor(
      encryptionKey,
    );
  }

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

    final allTiles = await conversationTilesDao.getAllTiles();
    if (allTiles.length > 50) {
      final evictedIds = allTiles.skip(50).map((t) => t.id).toList();
      await privateMessagesDao.deleteByConversationIds(evictedIds);
    }

    await conversationTilesDao.keepOnlyRecent();

    final remaining = await conversationTilesDao.getAllTiles();
    for (final tile in remaining) {
      await privateMessagesDao.keepRecentPerConversation(
        conversationId: tile.id,
      );
    }
  }

  Future<void> clearAll() async {
    await delete(mediaDownloadCacheTable).go();
    await delete(privateMessageAttachmentsTable).go();
    await delete(privateMessagesTable).go();
    await delete(conversationTilesTable).go();
  }
}
