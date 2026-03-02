import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/domain/utils/utils.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/presentation/presentation.dart';

class UnifiedSearchResultTile extends StatelessWidget {
  const UnifiedSearchResultTile({
    required this.item,
    required this.onPressed,
    super.key,
  });

  final UnifiedSearchListItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    String title;
    String? subtitle;
    String avatarText;
    IconData icon;

    switch (item.type) {
      case UnifiedSearchListItemType.user:
        title = ProfileDataExtractor.extractUserFullName(item.user!);
        avatarText = ProfileDataExtractor.extractUserInitials(item.user!);
        subtitle = item.user!.username;
        icon = Icons.person_outline;
        break;
      case UnifiedSearchListItemType.conversation:
        title = item.conversation!.title;
        avatarText = item.conversation!.title.substring(0, 2);
        if (item.conversation!.type == UnifiedSearchConversationType.group) {
          icon = Icons.group_outlined;
        } else if (item.conversation!.type ==
            UnifiedSearchConversationType.channel) {
          icon = Icons.campaign_outlined;
        } else {
          icon = Icons.person_outline;
        }
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 46),
            child: Row(
              children: [
                ConversationAvatar(text: avatarText),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textScheme.label.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textScheme.caption.copyWith(
                            color: colorScheme.primary.withAlpha(200),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
