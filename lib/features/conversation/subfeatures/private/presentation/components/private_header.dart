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
      onTap: () {
        showGeneralDialog(
          context: context,
          transitionBuilder: slideFadeDialogTransition,
          pageBuilder: (context, _, _) {
            return CompanionInfoModalCard(companion: widget.companion);
          },
        );
      },
      trailingActions: hasConversationId
          ? [
              _HeaderIconButton(
                icon: Icons.search,
                onPressed: () {
                  showConversationSearchSheet(
                    context: context,
                    conversationId: conversationId,
                    conversationType: ConversationType.private,
                    onMessageSelected: widget.onSearchResultSelected,
                    privateConversationBloc: context
                        .read<PrivateConversationBloc>(),
                  );
                },
              ),
              _HeaderIconButton(
                icon: Icons.photo_outlined,
                onPressed: () {
                  showConversationSharedMediaSheet(
                    context: context,
                    conversationId: conversationId,
                    conversationType: ConversationType.private,
                  );
                },
              ),
            ]
          : const [],
      menuButton: hasConversationId
          ? PopupMenuButton<_PrivateHeaderMenuAction>(
              icon: const Icon(Icons.more_vert),
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
        splashRadius: 18,
        onPressed: onPressed,
        icon: Icon(icon, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
