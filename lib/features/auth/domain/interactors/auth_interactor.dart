import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class AuthInteractor {
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

  Future<bool> hasValidSession() async {
    return true;
  }

  Future<Session> getSession() async {
    try {
      return await _sessionCacheRepo.loadSession();
    } catch (e, st) {
      _logger
        ..exception(e, st)
        ..log("Trying to logIn...");
      final session = await logIn();
      final saveSuccess = await _sessionCacheRepo.saveSession(session: session);
      if (!saveSuccess) {
        // TODO: replace with custom exception
        throw StateError("Failed to cache user");
      }
      return session;
    }
  }

  Future<User> getUser() async {
    try {
      return await _userCacheRepo.loadUser();
    } catch (e, st) {
      _logger
        ..exception(e, st)
        ..log('Trying to fetch user from remote...');

      final session = await getSession();
      final userId = session.userId;
      // TODO:implement with ME endpoint !!!
      final user = await _userRepo.getUserById(userId: userId);

      final bool saveSuccess = await _userCacheRepo.saveUser(user: user);

      if (!saveSuccess) {
        throw StateError('Failed to cache user');
      }

      return user;
    }
  }

  Future<Session> logIn() async {
    final session = await _authRepo.login(initData: 1);
    final user = await _userRepo.getUserById(userId: session.userId);
    final success = await _userCacheRepo.saveUser(user: user);
    if (!success) {
      // TODO: replace with custom exception
      throw StateError("Failed to cache user");
    }
    return session;
  }

  Future<void> logOut() async {
    await _sessionCacheRepo.clearSession();
  }
}
