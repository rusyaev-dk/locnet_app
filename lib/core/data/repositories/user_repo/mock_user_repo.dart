import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/mock/mock_users.dart';

/// In-memory implementation of IUserRepo with seeded data from [MockUsers].
final class MockMemoryUserRepo implements IUserRepo {
  MockMemoryUserRepo() : _usersById = <String, UserDTO>{} {
    _seedFromMockUsers();
  }

  final Map<String, UserDTO> _usersById;

  @override
  Future<User> me() async {
    try {
      final UserDTO? adminDto = _usersById[MockUsers.adminUser.userId];
      if (adminDto == null) {
        throw StateError('Admin user not found: ${MockUsers.adminUser.userId}');
      }
      return User.fromDTO(adminDto);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<User> getUserById({required String userId}) async {
    try {
      final UserDTO? dto = _usersById[userId];
      if (dto == null) {
        throw StateError('User not found: $userId');
      }
      return User.fromDTO(dto);
    } catch (error) {
      rethrow;
    }
  }

  /// Expects [updatedUser] to be a JSON string compatible with [UserDTO.fromJSON].
  /// Returns true if the user existed and was updated, false otherwise.
  @override
  Future<bool> updateUser({required User updatedUser}) async {
    return true;
  }

  void _seedFromMockUsers() {
    for (final User user in MockUsers.allUsers) {
      final UserDTO dto = UserDTO(
        userId: user.userId,
        username: user.username,
        languageCode: user.languageCode,
        password: 'hash_${user.username}_pw',
        firstName: user.firstName,
        lastName: user.lastName,
        description: user.description,
        avatarId: user.avatarId,
        isDeleted: user.isDeleted,
        isBanned: user.isBanned,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
      _usersById[user.userId] = dto;
    }
  }
}
