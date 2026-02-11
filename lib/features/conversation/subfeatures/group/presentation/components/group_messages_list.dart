import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class GroupMessagesList extends StatelessWidget {
  const GroupMessagesList({
    required this.messages,
    required this.currentUserId,
    required this.participants,
    super.key,
  });

  final List<GroupMessage> messages;
  final String currentUserId;
  final List<User> participants;

  @override
  Widget build(BuildContext context) {
    final Map<String, User> participantsMap = {
      for (final User user in participants) user.userId: user,
    };

    return ListView.separated(
      cacheExtent: 1200,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (BuildContext context, int index) {
        final GroupMessage message = messages[index];
        const Duration baseDuration = Duration(milliseconds: 280);
        final Duration delay = Duration(milliseconds: 35 * index);

        final bool isMine = message.senderId == currentUserId;
        final User? sender = participantsMap[message.senderId];
        final String senderName = sender != null
            ? (sender.fullName.isNotEmpty ? sender.fullName : sender.username)
            : 'Unknown';

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
                  companionId: '',
                  currentUserId: currentUserId,
                  onReply: () {},
                  onForward: () {},
                  onDelete: () {},
                  onSelect: () {},
                  onCopy: () async {
                    final String t = message.text.trim();
                    if (t.isNotEmpty) {
                      await Clipboard.setData(ClipboardData(text: t));
                    }
                  },
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        companionId: '',
                        currentUserId: currentUserId,
                        sender: senderName,
                        onReply: () {},
                        onForward: () {},
                        onDelete: () {},
                        onSelect: () {},
                        onCopy: () async {
                          final String t = message.text.trim();
                          if (t.isNotEmpty) {
                            await Clipboard.setData(ClipboardData(text: t));
                          }
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
