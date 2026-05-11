import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/conversation_tools.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/modals/companion_info_modal_card.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/uikit/uikit.dart';
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
      avatarOverride: Avatar.user(user: widget.companion, size: 38),
      subtitle: l10n.companionStatusOnline,
      isOnline: true,
      onTap: () => _openCompanionInfo(context),
      trailingActions: [
        if (hasConversationId) ...[
          SurfaceIconButton(
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
          SurfaceIconButton(
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
      ],
      menuButton: hasConversationId
          ? PopupMenuButton<_PrivateHeaderMenuAction>(
              padding: EdgeInsets.zero,
              child: const Material(
                color: Colors.transparent,
                child: SurfaceIconShell(
                  icon: Icons.more_vert,
                  margin: EdgeInsets.only(left: 6),
                ),
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
                    final bool? confirmed = await showAppAlertDialog<bool>(
                      context: context,
                      title: Text(l10n.deleteConversation),
                      content: Text(l10n.deletePrivateConversationBody),
                      buildActions: (BuildContext d) => [
                        AppAlertDialogAction(
                          child: Text(l10n.cancel),
                          onPressed: () => Navigator.of(d).pop(false),
                        ),
                        AppAlertDialogAction(
                          isDefaultAction: true,
                          child: Text(l10n.delete),
                          onPressed: () => Navigator.of(d).pop(true),
                        ),
                      ],
                    );
                    if (confirmed == true && context.mounted) {
                      await cubit.deleteConversation();
                    }
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
