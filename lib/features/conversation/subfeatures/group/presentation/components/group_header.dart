import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/conversation_tools.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/uikit/uikit.dart';

enum _GroupHeaderMenuAction {
  toggleNotifications,
  viewGroupInfo,
  leaveGroup,
  deleteGroup,
}

class GroupHeader extends StatefulWidget {
  const GroupHeader({
    required this.conversationId,
    required this.conversation,
    required this.participantsCount,
    super.key,
  });

  final String conversationId;
  final Group conversation;
  final int participantsCount;

  @override
  State<GroupHeader> createState() => _GroupHeaderState();
}

class _GroupHeaderState extends State<GroupHeader> {
  bool areNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final String subtitle = l10n.groupParticipantsCount(
      widget.participantsCount.toString(),
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
            return GroupInfoModalCard(conversation: widget.conversation);
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
              conversationType: ConversationType.group,
            );
          },
        ),
        SurfaceIconButton(
          icon: Icons.photo_outlined,
          onPressed: () {
            showConversationSharedMediaSheet(
              context: context,
              conversationId: widget.conversationId,
              conversationType: ConversationType.group,
            );
          },
        ),
      ],
      menuButton: PopupMenuButton<_GroupHeaderMenuAction>(
        padding: EdgeInsets.zero,
        child: const Material(
          color: Colors.transparent,
          child: SurfaceIconShell(
            icon: Icons.more_vert,
            margin: EdgeInsets.only(left: 6),
          ),
        ),
        onSelected: (action) async {
          // TODO: Implement GroupConversationOptionsCubit
          // final cubit = context.read<GroupConversationOptionsCubit>();

          switch (action) {
            case _GroupHeaderMenuAction.toggleNotifications:
              setState(() {
                areNotificationsEnabled = !areNotificationsEnabled;
              });

              // await cubit.toggleNotifications(
              //   newStatus: areNotificationsEnabled,
              // );
              break;

            case _GroupHeaderMenuAction.viewGroupInfo:
              // Already handled by onTap
              break;

            case _GroupHeaderMenuAction.leaveGroup:
              // await cubit.leaveGroup();
              break;

            case _GroupHeaderMenuAction.deleteGroup:
              // await cubit.deleteGroup();
              break;
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: _GroupHeaderMenuAction.toggleNotifications,
              child: Text(
                areNotificationsEnabled
                    ? l10n.toggleNotificationsOff
                    : l10n.toggleNotificationsOn,
              ),
            ),
            PopupMenuItem(
              value: _GroupHeaderMenuAction.viewGroupInfo,
              child: Text(l10n.groupMenuViewInfo),
            ),
            PopupMenuItem(
              value: _GroupHeaderMenuAction.leaveGroup,
              child: Text(l10n.groupMenuLeave),
            ),
            PopupMenuItem(
              value: _GroupHeaderMenuAction.deleteGroup,
              child: Text(l10n.groupMenuDelete),
            ),
          ];
        },
      ),
    );
  }
}
