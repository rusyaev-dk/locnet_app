import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';
import 'package:go_router/go_router.dart';

class PopScreenButton extends StatelessWidget {
  const PopScreenButton({
    super.key,
    this.onPressed,
    this.callback,
    this.icon,
    this.iconColor,
    this.iconSize,
  });

  final void Function()? onPressed;
  final void Function()? callback;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final isCupertino =
        !kIsWeb &&
        (Theme.of(context).platform == TargetPlatform.iOS ||
            Theme.of(context).platform == TargetPlatform.macOS);

    final buttonIcon = Icon(
      icon ??
          (isCupertino
              ? Icons.arrow_back_ios_new_rounded
              : Icons.arrow_back_rounded),
      color: iconColor ?? colorScheme.onSurface,
      size: iconSize,
    );

    return isCupertino
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed ?? () => _defaultBtnAction(context),
            child: buttonIcon,
          )
        : IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed ?? () => _defaultBtnAction(context),
            icon: buttonIcon,
          );
  }

  void _defaultBtnAction(BuildContext context) {
    GoRouter.of(context).pop();
    if (callback != null) {
      callback!();
    }
  }
}

class PopScreenButtonCirlced extends StatelessWidget {
  const PopScreenButtonCirlced({
    required this.diameter,
    super.key,
    this.onPressed,
    this.callback,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
  });

  final void Function()? onPressed;
  final void Function()? callback;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final double diameter;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);

    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(diameter / 2),
      ),
      child: PopScreenButton(
        onPressed: onPressed,
        callback: callback,
        icon: icon,
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }
}
