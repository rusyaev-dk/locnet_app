import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/models/app_theme_type.dart';
import 'package:locnet_app/features/settings/domain/repositories/i_theme_repository.dart';

class SettingsInteractor {
  SettingsInteractor({
    required ISettingsRepo settingsRepo,
    required IThemeRepository themeRepository,
    required IUserRepo userRepo,
    required IUserCacheRepo userCacheRepo,
  }) : _settingsRepo = settingsRepo,
       _themeRepository = themeRepository,
       _userRepo = userRepo,
       _userCacheRepo = userCacheRepo;

  final ISettingsRepo _settingsRepo;
  final IThemeRepository _themeRepository;
  final IUserRepo _userRepo;
  final IUserCacheRepo _userCacheRepo;

  Future<bool> changeLanguage({required String newLanguageCode}) async {
    try {
      final User current = await _userRepo.me();
      if (current.languageCode != newLanguageCode) {
        final User updated = await _userRepo.updateUser(
          updatedUser: current.copyWith(languageCode: newLanguageCode),
        );
        try {
          await _userCacheRepo.saveUser(user: updated);
        } on AppException {
          // Cache sync is best-effort; local settings still apply below.
        }
      }
    } on AppException {
      // No session or profile sync failed — still apply UI locale locally.
    }

    return _settingsRepo.changeLanguage(newLanguageCode: newLanguageCode);
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
