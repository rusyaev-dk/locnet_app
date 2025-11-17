import 'package:locnet_app/core/core.dart';

final class UserInteractor {
  UserInteractor({required IUserRepo userRepo, required ILogger logger})
    : _userRepo = userRepo,
      _logger = logger;

  final IUserRepo _userRepo;
  final ILogger _logger;
}
