import 'package:flutter/material.dart';

/// Border radius scale for the Locnet Messenger design system.
///
/// Scale mapping from the HTML prototype:
///   small  = 6  px — badges, small chips
///   medium = 8  px — buttons, inputs, setting rows
///   large  = 12 px — chat input container, conversation tiles
///   xl     = 16 px — modal sheets, profile cards
///   default = large (12 px) used for most containers
@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii._({
    required this.small,
    required this.medium,
    required this.large,
    required this.xl,
    required this.defaultRadius,
  });

  factory AppRadii.standard() {
    return const AppRadii._(
      small: 6,
      medium: 8,
      large: 12,
      xl: 16,
      defaultRadius: 8,
    );
  }

  final double small;
  final double medium;
  final double large;
  final double xl;
  final double defaultRadius;

  BorderRadius get smallRadius => BorderRadius.circular(small);
  BorderRadius get mediumRadius => BorderRadius.circular(medium);
  BorderRadius get largeRadius => BorderRadius.circular(large);
  BorderRadius get xlRadius => BorderRadius.circular(xl);
  BorderRadius get defaultRadiusValue => BorderRadius.circular(defaultRadius);

  @override
  AppRadii copyWith({
    double? small,
    double? medium,
    double? large,
    double? xl,
    double? defaultRadius,
  }) {
    return AppRadii._(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xl: xl ?? this.xl,
      defaultRadius: defaultRadius ?? this.defaultRadius,
    );
  }

  @override
  ThemeExtension<AppRadii> lerp(
    ThemeExtension<AppRadii>? other,
    double t,
  ) {
    if (other is! AppRadii) return this;
    return AppRadii._(
      small: _lerp(small, other.small, t),
      medium: _lerp(medium, other.medium, t),
      large: _lerp(large, other.large, t),
      xl: _lerp(xl, other.xl, t),
      defaultRadius: _lerp(defaultRadius, other.defaultRadius, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
