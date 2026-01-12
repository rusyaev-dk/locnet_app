import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class AppColorPaletteDto extends Equatable {
  const AppColorPaletteDto({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.surfaceTint,
    required this.approval,
  });

  factory AppColorPaletteDto.fromJson(Map<String, dynamic> json) {
    Color readColor(String key) {
      return Color(json[key] as int);
    }

    return AppColorPaletteDto(
      primary: readColor('primary'),
      onPrimary: readColor('on_primary'),
      primaryContainer: readColor('primary_container'),
      onPrimaryContainer: readColor('on_primary_container'),
      secondary: readColor('secondary'),
      onSecondary: readColor('on_secondary'),
      secondaryContainer: readColor('secondary_container'),
      onSecondaryContainer: readColor('on_secondary_container'),
      tertiary: readColor('tertiary'),
      onTertiary: readColor('on_tertiary'),
      tertiaryContainer: readColor('tertiary_container'),
      onTertiaryContainer: readColor('on_tertiary_container'),
      error: readColor('error'),
      onError: readColor('on_error'),
      errorContainer: readColor('error_container'),
      onErrorContainer: readColor('on_error_container'),
      surface: readColor('surface'),
      onSurface: readColor('on_surface'),
      surfaceDim: readColor('surface_dim'),
      surfaceBright: readColor('surface_bright'),
      surfaceContainerLowest: readColor('surface_container_lowest'),
      surfaceContainerLow: readColor('surface_container_low'),
      surfaceContainer: readColor('surface_container'),
      surfaceContainerHigh: readColor('surface_container_high'),
      surfaceContainerHighest: readColor('surface_container_highest'),
      onSurfaceVariant: readColor('on_surface_variant'),
      outline: readColor('outline'),
      outlineVariant: readColor('outline_variant'),
      shadow: readColor('shadow'),
      scrim: readColor('scrim'),
      inverseSurface: readColor('inverse_surface'),
      onInverseSurface: readColor('on_inverse_surface'),
      inversePrimary: readColor('inverse_primary'),
      surfaceTint: readColor('surface_tint'),
      approval: readColor('approval'),
    );
  }

  Map<String, dynamic> toJson() {
    int encode(Color value) => value.toARGB32();

    return <String, dynamic>{
      'primary': encode(primary),
      'on_primary': encode(onPrimary),
      'primary_container': encode(primaryContainer),
      'on_primary_container': encode(onPrimaryContainer),
      'secondary': encode(secondary),
      'on_secondary': encode(onSecondary),
      'secondary_container': encode(secondaryContainer),
      'on_secondary_container': encode(onSecondaryContainer),
      'tertiary': encode(tertiary),
      'on_tertiary': encode(onTertiary),
      'tertiary_container': encode(tertiaryContainer),
      'on_tertiary_container': encode(onTertiaryContainer),
      'error': encode(error),
      'on_error': encode(onError),
      'error_container': encode(errorContainer),
      'on_error_container': encode(onErrorContainer),
      'surface': encode(surface),
      'on_surface': encode(onSurface),
      'surface_dim': encode(surfaceDim),
      'surface_bright': encode(surfaceBright),
      'surface_container_lowest': encode(surfaceContainerLowest),
      'surface_container_low': encode(surfaceContainerLow),
      'surface_container': encode(surfaceContainer),
      'surface_container_high': encode(surfaceContainerHigh),
      'surface_container_highest': encode(surfaceContainerHighest),
      'on_surface_variant': encode(onSurfaceVariant),
      'outline': encode(outline),
      'outline_variant': encode(outlineVariant),
      'shadow': encode(shadow),
      'scrim': encode(scrim),
      'inverse_surface': encode(inverseSurface),
      'on_inverse_surface': encode(onInverseSurface),
      'inverse_primary': encode(inversePrimary),
      'surface_tint': encode(surfaceTint),
      'approval': encode(approval),
    };
  }

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color surfaceTint;
  final Color approval;

  @override
  List<Object?> get props => <Object?>[
    primary,
    onPrimary,
    primaryContainer,
    onPrimaryContainer,
    secondary,
    onSecondary,
    secondaryContainer,
    onSecondaryContainer,
    tertiary,
    onTertiary,
    tertiaryContainer,
    onTertiaryContainer,
    error,
    onError,
    errorContainer,
    onErrorContainer,
    surface,
    onSurface,
    surfaceDim,
    surfaceBright,
    surfaceContainerLowest,
    surfaceContainerLow,
    surfaceContainer,
    surfaceContainerHigh,
    surfaceContainerHighest,
    onSurfaceVariant,
    outline,
    outlineVariant,
    shadow,
    scrim,
    inverseSurface,
    onInverseSurface,
    inversePrimary,
    surfaceTint,
    approval,
  ];
}
