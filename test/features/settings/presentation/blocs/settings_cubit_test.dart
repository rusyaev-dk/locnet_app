import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/utils/utils.dart';
import '../../../theme_editor/domain/interactors/mock_theme_editor_interactor.dart';
import '../../domain/interactors/mock_settings_interactor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSettingsInteractor mockSettingsInteractor;
  late MockThemeEditorInteractor mockThemeEditorInteractor;
  late MockLogger mockLogger;

  late AppTheme appTheme;

  setUpAll(() {
    registerFallbackValue(const Locale('en'));
  });

  setUp(() {
    mockSettingsInteractor = MockSettingsInteractor();
    mockThemeEditorInteractor = MockThemeEditorInteractor();
    mockLogger = MockLogger();

    appTheme = AppTheme.basic();
  });

  SettingsCubit buildCubit() {
    return SettingsCubit(
      settingsInteractor: mockSettingsInteractor,
      themeConstructorInteractor: mockThemeEditorInteractor,
      logger: mockLogger,
    );
  }

  group('SettingsCubit', () {
    group('restoreSettings', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits [Loading, Loaded] when restore succeeds',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'dark');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.dark);

          return buildCubit();
        },
        act: (cubit) => cubit.restoreSettings(),
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.dark,
            appTheme: appTheme,
            themeType: AppThemeType.dark,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).called(1);
          verify(() => mockSettingsInteractor.getCurrentThemeMode()).called(1);
          verify(() => mockThemeEditorInteractor.loadAppTheme()).called(1);
          verify(() => mockSettingsInteractor.getCurrentThemeType()).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [Loading, Loaded] even if called twice (second call re-emits Loading)',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.restoreSettings();
        },
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).called(2);
          verify(() => mockSettingsInteractor.getCurrentThemeMode()).called(2);
          verify(() => mockThemeEditorInteractor.loadAppTheme()).called(2);
          verify(() => mockSettingsInteractor.getCurrentThemeType()).called(2);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [Loading, Failure] when getCurrentLanguageCode throws',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenThrow(Exception('boom'));
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          return buildCubit();
        },
        act: (cubit) => cubit.restoreSettings(),
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [Loading, Failure] when getCurrentThemeMode throws',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenThrow(Exception('boom'));
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          return buildCubit();
        },
        act: (cubit) => cubit.restoreSettings(),
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [Loading, Failure] when loadAppTheme throws',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenThrow(Exception('boom'));
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          return buildCubit();
        },
        act: (cubit) => cubit.restoreSettings(),
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits Failure with same AppException when restore throws AppException',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenThrow(AppUnknownException(message: 'app'));
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          return buildCubit();
        },
        act: (cubit) => cubit.restoreSettings(),
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'decodes unknown theme code to ThemeMode.system',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'unknown');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          return buildCubit();
        },
        act: (cubit) => cubit.restoreSettings(),
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
        ],
      );
    });

    group('changeLanguageCode', () {
      blocTest<SettingsCubit, SettingsState>(
        'does nothing when state is not Loaded',
        build: () {
          when(
            () => mockSettingsInteractor.changeLanguage(
              newLanguageCode: any(named: 'newLanguageCode'),
            ),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) => cubit.changeLanguageCode(const Locale('ru')),
        expect: () => <SettingsState>[],
        verify: (_) {
          verifyNever(
            () => mockSettingsInteractor.changeLanguage(
              newLanguageCode: any(named: 'newLanguageCode'),
            ),
          );
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'updates locale when changeLanguage returns true and locale differs',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'ru'),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeLanguageCode(const Locale('ru'));
        },
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
          SettingsLoadedState(
            locale: const Locale('ru'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'ru'),
          ).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'does not emit new Loaded when new locale equals previous locale (but still calls interactor)',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'en'),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeLanguageCode(const Locale('en'));
        },
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'en'),
          ).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits Loaded(with failure AppUnknownException) when changeLanguage returns false',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'ru'),
          ).thenAnswer((_) async => false);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeLanguageCode(const Locale('ru'));
        },
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsLoadedState>(),
          isA<SettingsLoadedState>()
              .having((state) => state.locale, 'locale', const Locale('en'))
              .having(
                (state) => state.failure,
                'failure',
                isA<AppUnknownException>(),
              ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'ru'),
          ).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits FailureState when changeLanguage throws',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'ru'),
          ).thenThrow(Exception('boom'));

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeLanguageCode(const Locale('ru'));
        },
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsLoadedState>(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits FailureState with same AppException when changeLanguage throws AppException',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeLanguage(newLanguageCode: 'ru'),
          ).thenThrow(AppUnknownException(message: 'app'));

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeLanguageCode(const Locale('ru'));
        },
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsLoadedState>(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );
    });

    group('changeThemeMode', () {
      blocTest<SettingsCubit, SettingsState>(
        'does nothing when state is not Loaded',
        build: () {
          when(
            () => mockSettingsInteractor.changeThemeMode(
              newThemeCode: any(named: 'newThemeCode'),
            ),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) => cubit.changeThemeMode(ThemeMode.dark),
        expect: () => <SettingsState>[],
        verify: (_) {
          verifyNever(
            () => mockSettingsInteractor.changeThemeMode(
              newThemeCode: any(named: 'newThemeCode'),
            ),
          );
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'updates themeMode when changeThemeMode returns true and mode differs',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeThemeMode(ThemeMode.dark);
        },
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.dark,
            appTheme: appTheme,
            themeType: AppThemeType.light,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'does not emit new Loaded when new theme equals previous theme (but still calls interactor)',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'dark');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.dark);

          when(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeThemeMode(ThemeMode.dark);
        },
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.dark,
            appTheme: appTheme,
            themeType: AppThemeType.dark,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'encodes ThemeMode.system as "system" (interactor called with correct code)',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'dark');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.dark);

          when(
            () =>
                mockSettingsInteractor.changeThemeMode(newThemeCode: 'system'),
          ).thenAnswer((_) async => true);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeThemeMode(ThemeMode.system);
        },
        expect: () => <SettingsState>[
          const SettingsLoadingState(),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.dark,
            appTheme: appTheme,
            themeType: AppThemeType.dark,
          ),
          SettingsLoadedState(
            locale: const Locale('en'),
            themeMode: ThemeMode.system,
            appTheme: appTheme,
            themeType: AppThemeType.dark,
          ),
        ],
        verify: (_) {
          verify(
            () =>
                mockSettingsInteractor.changeThemeMode(newThemeCode: 'system'),
          ).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits Loaded(with failure AppUnknownException) when changeThemeMode returns false',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).thenAnswer((_) async => false);

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeThemeMode(ThemeMode.dark);
        },
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsLoadedState>(),
          isA<SettingsLoadedState>()
              .having((state) => state.themeMode, 'themeMode', ThemeMode.system)
              .having(
                (state) => state.failure,
                'failure',
                isA<AppUnknownException>(),
              ),
        ],
        verify: (_) {
          verify(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits FailureState when changeThemeMode throws',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).thenThrow(Exception('boom'));

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeThemeMode(ThemeMode.dark);
        },
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsLoadedState>(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits FailureState with same AppException when changeThemeMode throws AppException',
        build: () {
          when(
            () => mockSettingsInteractor.getCurrentLanguageCode(),
          ).thenAnswer((_) async => 'en');
          when(
            () => mockSettingsInteractor.getCurrentThemeMode(),
          ).thenAnswer((_) async => 'system');
          when(
            () => mockThemeEditorInteractor.loadAppTheme(),
          ).thenAnswer((_) async => appTheme);
          when(
            () => mockSettingsInteractor.getCurrentThemeType(),
          ).thenAnswer((_) async => AppThemeType.light);

          when(
            () => mockSettingsInteractor.changeThemeMode(newThemeCode: 'dark'),
          ).thenThrow(AppUnknownException(message: 'app'));

          return buildCubit();
        },
        act: (cubit) async {
          await cubit.restoreSettings();
          await cubit.changeThemeMode(ThemeMode.dark);
        },
        expect: () => <dynamic>[
          const SettingsLoadingState(),
          isA<SettingsLoadedState>(),
          isA<SettingsFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );
    });
  });
}
