import 'package:flutter/material.dart';

/// Border widths for dividers and outlines (e.g. 1px typical).
@immutable
class AppBorders extends ThemeExtension<AppBorders> {
  const AppBorders._({
    required this.thin,
    required this.medium,
  });

  factory AppBorders.standard() {
    return const AppBorders._(
      thin: 1.0,
      medium: 1.5,
    );
  }

  final double thin;
  final double medium;

  @override
  AppBorders copyWith({
    double? thin,
    double? medium,
  }) {
    return AppBorders._(
      thin: thin ?? this.thin,
      medium: medium ?? this.medium,
    );
  }

  @override
  ThemeExtension<AppBorders> lerp(
    ThemeExtension<AppBorders>? other,
    double t,
  ) {
    if (other is! AppBorders) return this;
    return AppBorders._(
      thin: thin + (other.thin - thin) * t,
      medium: medium + (other.medium - medium) * t,
    );
  }
}
