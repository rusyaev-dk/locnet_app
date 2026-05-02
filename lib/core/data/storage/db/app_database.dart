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
