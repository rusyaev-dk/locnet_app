import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    super.key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.isActive = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChange,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController controller;

  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final bool isActive;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final ValueChanged<String?>? onChanged;
  final ValueChanged<String?>? onSubmitted;
  final ValueChanged<String?>? onFocusChange;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final String? errorText;
  final String? helperText;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadius.circular(14);

    final Color resolvedBackgroundColor =
        backgroundColor ?? colorScheme.surface;

    final Color resolvedBorderColor = borderColor ?? colorScheme.outlineVariant;

    final Color resolvedFocusedBorderColor =
        focusedBorderColor ?? colorScheme.primary;

    final EdgeInsetsGeometry resolvedContentPadding =
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    final TextField textField = TextField(
      controller: controller,
      enabled: enabled,
      readOnly: !isActive,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      onChanged: isActive
          ? (String value) {
              if (onChanged == null) {
                return;
              }

              onChanged!(value);
            }
          : null,
      onSubmitted: isActive
          ? (String value) {
              if (onSubmitted == null) {
                return;
              }

              onSubmitted!(value);
            }
          : null,
      style:
          textStyle ??
          textScheme.label.copyWith(
            color: colorScheme.onSurface,
            fontSize: 16.5,
          ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        labelStyle:
            labelStyle ??
            textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
        hintStyle:
            hintStyle ??
            textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant.withAlpha(179),
            ),
        filled: true,
        fillColor: resolvedBackgroundColor,
        contentPadding: resolvedContentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(color: resolvedBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(color: resolvedFocusedBorderColor, width: 1.6),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(color: resolvedBorderColor.withAlpha(120)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
    );

    if (onFocusChange == null) {
      return textField;
    }

    return Focus(
      onFocusChange: (bool hasFocus) {
        if (!hasFocus) {
          onFocusChange!(controller.text);
        }
      },
      skipTraversal: true,
      child: textField,
    );
  }
}
