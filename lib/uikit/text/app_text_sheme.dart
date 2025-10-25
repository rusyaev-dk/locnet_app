import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

class AppTextScheme extends ThemeExtension<AppTextScheme> {
  AppTextScheme.base()
    : display = AppTextStyle.displaySmall.value,
      headline = AppTextStyle.headlineSmall.value,
      label = AppTextStyle.labelMedium.value;

  const AppTextScheme._({
    required this.display,
    required this.headline,
    required this.label,
  });
  final TextStyle display;
  final TextStyle headline;
  final TextStyle label;

  @override
  ThemeExtension<AppTextScheme> lerp(
    ThemeExtension<AppTextScheme>? other,
    double t,
  ) {
    if (other is! AppTextScheme) {
      return this;
    }

    return AppTextScheme._(
      display: TextStyle.lerp(display, other.display, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
    );
  }

  @override
  AppTextScheme copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? label,
  }) {
    return AppTextScheme._(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      label: label ?? this.label,
    );
  }

  static AppTextScheme of(BuildContext context) {
    return Theme.of(context).extension<AppTextScheme>() ??
        _throwThemeExceptionFromFunc(context);
  }
}

Never _throwThemeExceptionFromFunc(BuildContext context) =>
    throw Exception('$AppTextScheme not found in $context');
