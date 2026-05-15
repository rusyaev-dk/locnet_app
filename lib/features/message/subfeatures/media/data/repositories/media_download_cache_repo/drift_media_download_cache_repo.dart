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
    if (MediaDownloadInfoMapper.isExpired(row)) return null;
    return MediaDownloadInfoMapper.fromRow(row);
  }

  @override
  Future<void> put(String mediaId, MediaDownloadInfo info) async {
    await _dao.put(MediaDownloadInfoMapper.toCompanion(mediaId, info));
  }

  @override
  Future<void> evictExpired() => _dao.deleteExpired();
}
