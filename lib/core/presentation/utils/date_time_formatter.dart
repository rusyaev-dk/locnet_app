import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class DateTimeFormatter {
  static DateTime parse(Object? raw) {
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty) {
      return DateTime.parse(raw);
    }
    if (raw is int) {
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

  static String formatConversationTime({
    required DateTime dateTime,
    required DateTime now,
    required Locale locale,
    required MaterialLocalizations materialLocalizations,
  }) {
    final Duration difference = now.difference(dateTime);

    if (difference.inHours >= 24) {
      final DateFormat weekdayFormatter = DateFormat.E(locale.toLanguageTag());
      return weekdayFormatter.format(dateTime);
    }

    final TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return materialLocalizations.formatTimeOfDay(timeOfDay);
  }
}
