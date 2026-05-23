import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/uikit/uikit.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    required this.text,
    super.key,
    this.icon,
    this.iconAnimationEffect,
    this.buttonText,
    this.onButtonPressed,
    this.useErrorStyle = false,
  });

  final String text;
  final IconData? icon;
  final Effect? iconAnimationEffect;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool useErrorStyle;

  @override
  Widget build(BuildContext context) {
    assert(
      (buttonText != null && onButtonPressed != null) ||
          (buttonText == null && onButtonPressed == null),
      'buttonText and onButtonPressed must be provided together or not at all.',
    );

    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final spacing = context.designTokens.spacing;

    final bool showIcon = !useErrorStyle && icon != null;

    final Widget? iconWidget = showIcon
        ? ConditionalWrapper(
            condition: iconAnimationEffect != null,
            child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 28),
            wrapper: (child) =>
                Animate(effects: [iconAnimationEffect!], child: child),
          )
        : null;

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconWidget != null) ...[
              iconWidget,
              SizedBox(height: spacing.xs),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: textScheme.subtitle.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: spacing.md),
              AppPrimaryButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
