import 'package:locnet_app/features/message/subfeatures/media/data/models/models.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_repo/i_media_repo.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/models/models.dart';

final class MediaInteractor {
  MediaInteractor({required IMediaRepo mediaRepo}) : _mediaRepo = mediaRepo;

  final IMediaRepo _mediaRepo;

  Future<MediaInitUpload> initUpload({
    required String scope,
    required String scopeId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? clientDedupeKey,
  }) async {
    final MediaInitUploadResponseDto dto = await _mediaRepo.initUpload(
      request: MediaInitUploadRequestDto(
        scope: scope,
        scopeId: scopeId,
        fileName: fileName,
        mimeType: mimeType,
        sizeBytes: sizeBytes,
        clientDedupeKey: clientDedupeKey,
      ),
    );
    return MediaInitUpload.fromDto(dto);
  }

  Future<String?> uploadBytes({
    required String uploadUrl,
    required List<int> bytes,
    required Map<String, String> requiredHeaders,
  }) async {
    return _mediaRepo.uploadBytes(
      uploadUrl: uploadUrl,
      bytes: bytes,
      requiredHeaders: requiredHeaders,
    );
  }

  Future<MediaCompleteUpload> completeUpload({
    required String mediaId,
    String? etag,
    int? contentLength,
  }) async {
    final MediaCompleteUploadResponseDto dto = await _mediaRepo.completeUpload(
      mediaId: mediaId,
      etag: etag,
      contentLength: contentLength,
    );
    return MediaCompleteUpload.fromDto(dto);
  }

  Future<MediaMetadata> getMetadata({required String mediaId}) async {
    final MediaMetadataDto dto = await _mediaRepo.getMetadata(mediaId: mediaId);
    return MediaMetadata.fromDto(dto);
  }

  Future<MediaDownloadInfo> getDownloadInfo({
    required String mediaId,
    String? scope,
    String? scopeId,
  }) async {
    final MediaDownloadInfoDto dto = await _mediaRepo.getDownloadInfo(
      mediaId: mediaId,
      scope: scope,
      scopeId: scopeId,
    );
    return MediaDownloadInfo.fromDto(dto);
  }

  Future<MediaDeleteResult> deleteMedia({required String mediaId}) async {
    final MediaDeleteResponseDto dto = await _mediaRepo.deleteMedia(
      mediaId: mediaId,
    );
    return MediaDeleteResult.fromDto(dto);
  }
}
