import 'package:locnet_app/features/settings/data/data.dart';

class SettingsInteractor {
  SettingsInteractor({required ISettingsRepo settingsRepo})
    : _settingsRepo = settingsRepo;

  final ISettingsRepo _settingsRepo;

  Future<bool> changeLanguage({required String newLanguageCode}) async {
    return await _settingsRepo.changeLanguage(newLanguageCode: newLanguageCode);
  }

  Future<bool> changeThemeMode({required String newThemeCode}) async {
    return await _settingsRepo.changeThemeMode(newThemeCode: newThemeCode);
  }

  Future<String> getCurrentLanguageCode() async {
    return await _settingsRepo.getCurrentLanguageCode();
  }

  Future<String> getCurrentThemeMode() async {
    return await _settingsRepo.getCurrentThemeMode();
  }
}
