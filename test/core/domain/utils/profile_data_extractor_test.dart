import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';

void main() {
  late User user;

  setUp(() {
    user = User(
      userId: 'user_id',
      username: 'username',
      firstName: 'Ivan',
      lastName: 'Petrov',
      patronymic: 'Ivanovich',
      languageCode: 'ru',
      isDeleted: false,
      isBanned: false,
      createdAt: DateTime(2026, 1, 23),
      updatedAt: DateTime(2026, 1, 23),
    );
  });

  group('ProfileDataExtractor', () {
    group('extractUserFullName method', () {
      test(
        'should return "first patronymic last" when all parts are present',
        () {
          user = user.copyWith(
            firstName: 'Ivan',
            patronymic: 'Ivanovich',
            lastName: 'Petrov',
          );

          final String result = ProfileDataExtractor.extractUserFullName(user);

          expect(result, equals('Ivan Ivanovich Petrov'));
        },
      );

      test('should skip patronymic when it is null', () {
        user = user.copyWith(
          firstName: 'Ivan',
          lastName: 'Petrov',
          patronymic: "",
        );

        final String result = ProfileDataExtractor.extractUserFullName(user);

        expect(result, equals('Ivan Petrov'));
      });

      test('should trim each part and join with single spaces', () {
        user = user.copyWith(
          firstName: '  Ivan  ',
          patronymic: '  Ivanovich ',
          lastName: '  Petrov ',
        );

        final String result = ProfileDataExtractor.extractUserFullName(user);

        expect(result, equals('Ivan Ivanovich Petrov'));
      });

      test('should skip empty parts after trim', () {
        user = user.copyWith(
          firstName: 'Ivan',
          patronymic: '   ',
          lastName: 'Petrov',
        );

        final String result = ProfileDataExtractor.extractUserFullName(user);

        expect(result, equals('Ivan Petrov'));
      });

      test(
        'should return empty string when all name parts are empty after trim',
        () {
          user = user.copyWith(
            firstName: '   ',
            patronymic: '   ',
            lastName: '   ',
          );

          final String result = ProfileDataExtractor.extractUserFullName(user);

          expect(result, equals(''));
        },
      );
    });

    group('extractUserInitials method', () {
      test(
        'should return first letter of first name when only first name exists',
        () {
          user = user.copyWith(
            firstName: 'Ivan',
            lastName: '',
            username: 'ivan123',
          );

          final String result = ProfileDataExtractor.extractUserInitials(user);

          expect(result, equals('I'));
        },
      );

      test('should return initials from first and last names', () {
        user = user.copyWith(
          firstName: 'Ivan',
          lastName: 'Petrov',
          username: 'ivan123',
        );

        final String result = ProfileDataExtractor.extractUserInitials(user);

        expect(result, equals('IP'));
      });

      test('should trim full name parts before extracting initials', () {
        user = user.copyWith(
          firstName: '  Ivan  ',
          lastName: '  Petrov ',
          username: 'ivan123',
        );

        final String result = ProfileDataExtractor.extractUserInitials(user);

        expect(result, equals('IP'));
      });

      test('should fall back to username when full name is empty', () {
        user = user.copyWith(
          firstName: '   ',
          lastName: '   ',
          username: 'johnny',
        );

        final String result = ProfileDataExtractor.extractUserInitials(user);

        expect(result, equals('J'));
      });

      test('should trim username before extracting initials', () {
        user = user.copyWith(
          firstName: '',
          lastName: '',
          username: '  johnny ',
        );

        final String result = ProfileDataExtractor.extractUserInitials(user);

        expect(result, equals('J'));
      });

      test('should return "?" when both full name and username are empty', () {
        user = user.copyWith(firstName: '', lastName: '', username: '   ');

        final String result = ProfileDataExtractor.extractUserInitials(user);

        expect(result, equals('?'));
      });

      test('should return uppercased initials', () {
        user = user.copyWith(
          firstName: 'ivan',
          lastName: 'petrov',
          username: 'ivan123',
        );

        final String result = ProfileDataExtractor.extractUserInitials(user);

        expect(result, equals('IP'));
      });
    });
  });
}
