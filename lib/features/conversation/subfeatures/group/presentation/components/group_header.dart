import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/presentation/modals/group_info_modal_card.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/conversation_tools.dart';

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

    final String subtitle = '${widget.participantsCount} participants';

    return ConversationProfileHeaderBase(
      title: widget.conversation.title,
      avatarText: widget.conversation.title,
      subtitle: subtitle,
      onTap: () {
        showGeneralDialog(
          context: context,
          transitionBuilder: slideFadeDialogTransition,
          pageBuilder: (context, _, _) {
            return GroupInfoModalCard(
              conversation: widget.conversation,
            );
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
              conversationType: ConversationType.group,
            );
          },
        ),
        _HeaderIconButton(
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
        icon: const Icon(Icons.more_vert),
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
              child: const Text('View Group Info'),
            ),
            PopupMenuItem(
              value: _GroupHeaderMenuAction.leaveGroup,
              child: const Text('Leave Group'),
            ),
            PopupMenuItem(
              value: _GroupHeaderMenuAction.deleteGroup,
              child: const Text('Delete Group'),
            ),
          ];
        },
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
  });

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
        splashRadius: 18,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

