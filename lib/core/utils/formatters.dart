import 'package:intl/intl.dart';
import 'package:locnet_app/core/domain/domain.dart';

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

final class ConversationDataFormatter {
  static void validateTitle(String title) {
    final String trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw CharactersCountViolationException(
        message: "Conversation title cannot be empty",
      );
    }

    if (trimmedTitle.length > 120) {
      throw CharactersCountViolationException(
        message: "Conversation title too much characters (max 120)",
      );
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
