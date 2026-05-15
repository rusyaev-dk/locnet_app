import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';

void main() {
  group('ProfileDataValidator', () {
    group('validateName method', () {
      test('should not throw when name contains only latin letters', () {
        expect(
          () => ProfileDataValidator.validateName('Ivan'),
          returnsNormally,
        );
      });

      test(
        'should throw InvalidCharactersException when name contains digits',
        () {
          expect(
            () => ProfileDataValidator.validateName('Ivan1'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when name contains underscore',
        () {
          expect(
            () => ProfileDataValidator.validateName('Ivan_Petrov'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when name contains spaces',
        () {
          expect(
            () => ProfileDataValidator.validateName('Ivan Petrov'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when name contains hyphen',
        () {
          expect(
            () => ProfileDataValidator.validateName('Jean-Claude'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when name contains cyrillic letters',
        () {
          expect(
            () => ProfileDataValidator.validateName('Иван'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test('should throw InvalidCharactersException when name is empty', () {
        expect(
          () => ProfileDataValidator.validateName(''),
          throwsA(isA<InvalidCharactersException>()),
        );
      });
    });

    group('validateUsername method', () {
      test(
        'should not throw when username contains latin letters, digits and underscore',
        () {
          expect(
            () => ProfileDataValidator.validateUsername('ivan_123'),
            returnsNormally,
          );
        },
      );

      test(
        'should throw InvalidCharactersException when username contains hyphen',
        () {
          expect(
            () => ProfileDataValidator.validateUsername('ivan-123'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when username contains dot',
        () {
          expect(
            () => ProfileDataValidator.validateUsername('ivan.petrov'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when username contains spaces',
        () {
          expect(
            () => ProfileDataValidator.validateUsername('ivan petrov'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when username contains cyrillic letters',
        () {
          expect(
            () => ProfileDataValidator.validateUsername('иван'),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );

      test(
        'should throw InvalidCharactersException when username is empty',
        () {
          expect(
            () => ProfileDataValidator.validateUsername(''),
            throwsA(isA<InvalidCharactersException>()),
          );
        },
      );
    });

    group('validateUserDescription method', () {
      test('should not throw when description length is 200', () {
        final String description = List<String>.filled(200, 'a').join();

        expect(
          () => ProfileDataValidator.validateUserDescription(description),
          returnsNormally,
        );
      });

      test(
        'should throw CharactersCountViolationException when description length is more than 200',
        () {
          final String description = List<String>.filled(201, 'a').join();

          expect(
            () => ProfileDataValidator.validateUserDescription(description),
            throwsA(isA<CharactersCountViolationException>()),
          );
        },
      );

      test('should not throw when description is empty', () {
        expect(
          () => ProfileDataValidator.validateUserDescription(''),
          returnsNormally,
        );
      });
    });
  });
}
