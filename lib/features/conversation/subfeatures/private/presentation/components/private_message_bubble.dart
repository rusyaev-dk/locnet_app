import 'package:flutter/material.dart';
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
      fontSize: (messageTextStyle.fontSize!) * 0.75,
      color: isMine
          ? colorScheme.onPrimary.withAlpha(150)
          : (messageTextStyle.color ?? colorScheme.onSurface).withAlpha(150),
    );

    final BorderRadius borderRadius = _buildBorderRadius(isMine: isMine);

    final String messageText = message.text ?? '';
    final String timeText = DateFormat.Hm().format(message.createdAt);
    final bool isEdited = message.isEdited;

    return Align(
      alignment: alignment,
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
                SelectableText(messageText, style: messageTextStyle, selectionColor: isMine ? colorScheme.onPrimary.withAlpha(150) : colorScheme.onSurface.withAlpha(150)),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEdited)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text('Изменено', style: metaTextStyle),
                    ),
                  Text(timeText, style: metaTextStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius _buildBorderRadius({required bool isMine}) {
    if (isLast) {
      return BorderRadius.circular(16);
    }

    if (isMine) {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16), // внутренняя грань
        bottomRight: Radius.circular(4), // внешняя грань
      );
    }

    return const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(4), // внешняя грань
      bottomRight: Radius.circular(16), // внутренняя грань
    );
  }
}
