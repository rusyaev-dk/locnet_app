import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class GroupInfoModalCard extends StatelessWidget {
  const GroupInfoModalCard({required this.conversation, super.key});

  final Group conversation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final String? description =
        (conversation.description ?? '').trim().isEmpty
            ? null
            : conversation.description!.trim();

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
            child: ConversationInfoHeroHeader(
              title: conversation.title,
              avatar: Avatar.group(group: conversation, size: 80),
              subtitle: description,
            ),
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _GroupActionRow(conversation: conversation),
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTileButtonGroupCard(
                    backgroundColor: colorScheme.surfaceContainerLow,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    children: [
                      AppTileButton(
                        title: 'Type',
                        value: 'Group',
                        icon: Icons.group_outlined,
                        onPressed: () {},
                      ),
                      if (description != null)
                        AppTileButton(
                          title: 'Description',
                          value: description,
                          icon: Icons.article_outlined,
                          onPressed: () {},
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _InfoSectionLabel('More'),
                  const SizedBox(height: 8),
                  AppTileButtonGroupCard(
                    backgroundColor: colorScheme.surfaceContainerLow,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    children: [
                      AppTileButton(
                        title: 'Shared media',
                        value: '0',
                        icon: Icons.photo_library_outlined,
                        onPressed: () {},
                      ),
                      AppTileButton(
                        title: 'Shared files',
                        value: '0',
                        icon: Icons.insert_drive_file_outlined,
                        onPressed: () {},
                      ),
                      AppTileButton(
                        title: 'Shared links',
                        value: '0',
                        icon: Icons.link_outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupActionRow extends StatelessWidget {
  const _GroupActionRow({required this.conversation});

  final Group conversation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Open',
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.notifications_off_outlined,
            label: 'Mute',
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _InfoSectionLabel extends StatelessWidget {
  const _InfoSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: textScheme.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
