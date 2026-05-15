import 'package:flutter/material.dart';

/// Centralized spacing scale for layout and components.
/// Use these values instead of hardcoded numbers.
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing._({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  factory AppSpacing.standard() {
    return const AppSpacing._(
      xxs: 4,
      xs: 8,
      sm: 12,
      md: 16,
      lg: 20,
      xl: 24,
      xxl: 32,
    );
  }

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  AppSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing._(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  ThemeExtension<AppSpacing> lerp(
    ThemeExtension<AppSpacing>? other,
    double t,
  ) {
    if (other is! AppSpacing) return this;
    return AppSpacing._(
      xxs: _lerp(xxs, other.xxs, t),
      xs: _lerp(xs, other.xs, t),
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      xl: _lerp(xl, other.xl, t),
      xxl: _lerp(xxl, other.xxl, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
