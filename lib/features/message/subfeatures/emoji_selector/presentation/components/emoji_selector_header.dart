import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class EmojiSelectorHeader extends StatelessWidget {
  const EmojiSelectorHeader({
    required this.controller,
    required this.onClose,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 22,
            color: colorScheme.onSurfaceVariant.withAlpha(160),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 36,
              child: Center(
                child: TextField(
                  controller: controller,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintText: '${l10n.searchEmoji}...',
                    hintStyle: textScheme.label.copyWith(
                      color: colorScheme.onSurfaceVariant.withAlpha(160),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          RoundedIconButton(
            icon: Icons.close,
            onPressed: onClose,
            buttonSize: 33,
            iconSize: 20,
            foregroundColor: colorScheme.onSurfaceVariant.withAlpha(160),
          ),
        ],
      ),
    );
  }
}
