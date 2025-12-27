import 'package:locnet_app/core/core.dart';

abstract interface class IUserRepo {
  Future<User> updateUser({required User updatedUser});
  Future<User> me();
  Future<User> getUserById({required String userId});
}
