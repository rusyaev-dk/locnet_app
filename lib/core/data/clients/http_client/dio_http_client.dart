import 'dart:io';

import 'package:dio/dio.dart';
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
    final uri = Uri.parse('${baseUrl ?? _apiConfig.baseUrl}$path');
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
    final uri = _makeUri(
      path: path,
      baseUrl: baseUrl,
      parameters: uriParameters,
    );

    try {
      final options = Options(
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
          throw ApiException(message: 'Unsupported HTTP method: $method');
      }

      _validateResponse(response);
      return response;
    } on DioException catch (e, st) {
      throw _mapDioError(e, st);
    } catch (e, st) {
      throw ApiException(message: 'Unexpected error', error: e, stackTrace: st);
    }
  }

  void _validateResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 400) {
      throw _mapHttpError(statusCode, response.data);
    }
  }

  Exception _mapDioError(DioException exception, StackTrace st) {
    if (exception.error is SocketException) {
      return ApiException(
        message: 'No internet',
        error: exception,
        stackTrace: st,
      );
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Request timed out',
          error: exception,
          stackTrace: st,
        );

      case DioExceptionType.badResponse:
        return _mapHttpError(
          exception.response?.statusCode,
          exception.response?.data,
          error: exception,
          st: st,
        );

      default:
        return ApiException(
          message: 'Dio error',
          error: exception,
          stackTrace: st,
        );
    }
  }

  Exception _mapHttpError(
    int? statusCode,
    dynamic data, {
    Object? error,
    StackTrace? st,
  }) {
    final message = _extractMessage(data: data);

    switch (statusCode) {
      case 401:
        return ApiUnauthorizedException(
          message: message,
          error: error,
          stackTrace: st,
          details: _extractDetails(data: data),
        );

      case 403:
        return ApiForbiddenException(
          message: message,
          error: error,
          stackTrace: st,
          details: _extractDetails(data: data),
        );

      case 404:
        return ApiNotFoundException(
          message: message,
          error: error,
          stackTrace: st,
        );

      case 422:
      case 400:
        return ApiValidationException(
          message: message,
          error: error,
          stackTrace: st,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ApiServerException(
          message: 'Server error',
          statusCode: statusCode,
          error: error,
          stackTrace: st,
        );

      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: st,
        );
    }
  }

  String _extractMessage({required dynamic data}) {
    if (data is Map) {
      final dynamic msg = data['msg'] ?? data['message'] ?? data['error'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return 'Unknown error';
  }

  Map<String, Object?>? _extractDetails({required dynamic data}) {
    if (data is Map) {
      return data.cast<String, Object?>();
    }
    return null;
  }
}
