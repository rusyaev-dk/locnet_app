import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

class AuthInteractor {
  AuthInteractor({
    required IAuthRepo authRepo,
    required IUserRepo userRepo,
    required ISessionCacheRepo sessionCacheRepo,
    required IUserCacheRepo userCacheRepo,
    required ILogger logger,
  }) : _authRepo = authRepo,
       _userRepo = userRepo,
       _sessionCacheRepo = sessionCacheRepo,
       _userCacheRepo = userCacheRepo,
       _logger = logger;

  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;
  final ISessionCacheRepo _sessionCacheRepo;
  final IUserCacheRepo _userCacheRepo;
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
      final Session session = await _authRepo.register(
        username: username,
        firstName: firstName,
        lastName: lastName,
        patronymic: patronymic,
        description: description,
        password: password,
      );

      final bool cacheSessionSuccess = await _sessionCacheRepo.saveSession(
        session: session,
      );

      if (!cacheSessionSuccess) {
        throw SessionCacheWriteException(
          message: 'Failed to save session to cache',
        );
      }

      final User user = await _userRepo.getUserById(userId: session.userId);

      final bool cacheUserSuccess = await _userCacheRepo.saveUser(user: user);

      if (!cacheUserSuccess) {
        throw UserCacheWriteException(message: 'Failed to save user to cache');
      }

      return (session, user);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);
      // TODO: переделать
      throw UsernameAlreadyTakenException(
        message: 'Username is already taken',
        error: e,
        stackTrace: st,
      );
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: 'Unauthorized registration attempt',
        error: e,
        stackTrace: st,
      );
    } on ApiConnectionException catch (e, st) {
      _logger.exception(e, st);
      throw RegistrationFailedException(
        message: 'Unable to connect to server',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      _logger.exception(e, st);
      throw RegistrationFailedException(
        message: 'Unknown registration error',
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
      final session = await _authRepo.logIn(
        username: username,
        password: password,
      );

      final bool cacheSessionSuccess = await _sessionCacheRepo.saveSession(
        session: session,
      );

      if (!cacheSessionSuccess) {
        throw SessionCacheWriteException(
          message: 'Failed to save session to cache',
        );
      }

      final User user = await _userRepo.getUserById(userId: session.userId);

      final bool cacheUserSuccess = await _userCacheRepo.saveUser(user: user);

      if (!cacheUserSuccess) {
        throw UserCacheWriteException(message: 'Failed to save user to cache');
      }

      return (session, user);
    } on ApiValidationException catch (e, st) {
      _logger.exception(e, st);
      // TODO: переделать
      throw UsernameAlreadyTakenException(
        message: 'Username is already taken',
        error: e,
        stackTrace: st,
      );
    } on ApiUnauthorizedException catch (e, st) {
      _logger.exception(e, st);
      throw AuthUnauthorizedException(
        message: 'Unauthorized logIn attempt',
        error: e,
        stackTrace: st,
      );
    } on ApiConnectionException catch (e, st) {
      _logger.exception(e, st);
      throw LogInFailedException(
        message: 'Unable to connect to server',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      _logger.exception(e, st);
      throw LogInFailedException(
        message: 'Unknown logIn error',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<bool> checkCachedSessionFreshness() async {
    try {
      final session = await getCachedSession();
      if (session.expiresAt.isAfter(DateTime.now())) {
        return true;
      }
      return false;
    } catch (e, st) {
      _logger.exception(e, st);
      return false;
    }
  }

  Future<void> logOut() async {
    await _sessionCacheRepo.clearSession();
  }

  Future<Session> getCachedSession() async {
    return await _sessionCacheRepo.loadSession();
  }
}
