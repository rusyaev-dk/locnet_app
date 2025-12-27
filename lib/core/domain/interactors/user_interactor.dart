import 'package:locnet_app/core/core.dart';

final class UserInteractor {
  UserInteractor({
    required IUserRepo userRepo,
    required IUserCacheRepo userCacheRepo,
    required ILogger logger,
  }) : _userRepo = userRepo,
       _userCacheRepo = userCacheRepo,
       _logger = logger;

  final IUserRepo _userRepo;
  final IUserCacheRepo _userCacheRepo;
  final ILogger _logger;

  Future<User> getUserById({required String userId}) async {
    _logger.log("Retrieving user with id: $userId");
    return await _userRepo.getUserById(userId: userId);
  }

  Future<User> getCurrentUser() async {
    try {
      return await _userCacheRepo.loadUser();
    } catch (e, st) {
      _logger
        ..exception(e, st)
        ..log('Trying to fetch user from remote...');

      final user = await _userRepo.me();
      final saveSuccess = await _userCacheRepo.saveUser(user: user);

      if (!saveSuccess) {
        _logger.exception("Failed to cache user");
      }

      return user;
    }
  }
}
