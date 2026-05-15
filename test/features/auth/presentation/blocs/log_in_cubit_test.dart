import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/blocs/log_in_cubit/log_in_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/utils/logger/mock_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogger mockLogger;

  LogInCubit buildCubit() => LogInCubit(logger: mockLogger);

  setUp(() {
    mockLogger = MockLogger();
  });

  group('LogInCubit', () {
    group('updateUsername', () {
      blocTest<LogInCubit, LogInState>(
        'should emit usernameException when updatedUsername is null',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.username, 'username', isNull)
              .having(
                (state) => state.usernameException,
                'usernameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should emit usernameException and set username to empty when updatedUsername is empty',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(updatedUsername: ''),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.username, 'username', isNull)
              .having(
                (state) => state.usernameException,
                'usernameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should emit usernameException when updatedUsername is whitespaces only',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(updatedUsername: '   '),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.username, 'username', '   ')
              .having(
                (state) => state.usernameException,
                'usernameException',
                isNull,
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should clear usernameException and set username on valid value',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(updatedUsername: 'john'),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.username, 'username', 'john')
              .having(
                (state) => state.usernameException,
                'usernameException',
                isNull,
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should override previous usernameException with null on subsequent valid update',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateUsername(updatedUsername: '');
          await cubit.updateUsername(updatedUsername: 'john');
        },
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.username, 'username', isNull)
              .having(
                (state) => state.usernameException,
                'usernameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((state) => state.failure, 'failure', isNull),
          isA<LogInState>()
              .having((state) => state.username, 'username', 'john')
              .having(
                (state) => state.usernameException,
                'usernameException',
                isNull,
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should keep failure null when validation emits field exception (not failure)',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(updatedUsername: ''),
        expect: () => <dynamic>[
          isA<LogInState>().having((state) => state.failure, 'failure', isNull),
        ],
      );
    });

    group('updatePassword', () {
      blocTest<LogInCubit, LogInState>(
        'should emit passwordException when updatedPassword is null',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.password, 'password', isNull)
              .having(
                (state) => state.passwordException,
                'passwordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should emit passwordException and set password to null when updatedPassword is null',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(updatedPassword: ''),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.password, 'password', isNull)
              .having(
                (state) => state.passwordException,
                'passwordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should clear passwordException and set password on valid value',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(updatedPassword: '123'),
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.password, 'password', '123')
              .having(
                (state) => state.passwordException,
                'passwordException',
                isNull,
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should override previous passwordException with null on subsequent valid update',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updatePassword(updatedPassword: '');
          await cubit.updatePassword(updatedPassword: '123');
        },
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.password, 'password', isNull)
              .having(
                (state) => state.passwordException,
                'passwordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((state) => state.failure, 'failure', isNull),
          isA<LogInState>()
              .having((state) => state.password, 'password', '123')
              .having(
                (state) => state.passwordException,
                'passwordException',
                isNull,
              )
              .having((state) => state.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('updateUsername + updatePassword interaction', () {
      blocTest<LogInCubit, LogInState>(
        'should not reset password fields when updating username',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updatePassword(updatedPassword: '123');
          await cubit.updateUsername(updatedUsername: 'john');
        },
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.password, 'password', '123')
              .having(
                (state) => state.passwordException,
                'passwordException',
                isNull,
              )
              .having((state) => state.username, 'username', isNull),
          isA<LogInState>()
              .having((state) => state.password, 'password', '123')
              .having(
                (state) => state.passwordException,
                'passwordException',
                isNull,
              )
              .having((state) => state.username, 'username', 'john')
              .having(
                (state) => state.usernameException,
                'usernameException',
                isNull,
              ),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should not reset username fields when updating password',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateUsername(updatedUsername: 'john');
          await cubit.updatePassword(updatedPassword: '123');
        },
        expect: () => <dynamic>[
          isA<LogInState>()
              .having((state) => state.username, 'username', 'john')
              .having(
                (state) => state.usernameException,
                'usernameException',
                isNull,
              )
              .having((state) => state.password, 'password', isNull),
          isA<LogInState>()
              .having((state) => state.username, 'username', 'john')
              .having(
                (state) => state.usernameException,
                'usernameException',
                isNull,
              )
              .having((state) => state.password, 'password', '123')
              .having(
                (state) => state.passwordException,
                'passwordException',
                isNull,
              ),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<LogInCubit, LogInState>(
        'should not clear usernameException when updating password',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateUsername(updatedUsername: '');
          await cubit.updatePassword(updatedPassword: '123');
        },
        expect: () => <dynamic>[
          isA<LogInState>().having(
            (state) => state.usernameException,
            'usernameException',
            isA<RequiredValueNotProvidedException>(),
          ),
          isA<LogInState>()
              .having((state) => state.password, 'password', '123')
              .having(
                (state) => state.passwordException,
                'passwordException',
                isNull,
              )
              .having(
                (state) => state.usernameException,
                'usernameException',
                isA<RequiredValueNotProvidedException>(),
              ),
        ],
      );
    });

    group('canLogIn', () {
      test('should return false on initial state', () {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        expect(cubit.canLogIn(), isFalse);
      });

      test('should return false when only username is set', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updateUsername(updatedUsername: 'john');

        expect(cubit.canLogIn(), isFalse);
      });

      test('should return false when only password is set', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updatePassword(updatedPassword: '123');

        expect(cubit.canLogIn(), isFalse);
      });

      test(
        'should return false when both are set but usernameException exists',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateUsername(updatedUsername: '');
          await cubit.updatePassword(updatedPassword: '123');

          expect(cubit.canLogIn(), isFalse);
        },
      );

      test(
        'should return false when both are set but passwordException exists',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateUsername(updatedUsername: 'john');
          await cubit.updatePassword(updatedPassword: '');

          expect(cubit.canLogIn(), isFalse);
        },
      );

      test(
        'should return true when username and password are non-empty and no field exceptions',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateUsername(updatedUsername: 'john');
          await cubit.updatePassword(updatedPassword: '123');

          expect(cubit.canLogIn(), isTrue);
        },
      );

      test('should become true after fixing both invalid fields', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updateUsername(updatedUsername: '');
        await cubit.updatePassword(updatedPassword: '');

        expect(cubit.canLogIn(), isFalse);

        await cubit.updateUsername(updatedUsername: 'john');
        await cubit.updatePassword(updatedPassword: '123');

        expect(cubit.canLogIn(), isTrue);
      });

      test(
        'should return false when both are non-empty but any field exception exists',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateUsername(updatedUsername: 'john');
          await cubit.updatePassword(updatedPassword: '123');

          expect(cubit.canLogIn(), isTrue);

          await cubit.updateUsername();

          expect(cubit.canLogIn(), isFalse);
        },
      );

      test('should not depend on failure field for canLogIn', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updateUsername(updatedUsername: 'john');
        await cubit.updatePassword(updatedPassword: '123');

        expect(cubit.canLogIn(), isTrue);

        cubit.emit(
          cubit.state.copyWith(failure: AppUnknownException(message: 'boom')),
        );

        expect(cubit.canLogIn(), isTrue);
      });
    });
  });
}
