import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/data/data.dart';

class LocalSettingsRepo implements ISettingsRepo {
  LocalSettingsRepo({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  final String _languageCodeKey = "language_code";
  final String _themeKey = "theme";
  final String _textScaleKey = "text_scale";
  final String _elementScaleKey = "element_scale";
  final String _chatPrefix = 'chat_setting_';
  final String _notificationPrefix = 'notification_setting_';
  final String _notificationSoundIndexKey = 'notification_sound_index';

  @override
  Future<bool> changeLanguage({required String newLanguageCode}) async {
    return await _storage.write<String>(
      key: _languageCodeKey,
      value: newLanguageCode,
    );
  }

  @override
  Future<String> getCurrentLanguageCode() async {
    return await _storage.read<String>(key: _languageCodeKey) ??
        AppConfig.defaultLanguageCode;
  }

  @override
  Future<bool> changeThemeMode({required String newThemeCode}) async {
    return await _storage.write<String>(key: _themeKey, value: newThemeCode);
  }

  @override
  Future<String> getCurrentThemeMode() async {
    return await _storage.read<String>(key: _themeKey) ??
        AppConfig.defaultThemeMode;
  }

  @override
  Future<bool> changeTextScale({required String newTextScaleCode}) async {
    return await _storage.write<String>(
      key: _textScaleKey,
      value: newTextScaleCode,
    );
  }

  @override
  Future<String> getCurrentTextScaleCode() async {
    return await _storage.read<String>(key: _textScaleKey) ??
        AppConfig.defaultTextScale;
  }

  @override
  Future<bool> changeElementScale({required String newElementScaleCode}) async {
    return await _storage.write<String>(
      key: _elementScaleKey,
      value: newElementScaleCode,
    );
  }

  @override
  Future<String> getCurrentElementScaleCode() async {
    return await _storage.read<String>(key: _elementScaleKey) ??
        AppConfig.defaultElementScale;
  }

  @override
  Future<bool> saveChatSetting({
    required String key,
    required bool value,
  }) async {
    return _storage.write<bool>(key: '$_chatPrefix$key', value: value);
  }

  @override
  Future<bool> getChatSetting({
    required String key,
    required bool fallback,
  }) async {
    return await _storage.read<bool>(key: '$_chatPrefix$key') ?? fallback;
  }

  @override
  Future<bool> saveNotificationSetting({
    required String key,
    required bool value,
  }) async {
    return _storage.write<bool>(key: '$_notificationPrefix$key', value: value);
  }

  @override
  Future<bool> getNotificationSetting({
    required String key,
    required bool fallback,
  }) async {
    return await _storage.read<bool>(key: '$_notificationPrefix$key') ??
        fallback;
  }

  @override
  Future<bool> saveNotificationSoundIndex({required int value}) async {
    return _storage.write<int>(key: _notificationSoundIndexKey, value: value);
  }

  @override
  Future<int> getNotificationSoundIndex({required int fallback}) async {
    return await _storage.read<int>(key: _notificationSoundIndexKey) ??
        fallback;
  }
}
