import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

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
    this.height = 46,
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
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final textScheme = AppTextScheme.of(context);

    final Color background = !isActive
        ? colorScheme.outline
        : (buttonColor ?? colorScheme.primary);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: colorScheme.outline,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
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
                      textColor ?? colorScheme.surface,
                    ),
                  ),
                )
              : Text(
                  key: const ValueKey('text'),
                  text,
                  textAlign: TextAlign.center,
                  style: textScheme.label.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? colorScheme.surface,
                  ),
                ),
        ),
      ),
    );
  }
}
