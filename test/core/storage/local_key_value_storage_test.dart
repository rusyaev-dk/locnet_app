import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/data/storage/key_value_storage/local_key_value_storage.dart';
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
      test('should successfully write String data', () async {
        // Arrange
        const String key = 'test_key';
        const String value = 'test_value';

        when(
          () => mockSharedPreferences.setString(key, value),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.write<String>(
          key: key,
          value: value,
        );

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.setString(key, value)).called(1);
      });

      test('should successfully write int data', () async {
        // Arrange
        const String key = 'test_key';
        const int value = 123;

        when(
          () => mockSharedPreferences.setInt(key, value),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.write<int>(
          key: key,
          value: value,
        );

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.setInt(key, value)).called(1);
      });

      test('should successfully write double data', () async {
        // Arrange
        const String key = 'test_key';
        const double value = 10.5;

        when(
          () => mockSharedPreferences.setDouble(key, value),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.write<double>(
          key: key,
          value: value,
        );

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.setDouble(key, value)).called(1);
      });

      test('should successfully write bool data', () async {
        // Arrange
        const String key = 'test_key';
        const bool value = true;

        when(
          () => mockSharedPreferences.setBool(key, value),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.write<bool>(
          key: key,
          value: value,
        );

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.setBool(key, value)).called(1);
      });

      test('should successfully write List<String> data', () async {
        // Arrange
        const String key = 'test_key';
        const List<String> value = <String>['a', 'b', 'c'];

        when(
          () => mockSharedPreferences.setStringList(key, value),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.write<List<String>>(
          key: key,
          value: value,
        );

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.setStringList(key, value)).called(1);
      });

      test('should throw ArgumentError on unsupported type', () async {
        // Arrange
        const String key = 'test_key';
        final DateTime value = DateTime(2025);

        // Act
        expect(
          () async =>
              localKeyValueStorage.write<DateTime>(key: key, value: value),
          throwsA(isA<ArgumentError>()),
        );

        // Assert
        verifyNever(() => mockSharedPreferences.setString(any(), any()));
        verifyNever(() => mockSharedPreferences.setInt(any(), any()));
        verifyNever(() => mockSharedPreferences.setDouble(any(), any()));
        verifyNever(() => mockSharedPreferences.setBool(any(), any()));
        verifyNever(() => mockSharedPreferences.setStringList(any(), any()));
      });
    });

    group('read method', () {
      test('should return String when stored value is String', () async {
        // Arrange
        const String key = 'test_key';
        const String value = 'test_value';

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        // Act
        final String? result = await localKeyValueStorage.read<String>(
          key: key,
        );

        // Assert
        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
      });

      test('should return int when stored value is int', () async {
        // Arrange
        const String key = 'test_key';
        const int value = 123;

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        // Act
        final int? result = await localKeyValueStorage.read<int>(key: key);

        // Assert
        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
      });

      test('should return double when stored value is double', () async {
        // Arrange
        const String key = 'test_key';
        const double value = 10.5;

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        // Act
        final double? result = await localKeyValueStorage.read<double>(
          key: key,
        );

        // Assert
        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
      });

      test('should return bool when stored value is bool', () async {
        // Arrange
        const String key = 'test_key';
        const bool value = true;

        when(() => mockSharedPreferences.get(key)).thenReturn(value);

        // Act
        final bool? result = await localKeyValueStorage.read<bool>(key: key);

        // Assert
        expect(result, equals(value));
        verify(() => mockSharedPreferences.get(key)).called(1);
      });

      test(
        'should return List<String> when stored value is List<String>',
        () async {
          // Arrange
          const String key = 'test_key';
          const List<String> value = <String>['a', 'b', 'c'];

          when(() => mockSharedPreferences.get(key)).thenReturn(value);

          // Act
          final List<String>? result = await localKeyValueStorage
              .read<List<String>>(key: key);

          // Assert
          expect(result, equals(value));
          verify(() => mockSharedPreferences.get(key)).called(1);
        },
      );

      test('should return null when key is missing', () async {
        // Arrange
        const String key = 'missing_key';

        when(() => mockSharedPreferences.get(key)).thenReturn(null);

        // Act
        final String? result = await localKeyValueStorage.read<String>(
          key: key,
        );

        // Assert
        expect(result, isNull);
        verify(() => mockSharedPreferences.get(key)).called(1);
      });

      test(
        'should return null when stored type does not match requested type',
        () async {
          // Arrange
          const String key = 'test_key';

          when(() => mockSharedPreferences.get(key)).thenReturn('123');

          // Act
          final int? result = await localKeyValueStorage.read<int>(key: key);

          // Assert
          expect(result, isNull);
          verify(() => mockSharedPreferences.get(key)).called(1);
        },
      );
    });

    group('delete method', () {
      test('should delete value and return true', () async {
        // Arrange
        const String key = 'test_key';

        when(
          () => mockSharedPreferences.remove(key),
        ).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.delete(key: key);

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.remove(key)).called(1);
      });

      test('should return false when remove returns false', () async {
        // Arrange
        const String key = 'test_key';

        when(
          () => mockSharedPreferences.remove(key),
        ).thenAnswer((_) async => false);

        // Act
        final bool success = await localKeyValueStorage.delete(key: key);

        // Assert
        expect(success, isFalse);
        verify(() => mockSharedPreferences.remove(key)).called(1);
      });
    });

    group('clear method', () {
      test('should clear storage and return true', () async {
        // Arrange
        when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);

        // Act
        final bool success = await localKeyValueStorage.clear();

        // Assert
        expect(success, isTrue);
        verify(() => mockSharedPreferences.clear()).called(1);
      });

      test('should return false when clear returns false', () async {
        // Arrange
        when(
          () => mockSharedPreferences.clear(),
        ).thenAnswer((_) async => false);

        // Act
        final bool success = await localKeyValueStorage.clear();

        // Assert
        expect(success, isFalse);
        verify(() => mockSharedPreferences.clear()).called(1);
      });
    });
  });
}
