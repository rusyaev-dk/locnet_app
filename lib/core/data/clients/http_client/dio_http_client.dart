import 'dart:io';

import 'package:dio/dio.dart';
import 'package:locnet_app/app/exceptions.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/data.dart';

class DioHttpClient implements IHttpClient {
  DioHttpClient({required Dio dio, required ApiConfig apiConfig})
    : _dio = dio,
      _apiConfig = apiConfig;

  final Dio _dio;
  final ApiConfig _apiConfig;

  Uri _makeUri({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? parameters,
  }) {
    final Uri uri = Uri.parse('${baseUrl ?? _apiConfig.baseUrl}$path');
    return parameters != null ? uri.replace(queryParameters: parameters) : uri;
  }

  @override
  Future<Response> get({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _sendRequest(
      method: 'GET',
      path: path,
      baseUrl: baseUrl,
      uriParameters: uriParameters,
      headers: headers,
    );
  }

  @override
  Future<Response> post({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    return await _sendRequest(
      method: 'POST',
      path: path,
      baseUrl: baseUrl,
      uriParameters: uriParameters,
      headers: headers,
      data: data,
    );
  }

  @override
  Future<Response> put({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    return await _sendRequest(
      method: 'PUT',
      path: path,
      baseUrl: baseUrl,
      uriParameters: uriParameters,
      headers: headers,
      data: data,
    );
  }

  @override
  Future<Response> delete({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _sendRequest(
      method: 'DELETE',
      path: path,
      baseUrl: baseUrl,
      uriParameters: uriParameters,
      headers: headers,
    );
  }

  Future<Response> _sendRequest({
    required String method,
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    final Uri uri = _makeUri(
      path: path,
      baseUrl: baseUrl,
      parameters: uriParameters,
    );

    try {
      final Options options = Options(
        contentType: Headers.jsonContentType,
        headers: headers,
      );

      late final Response response;

      switch (method) {
        case 'GET':
          response = await _dio.getUri(uri, options: options);
          break;
        case 'POST':
          response = await _dio.postUri(uri, data: data, options: options);
          break;
        case 'PUT':
          response = await _dio.putUri(uri, data: data, options: options);
          break;
        case 'DELETE':
          response = await _dio.deleteUri(uri, options: options);
          break;
        default:
          throw AppException(
            message: 'Unsupported HTTP method: $method',
            category: AppExceptionCategory.api,
            code: AppExceptionCode.unknown,
            details: <String, Object?>{'method': method},
          );
      }

      _validateResponse(response);
      return response;
    } on DioException catch (e, st) {
      throw _mapDioError(e: e, stackTrace: st);
    } catch (e, st) {
      throw AppException(
        message: 'Unexpected API error',
        category: AppExceptionCategory.api,
        code: AppExceptionCode.unknown,
        error: e,
        stackTrace: st,
      );
    }
  }

  void _validateResponse(Response response) {
    final int code = response.statusCode ?? 0;
    if (code >= 400) {
      throw _mapHttpError(statusCode: code, data: response.data);
    }
  }

  AppException _mapDioError({
    required DioException e,
    required StackTrace stackTrace,
  }) {
    if (e.error is SocketException) {
      return AppException(
        message: 'No internet',
        category: AppExceptionCategory.api,
        code: AppExceptionCode.connection,
        error: e,
        stackTrace: stackTrace,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppException(
          message: 'Request timed out',
          category: AppExceptionCategory.api,
          code: AppExceptionCode.timeout,
          error: e,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        return _mapHttpError(
          statusCode: e.response?.statusCode,
          data: e.response?.data,
          error: e,
          stackTrace: stackTrace,
        );

      default:
        return AppException(
          message: 'Dio error',
          category: AppExceptionCategory.api,
          code: AppExceptionCode.unknown,
          error: e,
          stackTrace: stackTrace,
        );
    }
  }

  AppException _mapHttpError({
    required int? statusCode,
    required dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final String message = _extractMessage(data) ?? 'Unknown error';

    final AppExceptionCode code = switch (statusCode) {
      400 => AppExceptionCode.validation,
      401 => AppExceptionCode.unauthorized,
      403 => AppExceptionCode.forbidden,
      404 => AppExceptionCode.notFound,
      500 => AppExceptionCode.server,
      _ => AppExceptionCode.unknown,
    };

    final Map<String, Object?>? details = _extractErrors(data);

    return AppException(
      message: message,
      category: AppExceptionCategory.api,
      code: code,
      statusCode: statusCode,
      error: error,
      stackTrace: stackTrace,
      details: details,
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map && data['msg'] is String) {
      final String msg = data['msg'] as String;
      if (msg.isNotEmpty) {
        return msg;
      }
    }
    return null;
  }

  Map<String, Object?>? _extractErrors(dynamic data) {
    if (data is Map && data['errors'] is Map) {
      final Map errors = data['errors'] as Map;
      return errors.map((dynamic key, dynamic value) {
        return MapEntry(key.toString(), value);
      });
    }
    return null;
  }
}
