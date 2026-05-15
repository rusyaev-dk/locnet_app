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
  IntColumn get expiresAtMs => integer()();
  IntColumn get cachedAtMs => integer()();

  @override
  Set<Column> get primaryKey => {mediaId};
}
