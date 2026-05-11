import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class DateTimeFormatter {
  static DateTime parse(Object? raw) {
    if (raw is DateTime) return raw.toUtc();
    if (raw is String && raw.isNotEmpty) {
      return DateTime.parse(raw).toUtc();
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
    return formatter.format(dateTime.toLocal());
  }

  static String formatConversationTime({
    required DateTime dateTime,
    required DateTime now,
    required Locale locale,
    required MaterialLocalizations materialLocalizations,
  }) {
    final DateTime localDateTime = dateTime.toLocal();
    final Duration difference = now.difference(localDateTime);

    if (difference.inHours >= 24) {
      final DateFormat weekdayFormatter = DateFormat.E(locale.toLanguageTag());
      return weekdayFormatter.format(localDateTime);
    }

    final TimeOfDay timeOfDay = TimeOfDay.fromDateTime(localDateTime);
    return materialLocalizations.formatTimeOfDay(timeOfDay);
  }
}
