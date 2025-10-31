import 'package:dio/dio.dart';

abstract interface class IHttpClient {
  Future<Response> get({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response> post({
    required String path,
    dynamic data,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response> put({
    required String path,
    dynamic data,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response> delete({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
  });
}
