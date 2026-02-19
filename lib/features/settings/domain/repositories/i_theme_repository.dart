import 'package:locnet_app/features/settings/domain/models/app_theme_type.dart';

/// Persists and retrieves the selected app theme type (no Flutter types).
abstract interface class IThemeRepository {
  Future<AppThemeType> getThemeType();

  Future<bool> setThemeType(AppThemeType type);
}
