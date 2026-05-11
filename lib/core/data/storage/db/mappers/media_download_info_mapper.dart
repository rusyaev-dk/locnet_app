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
      cachedAtMs: Value(DateTime.now().toUtc().millisecondsSinceEpoch),
    );
  }

  static MediaDownloadInfo fromRow(MediaDownloadCacheTableData row) {
    return MediaDownloadInfo(
      downloadUrl: row.downloadUrl,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        row.expiresAtMs,
        isUtc: true,
      ),
      mimeType: row.mimeType,
      sizeBytes: row.sizeBytes,
      status: row.status,
      scope: row.scope,
      scopeId: row.scopeId,
      ownerUserId: row.ownerUserId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.cachedAtMs,
        isUtc: true,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.cachedAtMs,
        isUtc: true,
      ),
      etag: null,
    );
  }

  static bool isExpired(MediaDownloadCacheTableData row) {
    final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    return row.expiresAtMs <= nowMs;
  }
}
