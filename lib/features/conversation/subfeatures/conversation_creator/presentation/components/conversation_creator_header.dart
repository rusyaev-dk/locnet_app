import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Matches [SettingsModalCard] chrome: bottom border + title + close control.
class ConversationCreatorHeader extends StatelessWidget {
  const ConversationCreatorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.conversationCreating,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
          ),
          SurfaceIconButton(
            icon: Icons.close,
            dimension: 32,
            iconSize: 14,
            margin: EdgeInsets.zero,
            foregroundColor: colorScheme.onSurfaceVariant,
            tooltip: l10n.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
