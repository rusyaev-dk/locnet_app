// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

final class AppColorPalette extends Equatable {
  const AppColorPalette({
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
    required this.hoverOverlay,
    required this.pressedOverlay,
  });

  factory AppColorPalette.fromColorScheme(AppColorScheme scheme) {
    return AppColorPalette(
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      surfaceDim: scheme.surfaceDim,
      surfaceBright: scheme.surfaceBright,
      surfaceContainerLowest: scheme.surfaceContainerLowest,
      surfaceContainerLow: scheme.surfaceContainerLow,
      surfaceContainer: scheme.surfaceContainer,
      surfaceContainerHigh: scheme.surfaceContainerHigh,
      surfaceContainerHighest: scheme.surfaceContainerHighest,
      onSurfaceVariant: scheme.onSurfaceVariant,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      surfaceTint: scheme.surfaceTint,
      approval: scheme.approval,
      hoverOverlay: scheme.hoverOverlay,
      pressedOverlay: scheme.pressedOverlay,
    );
  }

  AppColorScheme toColorScheme(AppColorScheme baseScheme) {
    return baseScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceDim: surfaceDim,
      surfaceBright: surfaceBright,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      surfaceTint: surfaceTint,
      approval: approval,
      hoverOverlay: hoverOverlay,
      pressedOverlay: pressedOverlay,
    );
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
  final Color hoverOverlay;
  final Color pressedOverlay;

  AppColorPalette copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    Color? hoverOverlay,
    Color? pressedOverlay,
    Color? activatedFilterButtonColor,
    Color? inActivatedFilterButtonColor,
    Color? activatedThemeButtonColor,
    Color? inActivatedThemeButtonColor,
    Color? sectionBackgroundColor,
    Color? settingsBackgroundColor,
    Color? approval,
  }) {
    return AppColorPalette(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      approval: approval ?? this.approval,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
    );
  }

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
    hoverOverlay,
    pressedOverlay,
  ];
}

extension ColorArgb32 on Color {
  int toArgb32() {
    return toARGB32();
  }

  static Color fromArgb32(int argb32) {
    return Color(argb32);
  }
}

extension AppColorPaletteSerialization on AppColorPalette {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'primary': primary.toArgb32(),
      'onPrimary': onPrimary.toArgb32(),
      'primaryContainer': primaryContainer.toArgb32(),
      'onPrimaryContainer': onPrimaryContainer.toArgb32(),
      'secondary': secondary.toArgb32(),
      'onSecondary': onSecondary.toArgb32(),
      'secondaryContainer': secondaryContainer.toArgb32(),
      'onSecondaryContainer': onSecondaryContainer.toArgb32(),
      'tertiary': tertiary.toArgb32(),
      'onTertiary': onTertiary.toArgb32(),
      'tertiaryContainer': tertiaryContainer.toArgb32(),
      'onTertiaryContainer': onTertiaryContainer.toArgb32(),
      'error': error.toArgb32(),
      'onError': onError.toArgb32(),
      'errorContainer': errorContainer.toArgb32(),
      'onErrorContainer': onErrorContainer.toArgb32(),
      'surface': surface.toArgb32(),
      'onSurface': onSurface.toArgb32(),
      'surfaceDim': surfaceDim.toArgb32(),
      'surfaceBright': surfaceBright.toArgb32(),
      'surfaceContainerLowest': surfaceContainerLowest.toArgb32(),
      'surfaceContainerLow': surfaceContainerLow.toArgb32(),
      'surfaceContainer': surfaceContainer.toArgb32(),
      'surfaceContainerHigh': surfaceContainerHigh.toArgb32(),
      'surfaceContainerHighest': surfaceContainerHighest.toArgb32(),
      'onSurfaceVariant': onSurfaceVariant.toArgb32(),
      'outline': outline.toArgb32(),
      'outlineVariant': outlineVariant.toArgb32(),
      'shadow': shadow.toArgb32(),
      'scrim': scrim.toArgb32(),
      'inverseSurface': inverseSurface.toArgb32(),
      'onInverseSurface': onInverseSurface.toArgb32(),
      'inversePrimary': inversePrimary.toArgb32(),
      'surfaceTint': surfaceTint.toArgb32(),
      'approval': approval.toArgb32(),
      'hoverOverlay': hoverOverlay.toArgb32(),
      'pressedOverlay': pressedOverlay.toArgb32(),
    };
  }

  static AppColorPalette fromJson(Map<String, dynamic> json) {
    Color color(String key) => ColorArgb32.fromArgb32(json[key] as int);
    Color? optColor(String key) {
      final value = json[key];
      if (value == null) return null;
      return ColorArgb32.fromArgb32(value as int);
    }

    return AppColorPalette(
      primary: color('primary'),
      onPrimary: color('onPrimary'),
      primaryContainer: color('primaryContainer'),
      onPrimaryContainer: color('onPrimaryContainer'),
      secondary: color('secondary'),
      onSecondary: color('onSecondary'),
      secondaryContainer: color('secondaryContainer'),
      onSecondaryContainer: color('onSecondaryContainer'),
      tertiary: color('tertiary'),
      onTertiary: color('onTertiary'),
      tertiaryContainer: color('tertiaryContainer'),
      onTertiaryContainer: color('onTertiaryContainer'),
      error: color('error'),
      onError: color('onError'),
      errorContainer: color('errorContainer'),
      onErrorContainer: color('onErrorContainer'),
      surface: color('surface'),
      onSurface: color('onSurface'),
      surfaceDim: color('surfaceDim'),
      surfaceBright: color('surfaceBright'),
      surfaceContainerLowest: color('surfaceContainerLowest'),
      surfaceContainerLow: color('surfaceContainerLow'),
      surfaceContainer: color('surfaceContainer'),
      surfaceContainerHigh: color('surfaceContainerHigh'),
      surfaceContainerHighest: color('surfaceContainerHighest'),
      onSurfaceVariant: color('onSurfaceVariant'),
      outline: color('outline'),
      outlineVariant: color('outlineVariant'),
      shadow: color('shadow'),
      scrim: color('scrim'),
      inverseSurface: color('inverseSurface'),
      onInverseSurface: color('onInverseSurface'),
      inversePrimary: color('inversePrimary'),
      surfaceTint: color('surfaceTint'),
      approval: color('approval'),
      hoverOverlay: optColor('hoverOverlay') ?? const Color(0x0D020617),
      pressedOverlay: optColor('pressedOverlay') ?? const Color(0x1A020617),
    );
  }
}
