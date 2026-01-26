import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class GroupMessagesList extends StatelessWidget {
  const GroupMessagesList({
    required this.messages,
    required this.currentUserId,
    required this.participants,
    super.key,
  });

  final List<Message> messages;
  final String currentUserId;
  final List<User> participants;

  @override
  Widget build(BuildContext context) {
    // Create a map for quick user lookup by userId
    final Map<String, User> participantsMap = {
      for (final User user in participants) user.userId: user,
    };

    return ListView.separated(
      cacheExtent: 1200,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 4);
      },
      itemBuilder: (BuildContext context, int index) {
        final Message message = messages[index];

        return GroupMessageAnimatedBubble(
          message: message,
          currentUserId: currentUserId,
          participantsMap: participantsMap,
          index: index,
        );
      },
    );
  }
}

class GroupMessageAnimatedBubble extends StatelessWidget {
  const GroupMessageAnimatedBubble({
    required this.message,
    required this.currentUserId,
    required this.participantsMap,
    required this.index,
    super.key,
  });

  final Message message;
  final String currentUserId;
  final Map<String, User> participantsMap;
  final int index;

  @override
  Widget build(BuildContext context) {
    const Duration baseDuration = Duration(milliseconds: 280);
    final Duration delay = Duration(milliseconds: 35 * index);

    final bool isMine = message.senderId == currentUserId;
    final User? sender = participantsMap[message.senderId];

    return Animate(
      delay: delay,
      effects: const [
        FadeEffect(duration: baseDuration, curve: Curves.easeOut),
        SlideEffect(
          begin: Offset(0, 0.18),
          end: Offset.zero,
          duration: baseDuration,
          curve: Curves.easeOutCubic,
        ),
        ScaleEffect(
          begin: Offset(0.98, 0.98),
          end: Offset(1, 1),
          duration: baseDuration,
          curve: Curves.easeOut,
        ),
      ],
      child: isMine
          ? MessageBubble(
              message: message,
              companionId: 'not_${currentUserId}',
              sender: null,
              onReply: () {},
              onDelete: () {},
              onForward: () {},
              onSelect: () {},
              onCopy: () async {
                final String text = (message.text ?? '').trim();
                if (text.isEmpty) {
                  return;
                }

                await Clipboard.setData(ClipboardData(text: text));
              },
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompanionAvatar(
                  text: sender != null
                      ? ProfileDataExtractor.extractUserInitials(sender)
                      : '?',
                  size: 32,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MessageBubble(
                    message: message,
                    companionId: currentUserId,
                    forceLeft: true, // Force left alignment for messages from others
                    sender: sender != null
                        ? (sender.fullName.isNotEmpty
                            ? sender.fullName
                            : sender.username)
                        : 'Unknown',
                    onReply: () {},
                    onDelete: () {},
                    onForward: () {},
                    onSelect: () {},
                    onCopy: () async {
                      final String text = (message.text ?? '').trim();
                      if (text.isEmpty) {
                        return;
                      }

                      await Clipboard.setData(ClipboardData(text: text));
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

