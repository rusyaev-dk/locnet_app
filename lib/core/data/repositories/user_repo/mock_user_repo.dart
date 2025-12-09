import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockUserRepo implements IUserRepo {
  MockUserRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<User> me() async {
    return User.fromDto(MockUsers.adminUser);
  }

  @override
  Future<User> getUserById({required String userId}) async {
    final UserDto dto = _backendStorage.getUserById(userId: userId);
    return User.fromDto(dto);
  }

  @override
  Future<bool> updateUser({required User updatedUser}) async {
    return _backendStorage.updateUser(updatedUser);
  }
}
