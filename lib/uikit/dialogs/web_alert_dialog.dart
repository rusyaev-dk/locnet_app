import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';
import 'package:go_router/go_router.dart';

class WebAlertDialog extends StatelessWidget {
  const WebAlertDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
    super.key,
    this.cancelText,
    this.isDestructiveConfirm = false,
  });

  final String title;
  final String content;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final bool isDestructiveConfirm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final textScheme = AppTextScheme.of(context);

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        title,
        style: textScheme.label.copyWith(
          fontSize: 21,
          color: colorScheme.onSurface,
        ),
      ),
      content: Text(
        content,
        style: textScheme.label.copyWith(
          fontSize: 17,
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: Text(
              cancelText!,
              style: textScheme.label.copyWith(
                fontSize: 17,
                color: colorScheme.primary,
              ),
            ),
          ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmText,
            style: textScheme.label.copyWith(
              fontSize: 17,
              color: isDestructiveConfirm
                  ? colorScheme.error
                  : colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
