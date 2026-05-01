import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale for the Locnet Messenger design system.
///
/// The [value] of each enum member is a plain [TextStyle] with size/weight/height.
/// The DM Sans font family is applied by [AppTextScheme.base] at construction time
/// via [GoogleFonts.dmSans], so enums can remain `const`-compatible.
enum AppTextStyle {
  displayLarge(TextStyle(fontSize: 57, fontWeight: FontWeight.w300, height: 1.2)),
  displayMedium(TextStyle(fontSize: 45, fontWeight: FontWeight.w300, height: 1.15)),
  displaySmall(TextStyle(fontSize: 36, fontWeight: FontWeight.w400, height: 1.1)),
  headlineLarge(TextStyle(fontSize: 32, fontWeight: FontWeight.w600, height: 1.1)),
  headlineMedium(TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 1.1)),
  headlineSmall(TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.1)),
  titleLarge(TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.1)),
  titleMedium(TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.1)),
  titleSmall(TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.1)),
  labelLarge(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.1)),
  labelMedium(TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.15)),
  labelSmall(TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.1)),
  bodyLarge(TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5)),
  bodyMedium(TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5)),
  bodySmall(TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5));

  final TextStyle value;

  // ignore: sort_constructors_first
  const AppTextStyle(this.value);

  /// Returns the style with DM Sans applied.
  TextStyle get dmSans => GoogleFonts.dmSans(textStyle: value);
}

/// Returns a DM Mono [TextStyle] for monospace usage (badges, timestamps, code).
TextStyle dmMono({
  double fontSize = 11,
  FontWeight fontWeight = FontWeight.w400,
  double height = 1.2,
  Color? color,
}) =>
    GoogleFonts.dmMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
