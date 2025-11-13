import 'package:locnet_app/features/settings/data/data.dart';

final class SettingsInteractor {
  SettingsInteractor({required ISettingsRepo settingsRepo})
    : _settingsRepo = settingsRepo;

  final ISettingsRepo _settingsRepo;

  Future<bool> changeLanguage({required String languageCode}) async {
    return await _settingsRepo.changeLanguage(languageCode: languageCode);
  }

  Future<bool> changeThemeMode({required String themeMode}) async {
    return await _settingsRepo.changeThemeMode(themeMode: themeMode);
  }

  Future<String> getCurrentLanguage() async {
    return await _settingsRepo.getCurrentLanguageCode();
  }

  Future<String> getCurrentThemeMode() async {
    return await _settingsRepo.getCurrentThemeMode();
  }
}
