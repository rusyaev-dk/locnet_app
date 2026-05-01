import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/conversation_tools.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/modals/companion_info_modal_card.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
enum _PrivateHeaderMenuAction {
  toggleNotifications,
  blockCompanion,
  deleteConversation,
}

class PrivateHeader extends StatefulWidget {
  const PrivateHeader({
    required this.companion,
    this.conversationId,
    this.onSearchResultSelected,
    super.key,
  });

  final String? conversationId;
  final User companion;
  final ValueChanged<String>? onSearchResultSelected;

  @override
  State<PrivateHeader> createState() => _PrivateHeaderState();
}

class _PrivateHeaderState extends State<PrivateHeader> {
  bool areNotificationsEnabled = true;

  void _openCompanionInfo(BuildContext context) {
    showGeneralDialog(
      context: context,
      transitionBuilder: slideFadeDialogTransition,
      pageBuilder: (context, _, _) {
        return CompanionInfoModalCard(companion: widget.companion);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String? conversationId = widget.conversationId;
    final bool hasConversationId = conversationId != null;

    final String title =
        "${widget.companion.firstName} ${widget.companion.lastName}";

    return ConversationProfileHeaderBase(
      title: title,
      avatarText: ProfileDataExtractor.extractUserInitials(widget.companion),
      subtitle: l10n.companionStatusOnline,
      isOnline: true,
      onTap: () => _openCompanionInfo(context),
      trailingActions: [
        HeaderActionButton(
          icon: Icons.call_outlined,
          onPressed: () {},
        ),
        HeaderActionButton(
          icon: Icons.videocam_outlined,
          onPressed: () {},
        ),
        if (hasConversationId) ...[
          HeaderActionButton(
            icon: Icons.search,
            onPressed: () {
              showConversationSearchSheet(
                context: context,
                conversationId: conversationId,
                conversationType: ConversationType.private,
                onMessageSelected: widget.onSearchResultSelected,
                privateConversationBloc: context.read<PrivateConversationBloc>(),
              );
            },
          ),
          HeaderActionButton(
            icon: Icons.photo_library_outlined,
            onPressed: () {
              showConversationSharedMediaSheet(
                context: context,
                conversationId: conversationId,
                conversationType: ConversationType.private,
                companionName: title,
                privateConversationBloc: context.read<PrivateConversationBloc>(),
              );
            },
          ),
        ],
        HeaderActionButton(
          icon: Icons.info_outline,
          onPressed: () => _openCompanionInfo(context),
        ),
      ],
      menuButton: hasConversationId
          ? PopupMenuButton<_PrivateHeaderMenuAction>(
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: context.colorScheme.onSurfaceVariant,
              ),
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
            )
          : null,
    );
  }
}
