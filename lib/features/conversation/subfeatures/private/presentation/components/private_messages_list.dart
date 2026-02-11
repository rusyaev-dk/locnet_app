import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class PrivateMessagesList extends StatelessWidget {
  const PrivateMessagesList({
    required this.messages,
    required this.companionId,
    super.key,
  });

  final List<PrivateMessage> messages;
  final String companionId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      cacheExtent: 1200,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 4);
      },
      itemBuilder: (BuildContext context, int index) {
        final PrivateMessage message = messages[index];
        const Duration baseDuration = Duration(milliseconds: 280);
        final Duration delay = Duration(milliseconds: 35 * index);

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
          child: MessageBubble(
            message: message,
            companionId: companionId,
            onReply: () {},
            onForward: () {},
            onDelete: () {},
            onSelect: () {},
            onCopy: () async {
              final String text = message.text.trim();
              if (text.isNotEmpty) {
                await Clipboard.setData(ClipboardData(text: text));
              }
            },
          ),
        );
      },
    );
  }
}
