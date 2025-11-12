
import 'package:locnet_app/core/core.dart';

abstract interface class IUserCacheRepo {
  Future<bool> saveUser({required User user});
  Future<User> loadUser();
}
