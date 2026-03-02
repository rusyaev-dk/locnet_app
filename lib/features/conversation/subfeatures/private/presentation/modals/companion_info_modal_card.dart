import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class CompanionInfoModalCard extends StatelessWidget {
  const CompanionInfoModalCard({required this.companion, super.key});

  final User companion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final bool hasDescription =
        (companion.description ?? '').trim().isNotEmpty;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
            child: CompanionInfoHeader(companion: companion),
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CompanionInfoActionRow(
              onChatPressed: () {},
              onMutePressed: () {},
              onCallPressed: () {},
              onMorePressed: () {},
            ),
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
                        title: 'Username',
                        value: '@${companion.username}',
                        icon: Icons.alternate_email,
                        onPressed: () {},
                      ),
                      AppTileButton(
                        title: 'Language',
                        value: companion.languageCode,
                        icon: Icons.language,
                        onPressed: () {},
                      ),
                      if (hasDescription)
                        AppTileButton(
                          title: 'About',
                          value: companion.description!.trim(),
                          icon: Icons.info_outline,
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

class CompanionInfoActionRow extends StatelessWidget {
  const CompanionInfoActionRow({
    required this.onChatPressed,
    required this.onMutePressed,
    required this.onCallPressed,
    required this.onMorePressed,
    super.key,
  });

  final VoidCallback onChatPressed;
  final VoidCallback onMutePressed;
  final VoidCallback onCallPressed;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            onPressed: onChatPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.notifications_off_outlined,
            label: 'Mute',
            onPressed: onMutePressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.call_outlined,
            label: 'Call',
            onPressed: onCallPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onPressed: onMorePressed,
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
