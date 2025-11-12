abstract interface class ISettingsRepo {
  Future<bool> changeLocale({required String newLocale});
  Future<String> getCurrentLocale();

  Future<bool> changeThemeMode({required String themeCode});
  Future<String> getCurrentThemeMode();
}
