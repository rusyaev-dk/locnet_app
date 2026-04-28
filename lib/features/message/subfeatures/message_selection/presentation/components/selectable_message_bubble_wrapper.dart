import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

typedef MessageIdResolver = String Function(Object message);

class SelectableMessageBubbleWrapper extends StatelessWidget {
  const SelectableMessageBubbleWrapper({
    required this.message,
    required this.companionId,
    required this.isSelected,
    required this.onEnterSelectionMode,
    required this.onToggleSelection,
    required this.onReply,
    required this.onForward,
    required this.onDelete,
    required this.onCopy,
    this.currentUserId,
    this.sender,
    this.forceLeft = false,
    this.showDeliveryStatus = true,
    this.replyPreviewText,
    this.replyPreviewAuthor,
    super.key,
  });

  final Object message;
  final String companionId;
  final bool isSelected;

  final String? currentUserId;
  final String? sender;
  final bool forceLeft;
  final bool showDeliveryStatus;
  final String? replyPreviewText;
  final String? replyPreviewAuthor;

  final VoidCallback onEnterSelectionMode;
  final VoidCallback onToggleSelection;
  final VoidCallback onReply;
  final VoidCallback onForward;
  final VoidCallback onDelete;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final Color highlightColor = isSelected
        ? colorScheme.primary.withOpacity(0.14)
        : Colors.transparent;

    return GestureDetector(
      onLongPress: onEnterSelectionMode,
      // Одиночный клик не меняет выделение, чтобы избежать случайного toggle.
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: highlightColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: MessageBubble(
          message: message,
          companionId: companionId,
          currentUserId: currentUserId,
          sender: sender,
          forceLeft: forceLeft,
          showDeliveryStatus: showDeliveryStatus,
          replyPreviewText: replyPreviewText,
          replyPreviewAuthor: replyPreviewAuthor,
          onReply: onReply,
          onForward: onForward,
          onDelete: onDelete,
          onSelect: onEnterSelectionMode,
          onCopy: onCopy,
        ),
      ),
    );
  }
}

