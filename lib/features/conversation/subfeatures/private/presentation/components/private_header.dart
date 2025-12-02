import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';

enum _PrivateHeaderMenuAction {
  toggleNotifications,
  blockCompanion,
  deleteConversation,
}

class PrivateHeader extends StatefulWidget {
  const PrivateHeader({super.key});

  @override
  State<PrivateHeader> createState() => _PrivateHeaderState();
}

class _PrivateHeaderState extends State<PrivateHeader> {
  bool areNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    // Пока оставляю заглушку, как у тебя в примере.
    const conversationId = 'test';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: colorScheme.surfaceBright,
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
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
                Text(
                  'Conversation $conversationId',
                  style: textScheme.headline.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('online', style: textScheme.label),
              ],
            ),
          ),
          PopupMenuButton<_PrivateHeaderMenuAction>(
            icon: const Icon(Icons.more_vert),
            color: colorScheme.surfaceBright,
            onSelected: (action) async {
              final cubit = context.read<PrivateConversationOptionsCubit>();

              switch (action) {
                case _PrivateHeaderMenuAction.toggleNotifications:
                  setState(() {
                    areNotificationsEnabled = !areNotificationsEnabled;
                  });

                  await cubit.toggleNotifications(
                    newStatus: areNotificationsEnabled,
                  );
                  break;

                case _PrivateHeaderMenuAction.blockCompanion:
                  await cubit.blockCompanion();
                  break;

                case _PrivateHeaderMenuAction.deleteConversation:
                  await cubit.deleteConversation();
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: _PrivateHeaderMenuAction.toggleNotifications,
                  child: Text(
                    areNotificationsEnabled
                        ? l10n.toggleNotificationsOff
                        : l10n.toggleNotificationsOn,
                  ),
                ),
                PopupMenuItem(
                  value: _PrivateHeaderMenuAction.blockCompanion,
                  child: Text(l10n.blockCompanion),
                ),
                PopupMenuItem(
                  value: _PrivateHeaderMenuAction.deleteConversation,
                  child: Text(l10n.deleteConversation),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
