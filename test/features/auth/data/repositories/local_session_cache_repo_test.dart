import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/storage/mock_key_value_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockKeyValueStorage mockStorage;
  late LocalSessionCacheRepo localSessionCacheRepo;

  setUp(() {
    mockStorage = MockKeyValueStorage();
    localSessionCacheRepo = LocalSessionCacheRepo(storage: mockStorage);
  });

  Session buildSession({
    String sessionId = 'session-id',
    String userId = 'user-id',
    String refreshToken = 'refresh-token',
    String accessToken = 'access-token',
    DateTime? expiresAt,
    bool isExpired = false,
    bool? isTerminated,
    DateTime? terminatedAt,
    String? ipAddress,
    String? macAddress,
    String? deviceName,
    String? deviceType,
    String? os,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Session(
      sessionId: sessionId,
      userId: userId,
      refreshToken: refreshToken,
      accessToken: accessToken,
      expiresAt: expiresAt ?? DateTime.utc(2030, 1, 1, 12),
      isExpired: isExpired,
      isTerminated: isTerminated,
      terminatedAt: terminatedAt,
      ipAddress: ipAddress,
      macAddress: macAddress,
      deviceName: deviceName,
      deviceType: deviceType,
      os: os,
      createdAt: createdAt ?? DateTime.utc(2029, 1, 1, 12),
      updatedAt: updatedAt ?? DateTime.utc(2029, 1, 2, 12),
    );
  }

  group('LocalSessionCacheRepo', () {
    group('saveSession method', () {
      test('should save session and return true', () async {
        final Session session = buildSession();

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        final bool result = await localSessionCacheRepo.saveSession(
          session: session,
        );

        expect(result, isTrue);

        final String expectedJson = jsonEncode(session.toJson());
        verify(
          () => mockStorage.write<String>(key: 'session', value: expectedJson),
        ).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test(
        'should save session with nullable fields and return true',
        () async {
          final Session session = buildSession(
            isTerminated: true,
            terminatedAt: DateTime.utc(2029, 6, 1, 10, 30),
            ipAddress: '192.168.0.10',
            macAddress: 'AA:BB:CC:DD:EE:FF',
            deviceName: 'Pixel',
            deviceType: 'phone',
            os: 'android',
          );

          when(
            () => mockStorage.write<String>(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenAnswer((_) async => true);

          final bool result = await localSessionCacheRepo.saveSession(
            session: session,
          );

          expect(result, isTrue);

          final String expectedJson = jsonEncode(session.toJson());
          verify(
            () =>
                mockStorage.write<String>(key: 'session', value: expectedJson),
          ).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test('should return false when storage returns false', () async {
        final Session session = buildSession();

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => false);

        final bool result = await localSessionCacheRepo.saveSession(
          session: session,
        );

        expect(result, isFalse);

        verify(
          () => mockStorage.write<String>(
            key: 'session',
            value: jsonEncode(session.toJson()),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test(
        'should throw StorageWriteException when storage.write throws Exception',
        () async {
          final Session session = buildSession();

          when(
            () => mockStorage.write<String>(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenThrow(Exception('disk error'));

          final Future<bool> future = localSessionCacheRepo.saveSession(
            session: session,
          );

          await expectLater(future, throwsA(isA<StorageWriteException>()));

          verify(
            () => mockStorage.write<String>(
              key: 'session',
              value: jsonEncode(session.toJson()),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageUnknownException when storage.write throws non-Exception error',
        () async {
          final Session session = buildSession();

          when(
            () => mockStorage.write<String>(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = localSessionCacheRepo.saveSession(
            session: session,
          );

          await expectLater(future, throwsA(isA<StorageUnknownException>()));

          verify(
            () => mockStorage.write<String>(
              key: 'session',
              value: jsonEncode(session.toJson()),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );
    });

    group('loadSession method', () {
      test('should return Session when cached json is valid', () async {
        final Session session = buildSession();

        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenAnswer((_) async => jsonEncode(session.toJson()));

        final Session result = await localSessionCacheRepo.loadSession();

        expect(result, equals(session));

        verify(() => mockStorage.read<String>(key: 'session')).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test(
        'should return Session when cached json has nullable fields',
        () async {
          final Session session = buildSession(
            isTerminated: true,
            terminatedAt: DateTime.utc(2029, 6, 1, 10, 30),
            ipAddress: '10.0.0.1',
            macAddress: '11:22:33:44:55:66',
            deviceName: 'Workstation',
            deviceType: 'desktop',
            os: 'linux',
          );

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(session.toJson()));

          final Session result = await localSessionCacheRepo.loadSession();

          expect(result, equals(session));

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageNotFoundException when value is null',
        () async {
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => null);

          await expectLater(
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageNotFoundException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
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
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageNotFoundException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
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
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
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
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json misses required keys',
        () async {
          final Map<String, dynamic> invalidJson = <String, dynamic>{
            'sessionId': 'session-id',
            'userId': 'user-id',
          };

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(invalidJson));

          await expectLater(
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json has wrong field types',
        () async {
          final Map<String, dynamic> invalidJson = <String, dynamic>{
            'sessionId': 123,
            'userId': 'user-id',
            'refreshToken': 'refresh-token',
            'accessToken': 'access-token',
            'expiresAt': '2030-01-01T12:00:00.000Z',
            'isExpired': false,
            'isTerminated': null,
            'terminatedAt': null,
            'ipAddress': null,
            'macAddress': null,
            'deviceName': null,
            'deviceType': null,
            'os': null,
            'createdAt': '2029-01-01T12:00:00.000Z',
            'updatedAt': '2029-01-02T12:00:00.000Z',
          };

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(invalidJson));

          await expectLater(
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when cached json has invalid datetime strings',
        () async {
          final Map<String, dynamic> invalidJson = <String, dynamic>{
            'sessionId': 'session-id',
            'userId': 'user-id',
            'refreshToken': 'refresh-token',
            'accessToken': 'access-token',
            'expiresAt': 'not-a-date',
            'isExpired': false,
            'isTerminated': null,
            'terminatedAt': null,
            'ipAddress': null,
            'macAddress': null,
            'deviceName': null,
            'deviceType': null,
            'os': null,
            'createdAt': '2029-01-01T12:00:00.000Z',
            'updatedAt': '2029-01-02T12:00:00.000Z',
          };

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(invalidJson));

          await expectLater(
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageSerializationException when optional fields have invalid types',
        () async {
          final Session session = buildSession();
          final Map<String, dynamic> jsonMap = session.toJson()
            ..['isTerminated'] = 'true';

          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => jsonEncode(jsonMap));

          await expectLater(
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageSerializationException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
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
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageReadException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
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
            () => localSessionCacheRepo.loadSession(),
            throwsA(isA<StorageUnknownException>()),
          );

          verify(() => mockStorage.read<String>(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );
    });

    group('clearSession method', () {
      test('should delete session key and return true', () async {
        when(
          () => mockStorage.delete(key: any(named: 'key')),
        ).thenAnswer((_) async => true);

        final bool result = await localSessionCacheRepo.clearSession();

        expect(result, isTrue);

        verify(() => mockStorage.delete(key: 'session')).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test('should return false when storage.delete returns false', () async {
        when(
          () => mockStorage.delete(key: any(named: 'key')),
        ).thenAnswer((_) async => false);

        final bool result = await localSessionCacheRepo.clearSession();

        expect(result, isFalse);

        verify(() => mockStorage.delete(key: 'session')).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test(
        'should throw StorageDeleteException when storage.delete throws Exception',
        () async {
          when(
            () => mockStorage.delete(key: any(named: 'key')),
          ).thenThrow(Exception('delete error'));

          final Future<bool> future = localSessionCacheRepo.clearSession();

          await expectLater(future, throwsA(isA<StorageDeleteException>()));

          verify(() => mockStorage.delete(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );

      test(
        'should throw StorageUnknownException when storage.delete throws non-Exception error',
        () async {
          when(
            () => mockStorage.delete(key: any(named: 'key')),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = localSessionCacheRepo.clearSession();

          await expectLater(future, throwsA(isA<StorageUnknownException>()));

          verify(() => mockStorage.delete(key: 'session')).called(1);
          verifyNoMoreInteractions(mockStorage);
        },
      );
    });
  });
}
