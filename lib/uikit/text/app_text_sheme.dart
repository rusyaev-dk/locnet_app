import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Typography hierarchy: title, subtitle, body, caption (desktop-compact).
class AppTextScheme extends ThemeExtension<AppTextScheme> {
  AppTextScheme.base()
    : display = AppTextStyle.displaySmall.value,
      headline = AppTextStyle.headlineSmall.value,
      title = AppTextStyle.titleMedium.value,
      subtitle = AppTextStyle.titleSmall.value,
      body = AppTextStyle.bodyMedium.value,
      label = AppTextStyle.labelMedium.value,
      caption = AppTextStyle.labelSmall.value;

  const AppTextScheme._({
    required this.display,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.label,
    required this.caption,
  });
  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;

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
      title: TextStyle.lerp(title, other.title, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }

  @override
  AppTextScheme copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return AppTextScheme._(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  static AppTextScheme of(BuildContext context) {
    return Theme.of(context).extension<AppTextScheme>() ??
        _throwThemeExceptionFromFunc(context);
  }
}

Never _throwThemeExceptionFromFunc(BuildContext context) =>
    throw Exception('$AppTextScheme not found in $context');
