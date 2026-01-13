import 'package:dio/dio.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';

final class JWTInterceptor extends Interceptor {
  JWTInterceptor({
    required ISessionCacheRepo sessionCacheRepo,
    required ILogger logger,
  }) : _sessionCacheRepo = sessionCacheRepo,
       _logger = logger;

  final ISessionCacheRepo _sessionCacheRepo;
  final ILogger _logger;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final session = await _sessionCacheRepo.loadSession();
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    } on (StorageException, StorageIOException) catch (e, st) {
      // No session / read failure: do not block request, only log.
      _logger.exception(e, st);
    } catch (e, st) {
      // Any unexpected error: also do not block, only log.
      _logger.exception(e, st);
    }

    handler.next(options);
  }

  bool _isAuthEndpoint(String path) {
    return path == ApiEndpoints.logIn ||
        path == ApiEndpoints.register ||
        path == ApiEndpoints.refresh;
  }
}
