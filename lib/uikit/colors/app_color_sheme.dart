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
    : primary = const Color(0xFF2563EB), // blue-600
      onPrimary = const Color(0xFFFFFFFF),
      primaryContainer = const Color(0xFFDBEAFE), // blue-100
      onPrimaryContainer = const Color(0xFF0B1120),

      secondary = const Color(0xFF0EA5E9), // cyan-500
      onSecondary = const Color(0xFF001319),
      secondaryContainer = const Color(0xFFCFF5FF),
      onSecondaryContainer = const Color(0xFF022C3A),

      tertiary = const Color(0xFFF97316), // orange-500
      onTertiary = const Color(0xFF1F1304),
      tertiaryContainer = const Color(0xFFFFEDD5),
      onTertiaryContainer = const Color(0xFF451A03),

      error = const Color(0xFFDC2626), // red-600
      onError = const Color(0xFFFFFFFF),
      errorContainer = const Color(0xFFFEE2E2),
      onErrorContainer = const Color(0xFF450A0A),

      surface = const Color(0xFFF9FAFB), // slate-50
      onSurface = const Color(0xFF020617), // slate-950
      surfaceDim = const Color(0xFFE5E7EB), // gray-200
      surfaceBright = const Color(0xFFFFFFFF),
      surfaceContainerLowest = const Color(0xFFFFFFFF),
      surfaceContainerLow = const Color(0xFFF3F4F6), // gray-100
      surfaceContainer = const Color(0xFFE5E7EB),
      surfaceContainerHigh = const Color(0xFFD1D5DB), // gray-300
      surfaceContainerHighest = const Color(0xFFCBD5E1), // slate-300

      onSurfaceVariant = const Color(0xFF4B5563), // gray-600
      outline = const Color(0xFFCBD5E1),
      outlineVariant = const Color(0xFFE5E7EB),

      shadow = const Color(0xFF000000),
      scrim = const Color(0xFF020617),

      inverseSurface = const Color(0xFF020617),
      onInverseSurface = const Color(0xFFE5E7EB),
      inversePrimary = const Color(0xFF60A5FA), // blue-400

      surfaceTint = const Color(0xFF2563EB),
      shimmer = const Color(0xFFE5E7EB),

      approval = const Color(0xFF22C55E); // green-500

  const AppColorScheme.dark()
    : primary = const Color(0xFF60A5FA), // blue-400
      onPrimary = const Color(0xFF0B1120),
      primaryContainer = const Color(0xFF1D4ED8), // blue-700
      onPrimaryContainer = const Color(0xFFDBEAFE),

      secondary = const Color(0xFF38BDF8), // sky-400
      onSecondary = const Color(0xFF02131A),
      secondaryContainer = const Color(0xFF075985), // sky-800
      onSecondaryContainer = const Color(0xFFE0F2FE),

      tertiary = const Color(0xFFF97316),
      onTertiary = const Color(0xFF1F1304),
      tertiaryContainer = const Color(0xFF9A3412),
      onTertiaryContainer = const Color(0xFFFDE7C3),

      error = const Color(0xFFF97373),
      onError = const Color(0xFF450A0A),
      errorContainer = const Color(0xFF7F1D1D),
      onErrorContainer = const Color(0xFFFEE2E2),

      surface = const Color(0xFF020617), // slate-950
      onSurface = const Color(0xFFE5E7EB),
      surfaceDim = const Color(0xFF020617),
      surfaceBright = const Color(0xFF111827), // slate-900
      surfaceContainerLowest = const Color(0xFF000000),
      surfaceContainerLow = const Color(0xFF030712),
      surfaceContainer = const Color(0xFF020617),
      surfaceContainerHigh = const Color(0xFF111827),
      surfaceContainerHighest = const Color(0xFF1F2937), // slate-800

      onSurfaceVariant = const Color(0xFF9CA3AF), // gray-400
      outline = const Color(0xFF4B5563), // gray-600
      outlineVariant = const Color(0xFF1F2937),

      shadow = const Color(0xFF000000),
      scrim = const Color(0xFF000000),

      inverseSurface = const Color(0xFFF9FAFB),
      onInverseSurface = const Color(0xFF020617),
      inversePrimary = const Color(0xFF2563EB),

      surfaceTint = const Color(0xFF60A5FA),
      shimmer = const Color(0xFF374151), // slate-700

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
