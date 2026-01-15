import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class PrivateMessagesList extends StatelessWidget {
  const PrivateMessagesList({
    required this.messages,
    required this.companionId,
    super.key,
  });

  final List<Message> messages;
  final String companionId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      cacheExtent: 800,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 4);
      },
      itemBuilder: (BuildContext context, int index) {
        final Message message = messages[index];

        return PrivateMessageAnimatedBubble(
          message: message,
          companionId: companionId,
          index: index,
        );
      },
    );
  }
}

class PrivateMessageAnimatedBubble extends StatelessWidget {
  const PrivateMessageAnimatedBubble({
    required this.message,
    required this.companionId,
    required this.index,
    super.key,
  });

  final Message message;
  final String companionId;
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
      child: PrivateMessageBubble(message: message, companionId: companionId),
    );
  }
}
