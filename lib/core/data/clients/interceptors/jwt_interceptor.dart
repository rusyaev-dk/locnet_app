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
    try {
      if (_isAuthEndpoint(options.path)) {
        handler.next(options);
        return;
      }

      final session = await _sessionCacheRepo.loadSession();
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';

      handler.next(options);
    } on StorageNotFoundException {
      // No cached session yet: continue without Authorization header.
      handler.next(options);
    } on StorageReadException catch (e, st) {
      // Cache read failed: do not block the request, just log it.
      _logger.exception(e, st);
      handler.next(options);
    } on StorageUnknownException catch (e, st) {
      _logger.exception(e, st);
      handler.next(options);
    } catch (e, st) {
      _logger.exception(e, st);
      handler.next(options);
    }
  }

  bool _isAuthEndpoint(String path) {
    return path == ApiEndpoints.logIn ||
        path == ApiEndpoints.register ||
        path == ApiEndpoints.refresh;
  }
}
