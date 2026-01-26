import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/presentation/modals/channel_info_modal_card.dart';

enum _ChannelHeaderMenuAction {
  toggleNotifications,
  viewChannelInfo,
  leaveChannel,
}

class ChannelHeader extends StatefulWidget {
  const ChannelHeader({
    required this.conversation,
    required this.subscribersCount,
    super.key,
  });

  final Conversation conversation;
  final int subscribersCount;

  @override
  State<ChannelHeader> createState() => _ChannelHeaderState();
}

class _ChannelHeaderState extends State<ChannelHeader> {
  bool areNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showGeneralDialog(
            context: context,
            transitionBuilder: slideFadeDialogTransition,
            pageBuilder: (context, _, _) {
              return ChannelInfoModalCard(
                conversation: widget.conversation,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: colorScheme.surfaceBright,
          child: Row(
            children: [
              ConversationAvatar(
                text: widget.conversation.title,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.conversation.title,
                      style: textScheme.headline.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${widget.subscribersCount} subscribers',
                      style: textScheme.label,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_ChannelHeaderMenuAction>(
                icon: const Icon(Icons.more_vert),
                color: colorScheme.surfaceBright,
                onSelected: (action) async {
                  switch (action) {
                    case _ChannelHeaderMenuAction.toggleNotifications:
                      setState(() {
                        areNotificationsEnabled = !areNotificationsEnabled;
                      });
                      break;

                    case _ChannelHeaderMenuAction.viewChannelInfo:
                      // Already handled by onTap
                      break;

                    case _ChannelHeaderMenuAction.leaveChannel:
                      // TODO: Implement leave channel
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: _ChannelHeaderMenuAction.toggleNotifications,
                      child: Text(
                        areNotificationsEnabled
                            ? 'Mute'
                            : 'Unmute',
                      ),
                    ),
                    PopupMenuItem(
                      value: _ChannelHeaderMenuAction.viewChannelInfo,
                      child: const Text('View Channel Info'),
                    ),
                    PopupMenuItem(
                      value: _ChannelHeaderMenuAction.leaveChannel,
                      child: const Text('Leave Channel'),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
