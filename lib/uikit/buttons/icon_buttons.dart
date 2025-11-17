import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.buttonSize = 33,
    this.iconSize = 17,
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
    final borderRadius =
        this.borderRadius ?? BorderRadius.circular(buttonSize! / 2.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        borderRadius: borderRadius,
        child: Container(
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.secondary,
            borderRadius: borderRadius,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: foregroundColor ?? colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
