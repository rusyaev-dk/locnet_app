import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme._({
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
    required this.shimmer,
    required this.approval,
  });

  const AppColorScheme.light()
    : primary = const Color(0xFF1D4ED8), // blue-700 (глубже, спокойнее)
      onPrimary = const Color(0xFFFFFFFF),
      primaryContainer = const Color(0xFFE0EAFF), // мягкий холодный blue-100
      onPrimaryContainer = const Color(0xFF0A1020),

      // Более чистый secondary без грязной альфы
      secondary = const Color(0xFFEAF1FF), // light blue surface
      onSecondary = const Color(0xFF0A1020),
      secondaryContainer = const Color(0xFFD6E4FF),
      onSecondaryContainer = const Color(0xFF0B1F44),

      tertiary = const Color(0xFFF97316), // orange-500
      onTertiary = const Color(0xFF1F1304),
      tertiaryContainer = const Color(0xFFFFEDD5),
      onTertiaryContainer = const Color(0xFF451A03),

      error = const Color(0xFFDC2626), // red-600
      onError = const Color(0xFFFFFFFF),
      errorContainer = const Color(0xFFFEE2E2),
      onErrorContainer = const Color(0xFF450A0A),

      // Поверхности стали чище и светлее
      surface = const Color(0xFFFCFDFF), // почти белый, холодный
      onSurface = const Color(0xFF020617),
      surfaceDim = const Color(0xFFE6EAF0),
      surfaceBright = const Color(0xFFFFFFFF),
      surfaceContainerLowest = const Color(0xFFFFFFFF),
      surfaceContainerLow = const Color(0xFFF4F7FB),
      surfaceContainer = const Color(0xFFE8EDF4),
      surfaceContainerHigh = const Color(0xFFD8DEE9),
      surfaceContainerHighest = const Color(0xFFCBD5E1),

      // Текст вторичный — чуть темнее
      onSurfaceVariant = const Color(0xFF475569), // slate-600
      outline = const Color(0xFFD1D9E6),
      outlineVariant = const Color(0xFFE2E8F0),

      // Тени холодные, не “грязно-чёрные”
      shadow = const Color(0xFF0F172A),
      scrim = const Color(0xFF020617),

      inverseSurface = const Color(0xFF020617),
      onInverseSurface = const Color(0xFFE5E7EB),
      inversePrimary = const Color(0xFF60A5FA),

      surfaceTint = const Color(0xFF1D4ED8),
      shimmer = const Color(0xFFE5EAF2),

      approval = const Color(0xFF22C55E);

  const AppColorScheme.dark()
    : primary = const Color(0xFF7AB4FF), // softer blue (чуть светлее)
      onPrimary = const Color(0xFF020617),
      primaryContainer = const Color(0xFF1E40AF), // blue-800
      onPrimaryContainer = const Color(0xFFDBEAFE),

      secondary = const Color(0xFF0F1F3D),
      onSecondary = const Color(0xFFE5E7EB),
      secondaryContainer = const Color(0xFF183A72),
      onSecondaryContainer = const Color(0xFFDCE7FF),

      tertiary = const Color(0xFFF59E0B), // orange-400 (мягче)
      onTertiary = const Color(0xFF1F1304),
      tertiaryContainer = const Color(0xFF92400E), // orange-700
      onTertiaryContainer = const Color(0xFFFFF3C4),

      error = const Color(0xFFF87171), // red-400
      onError = const Color(0xFF450A0A),
      errorContainer = const Color(0xFF7F1D1D),
      onErrorContainer = const Color(0xFFFEE2E2),

      // Поверхности: не pure black
      surface = const Color(0xFF020617), // slate-950
      onSurface = const Color(0xFFE5E7EB),
      surfaceDim = const Color(0xFF020617),
      surfaceBright = const Color(0xFF0B1220),
      surfaceContainerLowest = const Color(0xFF000000),
      surfaceContainerLow = const Color(0xFF020617),
      surfaceContainer = const Color(0xFF0B1220),
      surfaceContainerHigh = const Color(0xFF111827),
      surfaceContainerHighest = const Color(0xFF1E293B), // slate-700
      // Текст и разделители — мягче и читабельнее
      onSurfaceVariant = const Color(0xFFB6C0D1), // холодный gray-blue
      outline = const Color(0xFF334155), // slate-600
      outlineVariant = const Color(0xFF1E293B),

      // Тени минимальные
      shadow = const Color(0xFF000000),
      scrim = const Color(0xFF000000),

      inverseSurface = const Color(0xFFF9FAFB),
      onInverseSurface = const Color(0xFF020617),
      inversePrimary = const Color(0xFF2563EB),

      surfaceTint = const Color(0xFF7AB4FF),
      shimmer = const Color(0xFF1E293B),

      approval = const Color(0xFF22C55E);

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
  final Color shimmer;
  final Color approval;

  @override
  AppColorScheme copyWith({
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
    Color? shimmer,
    Color? approval,
  }) {
    return AppColorScheme._(
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
      shimmer: shimmer ?? this.shimmer,
      approval: approval ?? this.approval,
    );
  }

  @override
  ThemeExtension<AppColorScheme> lerp(
    ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) {
      return this;
    }

    return AppColorScheme._(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      onSecondaryContainer: Color.lerp(
        onSecondaryContainer,
        other.onSecondaryContainer,
        t,
      )!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      tertiaryContainer: Color.lerp(
        tertiaryContainer,
        other.tertiaryContainer,
        t,
      )!,
      onTertiaryContainer: Color.lerp(
        onTertiaryContainer,
        other.onTertiaryContainer,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(
        onErrorContainer,
        other.onErrorContainer,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      onInverseSurface: Color.lerp(
        onInverseSurface,
        other.onInverseSurface,
        t,
      )!,
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!,
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
      approval: Color.lerp(approval, other.approval, t)!,
    );
  }

  static AppColorScheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorScheme>() ??
      _throwThemeExceptionFromFunc(context);
}

Never _throwThemeExceptionFromFunc(BuildContext context) =>
    throw Exception('$AppColorScheme not found in $context');
