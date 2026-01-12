// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';
import 'package:locnet_app/uikit/uikit.dart';

class AppTheme extends Equatable {
  const AppTheme({required this.lightPalette, required this.darkPalette});

  final AppColorPalette lightPalette;
  final AppColorPalette darkPalette;

  factory AppTheme.fromDto(AppThemeDto dto) {
    return AppTheme(
      lightPalette: AppColorPalette.fromDto(dto.lightPalette),
      darkPalette: AppColorPalette.fromDto(dto.darkPalette),
    );
  }

  AppTheme copyWith({
    AppColorPalette? lightPalette,
    AppColorPalette? darkPalette,
  }) {
    return AppTheme(
      lightPalette: lightPalette ?? this.lightPalette,
      darkPalette: darkPalette ?? this.darkPalette,
    );
  }

  factory AppTheme.basic() {
    return AppTheme(
      lightPalette: AppColorPalette.fromColorScheme(
        const AppColorScheme.light(),
      ),
      darkPalette: AppColorPalette.fromColorScheme(const AppColorScheme.dark()),
    );
  }

  @override
  List<Object?> get props => <Object?>[lightPalette, darkPalette];
}
