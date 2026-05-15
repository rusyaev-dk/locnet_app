import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

void main() {
  group('ConversationDataValidator', () {
    group('validateTitle method', () {
      test('should not throw when title is valid', () {
        expect(
          () => ConversationDataValidator.validateTitle('General chat'),
          returnsNormally,
        );
      });

      test(
        'should trim title and not throw when title has surrounding spaces',
        () {
          expect(
            () => ConversationDataValidator.validateTitle('  General chat  '),
            returnsNormally,
          );
        },
      );

      test(
        'should throw CharactersCountViolationException when title is empty',
        () {
          expect(
            () => ConversationDataValidator.validateTitle(''),
            throwsA(isA<CharactersCountViolationException>()),
          );
        },
      );

      test(
        'should throw CharactersCountViolationException when title contains only spaces',
        () {
          expect(
            () => ConversationDataValidator.validateTitle('   \n\t  '),
            throwsA(isA<CharactersCountViolationException>()),
          );
        },
      );

      test('should not throw when title length is 120', () {
        final String title = List<String>.filled(120, 'a').join();

        expect(
          () => ConversationDataValidator.validateTitle(title),
          returnsNormally,
        );
      });

      test(
        'should throw CharactersCountViolationException when title length is more than 120',
        () {
          final String title = List<String>.filled(121, 'a').join();

          expect(
            () => ConversationDataValidator.validateTitle(title),
            throwsA(isA<CharactersCountViolationException>()),
          );
        },
      );
    });

    group('validateDescription method', () {
      test('should not throw when description is valid', () {
        expect(
          () =>
              ConversationDataValidator.validateDescription('Some description'),
          returnsNormally,
        );
      });

      test(
        'should trim description and not throw when description has surrounding spaces',
        () {
          expect(
            () => ConversationDataValidator.validateDescription(
              '  Some description  ',
            ),
            returnsNormally,
          );
        },
      );

      test(
        'should throw RequiredValueNotProvidedException when description is empty',
        () {
          expect(
            () => ConversationDataValidator.validateDescription(''),
            throwsA(isA<RequiredValueNotProvidedException>()),
          );
        },
      );

      test(
        'should throw RequiredValueNotProvidedException when description contains only spaces',
        () {
          expect(
            () => ConversationDataValidator.validateDescription('   \n\t  '),
            throwsA(isA<RequiredValueNotProvidedException>()),
          );
        },
      );

      test('should not throw when description length is 1000', () {
        final String description = List<String>.filled(1000, 'a').join();

        expect(
          () => ConversationDataValidator.validateDescription(description),
          returnsNormally,
        );
      });

      test(
        'should throw CharactersCountViolationException when description length is more than 1000',
        () {
          final String description = List<String>.filled(1001, 'a').join();

          expect(
            () => ConversationDataValidator.validateDescription(description),
            throwsA(isA<CharactersCountViolationException>()),
          );
        },
      );
    });
  });
}
