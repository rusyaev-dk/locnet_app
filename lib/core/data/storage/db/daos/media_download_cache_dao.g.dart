// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_download_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$MediaDownloadCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $MediaDownloadCacheTableTable get mediaDownloadCacheTable =>
      attachedDatabase.mediaDownloadCacheTable;
  MediaDownloadCacheDaoManager get managers =>
      MediaDownloadCacheDaoManager(this);
}

class MediaDownloadCacheDaoManager {
  final _$MediaDownloadCacheDaoMixin _db;
  MediaDownloadCacheDaoManager(this._db);
  $$MediaDownloadCacheTableTableTableManager get mediaDownloadCacheTable =>
      $$MediaDownloadCacheTableTableTableManager(
        _db.attachedDatabase,
        _db.mediaDownloadCacheTable,
      );
}
