import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/mock/mock_backend_storage.dart';
import 'package:locnet_app/mock/mock_users.dart';

/// In-memory implementation of IUserRepo backed by [MockBackendStorage].
final class MockMemoryUserRepo implements IUserRepo {
  MockMemoryUserRepo({required MockBackendStorage backendStorage})
    : _backendStorage = backendStorage;

  final MockBackendStorage _backendStorage;

  @override
  Future<User> me() async {
    final UserDTO? adminDto = _backendStorage.getUserById(
      MockUsers.adminUser.userId,
    );
    if (adminDto == null) {
      throw StateError('Admin user not found: ${MockUsers.adminUser.userId}');
    }
    return User.fromDTO(adminDto);
  }

  @override
  Future<User> getUserById({required String userId}) async {
    final UserDTO? dto = _backendStorage.getUserById(userId);
    if (dto == null) {
      throw StateError('User not found: $userId');
    }
    return User.fromDTO(dto);
  }

  @override
  Future<bool> updateUser({required User updatedUser}) async {
    final UserDTO dto = UserDTO(
      userId: updatedUser.userId,
      username: updatedUser.username,
      languageCode: updatedUser.languageCode,
      password: 'hash_${updatedUser.username}_pw',
      firstName: updatedUser.firstName,
      lastName: updatedUser.lastName,
      description: updatedUser.description,
      avatarId: updatedUser.avatarId,
      isDeleted: updatedUser.isDeleted,
      isBanned: updatedUser.isBanned,
      createdAt: updatedUser.createdAt,
      updatedAt: updatedUser.updatedAt,
    );

    return _backendStorage.updateUser(dto);
  }
}
