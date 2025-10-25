import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    required this.text,
    super.key,
    this.icon,
    this.iconAnimationEffect,
    this.buttonText,
    this.onButtonPressed,
  });

  final String text;
  final IconData? icon;
  final Effect? iconAnimationEffect;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    assert(
      (buttonText != null && onButtonPressed != null) ||
          (buttonText == null && onButtonPressed == null),
      'buttonText and onButtonPressed must be either provided both or none of them.',
    );

    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Widget iconWidget = Icon(
      icon,
      color: colorScheme.surfaceDim.withAlpha(170),
      size: 65,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConditionalWrapper(
              condition: iconAnimationEffect != null,
              child: iconWidget,
              wrapper: (child) =>
                  Animate(effects: [iconAnimationEffect!], child: child),
            ),
            const SizedBox(height: 20),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textScheme.headline.copyWith(
                color: colorScheme.surfaceDim.withAlpha(170),
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onButtonPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  foregroundColor: colorScheme.primary,
                  textStyle: textScheme.headline.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
