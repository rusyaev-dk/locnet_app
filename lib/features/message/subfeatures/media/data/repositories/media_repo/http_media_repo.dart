import 'package:dio/dio.dart';
import 'package:locnet_app/app/exceptions.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/models.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_repo/i_media_repo.dart';

class HttpMediaRepo implements IMediaRepo {
  HttpMediaRepo({required IHttpClient httpClient}) : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Future<MediaInitUploadResponseDto> initUpload({
    required MediaInitUploadRequestDto request,
  }) async {
    try {
      final Response<dynamic> response = await _httpClient.post(
        path: ApiEndpoints.mediaInit,
        data: request.toJson(),
      );
      final dynamic data = response.data;
      if (data is! Map<String, Object?>) {
        throw AppUnknownException(
          message: 'Invalid media init response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      return MediaInitUploadResponseDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to init media upload',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<String?> uploadBytes({
    required String uploadUrl,
    required List<int> bytes,
    required Map<String, String> requiredHeaders,
  }) async {
    try {
      final Response<dynamic> response = await _httpClient.put(
        path: uploadUrl,
        baseUrl: '',
        data: bytes,
        headers: requiredHeaders,
      );
      return response.headers.value('etag');
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to upload media bytes',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<MediaCompleteUploadResponseDto> completeUpload({
    required String mediaId,
    String? etag,
    int? contentLength,
  }) async {
    try {
      final Response<dynamic> response = await _httpClient.post(
        path: ApiEndpoints.mediaComplete(mediaId),
        data: <String, Object?>{
          if (etag != null && etag.isNotEmpty) 'etag': etag,
          if (contentLength != null) 'contentLength': contentLength,
        },
      );
      final dynamic data = response.data;
      if (data is! Map<String, Object?>) {
        throw AppUnknownException(
          message: 'Invalid media complete response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      return MediaCompleteUploadResponseDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to complete media upload',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<MediaMetadataDto> getMetadata({required String mediaId}) async {
    try {
      final Response<dynamic> response = await _httpClient.get(
        path: ApiEndpoints.mediaMetadata(mediaId),
      );
      final dynamic data = response.data;
      if (data is! Map<String, Object?>) {
        throw AppUnknownException(
          message: 'Invalid media metadata response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      return MediaMetadataDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to fetch media metadata',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<MediaDownloadInfoDto> getDownloadInfo({
    required String mediaId,
    String? scope,
    String? scopeId,
  }) async {
    try {
      final Response<dynamic> response = await _httpClient.get(
        path: ApiEndpoints.mediaDownload(mediaId),
        uriParameters: <String, dynamic>{
          if (scope != null && scope.isNotEmpty) 'scope': scope,
          if (scopeId != null && scopeId.isNotEmpty) 'scopeId': scopeId,
        },
      );
      final dynamic data = response.data;
      if (data is! Map<String, Object?>) {
        throw AppUnknownException(
          message: 'Invalid media download response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      return MediaDownloadInfoDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to fetch media download info',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<MediaDeleteResponseDto> deleteMedia({required String mediaId}) async {
    try {
      final Response<dynamic> response = await _httpClient.delete(
        path: ApiEndpoints.media(mediaId),
      );
      final dynamic data = response.data;
      if (data is! Map<String, Object?>) {
        throw AppUnknownException(
          message: 'Invalid media delete response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      return MediaDeleteResponseDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to delete media',
        error: e,
        stackTrace: st,
      );
    }
  }
}
