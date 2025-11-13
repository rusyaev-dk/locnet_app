import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class AuthInteractor {
  AuthInteractor({
    required IAuthRepo authRepo,
    required IUserRepo userRepo,
    required ISessionCacheRepo sessionCacheRepo,
    required IUserCacheRepo userCacheRepo,
  }) : _authRepo = authRepo,
       _userRepo = userRepo,
       _sessionCacheRepo = sessionCacheRepo,
       _userCacheRepo = userCacheRepo;

  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;
  final ISessionCacheRepo _sessionCacheRepo;
  final IUserCacheRepo _userCacheRepo;

  Future<bool> hasValidSession() async {
    return true;
  }

  Future<Session> getCachedSession() async {
    return await _sessionCacheRepo.loadSession();
  }

  Future<User> getCachedUser() async {
    return await _userCacheRepo.loadUser();
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
