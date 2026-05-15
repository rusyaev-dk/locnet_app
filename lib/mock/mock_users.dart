// mock_users.dart

import 'dart:math';

import 'package:locnet_app/core/core.dart';
import 'package:uuid/uuid.dart';

final class MockUsers {
  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static final UserDto adminUser = UserDto(
    userId: 'usr-adm',
    username: 'ivanushka_international',
    firstName: 'Ivan',
    lastName: 'Ivanov',
    patronymic: 'Ivanich',
    description: 'Active admin user',
    languageCode: 'ru',
    isDeleted: false,
    isBanned: false,
    createdAt: DateTime(2024, 1, 10, 12),
    updatedAt: DateTime(2024, 2, 1, 15, 30),
  );

  static UserDto createRandomUser() {
    final userId = _generateUserId();
    final firstName = _MockNamesRegistry.getRandomFirstName();
    final lastName = _MockNamesRegistry.getRandomLastName();
    final patronymic = _MockNamesRegistry.getRandomPatronymic();

    final user = UserDto(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      patronymic: patronymic,
      languageCode: _langaugeCodes[_random.nextInt(2)],
      username: _generateUsernameFromData(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        patronymic: patronymic,
      ),
      isDeleted: false,
      isBanned: false,
      createdAt: _now.subtract(Duration(days: _random.nextInt(5))),
      updatedAt: _now.subtract(Duration(minutes: _random.nextInt(20))),
    );

    return user;
  }

  static const List<String> _langaugeCodes = ["ru", "uz", "en"];

  static String _generateUserId() {
    return const Uuid().v4();
  }

  static String _generateUsernameFromData({
    required String userId,
    required String firstName,
    required String lastName,
    required String patronymic,
  }) {
    final String fn = _normalize(firstName);
    final String ln = _normalize(lastName);
    final String pn = _normalize(patronymic);
    final String seed = _shortHashFromUuid(userId);

    final List<String> parts = <String>[fn, ln, pn, seed]..shuffle(_random);

    final String username = parts.take(3).join();
    return username;
  }

  static String _normalize(String value) {
    final String lower = value.trim().toLowerCase();
    final String ascii = lower.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return ascii.isEmpty ? 'user' : ascii;
  }

  static String _shortHashFromUuid(String uuid) {
    final String cleaned = uuid.replaceAll('-', '');
    final int hash = cleaned.codeUnits.fold<int>(0, (int acc, int c) {
      return (acc * 31 + c) & 0xFFFFFFFF;
    });
    return hash.toRadixString(16).padLeft(8, '0').substring(0, 6);
  }
}

abstract class _MockNamesRegistry {
  static final Random _random = Random(42);

  static String getRandomFirstName() {
    return _firstNames[_random.nextInt(_firstNames.length)];
  }

  static String getRandomLastName() {
    return _lastNames[_random.nextInt(_lastNames.length)];
  }

  static String getRandomPatronymic() {
    return _patronymics[_random.nextInt(_patronymics.length)];
  }

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

    'Иван',
    'Мария',
    'Алексей',
    'Светлана',
    'Анастасия',
    'Елена',
    'Николай',
    'Артём',
    'Дмитрий',
    'Олег',
    'Сергей',
    'Павел',
    'Виктор',
    'Евгения',
    'Валерия',
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
    'Wilson',
    'Anderson',
    'Taylor',
    'Moore',
    'Martin',

    // Cyrillic
    'Иванов',
    'Петров',
    'Сидоров',
    'Смирнов',
    'Кузнецов',
    'Попов',
    'Лебедев',
    'Морозов',
    'Волков',
    'Новиков',
    'Фёдоров',
    'Михайлов',
    'Захаров',
    'Жарков',
  ];

  static const List<String> _patronymics = <String>[
    'Alexandrovich',
    'Alexandrovna',
    'Dmitrievich',
    'Dmitrievna',
    'Sergeevich',
    'Sergeevna',
    'Petrovich',
    'Petrovna',
    'Ivanovich',
    'Ivanovna',
    'Pavlovich',
    'Pavlovna',
    'Mikhailovich',
    'Mikhailovna',
    'Александрович',
    'Александровна',
    'Дмитриевич',
    'Дмитриевна',
    'Сергеевич',
    'Сергеевна',
    'Петрович',
    'Петровна',
    'Иванович',
    'Ивановна',
    'Павлович',
    'Павловна',
    'Михайлович',
    'Михайловна',
  ];
}
