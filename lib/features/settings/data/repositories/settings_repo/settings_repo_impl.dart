import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/data/data.dart';

class SettingsRepo implements ISettingsRepo {
  SettingsRepo({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  final String _localeKey = "locale";
  final String _themeKey = "theme";

  @override
  Future<bool> changeLocale({required String newLocale}) async {
    return await _storage.save(key: _localeKey, value: newLocale);
  }

  @override
  Future<String> getCurrentLocale() async {
    return await _storage.get(key: _localeKey) ?? AppConfig.defaultLanguageCode;
  }

  @override
  Future<bool> changeThemeMode({required String themeCode}) async {
    return await _storage.save(key: _themeKey, value: themeCode);
  }

  @override
  Future<String> getCurrentThemeMode() async {
    return await _storage.get(key: _themeKey) ?? "system";
  }
}
