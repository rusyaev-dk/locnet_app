import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class ConversationCreatorHeader extends StatelessWidget {
  const ConversationCreatorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.conversationCreating,
              style: textScheme.headline.copyWith(color: colorScheme.onSurface),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}