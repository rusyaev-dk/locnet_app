import 'package:flutter/material.dart';

/// Small, consistent border radius scale (Telegram Desktop–like).
/// Prefer [defaultRadius] for most containers, inputs, menus.
@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii._({
    required this.small,
    required this.medium,
    required this.large,
    required this.defaultRadius,
  });

  factory AppRadii.standard() {
    return const AppRadii._(
      small: 4,
      medium: 6,
      large: 8,
      defaultRadius: 6,
    );
  }

  final double small;
  final double medium;
  final double large;
  final double defaultRadius;

  BorderRadius get smallRadius => BorderRadius.circular(small);
  BorderRadius get mediumRadius => BorderRadius.circular(medium);
  BorderRadius get largeRadius => BorderRadius.circular(large);
  BorderRadius get defaultRadiusValue => BorderRadius.circular(defaultRadius);

  @override
  AppRadii copyWith({
    double? small,
    double? medium,
    double? large,
    double? defaultRadius,
  }) {
    return AppRadii._(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
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
      defaultRadius: _lerp(defaultRadius, other.defaultRadius, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
