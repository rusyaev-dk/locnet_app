import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.iconSize,
    this.iconColor,
  });

  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? colorScheme.onSurface,
        ),
      );
    } else {
      return IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? colorScheme.onSurface,
        ),
      );
    }
  }
}

class CustomIconButtonCircled extends StatelessWidget {
  const CustomIconButtonCircled({
    required this.icon,
    required this.onPressed,
    required this.diameter,
    super.key,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback onPressed;
  final double diameter;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);

    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(diameter / 2),
      ),
      child: CustomIconButton(
        icon: icon,
        onPressed: onPressed,
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }
}
