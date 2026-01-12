import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences mockSharedPreferences;
  late LocalKeyValueStorage localKeyValueStorage;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localKeyValueStorage = LocalKeyValueStorage(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('LocalKeyValueStorage', () {
    group('write method', () {
      test('should throw ArgumentError when key is empty', () async {
        const String key = '';
        const String value = 'value';

        final Future<bool> future = localKeyValueStorage.write<String>(
          key: key,
          value: value,
        );

        await expectLater(future, throwsA(isA<ArgumentError>()));

        verifyNever(() => mockSharedPreferences.setString(any(), any()));
        verifyNever(() => mockSharedPreferences.setInt(any(), any()));
        verifyNever(() => mockSharedPreferences.setDouble(any(), any()));
        verifyNever(() => mockSharedPreferences.setBool(any(), any()));
        verifyNever(() => mockSharedPreferences.setStringList(any(), any()));
      });

      test(
        'should throw ArgumentError when key contains only whitespaces',
        () async {
          const String key = '   ';
          const String value = 'value';

          final Future<bool> future = localKeyValueStorage.write<String>(
            key: key,
            value: value,
          );

          await expectLater(future, throwsA(isA<ArgumentError>()));

          verifyNever(() => mockSharedPreferences.setString(any(), any()));
          verifyNever(() => mockSharedPreferences.setInt(any(), any()));
          verifyNever(() => mockSharedPreferences.setDouble(any(), any()));
          verifyNever(() => mockSharedPreferences.setBool(any(), any()));
          verifyNever(() => mockSharedPreferences.setStringList(any(), any()));
        },
      );

      test('should successfully write String data', () async {
        const String key = 'test_key';
        const String value = 'test_value';

        when(
          () => mockSharedPreferences.setString(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<String>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setString(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write empty String data', () async {
        const String key = 'test_key';
        const String value = '';

        when(
          () => mockSharedPreferences.setString(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<String>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setString(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write int data', () async {
        const String key = 'test_key';
        const int value = 123;

        when(
          () => mockSharedPreferences.setInt(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<int>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setInt(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write negative int data', () async {
        const String key = 'test_key';
        const int value = -123;

        when(
          () => mockSharedPreferences.setInt(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<int>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setInt(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write double data', () async {
        const String key = 'test_key';
        const double value = 10.5;

        when(
          () => mockSharedPreferences.setDouble(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<double>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setDouble(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write double NaN data', () async {
        // Arrange
        const String key = 'test_key';
        const double value = double.nan;

        when(
          () => mockSharedPreferences.setDouble(key, any(that: isA<double>())),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.write<double>(
          key: key,
          value: value,
        );

        // Assert
        expect(success, isTrue);

        final verification = verify(
          () => mockSharedPreferences.setDouble(
            key,
            captureAny(that: isA<double>()),
          ),
        )..called(1);

        final List<Object?> captured = verification.captured;
        expect(captured.length, equals(1));

        final double capturedValue = captured.single as double;
        expect(capturedValue.isNaN, isTrue);

        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write double infinity data', () async {
        const String key = 'test_key';
        const double value = double.infinity;

        when(
          () => mockSharedPreferences.setDouble(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<double>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setDouble(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write bool data', () async {
        const String key = 'test_key';
        const bool value = true;

        when(
          () => mockSharedPreferences.setBool(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<bool>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setBool(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write List<String> data', () async {
        const String key = 'test_key';
        const List<String> value = <String>['a', 'b', 'c'];

        when(
          () => mockSharedPreferences.setStringList(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<List<String>>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setStringList(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should successfully write empty List<String> data', () async {
        const String key = 'test_key';
        const List<String> value = <String>[];

        when(
          () => mockSharedPreferences.setStringList(key, value),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.write<List<String>>(
          key: key,
          value: value,
        );

        expect(success, isTrue);
        verify(() => mockSharedPreferences.setStringList(key, value)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should throw ArgumentError on unsupported type', () async {
        const String key = 'test_key';
        final DateTime value = DateTime(2025);

        await expectLater(
          () => localKeyValueStorage.write<DateTime>(key: key, value: value),
          throwsA(isA<ArgumentError>()),
        );

        verifyNever(() => mockSharedPreferences.setString(any(), any()));
        verifyNever(() => mockSharedPreferences.setInt(any(), any()));
        verifyNever(() => mockSharedPreferences.setDouble(any(), any()));
        verifyNever(() => mockSharedPreferences.setBool(any(), any()));
        verifyNever(() => mockSharedPreferences.setStringList(any(), any()));
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test(
        'should throw StorageWriteException when plugin throws Exception',
        () async {
          const String key = 'test_key';
          const String value = 'test_value';

          when(
            () => mockSharedPreferences.setString(key, value),
          ).thenThrow(Exception('boom'));

          final Future<bool> future = localKeyValueStorage.write<String>(
            key: key,
            value: value,
          );

          await expectLater(future, throwsA(isA<StorageWriteException>()));
          verify(() => mockSharedPreferences.setString(key, value)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should throw StorageUnknownException when plugin throws non-Exception error',
        () async {
          const String key = 'test_key';
          const String value = 'test_value';

          when(
            () => mockSharedPreferences.setString(key, value),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = localKeyValueStorage.write<String>(
            key: key,
            value: value,
          );

          await expectLater(future, throwsA(isA<StorageUnknownException>()));
          verify(() => mockSharedPreferences.setString(key, value)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });

    group('read method', () {
      test('should throw ArgumentError when key is empty', () async {
        const String key = '';

        final Future<String?> future = localKeyValueStorage.read<String>(
          key: key,
        );

        await expectLater(future, throwsA(isA<ArgumentError>()));
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test(
        'should throw ArgumentError when key contains only whitespaces',
        () async {
          const String key = '   ';

          final Future<String?> future = localKeyValueStorage.read<String>(
            key: key,
          );

          await expectLater(future, throwsA(isA<ArgumentError>()));
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test('should return String when stored value is String', () async {
        const String key = 'test_key';
        const String value = 'test_value';

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        final String? result = await localKeyValueStorage.read<String>(
          key: key,
        );

        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should return int when stored value is int', () async {
        const String key = 'test_key';
        const int value = 123;

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        final int? result = await localKeyValueStorage.read<int>(key: key);

        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should return double when stored value is double', () async {
        const String key = 'test_key';
        const double value = 10.5;

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        final double? result = await localKeyValueStorage.read<double>(
          key: key,
        );

        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should return bool when stored value is bool', () async {
        const String key = 'test_key';
        const bool value = true;

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        final bool? result = await localKeyValueStorage.read<bool>(key: key);

        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test(
        'should return List<String> when stored value is List<String>',
        () async {
          const String key = 'test_key';
          const List<String> value = <String>['a', 'b', 'c'];

          when(() => mockSharedPreferences.get(key)).thenReturn(value);

          final List<String>? result = await localKeyValueStorage
              .read<List<String>>(key: key);

          expect(result, equals(value));
          verify(() => mockSharedPreferences.get(key)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test('should return null when key is missing', () async {
        const String key = 'missing_key';

        when(() => mockSharedPreferences.get(key)).thenReturn(null);

        final String? result = await localKeyValueStorage.read<String>(
          key: key,
        );

        expect(result, isNull);
        verify(() => mockSharedPreferences.get(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test(
        'should return null when stored type does not match requested type',
        () async {
          const String key = 'test_key';

          when(() => mockSharedPreferences.get(key)).thenReturn('123');

          final int? result = await localKeyValueStorage.read<int>(key: key);

          expect(result, isNull);
          verify(() => mockSharedPreferences.get(key)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should throw StorageReadException when plugin throws Exception',
        () async {
          const String key = 'test_key';

          when(
            () => mockSharedPreferences.get(key),
          ).thenThrow(Exception('boom'));

          final Future<String?> future = localKeyValueStorage.read<String>(
            key: key,
          );

          await expectLater(future, throwsA(isA<StorageReadException>()));
          verify(() => mockSharedPreferences.get(key)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should throw StorageUnknownException when plugin throws non-Exception error',
        () async {
          const String key = 'test_key';

          when(
            () => mockSharedPreferences.get(key),
          ).thenThrow(StateError('boom'));

          final Future<String?> future = localKeyValueStorage.read<String>(
            key: key,
          );

          await expectLater(future, throwsA(isA<StorageUnknownException>()));
          verify(() => mockSharedPreferences.get(key)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });

    group('delete method', () {
      test('should throw ArgumentError when key is empty', () async {
        const String key = '';

        final Future<bool> future = localKeyValueStorage.delete(key: key);

        await expectLater(future, throwsA(isA<ArgumentError>()));
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should delete value and return true', () async {
        const String key = 'test_key';

        when(
          () => mockSharedPreferences.remove(key),
        ).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.delete(key: key);

        expect(success, isTrue);
        verify(() => mockSharedPreferences.remove(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should return false when remove returns false', () async {
        const String key = 'test_key';

        when(
          () => mockSharedPreferences.remove(key),
        ).thenAnswer((_) async => false);

        final bool success = await localKeyValueStorage.delete(key: key);

        expect(success, isFalse);
        verify(() => mockSharedPreferences.remove(key)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test(
        'should throw StorageDeleteException when plugin throws Exception',
        () async {
          const String key = 'test_key';

          when(
            () => mockSharedPreferences.remove(key),
          ).thenThrow(Exception('boom'));

          final Future<bool> future = localKeyValueStorage.delete(key: key);

          await expectLater(future, throwsA(isA<StorageDeleteException>()));
          verify(() => mockSharedPreferences.remove(key)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should throw StorageUnknownException when plugin throws non-Exception error',
        () async {
          const String key = 'test_key';

          when(
            () => mockSharedPreferences.remove(key),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = localKeyValueStorage.delete(key: key);

          await expectLater(future, throwsA(isA<StorageUnknownException>()));
          verify(() => mockSharedPreferences.remove(key)).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });

    group('clear method', () {
      test('should clear storage and return true', () async {
        when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);

        final bool success = await localKeyValueStorage.clear();

        expect(success, isTrue);
        verify(() => mockSharedPreferences.clear()).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should return false when clear returns false', () async {
        when(
          () => mockSharedPreferences.clear(),
        ).thenAnswer((_) async => false);

        final bool success = await localKeyValueStorage.clear();

        expect(success, isFalse);
        verify(() => mockSharedPreferences.clear()).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test(
        'should throw StorageDeleteException when plugin throws Exception',
        () async {
          when(
            () => mockSharedPreferences.clear(),
          ).thenThrow(Exception('boom'));

          final Future<bool> future = localKeyValueStorage.clear();

          await expectLater(future, throwsA(isA<StorageDeleteException>()));
          verify(() => mockSharedPreferences.clear()).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should throw StorageUnknownException when plugin throws non-Exception error',
        () async {
          when(
            () => mockSharedPreferences.clear(),
          ).thenThrow(StateError('boom'));

          final Future<bool> future = localKeyValueStorage.clear();

          await expectLater(future, throwsA(isA<StorageUnknownException>()));
          verify(() => mockSharedPreferences.clear()).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });
  });
}
