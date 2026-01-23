import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/core.dart';

void main() {
  group('DateTimeFormatter', () {
    group('parse method', () {
      test('should return same DateTime when raw is DateTime', () {
        // Arrange
        final DateTime dateTime = DateTime.utc(2024, 1, 2, 3, 4, 5);

        // Act
        final DateTime result = DateTimeFormatter.parse(dateTime);

        // Assert
        expect(result, equals(dateTime));
      });

      test('should parse ISO-8601 string with Z', () {
        // Arrange
        const String raw = '2024-01-02T03:04:05Z';

        // Act
        final DateTime result = DateTimeFormatter.parse(raw);

        // Assert
        expect(result.isUtc, isTrue);
        expect(result, equals(DateTime.utc(2024, 1, 2, 3, 4, 5)));
      });

      test('should parse ISO-8601 string with offset', () {
        // Arrange
        const String raw = '2024-01-02T08:04:05+05:00';

        // Act
        final DateTime result = DateTimeFormatter.parse(raw);

        // Assert
        expect(result.toUtc(), equals(DateTime.utc(2024, 1, 2, 3, 4, 5)));
      });

      test('should throw FormatException for empty string', () {
        // Arrange
        const String raw = '';

        // Act & Assert
        expect(
          () => DateTimeFormatter.parse(raw),
          throwsA(isA<FormatException>()),
        );
      });

      test('should interpret int as seconds since epoch when < 1e12', () {
        // Arrange
        const int rawSeconds = 1704164645; // 2024-01-02T03:04:05Z

        // Act
        final DateTime result = DateTimeFormatter.parse(rawSeconds);

        // Assert
        expect(result.isUtc, isTrue);
        expect(result, equals(DateTime.utc(2024, 1, 2, 3, 4, 5)));
      });

      test('should interpret int as milliseconds since epoch when >= 1e12', () {
        // Arrange
        const int rawMillis = 1704164645000; // 2024-01-02T03:04:05Z

        // Act
        final DateTime result = DateTimeFormatter.parse(rawMillis);

        // Assert
        expect(result.isUtc, isTrue);
        expect(result, equals(DateTime.utc(2024, 1, 2, 3, 4, 5)));
      });

      test('should treat 1e12 exactly as milliseconds', () {
        // Arrange
        const int rawMillisThreshold = 1000000000000; // 2001-09-09T01:46:40Z

        // Act
        final DateTime result = DateTimeFormatter.parse(rawMillisThreshold);

        // Assert
        expect(result.isUtc, isTrue);
        expect(
          result,
          equals(
            DateTime.fromMillisecondsSinceEpoch(
              rawMillisThreshold,
              isUtc: true,
            ),
          ),
        );
      });

      test('should throw FormatException for unsupported type', () {
        // Arrange
        const Object raw = 12.34;

        // Act & Assert
        expect(
          () => DateTimeFormatter.parse(raw),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw FormatException for null', () {
        // Act & Assert
        expect(
          () => DateTimeFormatter.parse(null),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
