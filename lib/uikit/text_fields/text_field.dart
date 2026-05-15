import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/tokens/app_spacing.dart';

/// Text field aligned with [AppThemeData] input decoration: outlined surface,
/// `outlineVariant` / `primary` borders, [AppBorders] widths, [AppSpacing] padding.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    super.key,
    this.focusNode,
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
    this.extraInputFormatters,
  });

  final TextEditingController controller;

  final FocusNode? focusNode;

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

  /// Merged before the optional [maxSymbols] length limit.
  final List<TextInputFormatter>? extraInputFormatters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final radii = context.radii;
    final borders = context.borders;
    final spacing =
        Theme.of(context).extension<AppSpacing>() ?? AppSpacing.standard();

    final BorderRadius resolvedBorderRadius =
        borderRadius ?? radii.defaultRadiusValue;

    final bool chromeEnabled = enabled && isActive;

    final Color resolvedBackgroundColor =
        backgroundColor ??
        (chromeEnabled
            ? colorScheme.surface
            : colorScheme.surfaceContainerHigh);

    final Color resolvedBorder = borderColor ?? colorScheme.outlineVariant;
    final Color resolvedFocusedBorder =
        focusedBorderColor ?? colorScheme.primary;

    final EdgeInsetsGeometry resolvedContentPadding =
        contentPadding ??
        EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: (maxLines > 1 || expandable) ? spacing.sm : 14,
        );

    final List<TextInputFormatter> inputFormatters = <TextInputFormatter>[
      ...?extraInputFormatters,
      if (maxSymbols != null) LengthLimitingTextInputFormatter(maxSymbols!),
    ];

    final bool isExpandable = expandable && !obscureText;

    final TextStyle resolvedLabelStyle =
        labelStyle ??
        textScheme.label.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        );

    final WidgetStateTextStyle floatingLabelStyle =
        WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          final TextStyle base = textScheme.label.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          );
          if (states.contains(WidgetState.error)) {
            return base.copyWith(color: colorScheme.error);
          }
          if (states.contains(WidgetState.focused)) {
            return base.copyWith(color: resolvedFocusedBorder);
          }
          return base.copyWith(color: colorScheme.onSurfaceVariant);
        });

    final TextStyle resolvedHintStyle =
        hintStyle ??
        textScheme.body.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
          height: 1.25,
        );

    final OutlineInputBorder outlineBase = OutlineInputBorder(
      borderRadius: resolvedBorderRadius,
      borderSide: BorderSide(color: resolvedBorder, width: borders.thin),
    );

    final OutlineInputBorder outlineFocused = OutlineInputBorder(
      borderRadius: resolvedBorderRadius,
      borderSide: BorderSide(
        color: resolvedFocusedBorder,
        width: borders.medium,
      ),
    );

    final OutlineInputBorder outlineError = OutlineInputBorder(
      borderRadius: resolvedBorderRadius,
      borderSide: BorderSide(color: colorScheme.error, width: borders.thin),
    );

    final OutlineInputBorder outlineErrorFocused = OutlineInputBorder(
      borderRadius: resolvedBorderRadius,
      borderSide: BorderSide(color: colorScheme.error, width: borders.medium),
    );

    final TextField textField = TextField(
      controller: controller,
      focusNode: focusNode,
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
              final TextStyle counterTextStyle = textScheme.caption.copyWith(
                color: isLimitExceeded
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
              );

              return Padding(
                padding: EdgeInsets.only(top: spacing.xxs),
                child: Text(
                  '$currentLength/$maxSymbols',
                  style: counterTextStyle,
                ),
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
          textStyle ??
          textScheme.body.copyWith(
            color: chromeEnabled
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontSize: 15,
            height: 1.25,
          ),
      decoration: InputDecoration(
        isDense: false,
        filled: true,
        fillColor: resolvedBackgroundColor,
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: floatingLabelStyle,
        labelStyle: resolvedLabelStyle,
        hintStyle: resolvedHintStyle,
        helperStyle: textScheme.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.35,
        ),
        errorStyle: textScheme.caption.copyWith(
          color: colorScheme.error,
          height: 1.35,
        ),
        contentPadding: resolvedContentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: outlineBase,
        focusedBorder: outlineFocused,
        disabledBorder: OutlineInputBorder(
          borderRadius: resolvedBorderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            width: borders.thin,
          ),
        ),
        border: outlineBase,
        errorBorder: outlineError,
        focusedErrorBorder: outlineErrorFocused,
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
