import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class ChannelMessagesList extends StatelessWidget {
  const ChannelMessagesList({required this.messages, super.key});

  final List<Message> messages;

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
        final Message message = messages[index];

        return ChannelMessageAnimatedBubble(message: message, index: index);
      },
    );
  }
}

class ChannelMessageAnimatedBubble extends StatelessWidget {
  const ChannelMessageAnimatedBubble({
    required this.message,
    required this.index,
    super.key,
  });

  final Message message;
  final int index;

  @override
  Widget build(BuildContext context) {
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
        companionId: '', // Not used when forceLeft is true
        forceLeft: true, // Force left alignment for channels
        showDeliveryStatus: false, // Hide delivery status in channels
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
    );
  }
}
