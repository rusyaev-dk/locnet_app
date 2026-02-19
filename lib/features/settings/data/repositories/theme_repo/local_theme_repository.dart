import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';

/// Persists selected [AppThemeType] via [IKeyValueStorage].
final class LocalThemeRepository implements IThemeRepository {
  LocalThemeRepository({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  static const String _key = 'app_theme_type';

  @override
  Future<AppThemeType> getThemeType() async {
    try {
      final String? value = await _storage.read<String>(key: _key);
      return AppThemeType.fromStorage(value);
    } catch (_) {
      return AppThemeType.light;
    }
  }

  @override
  Future<bool> setThemeType(AppThemeType type) async {
    try {
      return await _storage.write<String>(key: _key, value: type.storageKey);
    } catch (_) {
      return false;
    }
  }
}
