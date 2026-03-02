import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
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
    this.maxSymbols,
    this.height,
    this.expandable = false,
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
  final int? maxSymbols;

  final double? height;
  final bool expandable;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final radii = context.radii;
    final borders = context.borders;

    final BorderRadius resolvedBorderRadius =
        borderRadius ?? radii.defaultRadiusValue;

    final Color resolvedBackgroundColor =
        backgroundColor ?? colorScheme.surface;

    final EdgeInsetsGeometry resolvedContentPadding =
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    final List<TextInputFormatter> inputFormatters = maxSymbols != null
        ? <TextInputFormatter>[LengthLimitingTextInputFormatter(maxSymbols)]
        : const <TextInputFormatter>[];

    final bool isExpandable = expandable && !obscureText;

    final TextField textField = TextField(
      controller: controller,
      enabled: enabled,
      readOnly: !isActive,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: obscureText ? 1 : (isExpandable ? null : maxLines),
      minLines: obscureText ? 1 : (isExpandable ? (minLines ?? 1) : minLines),
      maxLength: maxSymbols,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: maxSymbols != null
          ? (
              BuildContext buildContext, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) {
              final bool isLimitExceeded = currentLength > maxSymbols!;
              final TextStyle counterTextStyle = textScheme.label.copyWith(
                color: isLimitExceeded
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant.withAlpha(179),
              );

              return Text(
                '$currentLength/$maxSymbols',
                style: counterTextStyle,
              );
            }
          : null,
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
          textStyle ?? textScheme.body.copyWith(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        labelStyle:
            labelStyle ??
            textScheme.subtitle.copyWith(color: colorScheme.onSurfaceVariant),
        hintStyle:
            hintStyle ??
            textScheme.body.copyWith(
              color: colorScheme.onSurfaceVariant.withAlpha(179),
            ),
        filled: true,
        fillColor: resolvedBackgroundColor,
        contentPadding: resolvedContentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(color: colorScheme.error, width: borders.thin),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: borders.medium,
          ),
        ),
      ),
    );

    Widget child = textField;

    if (height != null) {
      if (isExpandable) {
        child = ConstrainedBox(
          constraints: BoxConstraints(minHeight: height!),
          child: textField,
        );
      } else {
        child = SizedBox(height: height, child: textField);
      }
    }

    if (onFocusChange == null) {
      return child;
    }

    return Focus(
      onFocusChange: (bool hasFocus) {
        if (!hasFocus) {
          onFocusChange!(controller.text);
        }
      },
      skipTraversal: true,
      child: child,
    );
  }
}
