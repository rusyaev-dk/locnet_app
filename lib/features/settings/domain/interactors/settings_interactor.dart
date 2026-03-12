import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/models/app_theme_type.dart';
import 'package:locnet_app/features/settings/domain/repositories/i_theme_repository.dart';

class SettingsInteractor {
  SettingsInteractor({
    required ISettingsRepo settingsRepo,
    required IThemeRepository themeRepository,
  }) : _settingsRepo = settingsRepo,
       _themeRepository = themeRepository;

  final ISettingsRepo _settingsRepo;
  final IThemeRepository _themeRepository;

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

  Future<bool> changeTextScale({required String newTextScaleCode}) async {
    return await _settingsRepo.changeTextScale(
      newTextScaleCode: newTextScaleCode,
    );
  }

  Future<String> getCurrentTextScaleCode() async {
    return await _settingsRepo.getCurrentTextScaleCode();
  }

  Future<AppThemeType> getCurrentThemeType() async {
    return await _themeRepository.getThemeType();
  }

  Future<bool> setThemeType(AppThemeType type) async {
    return await _themeRepository.setThemeType(type);
  }
}
