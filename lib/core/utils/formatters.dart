import 'package:intl/intl.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class DateTimeFormatter {
  static DateTime parse(Object? raw) {
    // Accepts DateTime, ISO-8601 String, or Unix epoch (int seconds or milliseconds).
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty) {
      // Preserves Z/offset. Use .toUtc() if you want to normalize.
      return DateTime.parse(raw);
    }
    if (raw is int) {
      // Heuristic: >= 1e12 => milliseconds since epoch, else seconds.
      final bool isMillis = raw >= 1000000000000;
      return DateTime.fromMillisecondsSinceEpoch(
        isMillis ? raw : raw * 1000,
        isUtc: true,
      );
    }
    throw FormatException('Unsupported date value: $raw');
  }

  static String formatLocalized(DateTime dateTime, {String? locale}) {
    final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm', locale);
    return formatter.format(dateTime);
  }
}

final class ProfileDataFormatter {
  static void validateName(String name) {
    final RegExp pattern = RegExp(r'^[A-Za-z]+$');
    if (!pattern.hasMatch(name)) {
      throw NameInvalidCharactersException();
    }
  }

  static void validateUsername(String username) {
    final RegExp pattern = RegExp(r'^[A-Za-z0-9_]+$');
    if (!pattern.hasMatch(username)) {
      throw UsernameInvalidCharactersException();
    }
  }

  static void validateJobPosition(String jobPosition) {
    final RegExp pattern = RegExp(r'^[A-Za-z ]+$');
    if (!pattern.hasMatch(jobPosition)) {
      throw JobPositionInvalidCharactersException();
    }
  }

  static void validatePassword(String password) {
    if (password.length < 14) {
      throw PasswordTooShortException();
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      throw PasswordNoUpperCaseException();
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      throw PasswordNoLowerCaseException();
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      throw PasswordNoDigitException();
    }

    if (!RegExp(r'^[A-Za-z0-9!?@#$%^&*()_\-{}]+$').hasMatch(password)) {
      throw PasswordInvalidCharactersException();
    }
  }
}

final class ConversationDataFormatter {
  static void validateTitle(String title) {
    final String trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ConversationEmptyFieldException();
    }

    if (trimmedTitle.length > 120) {
      throw ConversationDataTooLongException();
    }
  }

  static void validateDescription(String description) {
    final String trimmedDescription = description.trim();

    if (trimmedDescription.isEmpty) {
      throw ConversationEmptyFieldException();
    }

    if (trimmedDescription.length > 1000) {
      throw ConversationDataTooLongException();
    }
  }
}
