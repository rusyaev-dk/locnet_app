import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_flutter_secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late SecureStorage secureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    secureStorage = SecureStorage(
      flutterSecureStorage: mockFlutterSecureStorage,
    );
  });

  group('SecureStorage', () {
    group('write method', () {
      test('should successfully write String data', () async {
        const String data =
            'sdfaskdflaskdf^&*(@#E)!@#\$!*#)\$*!_#\$*!_@)#\$*!()@#*\$()*)';
        const String key = 'test_key';

        when(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).thenAnswer((_) async {});

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => data);

        final bool saveSuccess = await secureStorage.write<String>(
          key: key,
          value: data,
        );
        expect(saveSuccess, isTrue);

        final String? retrievedData = await secureStorage.read<String>(
          key: key,
        );
        expect(retrievedData, equals(data));

        verify(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).called(1);
        verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should throw StorageException on non-String data', () async {
        const int data = 12;
        const String key = 'test_key';

        await expectLater(
          () => secureStorage.write<int>(key: key, value: data),
          throwsA(isA<StorageException>()),
        );

        verifyNever(
          () => mockFlutterSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test(
        'should throw StorageIOException when plugin throws Exception',
        () async {
          const String key = 'test_key';
          const String data = 'value';

          when(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).thenThrow(Exception('boom'));

          final Future<bool> future = secureStorage.write<String>(
            key: key,
            value: data,
          );

          await expectLater(future, throwsA(isA<StorageIOException>()));
          verify(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test(
        'should throw AppUnknownException when plugin throws non-Exception error',
        () async {
          const String key = 'test_key';
          const String data = 'value';

          when(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = secureStorage.write<String>(
            key: key,
            value: data,
          );

          await expectLater(future, throwsA(isA<AppUnknownException>()));
          verify(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test('should write very large String value', () async {
        const String key = 'test_key';
        final String data = List.filled(50000, 'a').join();

        when(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).thenAnswer((_) async {});

        final bool result = await secureStorage.write<String>(
          key: key,
          value: data,
        );

        expect(result, isTrue);
        verify(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should write empty String value', () async {
        const String key = 'test_key';
        const String data = '';

        when(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).thenAnswer((_) async {});

        final bool result = await secureStorage.write<String>(
          key: key,
          value: data,
        );

        expect(result, isTrue);
        verify(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should throw StorageException when key is empty', () async {
        const String key = '';
        const String data = 'value';

        final Future<bool> future = secureStorage.write<String>(
          key: key,
          value: data,
        );

        await expectLater(future, throwsA(isA<StorageException>()));

        verifyNever(
          () => mockFlutterSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test(
        'should throw StorageException when key contains only whitespaces',
        () async {
          const String key = '   ';
          const String data = 'value';

          final Future<bool> future = secureStorage.write<String>(
            key: key,
            value: data,
          );

          await expectLater(future, throwsA(isA<StorageException>()));

          verifyNever(
            () => mockFlutterSecureStorage.write(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          );
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );
    });

    group('read method', () {
      test('should return String when value exists and T is String', () async {
        const String key = 'test_key';
        const String data = 'test_value';

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => data);

        final String? retrievedData = await secureStorage.read<String>(
          key: key,
        );

        expect(retrievedData, equals(data));
        verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should return null when value does not exist', () async {
        const String key = 'missing_key';

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => null);

        final String? retrievedData = await secureStorage.read<String>(
          key: key,
        );

        expect(retrievedData, isNull);
        verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should throw StorageException when T is not String', () async {
        const String key = 'test_key';

        final Future<int?> future = secureStorage.read<int>(key: key);

        await expectLater(future, throwsA(isA<StorageException>()));

        verifyNever(
          () => mockFlutterSecureStorage.read(key: any(named: 'key')),
        );
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should throw StorageException when key is empty', () async {
        const String key = '';

        final Future<String?> future = secureStorage.read<String>(key: key);

        await expectLater(future, throwsA(isA<StorageException>()));

        verifyNever(
          () => mockFlutterSecureStorage.read(key: any(named: 'key')),
        );
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test(
        'should throw StorageException when key contains only whitespaces',
        () async {
          const String key = '   ';

          final Future<String?> future = secureStorage.read<String>(key: key);

          await expectLater(future, throwsA(isA<StorageException>()));

          verifyNever(
            () => mockFlutterSecureStorage.read(key: any(named: 'key')),
          );
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test(
        'should throw StorageIOException when plugin throws Exception',
        () async {
          const String key = 'test_key';

          when(
            () => mockFlutterSecureStorage.read(key: key),
          ).thenThrow(Exception('boom'));

          final Future<String?> future = secureStorage.read<String>(key: key);

          await expectLater(future, throwsA(isA<StorageIOException>()));
          verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test(
        'should throw AppUnknownException when plugin throws non-Exception error',
        () async {
          const String key = 'test_key';

          when(
            () => mockFlutterSecureStorage.read(key: key),
          ).thenThrow(StateError('boom'));

          final Future<String?> future = secureStorage.read<String>(key: key);

          await expectLater(future, throwsA(isA<AppUnknownException>()));
          verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );
    });

    group('delete method', () {
      test('should delete value and return true', () async {
        const String key = 'test_key';

        when(
          () => mockFlutterSecureStorage.delete(key: key),
        ).thenAnswer((_) async {});

        final bool deleteSuccess = await secureStorage.delete(key: key);

        expect(deleteSuccess, isTrue);
        verify(() => mockFlutterSecureStorage.delete(key: key)).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test('should throw StorageException when key is empty', () async {
        const String key = '';

        final Future<bool> future = secureStorage.delete(key: key);

        await expectLater(future, throwsA(isA<StorageException>()));

        verifyNever(
          () => mockFlutterSecureStorage.delete(key: any(named: 'key')),
        );
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test(
        'should throw StorageException when key contains only whitespaces',
        () async {
          const String key = '   ';

          final Future<bool> future = secureStorage.delete(key: key);

          await expectLater(future, throwsA(isA<StorageException>()));

          verifyNever(
            () => mockFlutterSecureStorage.delete(key: any(named: 'key')),
          );
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test(
        'should throw StorageIOException when plugin throws Exception',
        () async {
          const String key = 'test_key';

          when(
            () => mockFlutterSecureStorage.delete(key: key),
          ).thenThrow(Exception('boom'));

          await expectLater(
            () => secureStorage.delete(key: key),
            throwsA(isA<StorageIOException>()),
          );

          verify(() => mockFlutterSecureStorage.delete(key: key)).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test(
        'should throw AppUnknownException when plugin throws non-Exception error',
        () async {
          const String key = 'test_key';

          when(
            () => mockFlutterSecureStorage.delete(key: key),
          ).thenThrow(StateError('boom'));

          await expectLater(
            () => secureStorage.delete(key: key),
            throwsA(isA<AppUnknownException>()),
          );

          verify(() => mockFlutterSecureStorage.delete(key: key)).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );
    });

    group('clear method', () {
      test('should clear storage and return true', () async {
        when(
          () => mockFlutterSecureStorage.deleteAll(),
        ).thenAnswer((_) async {});

        final bool clearSuccess = await secureStorage.clear();

        expect(clearSuccess, isTrue);
        verify(() => mockFlutterSecureStorage.deleteAll()).called(1);
        verifyNoMoreInteractions(mockFlutterSecureStorage);
      });

      test(
        'should throw StorageIOException when plugin throws Exception',
        () async {
          when(
            () => mockFlutterSecureStorage.deleteAll(),
          ).thenThrow(Exception('boom'));

          final Future<bool> future = secureStorage.clear();

          await expectLater(future, throwsA(isA<StorageIOException>()));
          verify(() => mockFlutterSecureStorage.deleteAll()).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );

      test(
        'should throw AppUnknownException when plugin throws non-Exception error',
        () async {
          when(
            () => mockFlutterSecureStorage.deleteAll(),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = secureStorage.clear();

          await expectLater(future, throwsA(isA<AppUnknownException>()));
          verify(() => mockFlutterSecureStorage.deleteAll()).called(1);
          verifyNoMoreInteractions(mockFlutterSecureStorage);
        },
      );
    });
  });
}
