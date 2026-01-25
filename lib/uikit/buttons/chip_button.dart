import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class ChipButton extends StatelessWidget {
  const ChipButton({
    required this.onPressed,
    this.label,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.height,
    this.textStyle,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    super.key,
  });

  final String? label;
  final VoidCallback onPressed;

  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? height;

  final TextStyle? textStyle;
  final Color? textColor;

  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadius.circular(14);

    final bool hasLabel = label != null;

    final EdgeInsetsGeometry resolvedPadding =
        padding ?? EdgeInsets.symmetric(horizontal: hasLabel ? 12 : 10);

    final Color resolvedBackground =
        backgroundColor ?? colorScheme.surfaceContainer;

    final Color resolvedTextColor = textColor ?? colorScheme.onSurfaceVariant;

    final TextStyle resolvedTextStyle =
        textStyle ?? textScheme.label.copyWith(color: resolvedTextColor);

    final Color? resolvedBorderColor = borderColor;
    final double resolvedBorderWidth = borderWidth ?? 1;

    return SizedBox(
      height: height ?? 32,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: resolvedPadding,
          minimumSize: const Size(0, 0),
          backgroundColor: resolvedBackground,
          shape: RoundedRectangleBorder(
            borderRadius: resolvedBorderRadius,
            side: resolvedBorderColor != null
                ? BorderSide(
                    color: resolvedBorderColor,
                    width: resolvedBorderWidth,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize ?? 16,
                color: iconColor ?? resolvedTextColor,
              ),
            if (icon != null && hasLabel) const SizedBox(width: 6),
            if (hasLabel) Text(label!, style: resolvedTextStyle),
          ],
        ),
      ),
    );
  }
}
