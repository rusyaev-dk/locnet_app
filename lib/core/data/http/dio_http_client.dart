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
  }) async => await _sendRequest(
    method: 'POST',
    path: path,
    baseUrl: baseUrl,
    uriParameters: uriParameters,
    headers: headers,
    data: data,
  );

  @override
  Future<Response> put({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async => await _sendRequest(
    method: 'PUT',
    path: path,
    baseUrl: baseUrl,
    uriParameters: uriParameters,
    headers: headers,
    data: data,
  );

  @override
  Future<Response> delete({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  }) async => await _sendRequest(
    method: 'DELETE',
    path: path,
    baseUrl: baseUrl,
    uriParameters: uriParameters,
    headers: headers,
  );

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
          throw ApiUnknownException(
            message: 'Unsupported HTTP method: $method',
          );
      }

      _validateResponse(response);
      return response;
    } on DioException catch (e, st) {
      throw _mapDioError(e, st);
    } catch (e, st) {
      throw ApiUnknownException(
        message: 'Unexpected error',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _validateResponse(Response response) {
    final code = response.statusCode ?? 0;
    if (code >= 400) throw _mapHttpError(code, response.data);
  }

  Exception _mapDioError(DioException e, StackTrace st) {
    if (e.error is SocketException) {
      return ApiConnectionException(
        message: 'No internet',
        error: e,
        stackTrace: st,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiTimeoutException(
          message: 'Request timed out',
          error: e,
          stackTrace: st,
        );
      case DioExceptionType.badResponse:
        return _mapHttpError(e.response?.statusCode, e.response?.data);
      default:
        return ApiUnknownException(
          message: 'Dio error',
          error: e,
          stackTrace: st,
        );
    }
  }

  Exception _mapHttpError(int? code, dynamic data) {
    final msg = (data is Map && data['msg'] != null)
        ? data['msg']
        : 'Unknown error';
    switch (code) {
      case 400:
        return ApiValidationException(message: msg, statusCode: code);
      case 401:
        return ApiUnauthorizedException(message: msg, statusCode: code);
      case 403:
        return ApiForbiddenException(message: msg, statusCode: code);
      case 404:
        return ApiNotFoundException(message: msg, statusCode: code);
      case 500:
        return ApiServerException(message: 'Server error', statusCode: code);
      default:
        return ApiUnknownException(message: msg, statusCode: code);
    }
  }
}
