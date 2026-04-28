abstract interface class ISettingsRepo {
  Future<bool> changeLanguage({required String newLanguageCode});
  Future<String> getCurrentLanguageCode();

  Future<bool> changeThemeMode({required String newThemeCode});
  Future<String> getCurrentThemeMode();

  Future<bool> changeTextScale({required String newTextScaleCode});
  Future<String> getCurrentTextScaleCode();

  Future<bool> saveChatSetting({required String key, required bool value});
  Future<bool> getChatSetting({required String key, required bool fallback});

  Future<bool> saveNotificationSetting({
    required String key,
    required bool value,
  });
  Future<bool> getNotificationSetting({
    required String key,
    required bool fallback,
  });

  Future<bool> saveNotificationSoundIndex({required int value});
  Future<int> getNotificationSoundIndex({required int fallback});
}
