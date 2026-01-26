import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/presentation/modals/group_info_modal_card.dart';

enum _GroupHeaderMenuAction {
  toggleNotifications,
  viewGroupInfo,
  leaveGroup,
  deleteGroup,
}

class GroupHeader extends StatefulWidget {
  const GroupHeader({
    required this.conversation,
    required this.participantsCount,
    super.key,
  });

  final Conversation conversation;
  final int participantsCount;

  @override
  State<GroupHeader> createState() => _GroupHeaderState();
}

class _GroupHeaderState extends State<GroupHeader> {
  bool areNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: colorScheme.surfaceBright,
          child: Row(
            children: [
              ConversationAvatar(
                text: widget.conversation.title,
              ), // TODO: passthrough real url
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
                      '${widget.participantsCount} participants',
                      style: textScheme.label,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_GroupHeaderMenuAction>(
                icon: const Icon(Icons.more_vert),
                color: colorScheme.surfaceBright,
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
            ],
          ),
        ),
      ),
    );
  }
}
