import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Icon button with small radius (Telegram-like); supports tooltip for desktop.
class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.buttonSize = 32,
    this.iconSize = 20,
  });

  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? buttonSize;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final radii = context.radii;
    final br = borderRadius ?? radii.defaultRadiusValue;

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: br,
        child: Container(
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: br,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: foregroundColor ?? colorScheme.onSurface,
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    return button;
  }
}
