import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isActive = true,
    this.buttonColor,
    this.textColor,
    this.borderRadius,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isActive;
  final Color? buttonColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final textScheme = AppTextScheme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          backgroundColor: !isActive
              ? colorScheme.outline
              : (buttonColor ?? colorScheme.primary),
        ),
        onPressed: (isLoading || !isActive) ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: textScheme.label.copyWith(
                  fontSize: 20,
                  color: textColor ?? colorScheme.surface,
                ),
              ),
      ),
    );
  }
}
