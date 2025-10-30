import 'package:locnet_app/core/core.dart';

abstract interface class IUserRepo {
  Future<bool> updateUser({required String updatedUser});
  Future<User> getUserById({required String userId});
}
