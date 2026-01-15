import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class AppAlertDialogAction extends StatelessWidget {
  const AppAlertDialogAction({
    required this.child,
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.style,
    super.key,
  });

  /// Action widget.
  ///
  /// Usually [Text].
  final Widget child;

  final VoidCallback onPressed;

  /// Only for iOS.
  final bool isDefaultAction;

  /// Only for iOS.
  final bool isDestructiveAction;

  /// Only for Android (Material).
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    // Safe platform check that works on all targets, including Web.
    final bool shouldUseCupertino =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    if (shouldUseCupertino) {
      return CupertinoDialogAction(
        onPressed: onPressed,
        isDefaultAction: isDefaultAction,
        isDestructiveAction: isDestructiveAction,
        child: child,
      );
    }

    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return TextButton(
      onPressed: onPressed,
      style:
          style ??
          TextButton.styleFrom(
            textStyle: textScheme.label.copyWith(
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
      child: child,
    );
  }
}
