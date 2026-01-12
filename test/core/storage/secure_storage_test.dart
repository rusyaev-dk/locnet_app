import 'package:flutter_test/flutter_test.dart';
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

  group("SecureStorage", () {
    group("write method", () {
      test("should successfully write String data", () async {
        // Arrange
        const String data =
            "sdfaskdflaskdf^&*(@#E)!@#\$!*#)\$*!_#\$*!_@)#\$*!()@#*\$()*)";
        const key = "test_key";

        when(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).thenAnswer((_) async {});

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => data);

        // Act
        final saveSuccess = await secureStorage.write<String>(
          key: key,
          value: data,
        );
        expect(saveSuccess, isTrue);

        final retrievedData = await secureStorage.read<String>(key: key);

        expect(retrievedData, equals(data));

        verify(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).called(1);

        verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
      });

      test("should throw ArgumentError on non-String data", () async {
        // Arrange
        const int data = 12;
        const key = "test_key";

        when(
          () =>
              mockFlutterSecureStorage.write(key: key, value: data.toString()),
        ).thenAnswer((_) async {});

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => data.toString());

        expect(() async {
          await secureStorage.write(key: key, value: data);
        }, throwsA(isA<ArgumentError>()));

        verifyNever(
          () => mockFlutterSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
      });

      test(
        'should throw StorageWriteException when plugin throws Exception',
        () async {
          // Arrange
          const String key = 'test_key';
          const String data = 'value';

          when(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).thenThrow(Exception('boom'));

          // Act
          final Future<bool> future = secureStorage.write<String>(
            key: key,
            value: data,
          );

          // Assert
          await expectLater(future, throwsA(isA<StorageWriteException>()));
          verify(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).called(1);
        },
      );

      test(
        'should throw StorageUnknownException when plugin throws non-Exception error',
        () async {
          // Arrange
          const String key = 'test_key';
          const String data = 'value';

          when(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).thenThrow(StateError('boom'));

          // Act
          final Future<bool> future = secureStorage.write<String>(
            key: key,
            value: data,
          );

          // Assert
          await expectLater(future, throwsA(isA<StorageUnknownException>()));
          verify(
            () => mockFlutterSecureStorage.write(key: key, value: data),
          ).called(1);
        },
      );

      test('should write very large String value', () async {
        // Arrange
        const String key = 'test_key';
        final String data = List.filled(50000, 'a').join();

        when(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).thenAnswer((_) async {});

        // Act
        final bool result = await secureStorage.write<String>(
          key: key,
          value: data,
        );

        // Assert
        expect(result, isTrue);
        verify(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).called(1);
      });

      test('should write empty String value', () async {
        // Arrange
        const String key = 'test_key';
        const String data = '';

        when(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).thenAnswer((_) async {});

        // Act
        final bool result = await secureStorage.write<String>(
          key: key,
          value: data,
        );

        // Assert
        expect(result, isTrue);
        verify(
          () => mockFlutterSecureStorage.write(key: key, value: data),
        ).called(1);
      });

      test('should throw ArgumentError when key is empty', () async {
        // Arrange
        const String key = '';
        const String data = 'value';

        // Act
        final Future<bool> future = secureStorage.write<String>(
          key: key,
          value: data,
        );

        // Assert
        await expectLater(future, throwsA(isA<ArgumentError>()));

        verifyNever(
          () => mockFlutterSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
      });

      test(
        'should throw ArgumentError when key contains only whitespaces',
        () async {
          // Arrange
          const String key = '   ';
          const String data = 'value';

          // Act
          final Future<bool> future = secureStorage.write<String>(
            key: key,
            value: data,
          );

          // Assert
          await expectLater(future, throwsA(isA<ArgumentError>()));

          verifyNever(
            () => mockFlutterSecureStorage.write(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          );
        },
      );
    });
    group("read method", () {
      test('should return String when value exists and T is String', () async {
        // Arrange
        const String key = 'test_key';
        const String data = 'test_value';

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => data);

        // Act
        final String? retrievedData = await secureStorage.read<String>(
          key: key,
        );

        // Assert
        expect(retrievedData, equals(data));
        verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
      });

      test('should return null when value does not exist', () async {
        // Arrange
        const String key = 'missing_key';

        when(
          () => mockFlutterSecureStorage.read(key: key),
        ).thenAnswer((_) async => null);

        // Act
        final String? retrievedData = await secureStorage.read<String>(
          key: key,
        );

        // Assert
        expect(retrievedData, isNull);
        verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
      });

      test('should throw ArgumentError when T is not String', () async {
        // Arrange
        const String key = 'test_key';

        // Act
        final Future<int?> future = secureStorage.read<int>(key: key);

        // Assert
        await expectLater(future, throwsA(isA<ArgumentError>()));

        verifyNever(
          () => mockFlutterSecureStorage.read(key: any(named: 'key')),
        );
      });

      test(
        'should throw StorageReadException when plugin throws Exception',
        () async {
          // Arrange
          const String key = 'test_key';

          when(
            () => mockFlutterSecureStorage.read(key: key),
          ).thenThrow(Exception('boom'));

          // Act
          final Future<String?> future = secureStorage.read<String>(key: key);

          // Assert
          await expectLater(future, throwsA(isA<StorageReadException>()));

          verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
        },
      );
    });
    group("delete method", () {
      test('should delete value and return true', () async {
        // Arrange
        const String key = 'test_key';

        when(
          () => mockFlutterSecureStorage.delete(key: key),
        ).thenAnswer((_) async {});

        // Act
        final bool deleteSuccess = await secureStorage.delete(key: key);

        // Assert
        expect(deleteSuccess, isTrue);
        verify(() => mockFlutterSecureStorage.delete(key: key)).called(1);
      });

      test('should throw when plugin throws', () async {
        // Arrange
        const String key = 'test_key';

        when(
          () => mockFlutterSecureStorage.delete(key: key),
        ).thenThrow(Exception('boom'));

        // Act
        expect(
          () async => secureStorage.delete(key: key),
          throwsA(isA<Exception>()),
        );

        // Assert
        verify(() => mockFlutterSecureStorage.delete(key: key)).called(1);
      });
    });
    group("clear method", () {
      test('should clear storage and return true', () async {
        // Arrange
        when(
          () => mockFlutterSecureStorage.deleteAll(),
        ).thenAnswer((_) async {});

        // Act
        final bool clearSuccess = await secureStorage.clear();

        // Assert
        expect(clearSuccess, isTrue);
        verify(() => mockFlutterSecureStorage.deleteAll()).called(1);
      });

      test('should throw when plugin throws', () async {
        // Arrange
        when(
          () => mockFlutterSecureStorage.deleteAll(),
        ).thenThrow(Exception('boom'));

        // Act
        expect(() async => secureStorage.clear(), throwsA(isA<Exception>()));

        // Assert
        verify(() => mockFlutterSecureStorage.deleteAll()).called(1);
      });
    });
  });
}
