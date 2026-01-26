import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/app/app.dart';

class ChannelConversationLoadingShimmer extends StatelessWidget {
  const ChannelConversationLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        final bool isFromOther = index.isEven;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Align(
            alignment: isFromOther
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: isFromOther ? 0.72 : 0.64,
              child: _ShimmerBubble(
                baseColor: colorScheme.surfaceContainerHighest,
                isFromOther: isFromOther,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerBubble extends StatelessWidget {
  const _ShimmerBubble({
    required this.baseColor,
    required this.isFromOther,
  });

  final Color baseColor;
  final bool isFromOther;

  @override
  Widget build(BuildContext context) {
    final Color highlightColor = baseColor.withAlpha(210);
    final Color lineColor = baseColor.withAlpha(170);

    final Widget bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isFromOther ? 4 : 18),
          bottomRight: Radius.circular(isFromOther ? 18 : 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            height: 10,
            margin: const EdgeInsets.only(bottom: 4),
            width: 140,
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            height: 10,
            width: 80,
            decoration: BoxDecoration(
              color: lineColor.withAlpha(150),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );

    return bubble
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: const Duration(milliseconds: 1500))
        .fadeIn(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
  }
}
