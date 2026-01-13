import 'package:locnet_app/core/core.dart';
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
  }) : _authRepo = authRepo,
       _userRepo = userRepo,
       _sessionCacheRepo = sessionCacheRepo,
       _userCacheRepo = userCacheRepo,
       _deviceInfoRepo = deviceInfoRepo,
       _logger = logger;

  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;
  final ISessionCacheRepo _sessionCacheRepo;
  final IUserCacheRepo _userCacheRepo;
  final IDeviceInfoRepo _deviceInfoRepo;
  final ILogger _logger;

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

      final bool cacheSessionSuccess = await _sessionCacheRepo.saveSession(
        session: session,
      );

      if (!cacheSessionSuccess) {
        _logger.exception('Failed to save session to cache');
      }

      final User user = await _userRepo.getUserById(userId: session.userId);

      final bool cacheUserSuccess = await _userCacheRepo.saveUser(user: user);

      if (!cacheUserSuccess) {
        _logger.exception('Failed to save user to cache');
      }

      return (session, user);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);

      final String? usernameError = _getFieldError(e.errors, 'username');
      if (usernameError != null) {
        throw UsernameAlreadyTakenException(
          message: usernameError,
          error: e,
          stackTrace: st,
        );
      }

      final String? passwordError = _getFieldError(e.errors, 'password');
      if (passwordError != null) {
        throw RegistrationFailedException(
          message: passwordError,
          error: e,
          stackTrace: st,
        );
      }

      throw RegistrationFailedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
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
    } on ApiTimeoutException catch (e, st) {
      _logger.exception(e, st);

      throw RegistrationFailedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiConnectionException catch (e, st) {
      _logger.exception(e, st);

      throw RegistrationFailedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiServerException catch (e, st) {
      _logger.exception(e, st);

      throw RegistrationFailedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on AppApiException catch (e, st) {
      _logger.exception(e, st);

      throw RegistrationFailedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on AppStorageException catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    } catch (e, st) {
      _logger.exception(e, st);

      throw RegistrationFailedException(
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

      final bool cacheSessionSuccess = await _sessionCacheRepo.saveSession(
        session: session,
      );

      if (!cacheSessionSuccess) {
        _logger.exception('Failed to save session to cache');
      }

      final User user = await _userRepo.getUserById(userId: session.userId);

      final bool cacheUserSuccess = await _userCacheRepo.saveUser(user: user);

      if (!cacheUserSuccess) {
        _logger.exception('Failed to save user to cache');
      }

      return (session, user);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);

      final String? usernameError = _getFieldError(e.errors, 'username');
      final String? passwordError = _getFieldError(e.errors, 'password');

      if (usernameError != null || passwordError != null) {
        throw AuthInvalidCredentialsException(
          message: usernameError ?? passwordError ?? e.message,
          error: e,
          stackTrace: st,
        );
      }

      throw LogInFailedException(message: e.message, error: e, stackTrace: st);
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
    } on ApiTimeoutException catch (e, st) {
      _logger.exception(e, st);

      throw LogInFailedException(message: e.message, error: e, stackTrace: st);
    } on ApiConnectionException catch (e, st) {
      _logger.exception(e, st);

      throw LogInFailedException(message: e.message, error: e, stackTrace: st);
    } on ApiServerException catch (e, st) {
      _logger.exception(e, st);

      throw LogInFailedException(message: e.message, error: e, stackTrace: st);
    } on AppApiException catch (e, st) {
      _logger.exception(e, st);

      throw LogInFailedException(message: e.message, error: e, stackTrace: st);
    } on AppStorageException catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    } catch (e, st) {
      _logger.exception(e, st);

      throw LogInFailedException(
        message: e.toString(),
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<(Session, User)?> restoreSession() async {
    try {
      final Session cachedSession = await _sessionCacheRepo.loadSession();

      if (cachedSession.expiresAt.isAfter(DateTime.now())) {
        final User user = await _userRepo.getUserById(
          userId: cachedSession.userId,
        );
        return (cachedSession, user);
      }

      final DeviceInfo deviceInfo = await _deviceInfoRepo.getDeviceInfo();

      final Session refreshedSession = await _authRepo.refresh(
        refreshToken: cachedSession.refreshToken,
        sessionId: cachedSession.sessionId,
        deviceInfo: deviceInfo,
      );

      final bool cacheSessionSuccess = await _sessionCacheRepo.saveSession(
        session: refreshedSession,
      );

      if (!cacheSessionSuccess) {
        _logger.exception('Failed to save session to cache');
      }

      final User user = await _userRepo.getUserById(
        userId: refreshedSession.userId,
      );

      final bool cacheUserSuccess = await _userCacheRepo.saveUser(user: user);

      if (!cacheUserSuccess) {
        _logger.exception('Failed to save user to cache');
      }

      return (refreshedSession, user);
    } on StorageNotFoundException catch (e, st) {
      _logger.exception(e, st);
      return null;
    } on ApiConnectionException catch (e, st) {
      _logger.exception(e, st);
      return null;
    } on ApiTimeoutException catch (e, st) {
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
    } on AppStorageException catch (e, st) {
      _logger.exception(e, st);
      return null;
    } on AppApiException catch (e, st) {
      _logger.exception(e, st);
      await logOut();
      return null;
    } catch (e, st) {
      _logger.exception(e, st);
      await logOut();
      return null;
    }
  }

  Future<void> logOut() async {
    await _sessionCacheRepo.clearSession();
    await _userCacheRepo.clearUser();
  }

  Future<Session> getCachedSession() async {
    return await _sessionCacheRepo.loadSession();
  }

  String? _getFieldError(Map<String, dynamic>? errors, String fieldName) {
    if (errors == null) {
      return null;
    }

    final dynamic fieldValue = errors[fieldName];

    if (fieldValue is String && fieldValue.isNotEmpty) {
      return fieldValue;
    }

    if (fieldValue is List && fieldValue.isNotEmpty) {
      final dynamic firstValue = fieldValue.first;
      if (firstValue is String && firstValue.isNotEmpty) {
        return firstValue;
      }
    }

    return null;
  }
}
