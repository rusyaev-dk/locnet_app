import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class MessageDeliveryStatusIndicator extends StatelessWidget {
  const MessageDeliveryStatusIndicator({
    required this.deliveryStatus,
    required this.color,
    required this.size,
    this.isRead = false,
    super.key,
  });
  final MessageDeliveryStatus deliveryStatus;
  final Color color;
  final double size;
  final bool isRead;
  @override
  Widget build(BuildContext context) {
    switch (deliveryStatus) {
      case MessageDeliveryStatus.sending:
        return _SendingClockIcon(color: color, size: size);
      case MessageDeliveryStatus.sent:
        if (isRead) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, size: size, color: color),
              Transform.translate(
                offset: Offset(-size * 0.35, 0),
                child: Icon(Icons.check, size: size, color: color),
              ),
            ],
          );
        }
        return Icon(Icons.check, size: size, color: color);
      case MessageDeliveryStatus.failed:
        return Icon(Icons.error_outline, size: size, color: color);
    }
  }
}

class _SendingClockIcon extends StatelessWidget {
  const _SendingClockIcon({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.schedule, size: size, color: color)
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 900.ms, begin: 0, end: 1, curve: Curves.linear)
        .fade(duration: 450.ms, begin: 0.55, end: 1)
        .then()
        .fade(duration: 450.ms, begin: 1, end: 0.55);
  }
}
