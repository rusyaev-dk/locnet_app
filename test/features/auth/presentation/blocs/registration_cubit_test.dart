import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/blocs/registration_bloc/registration_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/interactors/mock_auth_interactor.dart';
import '../../../../core/utils/logger/mock_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogger mockLogger;
  late MockAuthInteractor mockAuthInteractor;

  RegistrationCubit buildCubit() =>
      RegistrationCubit(authInteractor: mockAuthInteractor, logger: mockLogger);

  const Duration usernameDebounceDelay = Duration(milliseconds: 400);

  Future<void> flushUsernameDebounce() =>
      Future<void>.delayed(usernameDebounceDelay);

  setUp(() {
    mockLogger = MockLogger();
    mockAuthInteractor = MockAuthInteractor();
    when(
      () =>
          mockAuthInteractor.validateRegisterLogin(login: any(named: 'login')),
    ).thenAnswer((_) async => true);
  });

  group('RegistrationCubit', () {
    group('updateFirstName method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newFirstName is null',
        build: buildCubit,
        act: (cubit) => cubit.updateFirstName(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', isNull)
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newFirstName is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateFirstName(newFirstName: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', isNull)
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit validator exception when validateName throws',
        build: buildCubit,
        act: (cubit) => cubit.updateFirstName(newFirstName: '1'),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', '1')
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear firstNameException when newFirstName becomes valid after invalid',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateFirstName(newFirstName: '1');
          await cubit.updateFirstName(newFirstName: 'John');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', '1')
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', 'John')
              .having((s) => s.firstNameException, 'firstNameException', isNull)
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('updateLastName method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newLastName is null',
        build: buildCubit,
        act: (cubit) => cubit.updateLastName(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', isNull)
              .having(
                (s) => s.lastNameException,
                'lastNameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newLastName is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateLastName(newLastName: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', isNull)
              .having(
                (s) => s.lastNameException,
                'lastNameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit validator exception when validateName throws',
        build: buildCubit,
        act: (cubit) => cubit.updateLastName(newLastName: '1'),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', '1')
              .having(
                (s) => s.lastNameException,
                'lastNameException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear lastNameException when newLastName becomes valid after invalid',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateLastName(newLastName: '1');
          await cubit.updateLastName(newLastName: 'Doe');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', '1')
              .having(
                (s) => s.lastNameException,
                'lastNameException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', 'Doe')
              .having((s) => s.lastNameException, 'lastNameException', isNull)
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('updateDescription method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should clear descriptionException when newUserDescription is null',
        build: buildCubit,
        act: (cubit) => cubit.updateDescription(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear descriptionException when newUserDescription is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateDescription(newUserDescription: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit validator exception when validateUserDescription throws',
        build: buildCubit,
        act: (cubit) =>
            cubit.updateDescription(newUserDescription: 'a' * 10000),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.description, 'description', isNotNull)
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear descriptionException when newUserDescription becomes valid after invalid',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateDescription(newUserDescription: 'a' * 10000);
          await cubit.updateDescription(newUserDescription: 'Hello');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.description, 'description', isNotNull)
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
          isA<RegistrationState>()
              .having((s) => s.description, 'description', 'Hello')
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should overwrite description to null if null provided',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updateDescription();
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.description, 'description', equals('Hello'))
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNull,
              ),
          isA<RegistrationState>()
              .having((s) => s.description, 'description', isNull)
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNull,
              ),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('updateUsername method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newUsername is null',
        build: buildCubit,
        wait: usernameDebounceDelay,
        act: (cubit) => cubit.updateUsername(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', isNull)
              .having(
                (s) => s.usernameException,
                'usernameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newUsername is empty',
        build: buildCubit,
        wait: usernameDebounceDelay,
        act: (cubit) => cubit.updateUsername(newUsername: ''),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', isNull)
              .having(
                (s) => s.usernameException,
                'usernameException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit validator exception when validateUsername throws',
        build: buildCubit,
        wait: usernameDebounceDelay,
        act: (cubit) => cubit.updateUsername(newUsername: 'a!^&&&'),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', equals('a!^&&&'))
              .having(
                (s) => s.usernameException,
                'usernameException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear usernameException when newUsername becomes valid after invalid',
        build: buildCubit,
        wait: usernameDebounceDelay,
        act: (cubit) async {
          await cubit.updateUsername(newUsername: '!exampleinvalid?');
          await flushUsernameDebounce();
          await cubit.updateUsername(newUsername: 'john_doe');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', equals('!exampleinvalid?'))
              .having(
                (s) => s.usernameException,
                'usernameException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
          isA<RegistrationState>()
              .having((s) => s.username, 'username', 'john_doe')
              .having((s) => s.usernameException, 'usernameException', isNull)
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('updatePassword method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newPassword is null',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.password, 'password', isNull)
              .having(
                (s) => s.passwordException,
                'passwordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newPassword is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(newPassword: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.password, 'password', isNull)
              .having(
                (s) => s.passwordException,
                'passwordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwordException when repeatPassword is set but newPassword is too weak',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateRepeatPassword(newRepeatPassword: '1234');
          await cubit.updatePassword(newPassword: '1111');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', '1234')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isNotNull,
              ),
          isA<RegistrationState>()
              .having((s) => s.password, 'password', '1111')
              .having(
                (s) => s.passwordException,
                'passwordException',
                isA<PasswordTooWeakException>(),
              ),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwordException when repeatPassword equals newPassword but password is too weak',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateRepeatPassword(newRepeatPassword: 'abcd');
          await cubit.updatePassword(newPassword: 'abcd');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', 'abcd')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isNotNull,
              ),
          isA<RegistrationState>()
              .having((s) => s.password, 'password', 'abcd')
              .having(
                (s) => s.passwordException,
                'passwordException',
                isA<PasswordTooWeakException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit validator exception when validatePassword throws (and no repeatPassword early-return conditions apply)',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(newPassword: '1'),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.password, 'password', '1')
              .having(
                (s) => s.passwordException,
                'passwordException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear passwordException when newPassword becomes valid after invalid',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updatePassword(newPassword: '1');
          await cubit.updatePassword(newPassword: 'StrongPassword1!');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.password, 'password', '1')
              .having(
                (s) => s.passwordException,
                'passwordException',
                isNotNull,
              )
              .having((s) => s.failure, 'failure', isNull),
          isA<RegistrationState>()
              .having((s) => s.password, 'password', 'StrongPassword1!')
              .having((s) => s.passwordException, 'passwordException', isNull)
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should set repeatPasswordException when repeatPassword is shorter than newPassword',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateRepeatPassword(newRepeatPassword: 'abc');
          await cubit.updatePassword(newPassword: 'abcd');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', 'abc')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isNotNull,
              ),
          isA<RegistrationState>()
              .having((s) => s.password, 'password', 'abcd')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<PasswordsMismatchException>(),
              ),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('updateRepeatPassword method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newRepeatPassword is null',
        build: buildCubit,
        act: (cubit) => cubit.updateRepeatPassword(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', isNull)
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit RequiredValueNotProvidedException when newRepeatPassword is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateRepeatPassword(newRepeatPassword: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', isNull)
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<RequiredValueNotProvidedException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwords mismatch when first password is not set',
        build: buildCubit,
        act: (cubit) => cubit.updateRepeatPassword(newRepeatPassword: '1234'),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', '1234')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<PasswordsMismatchException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwords mismatch when first password differs by content',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updatePassword(newPassword: 'abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'abce');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>().having(
            (s) => s.password,
            'password',
            'abcd',
          ),
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', 'abce')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<PasswordsMismatchException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwords mismatch when first password differs by length',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updatePassword(newPassword: 'abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'abc');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>().having(
            (s) => s.password,
            'password',
            'abcd',
          ),
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', 'abc')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<PasswordsMismatchException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear repeatPasswordException when repeat password matches password',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updatePassword(newPassword: 'abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'abcd');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>().having(
            (s) => s.password,
            'password',
            'abcd',
          ),
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', 'abcd')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isNull,
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
        verify: (_) {
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });

    group('field interaction', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should not reset other fields when updating a single field',
        build: buildCubit,
        wait: usernameDebounceDelay,
        act: (cubit) async {
          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await flushUsernameDebounce();
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'abcd');
          await cubit.updateFirstName(newFirstName: 'Johnny');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>().having(
            (s) => s.firstName,
            'firstName',
            'John',
          ),
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', 'John')
              .having((s) => s.lastName, 'lastName', 'Doe'),
          isA<RegistrationState>()
              .having((s) => s.username, 'username', 'john_doe')
              .having((s) => s.firstName, 'firstName', 'John')
              .having((s) => s.lastName, 'lastName', 'Doe'),
          isA<RegistrationState>()
              .having((s) => s.description, 'description', 'Hello')
              .having((s) => s.username, 'username', 'john_doe'),
          isA<RegistrationState>()
              .having((s) => s.password, 'password', 'abcd')
              .having((s) => s.username, 'username', 'john_doe'),
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', 'abcd')
              .having((s) => s.password, 'password', 'abcd'),
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', 'Johnny')
              .having((s) => s.lastName, 'lastName', 'Doe')
              .having((s) => s.username, 'username', 'john_doe')
              .having((s) => s.description, 'description', 'Hello')
              .having((s) => s.password, 'password', 'abcd')
              .having((s) => s.repeatPassword, 'repeatPassword', 'abcd'),
        ],
      );
    });

    group('canRegister method', () {
      test('should return false on initial state', () {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        expect(cubit.canRegister(), isFalse);
      });

      test(
        'should return false when some required fields are missing',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');

          expect(cubit.canRegister(), isFalse);
        },
      );

      test(
        'should return true when description is missing but other required fields are valid',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await flushUsernameDebounce();
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

          expect(cubit.canRegister(), isTrue);
        },
      );

      test('should return false when passwords do not match', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updateFirstName(newFirstName: 'John');
        await cubit.updateLastName(newLastName: 'Doe');
        await cubit.updateUsername(newUsername: 'john_doe');
        await flushUsernameDebounce();
        await cubit.updateDescription(newUserDescription: 'Hello');
        await cubit.updatePassword(newPassword: 'abcd');
        await cubit.updateRepeatPassword(newRepeatPassword: 'abce');

        expect(cubit.canRegister(), isFalse);
      });

      test(
        'should return false when any field exception exists even if all filled',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await flushUsernameDebounce();
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

          expect(cubit.canRegister(), isTrue);

          await cubit.updateUsername(newUsername: '');
          await flushUsernameDebounce();

          expect(cubit.canRegister(), isFalse);
        },
      );

      test(
        'should return true when all required fields are filled, passwords match, and no exceptions',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await flushUsernameDebounce();
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

          expect(cubit.canRegister(), isTrue);
        },
      );

      test(
        'should become true after fixing invalid fields and matching passwords',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: ' ');
          await cubit.updateLastName(newLastName: ' ');
          await cubit.updateUsername(newUsername: '');
          await cubit.updateDescription(newUserDescription: ' ');
          await cubit.updatePassword(newPassword: ' ');
          await cubit.updateRepeatPassword(newRepeatPassword: ' ');

          expect(cubit.canRegister(), isFalse);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await flushUsernameDebounce();
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

          expect(cubit.canRegister(), isTrue);
        },
      );

      test(
        'should stay true when description is cleared to whitespace after being valid',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await flushUsernameDebounce();
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

          expect(cubit.canRegister(), isTrue);

          await cubit.updateDescription(newUserDescription: '   ');

          expect(cubit.canRegister(), isTrue);
        },
      );
    });

    group('logger usage', () {
      test('should not log exceptions on normal validation paths', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updateFirstName(newFirstName: 'John');
        await cubit.updateLastName(newLastName: 'Doe');
        await cubit.updateUsername(newUsername: 'john_doe');
        await flushUsernameDebounce();
        await cubit.updateDescription(newUserDescription: 'Hello');
        await cubit.updatePassword(newPassword: 'abcd');
        await cubit.updateRepeatPassword(newRepeatPassword: 'abcd');

        verifyNever(() => mockLogger.exception(any(), any()));
      });

      test(
        'should not log exceptions when validators throw (handled as field exceptions)',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: '1');
          await cubit.updateLastName(newLastName: '1');
          await cubit.updateUsername(newUsername: '!!!');
          await flushUsernameDebounce();
          await cubit.updatePassword(newPassword: '1');
          await cubit.updateDescription(newUserDescription: 'a' * 10000);

          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );
    });
  });
}
