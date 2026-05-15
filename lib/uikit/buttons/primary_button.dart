import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Primary action button; uses design tokens (small radius, spacing).
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isActive = true,
    this.buttonColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isActive;
  final Color? buttonColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final radii = context.radii;

    final Color background = !isActive
        ? colorScheme.outline
        : (buttonColor ?? colorScheme.primary);

    final double buttonHeight = height ?? 40;

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: colorScheme.outline,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? radii.defaultRadiusValue,
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        onPressed: (isLoading || !isActive) ? null : onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loader'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  key: const ValueKey('text'),
                  text,
                  textAlign: TextAlign.center,
                  style: textScheme.title.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor ?? colorScheme.onPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
