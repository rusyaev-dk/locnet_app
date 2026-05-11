import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/domain/models/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/models/group.dart';
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
    IconData icon;

    switch (item.type) {
      case UnifiedSearchListItemType.user:
        title = ProfileDataExtractor.extractUserFullName(item.user!);
        subtitle = item.user!.username;
        icon = Icons.person_outline;
        break;
      case UnifiedSearchListItemType.conversation:
        title = item.conversation!.title;
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
                _buildAvatar(),
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

  Widget _buildAvatar() {
    if (item.type == UnifiedSearchListItemType.user) {
      return Avatar.user(user: item.user!);
    }

    final UnifiedSearchConversation conversation = item.conversation!;
    switch (conversation.type) {
      case UnifiedSearchConversationType.private:
        if (conversation.companion != null) {
          return Avatar.user(user: conversation.companion!);
        }
        return Avatar.user(
          user: _placeholderUser(id: conversation.id, title: conversation.title),
        );
      case UnifiedSearchConversationType.group:
        return Avatar.group(
          group: _placeholderGroup(id: conversation.id, title: conversation.title),
        );
      case UnifiedSearchConversationType.channel:
        return Avatar.channel(
          channel: _placeholderChannel(id: conversation.id, title: conversation.title),
        );
    }
  }

  User _placeholderUser({required String id, required String title}) {
    final DateTime now = DateTime.now();
    return User(
      userId: id,
      username: title,
      firstName: title,
      lastName: '',
      languageCode: 'en',
      isDeleted: false,
      isBanned: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  Group _placeholderGroup({required String id, required String title}) {
    final DateTime now = DateTime.now();
    return Group(
      groupId: id,
      createdById: '',
      title: title,
      description: null,
      createdAt: now,
      updatedAt: now,
      avatarFileId: null,
      isDeleted: false,
      deletedAt: null,
      isPublic: true,
    );
  }

  Channel _placeholderChannel({required String id, required String title}) {
    final DateTime now = DateTime.now();
    return Channel(
      channelId: id,
      ownerId: '',
      title: title,
      description: null,
      createdAt: now,
      updatedAt: now,
      avatarFileId: null,
      isDeleted: false,
      deletedAt: null,
      isPublic: true,
    );
  }
}
