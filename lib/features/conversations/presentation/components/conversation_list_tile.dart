import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class ConversationListTile extends StatelessWidget {
  const ConversationListTile({required this.conversationTile, super.key});

  final ConversationTile conversationTile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Message? lastMessage = conversationTile.lastMessage;
    final String? lastMessageText = lastMessage?.text;

    String titleText = conversationTile.conversation.title;
    String? subtitleText = lastMessageText;

    switch (conversationTile.conversation.type) {
      case ConversationType.private:
        titleText = conversationTile.conversation.title;
        subtitleText = lastMessageText;
        break;
      case ConversationType.group:
        if (lastMessage != null && lastMessageText != null) {
          final String senderLabel = lastMessage.senderId;
          subtitleText = '$senderLabel: $lastMessageText';
        } else {
          subtitleText = null;
        }
        break;
      case ConversationType.channel:
        subtitleText = lastMessageText;
        break;
    }

    String? timeText;
    if (lastMessage != null) {
      final DateTime createdAt = lastMessage.createdAt;
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(createdAt);

      if (difference.inHours >= 24) {
        final Locale locale = Localizations.localeOf(context);
        final DateFormat weekdayFormatter = DateFormat.E(
          locale.toLanguageTag(),
        );
        timeText = weekdayFormatter.format(createdAt);
      } else {
        final TimeOfDay timeOfDay = TimeOfDay.fromDateTime(createdAt);
        timeText = timeOfDay.format(context);
      }
    }

    return Material(
      color: colorScheme.surfaceContainer.withAlpha(60),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          GoRouter.of(
            context,
          ).go('/home/conversations/${conversationTile.conversation.id}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ConversationAvatar(
                backgroundColor: colorScheme.onSurface.withAlpha(0x14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: textScheme.headline.copyWith(fontSize: 16.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitleText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitleText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textScheme.label.copyWith(
                          color: colorScheme.onSurface.withAlpha(0x99),
                        ),
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

class _ConversationAvatar extends StatelessWidget {
  const _ConversationAvatar({required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
    );
  }
}
