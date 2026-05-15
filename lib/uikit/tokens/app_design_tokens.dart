import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/tokens/app_borders.dart';
import 'package:locnet_app/uikit/tokens/app_motion.dart';
import 'package:locnet_app/uikit/tokens/app_radii.dart';
import 'package:locnet_app/uikit/tokens/app_spacing.dart';

/// Combined design tokens for layout and components.
/// Access via Theme.of(context).extension\<AppSpacing\>() etc., or use context extensions.
@immutable
class AppDesignTokens extends ThemeExtension<AppDesignTokens> {
  const AppDesignTokens._({
    required this.spacing,
    required this.radii,
    required this.motion,
    required this.borders,
  });

  factory AppDesignTokens.standard() {
    return AppDesignTokens._(
      spacing: AppSpacing.standard(),
      radii: AppRadii.standard(),
      motion: AppMotion.standard(),
      borders: AppBorders.standard(),
    );
  }

  final AppSpacing spacing;
  final AppRadii radii;
  final AppMotion motion;
  final AppBorders borders;

  @override
  AppDesignTokens copyWith({
    AppSpacing? spacing,
    AppRadii? radii,
    AppMotion? motion,
    AppBorders? borders,
  }) {
    return AppDesignTokens._(
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      motion: motion ?? this.motion,
      borders: borders ?? this.borders,
    );
  }

  @override
  ThemeExtension<AppDesignTokens> lerp(
    ThemeExtension<AppDesignTokens>? other,
    double t,
  ) {
    if (other is! AppDesignTokens) return this;
    return AppDesignTokens._(
      spacing: spacing.lerp(other.spacing, t) as AppSpacing,
      radii: radii.lerp(other.radii, t) as AppRadii,
      motion: motion.lerp(other.motion, t) as AppMotion,
      borders: borders.lerp(other.borders, t) as AppBorders,
    );
  }

  /// Returns design tokens from the nearest [Theme]; fallback to [standard] if not set.
  static AppDesignTokens of(BuildContext context) {
    return Theme.of(context).extension<AppDesignTokens>() ??
        AppDesignTokens.standard();
  }
}
