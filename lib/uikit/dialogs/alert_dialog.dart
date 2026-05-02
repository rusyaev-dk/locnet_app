import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/dialogs/alert_dialog_action.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.actions,
    super.key,
    this.title,
    this.content,
  });

  final List<AppAlertDialogAction> actions;
  final Widget? title;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final List<Widget> builtActions = actions
        .map((AppAlertDialogAction action) => action.build(context))
        .toList();

    final bool shouldUseCupertino =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    if (shouldUseCupertino) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: builtActions,
      );
    }

    return _AppMaterialAlertDialog(
      title: title,
      content: content,
      actions: builtActions,
    );
  }
}

class _AppMaterialAlertDialog extends StatelessWidget {
  const _AppMaterialAlertDialog({
    required this.actions,
    this.title,
    this.content,
  });

  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final radii = context.radii;
    final brightness = Theme.of(context).brightness;

    final Color background = brightness == Brightness.dark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surface;
    final Color borderColor = brightness == Brightness.dark
        ? colorScheme.outline
        : colorScheme.outlineVariant;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: radii.xlRadius,
            side: BorderSide(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 16, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style: textScheme.headline.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    child: title!,
                  ),
                if (title != null && content != null) const SizedBox(height: 12),
                if (content != null)
                  DefaultTextStyle(
                    style: textScheme.body.copyWith(
                      fontSize: 14,
                      height: 1.45,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    child: content!,
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 4,
                    runSpacing: 4,
                    children: actions,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
