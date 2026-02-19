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
    final textScheme = context.textScheme;

    return AppModalCard(
      child: Container(
        color: colorScheme.secondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: CompanionInfoHeader(companion: companion),
            ),
            Expanded(
              child: Container(
                color: colorScheme.surface,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      CompanionInfoActionRow(
                        onChatPressed: () {},
                        onMutePressed: () {},
                        onCallPressed: () {},
                        onMorePressed: () {},
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Info",
                        style: textScheme.label.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTileButtonGroupCard(
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
                          if ((companion.description ?? '').trim().isNotEmpty)
                            AppTileButton(
                              title: 'About',
                              value: companion.description!.trim(),
                              icon: Icons.info_outline,
                              onPressed: () {},
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "More",
                        style: textScheme.label.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTileButtonGroupCard(
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
            ),
          ],
        ),
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
