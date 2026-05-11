import 'package:dio/dio.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class JWTInterceptor extends Interceptor {
  JWTInterceptor({
    required IHttpClient httpClient,
    required ISessionCacheRepo sessionCacheRepo,
    required IAuthTokenRefreshRepo authTokenRefreshRepo,
    required UnauthorizedEventBus unauthorizedEventBus,
    required ILogger logger,
  }) : _httpClient = httpClient,
       _sessionCacheRepo = sessionCacheRepo,
       _authTokenRefreshRepo = authTokenRefreshRepo,
       _unauthorizedEventBus = unauthorizedEventBus,
       _logger = logger;

  final IHttpClient _httpClient;
  final ISessionCacheRepo _sessionCacheRepo;
  final IAuthTokenRefreshRepo _authTokenRefreshRepo;
  final UnauthorizedEventBus _unauthorizedEventBus;
  final ILogger _logger;
  Future<Session>? _refreshInFlight;
  static const Duration _refreshLeeway = Duration(seconds: 30);
  static const String _retryMarker = '__jwtRefreshRetried__';

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
      Session session = await _sessionCacheRepo.loadSession();
      session = await _ensureValidSession(session);
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    } on StorageException catch (e) {
      // No session before login is expected. Do not block request.
      _logger.warning('Skip Authorization header: ${e.message}');
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      _unauthorizedEventBus.emit();
    } catch (e, st) {
      // Any unexpected error: also do not block, only log.
      _logger.exception(e, st);
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(err.requestOptions.path) &&
        !_isPresignedS3Request(err.requestOptions) &&
        err.requestOptions.extra[_retryMarker] != true) {
      await _retryWithRefreshedToken(err, handler);
      return;
    }
    if (err.response?.statusCode == 401) {
      _unauthorizedEventBus.emit();
    }
    handler.next(err);
  }

  Future<void> _retryWithRefreshedToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final Session currentSession = await _sessionCacheRepo.loadSession();
      final Session refreshedSession = await _refreshSession(currentSession);
      final RequestOptions retriedRequest = err.requestOptions.copyWith(
        headers: <String, dynamic>{
          ...err.requestOptions.headers,
          'Authorization': 'Bearer ${refreshedSession.accessToken}',
        },
        extra: <String, dynamic>{
          ...err.requestOptions.extra,
          _retryMarker: true,
        },
      );
      final Response<dynamic> response = await _httpClient.fetch(
        retriedRequest,
      );
      handler.resolve(response);
    } catch (e, st) {
      _logger.exception(e, st);
      _unauthorizedEventBus.emit();
      handler.next(err);
    }
  }

  Future<Session> _ensureValidSession(Session session) async {
    final DateTime refreshThreshold =
        DateTime.now().toUtc().add(_refreshLeeway);
    if (session.accessExpiresAt.toUtc().isAfter(refreshThreshold)) {
      return session;
    }
    return _refreshSession(session);
  }

  Future<Session> _refreshSession(Session session) async {
    final DateTime now = DateTime.now().toUtc();
    if (!session.refreshExpiresAt.toUtc().isAfter(now)) {
      throw ApiUnauthorizedException(message: 'Refresh token expired');
    }

    final Future<Session>? inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final Future<Session> refreshFuture = _performRefresh(session);
    _refreshInFlight = refreshFuture;
    try {
      return await refreshFuture;
    } finally {
      if (identical(_refreshInFlight, refreshFuture)) {
        _refreshInFlight = null;
      }
    }
  }

  Future<Session> _performRefresh(Session session) async {
    final Session refreshed = await _authTokenRefreshRepo.refresh(session);
    await _sessionCacheRepo.saveSession(session: refreshed);
    _logger.info('Access token refreshed.');
    return refreshed;
  }

  bool _isAuthEndpoint(String path) {
    final String normalizedPath = Uri.tryParse(path)?.path ?? path;
    return normalizedPath == ApiEndpoints.logIn ||
        normalizedPath == ApiEndpoints.register ||
        normalizedPath == ApiEndpoints.refresh;
  }

  bool _isPresignedS3Request(RequestOptions options) {
    final Uri uri = options.uri;
    final Map<String, String> queryParameters = uri.queryParameters;
    return queryParameters.containsKey('X-Amz-Algorithm') &&
        queryParameters.containsKey('X-Amz-Signature');
  }
}
