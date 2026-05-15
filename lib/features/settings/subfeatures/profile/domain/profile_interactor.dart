import 'package:locnet_app/core/core.dart';

final class ProfileInteractor {
  ProfileInteractor({required IUserRepo userRepo, required ILogger logger})
    : _userRepo = userRepo,
      _logger = logger;

  final IUserRepo _userRepo;
  final ILogger _logger;

  Future<User> loadUserData() async {
    _logger.info('Retrieving user data...');
    return _userRepo.me();
  }

  Future<User> udpateUserData({required User updatedUser}) async {
    return _userRepo.updateUser(updatedUser: updatedUser);
  }
}
