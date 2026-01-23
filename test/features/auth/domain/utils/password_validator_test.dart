import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

void main() {
  group('PasswordValidator', () {
    group('validatePassword method', () {
      test('should not throw for strong password (minimal valid)', () {
        expect(
          () => PasswordValidator.validatePassword('StrongPassword1!'),
          returnsNormally,
        );
      });

      test(
        'should not throw for password with all allowed special symbols set',
        () {
          expect(
            () => PasswordValidator.validatePassword(
              'StrongPassword1!@#\$%^&*()_-{}',
            ),
            returnsNormally,
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password is shorter than 14 characters',
        () {
          expect(
            () => PasswordValidator.validatePassword('ShortPass1!A'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should not throw when password length is exactly 14 characters and meets all rules',
        () {
          expect(
            () => PasswordValidator.validatePassword('Abcdefghijk1!A'),
            returnsNormally,
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password has no uppercase letters',
        () {
          expect(
            () => PasswordValidator.validatePassword('strongpassword1!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password has no lowercase letters',
        () {
          expect(
            () => PasswordValidator.validatePassword('STRONGPASSWORD1!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password has no digits',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword!!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: space',
        () {
          expect(
            () => PasswordValidator.validatePassword('Strong Password1!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: dot',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1!.'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: plus sign',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1+!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: equals sign',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1=!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: slash',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1!/'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: backslash',
        () {
          expect(
            () => PasswordValidator.validatePassword(r'StrongPassword1!\'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains forbidden character: quotation mark',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1!"'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains non-latin letters',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongПароль1!A'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains emoji',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1!🙂'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains newline',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1!\nA'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains tab',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1!\tA'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains only digits and allowed symbols but no letters',
        () {
          expect(
            () => PasswordValidator.validatePassword('1234567890123!'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains letters and digits but no special symbol',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword1234'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should not throw when password has underscore and hyphen (allowed)',
        () {
          expect(
            () => PasswordValidator.validatePassword('Strong_Password1-A!'),
            returnsNormally,
          );
        },
      );

      test('should not throw when password contains braces (allowed)', () {
        expect(
          () => PasswordValidator.validatePassword('StrongPassword1{A}!a'),
          returnsNormally,
        );
      });

      test('should not throw when password contains parentheses (allowed)', () {
        expect(
          () => PasswordValidator.validatePassword('StrongPassword1(A)!a'),
          returnsNormally,
        );
      });

      test('should throw PasswordTooWeakException when password is empty', () {
        expect(
          () => PasswordValidator.validatePassword(''),
          throwsA(isA<PasswordTooWeakException>()),
        );
      });

      test(
        'should throw PasswordTooWeakException when password contains only spaces',
        () {
          expect(
            () => PasswordValidator.validatePassword('              '),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains only lowercase letters (even if long)',
        () {
          expect(
            () => PasswordValidator.validatePassword(
              'verylongpasswordonlylowercase',
            ),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains only uppercase letters (even if long)',
        () {
          expect(
            () => PasswordValidator.validatePassword(
              'VERYLONGPASSWORDONLYUPPERCASE',
            ),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );

      test(
        'should throw PasswordTooWeakException when password contains only letters with special symbol but no digit',
        () {
          expect(
            () => PasswordValidator.validatePassword('StrongPassword!!AAaa'),
            throwsA(isA<PasswordTooWeakException>()),
          );
        },
      );
    });
  });
}
