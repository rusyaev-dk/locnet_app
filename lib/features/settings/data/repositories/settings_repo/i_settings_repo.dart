abstract interface class ISettingsRepo {
  Future<bool> changeLanguage({required String languageCode});
  Future<String> getCurrentLanguageCode();

  Future<bool> changeThemeMode({required String themeMode});
  Future<String> getCurrentThemeMode();
}
