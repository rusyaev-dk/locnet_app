import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/components/components.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

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
    final spacing = context.designTokens.spacing;
    final textScheme = context.textScheme;
    final l10n = context.l10n;
    final Color secondaryTextColor = colorScheme.onSurfaceVariant;

    if (isCompact) {
      final String avatarText = conversationTile.companion != null
          ? ProfileDataExtractor.extractUserInitials(
              conversationTile.companion!,
            )
          : conversationTile.title;

      return Material(
        color: isSelected ? colorScheme.surfaceContainer : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs + spacing.xxs / 2,
            ),
            child: ConversationAvatar(text: avatarText),
          ),
        ),
      );
    }

    final String titleText = conversationTile.title;
    InlineSpan? subtitleSpan;
    String? timeText;
    IconData? icon;

    final String? lastMessageText = conversationTile.lastMessageText;
    final String? lastSenderId = conversationTile.lastMessageSenderId;
    final DateTime? lastAt = conversationTile.lastMessageAt;

    if (lastMessageText != null && lastAt != null) {
      final bool lastMessageBelongsToUser = lastSenderId == currentUserId;

      if (lastMessageBelongsToUser) {
        subtitleSpan = TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${l10n.you}: ',
              style: textScheme.body.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: lastMessageText,
              style: textScheme.body.copyWith(color: secondaryTextColor),
            ),
          ],
        );
      } else {
        subtitleSpan = TextSpan(
          text: lastMessageText,
          style: textScheme.body.copyWith(color: secondaryTextColor),
        );
      }

      timeText = DateTimeFormatter.formatConversationTime(
        dateTime: lastAt,
        now: DateTime.now(),
        locale: Localizations.localeOf(context),
        materialLocalizations: MaterialLocalizations.of(context),
      );
    }

    switch (conversationTile.type) {
      case ConversationTileType.private:
        break;
      case ConversationTileType.group:
        icon = Icons.group;
        break;
      case ConversationTileType.channel:
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
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs + spacing.xxs / 2,
          ),
          child: Row(
            children: [
              ConversationAvatar(
                text: conversationTile.companion != null
                    ? ProfileDataExtractor.extractUserInitials(
                        conversationTile.companion!,
                      )
                    : conversationTile.title,
              ), // TODO: passthrouth real url
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: colorScheme.onSurfaceVariant,
                            size: spacing.sm + spacing.xxs - spacing.xxs / 4,
                          ),
                          SizedBox(width: spacing.xxs),
                        ],
                        Expanded(
                          child: Text(
                            titleText,
                            style: textScheme.title.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (timeText != null) ...[
                          SizedBox(width: spacing.xs),
                          Text(
                            timeText,
                            style: textScheme.caption.copyWith(
                              color: secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    if (subtitleSpan != null) ...[
                      SizedBox(height: spacing.xs - spacing.xxs / 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: subtitleSpan,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
