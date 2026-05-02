import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/app_database.dart';
import 'package:locnet_app/core/data/storage/db/tables/media_download_cache_table.dart';

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
