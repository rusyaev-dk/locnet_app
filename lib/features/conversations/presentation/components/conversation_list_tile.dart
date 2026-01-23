import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/components/components.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class ConversationListTile extends StatelessWidget {
  const ConversationListTile({
    required this.conversationTile,
    required this.isCompact,
    required this.onTap,
    required this.currentUserId,
    this.isSelected = false,
    super.key,
  });

  final ConversationTile conversationTile;
  final bool isCompact;
  final bool isSelected;
  final String currentUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    if (isCompact) {
      return Material(
        color: isSelected ? colorScheme.surfaceContainer : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ConversationAvatar(
              text: conversationTile.conversation.title,
            ),
          ),
        ),
      );
    }

    final String titleText = conversationTile.conversation.title;
    InlineSpan? subtitleSpan;
    String? timeText;
    IconData? icon;

    final Message? lastMessage = conversationTile.lastMessage;
    if (lastMessage != null) {
      final bool lastMessageBelongsToUser =
          lastMessage.senderId == currentUserId;

      if (lastMessageBelongsToUser) {
        subtitleSpan = TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${l10n.you}: ',
              style: textScheme.label.copyWith(
                color: colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: lastMessage.text,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurface.withAlpha(0x99),
                fontSize: 14,
              ),
            ),
          ],
        );
      } else {
        subtitleSpan = TextSpan(
          text: lastMessage.text,
          style: textScheme.label.copyWith(
            color: colorScheme.onSurface.withAlpha(0x99),
            fontSize: 14,
          ),
        );
      }

      timeText = DateTimeFormatter.formatConversationTime(
        dateTime: lastMessage.createdAt,
        now: DateTime.now(),
        locale: Localizations.localeOf(context),
        materialLocalizations: MaterialLocalizations.of(context),
      );
    }

    switch (conversationTile.conversation.type) {
      case ConversationType.private:
        break;
      case ConversationType.group:
        icon = Icons.group;
        break;
      case ConversationType.channel:
        icon = Icons.campaign;
        break;
    }

    return Material(
      color: isSelected
          ? colorScheme.surfaceContainer
          : colorScheme.surfaceBright,

      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ConversationAvatar(
                text: conversationTile.conversation.title,
              ), // TODO: passthrouth real url
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: colorScheme.onSurface, size: 15),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          titleText,
                          style: textScheme.headline.copyWith(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (subtitleSpan != null) ...[
                      const SizedBox(height: 7),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: subtitleSpan,
                      ),
                    ],
                  ],
                ),
              ),
              if (timeText != null) ...[
                const SizedBox(width: 8),
                Text(
                  timeText,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurface.withAlpha(0x99),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
