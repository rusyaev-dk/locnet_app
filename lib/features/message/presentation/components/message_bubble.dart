import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class PrivateMessageBubble extends StatelessWidget {
  const PrivateMessageBubble({
    required this.message,
    required this.companionId,
    this.isLast = false,
    super.key,
  });

  final Message message;
  final String companionId;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final bool isMine = message.senderId != companionId;

    final Alignment alignment = isMine
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final CrossAxisAlignment crossAxisAlignment = isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    final EdgeInsetsGeometry margin = EdgeInsets.only(
      left: isMine ? 60 : 0,
      right: isMine ? 0 : 60,
      top: 2,
      bottom: 2,
    );

    final Color bubbleColor = isMine
        ? colorScheme.primary
        : colorScheme.surfaceContainerHigh;

    final TextStyle messageTextStyle = isMine
        ? textScheme.label.copyWith(
            color: colorScheme.onPrimary,
            fontSize: 14.5,
          )
        : textScheme.label.copyWith(fontSize: 14.5);

    final TextStyle metaTextStyle = messageTextStyle.copyWith(
      fontSize: (messageTextStyle.fontSize!) * 0.8,
      color: isMine
          ? colorScheme.onPrimary.withAlpha(150)
          : (messageTextStyle.color ?? colorScheme.onSurface).withAlpha(150),
    );

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMine ? 16 : 4), // внутренняя грань
      bottomRight: Radius.circular(isMine ? 4 : 16), // внешняя грань
    );

    final String messageText = message.text ?? '';
    final String timeText = DateFormat.Hm().format(message.createdAt);

    return Align(
      alignment: alignment,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            margin: margin,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (messageText.isNotEmpty)
                  SelectableText(
                    messageText,
                    style: messageTextStyle,
                    selectionColor: isMine
                        ? colorScheme.onPrimary.withAlpha(150)
                        : colorScheme.onSurface.withAlpha(150),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (message.isEdited)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(l10n.edited, style: metaTextStyle),
                      ),
                    Text(timeText, style: metaTextStyle),
                    const SizedBox(width: 6),
                    _MessageDeliveryStatusIndicator(
                      deliveryStatus: message.deliveryStatus,
                      color:
                          metaTextStyle.color ??
                          (isMine
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface),
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageDeliveryStatusIndicator extends StatelessWidget {
  const _MessageDeliveryStatusIndicator({
    required this.deliveryStatus,
    required this.color,
    required this.size,
  });

  final MessageDeliveryStatus deliveryStatus;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    switch (deliveryStatus) {
      case MessageDeliveryStatus.sending:
        return _SendingClockIcon(color: color, size: size);

      case MessageDeliveryStatus.sent:
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
