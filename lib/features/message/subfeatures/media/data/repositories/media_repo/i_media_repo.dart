import 'package:locnet_app/features/message/subfeatures/media/data/models/models.dart';

abstract interface class IMediaRepo {
  Future<MediaInitUploadResponseDto> initUpload({
    required MediaInitUploadRequestDto request,
  });

  Future<String?> uploadBytes({
    required String uploadUrl,
    required List<int> bytes,
    required Map<String, String> requiredHeaders,
  });

  Future<MediaCompleteUploadResponseDto> completeUpload({
    required String mediaId,
    String? etag,
    int? contentLength,
  });

  Future<MediaMetadataDto> getMetadata({required String mediaId});

  Future<MediaDownloadInfoDto> getDownloadInfo({
    required String mediaId,
    String? scope,
    String? scopeId,
  });

  Future<MediaDeleteResponseDto> deleteMedia({required String mediaId});
}
