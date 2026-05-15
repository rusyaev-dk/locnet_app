import 'dart:async';

import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';

final class LocalThemeEditorRepo implements IThemeEditorRepo {
  LocalThemeEditorRepo({required IKeyValueStorage storage})
    : _storage = storage;

  final IKeyValueStorage _storage;

  static const _themeKey = "app_theme";

  @override
  Future<AppTheme> loadAppTheme() async {
    final String? data = await _storage.read<String>(key: _themeKey);
    if (data == null || data.trim().isEmpty) {
      return AppTheme.basic();
    }
    return AppThemeSerialization.fromJsonString(data);
  }

  @override
  Future<bool> saveAppTheme({required AppTheme newAppTheme}) async {
    final data = newAppTheme.toJsonString();
    return await _storage.write(key: _themeKey, value: data);
  }
}
