abstract interface class ISettingsRepo {
  Future<bool> changeLanguage({required String newLanguageCode});
  Future<String> getCurrentLanguageCode();

  Future<bool> changeThemeMode({required String newThemeCode});
  Future<String> getCurrentThemeMode();

  Future<bool> changeTextScale({required String newTextScaleCode});
  Future<String> getCurrentTextScaleCode();
}
