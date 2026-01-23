import 'package:locnet_app/core/core.dart';

final class ProfileDataExtractor {
  static String extractUserInitials(User user) {
    final String firstName = user.firstName.trim();
    final String lastName = user.lastName.trim();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      final String first = _firstLetter(firstName);
      final String second = _firstLetter(lastName);
      return '$first$second';
    }

    if (firstName.isNotEmpty) {
      return _firstLetter(firstName);
    }

    final String normalizedUsername = user.username.trim();
    if (normalizedUsername.isNotEmpty) {
      return _firstLetter(normalizedUsername);
    }

    return '?';
  }

  static String extractUserFullName(User user) {
    final String firstName = user.firstName.trim();
    final String lastName = user.lastName.trim();
    final String patronymic = (user.patronymic ?? '').trim();

    if (firstName.isEmpty && lastName.isEmpty) {
      return '';
    }

    if (patronymic.isEmpty) {
      return <String>[
        firstName,
        lastName,
      ].where((String value) => value.isNotEmpty).join(' ');
    }

    return <String>[
      firstName,
      patronymic,
      lastName,
    ].where((String value) => value.isNotEmpty).join(' ');
  }

  static String _firstLetter(String value) {
    if (value.isEmpty) {
      return '';
    }
    return value.substring(0, 1).toUpperCase();
  }
}
