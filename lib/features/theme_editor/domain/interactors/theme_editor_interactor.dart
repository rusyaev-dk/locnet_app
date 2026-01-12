import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';

class ThemeEditorInteractor {
  ThemeEditorInteractor({required IThemeEditorRepo themeEditorRepo})
    : _themeEditorRepo = themeEditorRepo;

  final IThemeEditorRepo _themeEditorRepo;

  Future<AppTheme> loadAppTheme() async {
    return await _themeEditorRepo.loadAppTheme();
  }

  Future<bool> updateAppTheme({required AppTheme updatedAppTheme}) async {
    return await _themeEditorRepo.updateAppTheme(
      updatedAppTheme: updatedAppTheme,
    );
  }
}
