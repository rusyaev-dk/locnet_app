import 'package:locnet_app/core/core.dart';

final class UserInteractor {
  UserInteractor({required IUserRepo userRepo, required ILogger logger})
    : _userRepo = userRepo,
      _logger = logger;

  final IUserRepo _userRepo;
  final ILogger _logger;

  Future<User> getUserById({required String userId}) async {
    _logger.log("Retrieving user with id: $userId");
    return await _userRepo.getUserById(userId: userId);
  }
}
