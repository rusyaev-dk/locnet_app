import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/app/app_config.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/storage/mock_key_value_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockKeyValueStorage mockStorage;
  late LocalSettingsRepo localSettingsRepo;

  setUp(() {
    mockStorage = MockKeyValueStorage();
    localSettingsRepo = LocalSettingsRepo(storage: mockStorage);
  });

  group('LocalSettingsRepo', () {
    group('changeLanguageCode method', () {
      test('should write new language code and return true', () async {
        // Arrange
        const String newLanguageCode = 'ru';

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        // Act
        final bool result = await localSettingsRepo.changeLanguage(
          newLanguageCode: newLanguageCode,
        );

        // Assert
        expect(result, isTrue);

        verify(
          () => mockStorage.write<String>(
            key: 'language_code',
            value: newLanguageCode,
          ),
        ).called(1);

        verifyNever(() => mockStorage.read<String>(key: any(named: 'key')));
      });

      test('should write new language code and return false', () async {
        // Arrange
        const String newLanguageCode = 'en';

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => false);

        // Act
        final bool result = await localSettingsRepo.changeLanguage(
          newLanguageCode: newLanguageCode,
        );

        // Assert
        expect(result, isFalse);

        verify(
          () => mockStorage.write<String>(
            key: 'language_code',
            value: newLanguageCode,
          ),
        ).called(1);
      });

      test('should throw when storage.write throws', () async {
        // Arrange
        const String newLanguageCode = 'uz';

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(StorageWriteException(message: 'write failed'));

        // Act
        final Future<bool> future = localSettingsRepo.changeLanguage(
          newLanguageCode: newLanguageCode,
        );

        // Assert
        await expectLater(future, throwsA(isA<StorageWriteException>()));

        verify(
          () => mockStorage.write<String>(
            key: 'language_code',
            value: newLanguageCode,
          ),
        ).called(1);
      });
    });

    group('getCurrentLanguageCode method', () {
      test('should return stored language code when exists', () async {
        // Arrange
        const String storedLanguageCode = 'ru';

        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenAnswer((_) async => storedLanguageCode);

        // Act
        final String result = await localSettingsRepo.getCurrentLanguageCode();

        // Assert
        expect(result, equals(storedLanguageCode));

        verify(() => mockStorage.read<String>(key: 'language_code')).called(1);
      });

      test(
        'should return default language code when storage returns null',
        () async {
          // Arrange
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => null);

          // Act
          final String result = await localSettingsRepo
              .getCurrentLanguageCode();

          // Assert
          expect(result, equals(AppConfig.defaultLanguageCode));

          verify(
            () => mockStorage.read<String>(key: 'language_code'),
          ).called(1);
        },
      );

      test('should throw when storage.read throws', () async {
        // Arrange
        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenThrow(StorageReadException(message: 'read failed'));

        // Act
        final Future<String> future = localSettingsRepo
            .getCurrentLanguageCode();

        // Assert
        await expectLater(future, throwsA(isA<StorageReadException>()));

        verify(() => mockStorage.read<String>(key: 'language_code')).called(1);
      });
    });

    group('changeThemeMode method', () {
      test('should write new theme code and return true', () async {
        // Arrange
        const String newThemeCode = 'dark';

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        // Act
        final bool result = await localSettingsRepo.changeThemeMode(
          newThemeCode: newThemeCode,
        );

        // Assert
        expect(result, isTrue);

        verify(
          () => mockStorage.write<String>(key: 'theme', value: newThemeCode),
        ).called(1);

        verifyNever(() => mockStorage.read<String>(key: any(named: 'key')));
      });

      test('should write new theme code and return false', () async {
        // Arrange
        const String newThemeCode = 'light';

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => false);

        // Act
        final bool result = await localSettingsRepo.changeThemeMode(
          newThemeCode: newThemeCode,
        );

        // Assert
        expect(result, isFalse);

        verify(
          () => mockStorage.write<String>(key: 'theme', value: newThemeCode),
        ).called(1);
      });

      test('should throw when storage.write throws', () async {
        // Arrange
        const String newThemeCode = 'system';

        when(
          () => mockStorage.write<String>(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(StorageWriteException(message: 'write failed'));

        // Act
        final Future<bool> future = localSettingsRepo.changeThemeMode(
          newThemeCode: newThemeCode,
        );

        // Assert
        await expectLater(future, throwsA(isA<StorageWriteException>()));

        verify(
          () => mockStorage.write<String>(key: 'theme', value: newThemeCode),
        ).called(1);
      });
    });

    group('getCurrentThemeMode method', () {
      test('should return stored theme code when exists', () async {
        // Arrange
        const String storedThemeCode = 'dark';

        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenAnswer((_) async => storedThemeCode);

        // Act
        final String result = await localSettingsRepo.getCurrentThemeMode();

        // Assert
        expect(result, equals(storedThemeCode));

        verify(() => mockStorage.read<String>(key: 'theme')).called(1);
      });

      test(
        'should return default theme code when storage returns null',
        () async {
          // Arrange
          when(
            () => mockStorage.read<String>(key: any(named: 'key')),
          ).thenAnswer((_) async => null);

          // Act
          final String result = await localSettingsRepo.getCurrentThemeMode();

          // Assert
          expect(result, equals(AppConfig.defaultThemeMode));

          verify(() => mockStorage.read<String>(key: 'theme')).called(1);
        },
      );

      test('should throw when storage.read throws', () async {
        // Arrange
        when(
          () => mockStorage.read<String>(key: any(named: 'key')),
        ).thenThrow(StorageReadException(message: 'read failed'));

        // Act
        final Future<String> future = localSettingsRepo.getCurrentThemeMode();

        // Assert
        await expectLater(future, throwsA(isA<StorageReadException>()));

        verify(() => mockStorage.read<String>(key: 'theme')).called(1);
      });
    });
  });
}
