import 'package:flutter/material.dart';

/// Animation durations and curves for quick, subtle transitions (no bouncy).
@immutable
class AppMotion extends ThemeExtension<AppMotion> {
  const AppMotion._({
    required this.fast,
    required this.medium,
    required this.fastCurve,
    required this.mediumCurve,
  });

  factory AppMotion.standard() {
    return const AppMotion._(
      fast: Duration(milliseconds: 150),
      medium: Duration(milliseconds: 250),
      fastCurve: Curves.easeOut,
      mediumCurve: Curves.easeOutCubic,
    );
  }

  final Duration fast;
  final Duration medium;
  final Curve fastCurve;
  final Curve mediumCurve;

  @override
  AppMotion copyWith({
    Duration? fast,
    Duration? medium,
    Curve? fastCurve,
    Curve? mediumCurve,
  }) {
    return AppMotion._(
      fast: fast ?? this.fast,
      medium: medium ?? this.medium,
      fastCurve: fastCurve ?? this.fastCurve,
      mediumCurve: mediumCurve ?? this.mediumCurve,
    );
  }

  @override
  ThemeExtension<AppMotion> lerp(
    ThemeExtension<AppMotion>? other,
    double t,
  ) {
    if (other is! AppMotion) return this;
    return AppMotion._(
      fast: Duration(
        milliseconds: (fast.inMilliseconds + (other.fast.inMilliseconds - fast.inMilliseconds) * t).round(),
      ),
      medium: Duration(
        milliseconds: (medium.inMilliseconds + (other.medium.inMilliseconds - medium.inMilliseconds) * t).round(),
      ),
      fastCurve: t < 0.5 ? fastCurve : other.fastCurve,
      mediumCurve: t < 0.5 ? mediumCurve : other.mediumCurve,
    );
  }
}
