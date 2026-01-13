import 'package:locnet_app/features/theme_editor/domain/domain.dart';

abstract interface class IThemeEditorRepo {
  Future<bool> saveAppTheme({required AppTheme newAppTheme});
  Future<AppTheme> loadAppTheme();
}
