// message_bubble.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    required this.message,
    required this.companionId,
    required this.onReply,
    required this.onForward,
    required this.onDelete,
    required this.onSelect,
    required this.onCopy,
    this.isLast = false,
    super.key,
  });

  final Message message;
  final String companionId;
  final bool isLast;

  final VoidCallback onReply;
  final VoidCallback onForward;
  final VoidCallback onDelete;
  final VoidCallback onSelect;
  final VoidCallback onCopy;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  static final DateFormat _timeFormatter = DateFormat.Hm();

  final MessageContextMenuController _menuController =
      MessageContextMenuController();

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _showContextMenu(TapDownDetails details) {
    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);

    final RenderObject? renderObject = overlayState.context.findRenderObject();
    if (renderObject is! RenderBox) {
      return;
    }

    final RenderBox overlayBox = renderObject;
    final Offset globalPosition = details.globalPosition;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
      Offset.zero & overlayBox.size,
    );

    final l10n = context.l10n;
    final String messageText = (widget.message.text ?? '').trim();

    final List<MessageContextMenuAction> actions = <MessageContextMenuAction>[
      MessageContextMenuAction(
        id: 'reply',
        title: l10n.messageContextActionReply,
        icon: Icons.reply,
        onPressed: widget.onReply,
      ),
      MessageContextMenuAction(
        id: 'forward',
        title: l10n.messageContextActionForward,
        icon: Icons.forward,
        onPressed: widget.onForward,
      ),
      MessageContextMenuAction(
        id: 'copy',
        title: l10n.messageContextActionCopyText,
        icon: Icons.copy,
        isEnabled: messageText.isNotEmpty,
        onPressed: widget.onCopy,
      ),
      MessageContextMenuAction(
        id: 'select',
        title: l10n.messageContextActionSelect,
        icon: Icons.select_all,
        isEnabled: messageText.isNotEmpty,
        onPressed: widget.onSelect,
      ),
      MessageContextMenuAction(
        id: 'delete',
        title: l10n.messageContextActionDelete,
        icon: Icons.delete_outline,
        isDestructive: true,
        onPressed: widget.onDelete,
      ),
    ];

    _menuController.show(
      context: context,
      position: position,
      actions: actions,
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    final bool isSecondaryClick = (event.buttons & kSecondaryMouseButton) != 0;
    if (!isSecondaryClick) {
      return;
    }

    _showContextMenu(TapDownDetails(globalPosition: event.position));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final bool isMine = widget.message.senderId != widget.companionId;

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
        : textScheme.label.copyWith(
            color: colorScheme.onSurface,
            fontSize: 14.5,
          );

    final TextStyle metaTextStyle = messageTextStyle.copyWith(
      fontSize: (messageTextStyle.fontSize!) * 0.8,
      color: isMine
          ? colorScheme.onPrimary.withAlpha(150)
          : messageTextStyle.color!.withAlpha(150),
    );

    final BorderRadius borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMine ? 16 : 4),
      bottomRight: Radius.circular(isMine ? 4 : 16),
    );

    final String messageText = (widget.message.text ?? '').trim();
    final String timeText = _timeFormatter.format(widget.message.createdAt);

    final Color selectionColor = isMine
        ? colorScheme.onPrimary.withAlpha(80)
        : colorScheme.onSurface.withAlpha(80);

    final Color linkColor = isMine
        ? colorScheme.onPrimary
        : colorScheme.primary;

    return Listener(
      onPointerDown: _handlePointerDown,
      child: Align(
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
                children: <Widget>[
                  if (messageText.isNotEmpty)
                    TextSelectionTheme(
                      data: TextSelectionThemeData(
                        selectionColor: selectionColor,
                      ),
                      child: AppMessageText(
                        data: messageText,
                        textStyle: messageTextStyle,
                        linkColor: linkColor,
                        onLinkTap: _onMessageLinkTap,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (widget.message.isEdited)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            context.l10n.edited,
                            style: metaTextStyle,
                          ),
                        ),
                      Text(timeText, style: metaTextStyle),
                      const SizedBox(width: 6),
                      MessageDeliveryStatusIndicator(
                        deliveryStatus: widget.message.deliveryStatus,
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
      ),
    );
  }

  void _onMessageLinkTap(Uri uri) async {
    final bool canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
