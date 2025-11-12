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
      // TODO: implement refresh
      final session = await _sessionCacheRepo.loadSession();
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    } on (StorageNotFoundException, StorageReadException) catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    } on StorageUnknownException catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }

    handler.next(options);
  }
}
