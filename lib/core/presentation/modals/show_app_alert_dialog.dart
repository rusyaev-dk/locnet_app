import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/navigation/transitions.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Application alert dialog with [slideFadeDialogTransition] and themed barrier.
Future<T?> showAppAlertDialog<T>({
  required BuildContext context,
  required List<AppAlertDialogAction> Function(BuildContext dialogContext)
      buildActions,
  Widget? title,
  Widget? content,
  bool barrierDismissible = true,
}) {
  final colorScheme = context.colorScheme;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.45),
    transitionBuilder: slideFadeDialogTransition,
    pageBuilder: (dialogContext, _, _) {
      return AppAlertDialog(
        title: title,
        content: content,
        actions: buildActions(dialogContext),
      );
    },
  );
}
