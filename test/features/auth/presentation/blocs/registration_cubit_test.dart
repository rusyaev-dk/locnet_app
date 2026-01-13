import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/blocs/registration_cubit/registration_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/utils/logger/mock_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogger mockLogger;

  RegistrationCubit buildCubit() => RegistrationCubit(logger: mockLogger);

  setUp(() {
    mockLogger = MockLogger();
  });

  group('RegistrationCubit', () {
    group('updateFirstName method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newFirstName is null',
        build: buildCubit,
        act: (cubit) => cubit.updateFirstName(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', isNull)
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isA<EmptyFieldException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newFirstName is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateFirstName(newFirstName: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', '   ')
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isA<EmptyFieldException>(),
              ),
        ],
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
              ),
        ],
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
              ),
          isA<RegistrationState>()
              .having((s) => s.firstName, 'firstName', 'John')
              .having(
                (s) => s.firstNameException,
                'firstNameException',
                isNull,
              ),
        ],
      );
    });

    group('updateLastName method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newLastName is null',
        build: buildCubit,
        act: (cubit) => cubit.updateLastName(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', isNull)
              .having(
                (s) => s.lastNameException,
                'lastNameException',
                isA<EmptyFieldException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newLastName is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateLastName(newLastName: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', '   ')
              .having(
                (s) => s.lastNameException,
                'lastNameException',
                isA<EmptyFieldException>(),
              ),
        ],
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
              ),
        ],
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
              ),
          isA<RegistrationState>()
              .having((s) => s.lastName, 'lastName', 'Doe')
              .having((s) => s.lastNameException, 'lastNameException', isNull),
        ],
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
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear descriptionException when newUserDescription is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateDescription(newUserDescription: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>().having(
            (s) => s.descriptionException,
            'descriptionException',
            isNull,
          ),
        ],
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
              ),
        ],
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
              ),
          isA<RegistrationState>()
              .having((s) => s.description, 'description', 'Hello')
              .having(
                (s) => s.descriptionException,
                'descriptionException',
                isNull,
              ),
        ],
      );
    });

    group('updateUsername method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newUsername is null',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', isNull)
              .having(
                (s) => s.usernameException,
                'usernameException',
                isA<EmptyFieldException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newUsername is empty',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(newUsername: ''),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', '')
              .having(
                (s) => s.usernameException,
                'usernameException',
                isA<EmptyFieldException>(),
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit validator exception when validateUsername throws',
        build: buildCubit,
        act: (cubit) => cubit.updateUsername(newUsername: 'a!^&&&'),
        expect: () => [
          isA<RegistrationState>()
              .having((s) => s.username, 'username', equals('a!^&&&'))
              .having(
                (s) => s.usernameException,
                'usernameException',
                isNotNull,
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear usernameException when newUsername becomes valid after invalid',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateUsername(newUsername: '!exampleinvalid?');
          await cubit.updateUsername(newUsername: 'john_doe');
        },
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.username, 'username', equals("!exampleinvalid?"))
              .having(
                (s) => s.usernameException,
                'usernameException',
                isNotNull,
              ),
          isA<RegistrationState>()
              .having((s) => s.username, 'username', 'john_doe')
              .having((s) => s.usernameException, 'usernameException', isNull),
        ],
      );
    });

    group('updatePassword method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newPassword is null',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.password, 'password', isNull)
              .having(
                (s) => s.passwordException,
                'passwordException',
                isA<EmptyFieldException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newPassword is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword(newPassword: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.password, 'password', '   ')
              .having(
                (s) => s.passwordException,
                'passwordException',
                isA<EmptyFieldException>(),
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should set repeatPasswordException when repeatPassword is already set, differs, and repeat length >= newPassword length',
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
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<RegistrationPasswordsDontMatchException>(),
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should clear repeatPasswordException when repeatPassword equals newPassword and both non-empty',
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
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isNull,
              )
              .having((s) => s.passwordException, 'passwordException', isNull),
        ],
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
              ),
        ],
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
              ),
          isA<RegistrationState>()
              .having((s) => s.password, 'password', 'StrongPassword1!')
              .having((s) => s.passwordException, 'passwordException', isNull),
        ],
      );
    });

    group('updateRepeatPassword method', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newRepeatPassword is null',
        build: buildCubit,
        act: (cubit) => cubit.updateRepeatPassword(),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', isNull)
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<EmptyFieldException>(),
              )
              .having((s) => s.failure, 'failure', isNull),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit EmptyFieldException when newRepeatPassword is whitespace',
        build: buildCubit,
        act: (cubit) => cubit.updateRepeatPassword(newRepeatPassword: '   '),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', '   ')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<EmptyFieldException>(),
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwords-dont-match when first password is not set',
        build: buildCubit,
        act: (cubit) => cubit.updateRepeatPassword(newRepeatPassword: '1234'),
        expect: () => <dynamic>[
          isA<RegistrationState>()
              .having((s) => s.repeatPassword, 'repeatPassword', '1234')
              .having(
                (s) => s.repeatPasswordException,
                'repeatPasswordException',
                isA<RegistrationPasswordsDontMatchException>(),
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwords-dont-match when first password differs by content',
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
                isA<RegistrationPasswordsDontMatchException>(),
              ),
        ],
      );

      blocTest<RegistrationCubit, RegistrationState>(
        'should emit passwords-dont-match when first password differs by length',
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
                isA<RegistrationPasswordsDontMatchException>(),
              ),
        ],
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
              ),
        ],
      );
    });

    group('field interaction', () {
      blocTest<RegistrationCubit, RegistrationState>(
        'should not reset other fields when updating a single field',
        build: buildCubit,
        act: (cubit) async {
          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
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
        'should return false when description is missing (required by canRegister)',
        () async {
          final cubit = buildCubit();
          addTearDown(cubit.close);

          await cubit.updateFirstName(newFirstName: 'John');
          await cubit.updateLastName(newLastName: 'Doe');
          await cubit.updateUsername(newUsername: 'john_doe');
          await cubit.updatePassword(newPassword: 'abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'abcd');

          expect(cubit.canRegister(), isFalse);
        },
      );

      test('should return false when passwords do not match', () async {
        final cubit = buildCubit();
        addTearDown(cubit.close);

        await cubit.updateFirstName(newFirstName: 'John');
        await cubit.updateLastName(newLastName: 'Doe');
        await cubit.updateUsername(newUsername: 'john_doe');
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
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

          expect(cubit.canRegister(), isTrue);

          await cubit.updateUsername(newUsername: '');

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
          await cubit.updateDescription(newUserDescription: 'Hello');
          await cubit.updatePassword(newPassword: 'A!fa98dsf9abcd');
          await cubit.updateRepeatPassword(newRepeatPassword: 'A!fa98dsf9abcd');

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
        await cubit.updateDescription(newUserDescription: 'Hello');
        await cubit.updatePassword(newPassword: 'abcd');
        await cubit.updateRepeatPassword(newRepeatPassword: 'abcd');

        verifyNever(() => mockLogger.exception(any(), any()));
      });
    });
  });
}
