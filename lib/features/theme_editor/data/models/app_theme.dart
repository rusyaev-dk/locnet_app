// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';

final class AppThemeDto extends Equatable {
  const AppThemeDto({
    required AppColorPaletteDto lightPalette,
    required AppColorPaletteDto darkPalette,
  }) : _lightPalette = lightPalette,
       _darkPalette = darkPalette;

  final AppColorPaletteDto _lightPalette;
  final AppColorPaletteDto _darkPalette;

  AppColorPaletteDto get lightPalette => _lightPalette;
  AppColorPaletteDto get darkPalette => _darkPalette;

  factory AppThemeDto.fromJson(Map<String, dynamic> json) {
    return AppThemeDto(
      lightPalette: AppColorPaletteDto.fromJson(
        json['light_palette'] as Map<String, dynamic>,
      ),
      darkPalette: AppColorPaletteDto.fromJson(
        json['dark_palette'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'light_palette': _lightPalette.toJson(),
      'dark_palette': _darkPalette.toJson(),
    };
  }

  @override
  List<Object?> get props => <Object?>[_lightPalette, _darkPalette];
}
