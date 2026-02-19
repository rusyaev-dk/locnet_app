import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ChannelInfoModalCard extends StatelessWidget {
  const ChannelInfoModalCard({required this.conversation, super.key});

  final Channel conversation;

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
              child: ChannelInfoHeader(conversation: conversation),
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
                          if ((conversation.description ?? '').trim().isNotEmpty)
                            AppTileButton(
                              title: 'Description',
                              value: conversation.description!.trim(),
                              icon: Icons.info_outline,
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

class ChannelInfoHeader extends StatelessWidget {
  const ChannelInfoHeader({required this.conversation, super.key});

  final Channel conversation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 6),
              ConversationAvatar(
                text: conversation.title,
                size: 85,
              ),
              const SizedBox(height: 10),
              Text(
                conversation.title,
                textAlign: TextAlign.center,
                style: textScheme.headline.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                ),
              ),
              if ((conversation.description ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    conversation.description!.trim(),
                    textAlign: TextAlign.center,
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: RoundedIconButton(
            icon: Icons.close,
            foregroundColor: colorScheme.onSurfaceVariant,
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ),
      ],
    );
  }
}
