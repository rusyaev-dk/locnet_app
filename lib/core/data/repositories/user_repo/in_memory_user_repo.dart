import 'dart:convert';
import 'dart:math';

import 'package:locnet_app/core/core.dart';

/// In-memory implementation of IUserRepo with seeded data:
/// - 1 admin account
/// - N random users (100 by default)
final class InMemoryUserRepo implements IUserRepo {
  InMemoryUserRepo({int randomUsersCount = 100})
    : _usersById = <String, UserDTO>{},
      _random = Random() {
    _seedInitialData(randomUsersCount: randomUsersCount);
  }

  final Map<String, UserDTO> _usersById;
  final Random _random;

  @override
  Future<User> getUserById({required String userId}) async {
    try {
      final UserDTO? dto = _usersById[userId];
      if (dto == null) {
        throw StateError('User not found: $userId');
      }
      return User.fromDTO(dto);
    } catch (error) {
      // Re-throwing to preserve stack trace for callers while keeping try-catch in async method.
      rethrow;
    }
  }

  /// Expects [updatedUser] to be a JSON string compatible with [UserDTO.fromJson].
  /// Returns true if the user existed and was updated, false otherwise.
  @override
  Future<bool> updateUser({required String updatedUser}) async {
    try {
      final dynamic raw = jsonDecode(updatedUser);
      if (raw is! Map<String, dynamic>) {
        return false;
      }
      final UserDTO incoming = UserDTO.fromJson(raw);

      final UserDTO? existing = _usersById[incoming.userId];
      if (existing == null) {
        return false;
      }

      final DateTime now = DateTime.now();
      final UserDTO updated = incoming.copyWith(updatedAt: now);

      _usersById[updated.userId] = updated;
      return true;
    } catch (error) {
      return false;
    }
  }

  // ---------------------------
  // Seeding helpers (private)
  // ---------------------------

  void _seedInitialData({required int randomUsersCount}) {
    final DateTime now = DateTime.now();

    // Seed admin
    final String adminId = _uuidV4();
    final UserDTO admin = UserDTO(
      userId: adminId,
      username: 'admin',
      languageCode: 'ru',
      password: 'hash_admin_password',
      firstName: 'Admin',
      description: 'System administrator',
      isDeleted: false,
      isBanned: false,
      createdAt: now,
      updatedAt: now,
    );
    _usersById[adminId] = admin;

    // Seed random users
    final List<String> firstNames = <String>[
      'Alex',
      'Maria',
      'John',
      'Sara',
      'David',
      'Emma',
      'Michael',
      'Olivia',
      'Daniel',
      'Sophia',
      'James',
      'Ava',
      'William',
      'Mia',
      'Benjamin',
      'Charlotte',
      'Lucas',
      'Amelia',
      'Henry',
      'Isabella',
    ];

    final List<String> lastNames = <String>[
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Garcia',
      'Miller',
      'Davis',
      'Rodriguez',
      'Martinez',
      'Hernandez',
      'Lopez',
      'Gonzalez',
      'Wilson',
      'Anderson',
      'Thomas',
      'Taylor',
      'Moore',
      'Jackson',
      'Martin',
    ];

    final Set<String> usedUsernames = <String>{'admin'};

    for (int index = 0; index < randomUsersCount; index++) {
      final String id = _uuidV4();

      final String first = firstNames[_random.nextInt(firstNames.length)];
      final String last = lastNames[_random.nextInt(lastNames.length)];

      String candidate = _buildUsername(first: first, last: last);
      int salt = 1;
      while (usedUsernames.contains(candidate)) {
        candidate = _buildUsername(first: first, last: last, suffix: salt);
        salt++;
      }
      usedUsernames.add(candidate);

      final DateTime createdAt = now.subtract(
        Duration(
          days: _random.nextInt(365),
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
        ),
      );

      final UserDTO dto = UserDTO(
        userId: id,
        username: candidate,
        languageCode: 'ru',
        password: 'hash_${candidate}_pw',
        firstName: first,
        lastName: last,
        description: _random.nextBool() ? 'Just a random user' : null,
        avatarId: _random.nextBool() ? _uuidV4() : null,
        isDeleted: false,
        isBanned: _random.nextInt(100) < 3, // about 3% banned
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      _usersById[id] = dto;
    }
  }

  String _buildUsername({
    required String first,
    required String last,
    int? suffix,
  }) {
    final String base = '${first.toLowerCase()}.${last.toLowerCase()}'
        .replaceAll(RegExp(r'[^a-z0-9\.]'), '');
    return suffix == null ? base : '$base$suffix';
  }

  /// Simple UUID v4 generator based on Random.
  /// This is not cryptographically secure and is only for demo/in-memory usage.
  String _uuidV4() {
    final List<int> bytes = List<int>.generate(16, (_) => _random.nextInt(256));

    // Set version (4)
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    // Set variant (RFC 4122)
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final String hex = bytes
        .map((int b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
