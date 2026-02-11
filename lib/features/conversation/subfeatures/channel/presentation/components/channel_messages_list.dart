import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class ChannelMessagesList extends StatelessWidget {
  const ChannelMessagesList({required this.messages, super.key});

  final List<ChannelPublication> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      cacheExtent: 1200,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (BuildContext context, int index) {
        final ChannelPublication publication = messages[index];
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
            message: publication,
            companionId: '',
            forceLeft: true,
            showDeliveryStatus: false,
            onReply: () {},
            onForward: () {},
            onDelete: () {},
            onSelect: () {},
            onCopy: () async {
              final String text = (publication.text ?? '').trim();
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
