String normalizeLanguageCode(String? code, {String fallback = 'ru'}) {
  final String raw = (code ?? '').trim().toLowerCase();
  if (raw.isEmpty) {
    return fallback;
  }

  final String languagePart = raw.split(RegExp(r'[_-]')).first;
  if (!_iso639LanguageCode.hasMatch(languagePart)) {
    return fallback;
  }

  return languagePart;
}

final RegExp _iso639LanguageCode = RegExp(r'^[a-z]{2,3}$');
