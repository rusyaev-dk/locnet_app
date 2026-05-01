import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/presentation/modals/channel_info_modal_card.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/conversation_tools.dart';

enum _ChannelHeaderMenuAction {
  toggleNotifications,
  viewChannelInfo,
  leaveChannel,
}

class ChannelHeader extends StatefulWidget {
  const ChannelHeader({
    required this.conversationId,
    required this.conversation,
    required this.subscribersCount,
    super.key,
  });

  final String conversationId;
  final Channel conversation;
  final int subscribersCount;

  @override
  State<ChannelHeader> createState() => _ChannelHeaderState();
}

class _ChannelHeaderState extends State<ChannelHeader> {
  bool areNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String subtitle = l10n.channelSubscribersCount(
      widget.subscribersCount.toString(),
    );

    return ConversationProfileHeaderBase(
      title: widget.conversation.title,
      avatarText: widget.conversation.title,
      subtitle: subtitle,
      onTap: () {
        showGeneralDialog(
          context: context,
          transitionBuilder: slideFadeDialogTransition,
          pageBuilder: (context, _, _) {
            return ChannelInfoModalCard(conversation: widget.conversation);
          },
        );
      },
      trailingActions: [
        _HeaderIconButton(
          icon: Icons.search,
          onPressed: () {
            showConversationSearchSheet(
              context: context,
              conversationId: widget.conversationId,
              conversationType: ConversationType.channel,
            );
          },
        ),
        _HeaderIconButton(
          icon: Icons.photo_outlined,
          onPressed: () {
            showConversationSharedMediaSheet(
              context: context,
              conversationId: widget.conversationId,
              conversationType: ConversationType.channel,
            );
          },
        ),
      ],
      menuButton: PopupMenuButton<_ChannelHeaderMenuAction>(
        icon: const Icon(Icons.more_vert),
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
                    ? l10n.toggleNotificationsOff
                    : l10n.toggleNotificationsOn,
              ),
            ),
            PopupMenuItem(
              value: _ChannelHeaderMenuAction.viewChannelInfo,
              child: Text(l10n.channelMenuViewInfo),
            ),
            PopupMenuItem(
              value: _ChannelHeaderMenuAction.leaveChannel,
              child: Text(l10n.channelMenuLeave),
            ),
          ];
        },
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        tooltip: null,
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        onPressed: onPressed,
        icon: Icon(icon, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
