import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/domain/utils/utils.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversations/subfeatures/unified_search/presentation/presentation.dart';

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
        icon = Icons.person;
        break;
      case UnifiedSearchListItemType.conversation:
        title = item.conversation!.title;
        avatarText = item.conversation!.title.substring(0, 2);
        if (item.conversation!.type == ConversationType.private) {
          icon = Icons.person;
        } else if (item.conversation!.type == ConversationType.group) {
          icon = Icons.group;
        } else {
          icon = Icons.campaign;
        }
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 45),
            child: Row(
              children: [
                ConversationAvatar(text: avatarText), // TODO: passthrough url
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: colorScheme.onSurface, size: 15.5),
                          const SizedBox(width: 4),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textScheme.label.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textScheme.label.copyWith(
                            color: colorScheme.primary.withAlpha(190),
                            fontSize: 12.5,
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
