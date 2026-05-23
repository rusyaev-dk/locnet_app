import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

class AuthInteractor {
  AuthInteractor({
    required IAuthRepo authRepo,
    required IUserRepo userRepo,
    required ISessionCacheRepo sessionCacheRepo,
    required IUserCacheRepo userCacheRepo,
    required IDeviceInfoRepo deviceInfoRepo,
    required ILogger logger,
    required AppDatabase db,
  }) : _authRepo = authRepo,
       _userRepo = userRepo,
       _sessionCacheRepo = sessionCacheRepo,
       _userCacheRepo = userCacheRepo,
       _deviceInfoRepo = deviceInfoRepo,
       _logger = logger,
       _db = db;

  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;
  final ISessionCacheRepo _sessionCacheRepo;
  final IUserCacheRepo _userCacheRepo;
  final IDeviceInfoRepo _deviceInfoRepo;
  final ILogger _logger;
  final AppDatabase _db;

  Future<(Session, User)> register({
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    String? patronymic,
    String? description,
  }) async {
    try {
      final DeviceInfo deviceInfo = await _deviceInfoRepo.getDeviceInfo();

      final Session session = await _authRepo.register(
        username: username,
        firstName: firstName,
        lastName: lastName,
        patronymic: patronymic,
        description: description,
        password: password,
        deviceInfo: deviceInfo,
      );
      await _tryCacheSession(session);

      final User user = await _userRepo.getUserById(userId: session.userId);
      await _tryCacheUser(user);

      return (session, user);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiForbiddenException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiServerException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on ApiException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on StorageException catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    } catch (e, st) {
      _logger.exception(e, st);
      throw AppUnknownException(
        message: e.toString(),
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<(Session, User)> logIn({
    required String username,
    required String password,
  }) async {
    try {
      final DeviceInfo deviceInfo = await _deviceInfoRepo.getDeviceInfo();

      final Session session = await _authRepo.logIn(
        username: username,
        password: password,
        deviceInfo: deviceInfo,
      );

      await _tryCacheSession(session);
      final User user = await _userRepo.getUserById(userId: session.userId);
      await _tryCacheUser(user);

      return (session, user);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);

      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      throw AuthInvalidCredentialsException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiForbiddenException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiServerException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on ApiException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on StorageException catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    } catch (e, st) {
      _logger.exception(e, st);
      throw AppUnknownException(
        message: e.toString(),
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<bool> validateRegisterLogin({required String login}) async {
    try {
      return await _authRepo.validateLogin(login: login);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiForbiddenException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiServerException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } on ApiException catch (e, st) {
      _logger.exception(e, st);
      throw AuthException(message: e.message, error: e, stackTrace: st);
    } catch (e, st) {
      _logger.exception(e, st);
      throw AppUnknownException(
        message: e.toString(),
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<(Session, User)?> restoreSession() async {
    try {
      final Session cachedSession = await _sessionCacheRepo.loadSession();
      final DateTime now = DateTime.now();

      if (!cachedSession.refreshExpiresAt.isAfter(now)) {
        await logOut();
        return null;
      }

      if (cachedSession.accessExpiresAt.isAfter(now)) {
        try {
          final User user = await _userRepo.getUserById(
            userId: cachedSession.userId,
          );
          return (cachedSession, user);
        } on ApiNetworkException catch (e, st) {
          _logger.exception('Server unreachable, using cached user: $e', st);
          final User cachedUser = await _userCacheRepo.loadUser();
          return (cachedSession, cachedUser);
        } on ApiTimeoutException catch (e, st) {
          _logger.exception('Request timed out, using cached user: $e', st);
          final User cachedUser = await _userCacheRepo.loadUser();
          return (cachedSession, cachedUser);
        }
      }

      final DeviceInfo deviceInfo = await _deviceInfoRepo.getDeviceInfo();

      late final Session activeSession;
      try {
        final Session refreshedSession = await _authRepo.refresh(
          refreshToken: cachedSession.refreshToken,
          sessionId: cachedSession.sessionId,
          deviceInfo: deviceInfo,
        );
        await _tryCacheSession(refreshedSession);
        activeSession = refreshedSession;
      } on ApiNetworkException catch (e, st) {
        _logger.exception('Server unreachable during refresh, using cached session: $e', st);
        activeSession = cachedSession;
      } on ApiTimeoutException catch (e, st) {
        _logger.exception('Refresh timed out, using cached session: $e', st);
        activeSession = cachedSession;
      }

      try {
        final User user = await _userRepo.getUserById(
          userId: activeSession.userId,
        );
        await _tryCacheUser(user);
        return (activeSession, user);
      } on ApiNetworkException catch (e, st) {
        _logger.exception('Server unreachable, using cached user: $e', st);
        final User cachedUser = await _userCacheRepo.loadUser();
        return (activeSession, cachedUser);
      } on ApiTimeoutException catch (e, st) {
        _logger.exception('Request timed out, using cached user: $e', st);
        final User cachedUser = await _userCacheRepo.loadUser();
        return (activeSession, cachedUser);
      }
    } on StorageException catch (e, st) {
      _logger.exception(e, st);
      return null;
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      await logOut();
      return null;
    } on ApiForbiddenException catch (e, st) {
      _logger.exception(e, st);
      await logOut();
      return null;
    } on ApiException catch (e, st) {
      _logger.exception(e, st);
      return null;
    } catch (e, st) {
      _logger.exception(e, st);
      return null;
    }
  }

  Future<void> logOut() async {
    await _sessionCacheRepo.clearSession();
    await _userCacheRepo.clearUser();
    await _db.clearAll();
  }

  /// Persists the latest user snapshot (e.g. after profile update).
  Future<void> cacheUser(User user) async {
    await _tryCacheUser(user);
  }

  Future<Session> getCachedSession() async {
    return await _sessionCacheRepo.loadSession();
  }

  Future<void> _tryCacheSession(Session session) async {
    try {
      final bool cacheSessionSuccess = await _sessionCacheRepo.saveSession(
        session: session,
      );
      if (!cacheSessionSuccess) {
        _logger.exception('Failed to save session object to cache');
      }
    } on StorageException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _tryCacheUser(User user) async {
    try {
      final bool cacheUserSuccess = await _userCacheRepo.saveUser(user: user);
      if (!cacheUserSuccess) {
        _logger.exception('Failed to save user object to cache');
      }
    } on StorageException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
