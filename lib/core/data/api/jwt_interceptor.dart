import 'package:dio/dio.dart';
import 'package:locnet_app/core/data/api/api.dart';

class JwtRefreshInterceptor extends Interceptor {
  JwtRefreshInterceptor({required IAuthTokenProvider authTokenProvider})
    : _authProvider = authTokenProvider;

  final IAuthTokenProvider _authProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authProvider.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _authProvider.refreshToken();
      if (refreshed) {
        final retryOptions = err.requestOptions;
        final newToken = await _authProvider.getToken();
        retryOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(retryOptions);
        return handler.resolve(response);
      }
    }
    return handler.next(err);
  }
}
