import 'package:dio/dio.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';

final class JWTInterceptor extends Interceptor {
  JWTInterceptor({
    required ISessionCacheRepo sessionCacheRepo,
    required UnauthorizedEventBus unauthorizedEventBus,
    required ILogger logger,
  }) : _sessionCacheRepo = sessionCacheRepo,
       _unauthorizedEventBus = unauthorizedEventBus,
       _logger = logger;

  final ISessionCacheRepo _sessionCacheRepo;
  final UnauthorizedEventBus _unauthorizedEventBus;
  final ILogger _logger;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthEndpoint(options.path) || _isPresignedS3Request(options)) {
      handler.next(options);
      return;
    }

    try {
      final session = await _sessionCacheRepo.loadSession();
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    } on StorageException catch (e, st) {
      // No session / read failure: do not block request, only log.
      _logger.exception(e, st);
    } catch (e, st) {
      // Any unexpected error: also do not block, only log.
      _logger.exception(e, st);
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _unauthorizedEventBus.emit();
    }
    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    return path == ApiEndpoints.logIn ||
        path == ApiEndpoints.register ||
        path == ApiEndpoints.refresh;
  }

  bool _isPresignedS3Request(RequestOptions options) {
    final Uri uri = options.uri;
    final Map<String, String> queryParameters = uri.queryParameters;
    return queryParameters.containsKey('X-Amz-Algorithm') &&
        queryParameters.containsKey('X-Amz-Signature');
  }
}
