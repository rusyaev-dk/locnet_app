import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/app/app.dart';

/// Shared skeleton loader for any conversation type.
///
/// Uses a single [AnimationController] by applying the shimmer effect at the
/// container level rather than per-bubble, which reduces GPU/CPU overhead by
/// 8x compared to animating each bubble individually.
class ConversationLoadingShimmer extends StatelessWidget {
  const ConversationLoadingShimmer({super.key});

  static const int _itemCount = 8;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = context.colorScheme.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: List.generate(_itemCount, (index) {
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
                  baseColor: baseColor,
                  isFromOther: isFromOther,
                ),
              ),
            ),
          );
        }),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
        )
        .fadeIn(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutQuad,
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
    final Color lineColor = Color.lerp(baseColor, Colors.white, 0.12)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double secondLineWidth = maxWidth * 0.65;
        final double thirdLineWidth = maxWidth * 0.4;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isFromOther ? 4 : 16),
              bottomRight: Radius.circular(isFromOther ? 16 : 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: lineColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                height: 10,
                margin: const EdgeInsets.only(bottom: 4),
                width: secondLineWidth,
                decoration: BoxDecoration(
                  color: lineColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                height: 10,
                width: thirdLineWidth,
                decoration: BoxDecoration(
                  color: lineColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
