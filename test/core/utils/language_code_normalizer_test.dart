import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/utils/language_code_normalizer.dart';

void main() {
  group('normalizeLanguageCode', () {
    test('returns fallback for null and empty values', () {
      expect(normalizeLanguageCode(null), 'ru');
      expect(normalizeLanguageCode(''), 'ru');
      expect(normalizeLanguageCode('   '), 'ru');
    });

    test('normalizes supported codes', () {
      expect(normalizeLanguageCode('ru'), 'ru');
      expect(normalizeLanguageCode('RU'), 'ru');
      expect(normalizeLanguageCode('ru-RU'), 'ru');
      expect(normalizeLanguageCode('en_US'), 'en');
    });

    test('returns fallback for invalid codes', () {
      expect(normalizeLanguageCode('invalid'), 'ru');
      expect(normalizeLanguageCode('123'), 'ru');
    });
  });
}
