// lib/mock/mock_users.dart

import 'dart:math';

import 'package:locnet_app/core/core.dart';

final class MockUsers {
  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static const List<String> _firstNames = <String>[
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

  static const List<String> _lastNames = <String>[
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

  static final User adminUser = User(
    userId: 'usr-adm',
    username: 'adminadminich',
    firstName: 'Den',
    lastName: 'Bobovich',
    description: 'Active admin user',
    languageCode: 'ru',
    avatarId: null,
    isDeleted: false,
    isBanned: false,
    createdAt: DateTime(2024, 1, 10, 12),
    updatedAt: DateTime(2024, 2, 1, 15, 30),
  );

  static final List<User> randomUsers =
      _generateRandomUsers(count: 20, seedUsernames: <String>{adminUser.username});

  static final List<User> allUsers = <User>[
    adminUser,
    ...randomUsers,
  ];

  static List<User> _generateRandomUsers({
    required int count,
    required Set<String> seedUsernames,
  }) {
    final List<User> users = <User>[];
    final Set<String> usedUsernames = <String>{...seedUsernames};

    for (int index = 0; index < count; index++) {
      final String firstName =
          _firstNames[_random.nextInt(_firstNames.length)];
      final String lastName =
          _lastNames[_random.nextInt(_lastNames.length)];

      String candidateUsername = _buildUsername(
        firstName: firstName,
        lastName: lastName,
      );

      int suffix = 1;
      while (usedUsernames.contains(candidateUsername)) {
        candidateUsername = _buildUsername(
          firstName: firstName,
          lastName: lastName,
          suffix: suffix,
        );
        suffix++;
      }
      usedUsernames.add(candidateUsername);

      final DateTime createdAt = _now.subtract(
        Duration(
          days: _random.nextInt(365),
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
        ),
      );

      final bool isBanned = _random.nextInt(100) < 3;
      final bool hasDescription = _random.nextBool();

      final User user = User(
        userId: 'usr-${index.toString().padLeft(3, '0')}',
        username: candidateUsername,
        firstName: firstName,
        lastName: lastName,
        description: hasDescription ? 'Just a random user' : null,
        languageCode: _random.nextBool() ? 'ru' : 'en',
        avatarId: _random.nextBool() ? 'avatar-${index + 1}' : null,
        isDeleted: false,
        isBanned: isBanned,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      users.add(user);
    }

    return users;
  }

  static String _buildUsername({
    required String firstName,
    required String lastName,
    int? suffix,
  }) {
    final String base = '${firstName.toLowerCase()}.${lastName.toLowerCase()}'
        .replaceAll(RegExp(r'[^a-z0-9\.]'), '');
    return suffix == null ? base : '$base$suffix';
  }
}
