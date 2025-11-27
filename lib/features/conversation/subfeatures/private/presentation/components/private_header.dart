import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class PrivateHeader extends StatelessWidget {
  const PrivateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    const conversationId = "test";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: colorScheme.surface,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colorScheme.primary.withAlpha(40),
            child: Text(
              conversationId.isNotEmpty ? conversationId[0].toUpperCase() : '?',
              style: textScheme.label,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Здесь позже можно подставить имя собеседника из Conversation.
                Text(
                  'Conversation $conversationId',
                  style: textScheme.headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('online', style: textScheme.label),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: open conversation menu.
            },
          ),
        ],
      ),
    );
  }
}
