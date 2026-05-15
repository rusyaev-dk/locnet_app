import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_download_info.dart';

abstract interface class IMediaDownloadCacheRepo {
  Future<MediaDownloadInfo?> get(String mediaId);
  Future<void> put(String mediaId, MediaDownloadInfo info);
  Future<void> evictExpired();
}
