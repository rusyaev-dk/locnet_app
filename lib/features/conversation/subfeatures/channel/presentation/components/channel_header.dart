import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/conversation_tools.dart';
import 'package:locnet_app/uikit/uikit.dart';

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
      avatarOverride: Avatar.channel(channel: widget.conversation, size: 38),
      subtitle: subtitle,
      onTap: () {
        showGeneralDialog(
          context: context,
          transitionBuilder: slideFadeDialogTransition,
          pageBuilder: (context, _, _) {
            return ChannelInfoModalCard(channel: widget.conversation);
          },
        );
      },
      trailingActions: [
        SurfaceIconButton(
          icon: Icons.search,
          onPressed: () {
            showConversationSearchSheet(
              context: context,
              conversationId: widget.conversationId,
              conversationType: ConversationType.channel,
            );
          },
        ),
        SurfaceIconButton(
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
        padding: EdgeInsets.zero,
        child: const Material(
          color: Colors.transparent,
          child: SurfaceIconShell(
            icon: Icons.more_vert,
            margin: EdgeInsets.only(left: 6),
          ),
        ),
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
