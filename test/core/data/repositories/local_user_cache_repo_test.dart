import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';
import 'package:mocktail/mocktail.dart';

import '../../storage/mock_key_value_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockKeyValueStorage mockStorage;
  late LocalUserCacheRepo localUserCacheRepo;

  setUp(() {
    mockStorage = MockKeyValueStorage();
    localUserCacheRepo = LocalUserCacheRepo(storage: mockStorage);
  });

  User buildUser({
    String userId = 'user-id',
    String username = 'username',
    String firstName = 'First',
    String patronymic = 'Middle',
    String lastName = 'Last',
    String languageCode = 'en',
    String? description,
    String? avatarId,
    bool isDeleted = false,
    bool isBanned = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId,
      username: username,
      firstName: firstName,
      patronymic: patronymic,
      lastName: lastName,
      languageCode: languageCode,
      description: description,
      avatarId: avatarId,
      isDeleted: isDeleted,
      isBanned: isBanned,
      createdAt: createdAt ?? DateTime.utc(2029, 1, 1, 12),
      updatedAt: updatedAt ?? DateTime.utc(2029, 1, 2, 12),
    );
  }

  group('LocalUserCacheRepo', () {
    group('saveUser', () {
      test('should save user and return true', () async {
        final User user = buildUser();

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        final bool result = await localUserCacheRepo.saveUser(user: user);

        expect(result, isTrue);

        verify(
          () => mockStorage.write<String>(
            key: 'user',
            value: jsonEncode(user.toJson()),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test('should save user with nullable fields and return true', () async {
        final User user = buildUser(
          description: 'About me',
          avatarId: 'avatar-id',
        );

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        final bool result = await localUserCacheRepo.saveUser(user: user);

        expect(result, isTrue);

        verify(
          () => mockStorage.write<String>(
            key: 'user',
            value: jsonEncode(user.toJson()),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test('should return false when storage returns false', () async {
        final User user = buildUser();

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => false);

        final bool result = await localUserCacheRepo.saveUser(user: user);

        expect(result, isFalse);

        verify(
          () => mockStorage.write<String>(
            key: 'user',
            value: jsonEncode(user.toJson()),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test(
        'should throw StorageWriteException when storage.write throws Exception',
        () async {
          final User user = buildUser();

          when(
            () => mockStorage.write<String>(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenThrow(Exception('disk error'));

          final Future<bool> future = localUserCacheRepo.saveUser(user: user);

          await expectLater(future, throwsA(isA<StorageWriteException>()));

          verify(
            () => mockStorage.write<String>(
              key: 'user',
              value: jsonEncode(user.toJson()),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageUnknownException when storage.write throws non-Exception error',
        () async {
          final User user = buildUser();

          when(
            () => mockStorage.write<String>(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = localUserCacheRepo.saveUser(user: user);

          await expectLater(future, throwsA(isA<StorageUnknownException>()));

          verify(
            () => mockStorage.write<String>(
              key: 'user',
              value: jsonEncode(user.toJson()),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );
    });

    group('loadUser', () {
      test('should return User when cached json is valid', () async {
        final User user = buildUser();

        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenAnswer((_) async => jsonEncode(user.toJson()));

        final User result = await localUserCacheRepo.loadUser();

        expect(result, equals(user));

        verify(() => mockStorage.read<String>(key: 'user')).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test('should return User when cached json has nullable fields', () async {
        final User user = buildUser(
          description: 'About me',
          avatarId: 'avatar-id',
        );

        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenAnswer((_) async => jsonEncode(user.toJson()));

        final User result = await localUserCacheRepo.loadUser();

        expect(result, equals(user));

        verify(() => mockStorage.read<String>(key: 'user')).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test(
        'should throw StorageNotFoundException when value is null',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => null);

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageNotFoundException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageNotFoundException when value is empty',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => '');

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageNotFoundException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json is corrupted (FormatException)',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => '{broken json');

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json is not an object',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(<dynamic>[]));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json misses required keys',
        () async {
          final Map<String, dynamic> invalidJson = <String, dynamic>{
            'userId': 'user-id',
            // Missing: username, firstName, patronymic, lastName, languageCode,
            // isDeleted, isBanned, createdAt, updatedAt
          };

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(invalidJson));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json has wrong field types',
        () async {
          final Map<String, dynamic> invalidJson = <String, dynamic>{
            'userId': 123,
            'username': 'username',
            'firstName': 'First',
            'patronymic': 'Middle',
            'lastName': 'Last',
            'languageCode': 'en',
            'description': null,
            'avatarId': null,
            'isDeleted': false,
            'isBanned': false,
            'createdAt': '2029-01-01T12:00:00.000Z',
            'updatedAt': '2029-01-02T12:00:00.000Z',
          };

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(invalidJson));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json has invalid datetime strings',
        () async {
          final Map<String, dynamic> invalidJson = <String, dynamic>{
            'userId': 'user-id',
            'username': 'username',
            'firstName': 'First',
            'patronymic': 'Middle',
            'lastName': 'Last',
            'languageCode': 'en',
            'description': null,
            'avatarId': null,
            'isDeleted': false,
            'isBanned': false,
            'createdAt': 'not-a-date',
            'updatedAt': '2029-01-02T12:00:00.000Z',
          };

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(invalidJson));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when optional fields have invalid types',
        () async {
          final User user = buildUser();
          final Map<String, dynamic> jsonMap = user.toJson()
            ..['avatarId'] = 123;

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(jsonMap));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageReadException when storage.read throws Exception',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenThrow(Exception('read error'));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageReadException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageUnknownException when storage.read throws non-Exception error',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenThrow(StateError('boom'));

          await expectLater(
            () => localUserCacheRepo.loadUser(),
            throwsA(isA<StorageUnknownException>()),
          );

          verify(() => mockStorage.read<String>(key: 'user')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );
    });
  });
}
