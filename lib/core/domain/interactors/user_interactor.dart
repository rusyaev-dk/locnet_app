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

  Future<User> getCachedUser() async {
    return await _userCacheRepo.loadUser();
  }
}
