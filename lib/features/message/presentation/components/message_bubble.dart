// message_bubble.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
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
    this.forceLeft = false,
    this.currentUserId,
    this.sender,
    this.showDeliveryStatus = true,
    super.key,
  });

  /// Can be one of:
  /// - PrivateMessage
  /// - GroupMessage
  /// - ChannelPublication
  final Object message;
  final String companionId;
  final bool isLast;
  final bool forceLeft;

  /// When set (e.g. in group chat), isMine = (senderId == currentUserId).
  /// When null, isMine = (senderId != companionId).
  final String? currentUserId;
  final String? sender;
  final bool showDeliveryStatus;

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
    final String messageText = _getText().trim();

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

    final bool isMine = widget.forceLeft
        ? false
        : widget.currentUserId != null
        ? _getSenderId() == widget.currentUserId
        : _getSenderId() != widget.companionId;

    final Alignment alignment = isMine
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final CrossAxisAlignment crossAxisAlignment = isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    final EdgeInsetsGeometry margin = EdgeInsets.only(
      left: isMine ? 60 : 0,
      right: isMine ? 0 : 60,
    );

    final Color bubbleColor = isMine
        ? colorScheme.surfaceContainerHigh
        : colorScheme.primaryContainer;

    final TextStyle messageTextStyle = isMine
        ? textScheme.label.copyWith(
            color: colorScheme.onSurface,
            fontSize: 14.5,
          )
        : textScheme.label.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontSize: 14.5,
          );

    final TextStyle metaTextStyle = messageTextStyle.copyWith(
      fontSize: (messageTextStyle.fontSize!) * 0.8,
      color: isMine
          ? messageTextStyle.color!.withAlpha(150)
          : colorScheme.onPrimaryContainer.withAlpha(150),
    );

    final BorderRadius borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMine ? 16 : 4),
      bottomRight: Radius.circular(isMine ? 4 : 16),
    );

    final String messageMarkdown = _getText().trim();
    final String timeText = _timeFormatter.format(_getCreatedAt());

    final Color selectionColor = isMine
        ? colorScheme.onSurface.withAlpha(80)
        : colorScheme.onPrimaryContainer.withAlpha(80);

    final Color linkColor = isMine
        ? colorScheme.primary
        : colorScheme.onPrimaryContainer;

    final double maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.7;

    return Listener(
      onPointerDown: _handlePointerDown,
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          child: IntrinsicWidth(
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
                  if (widget.sender != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.sender!,
                          style: textScheme.label.copyWith(
                            color: isMine
                                ? colorScheme.onSurface.withAlpha(200)
                                : colorScheme.onPrimaryContainer.withAlpha(230),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (messageMarkdown.isNotEmpty)
                    TextSelectionTheme(
                      data: TextSelectionThemeData(
                        selectionColor: selectionColor,
                      ),
                      child: AppMessageText(
                        data: messageMarkdown,
                        textStyle: messageTextStyle,
                        linkColor: linkColor,
                        onLinkTap: _onMessageLinkTap,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Spacer(),
                      if (_isEdited())
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            context.l10n.edited,
                            style: metaTextStyle,
                          ),
                        ),
                      Text(timeText, style: metaTextStyle),
                      if (widget.showDeliveryStatus && isMine) ...[
                        const SizedBox(width: 6),
                        if (_getDeliveryStatus() != null)
                          MessageDeliveryStatusIndicator(
                            deliveryStatus: _getDeliveryStatus()!,
                            color:
                                metaTextStyle.color ??
                                colorScheme.onSurface,
                            size: 14,
                          ),
                      ],
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

  String _getText() {
    final m = widget.message;
    if (m is PrivateMessage) return m.text;
    if (m is GroupMessage) return m.text;
    if (m is ChannelPublication) return m.text ?? '';
    return '';
  }

  String _getSenderId() {
    final m = widget.message;
    if (m is PrivateMessage) return m.senderId;
    if (m is GroupMessage) return m.senderId;
    if (m is ChannelPublication) return m.publishedById;
    return '';
  }

  DateTime _getCreatedAt() {
    final m = widget.message;
    if (m is PrivateMessage) return m.createdAt;
    if (m is GroupMessage) return m.createdAt;
    if (m is ChannelPublication) return m.createdAt;
    return DateTime.now();
  }

  bool _isEdited() {
    final m = widget.message;
    if (m is PrivateMessage) return m.editedAt != null;
    if (m is GroupMessage) return m.editedAt != null;
    if (m is ChannelPublication) return m.editedAt != null;
    return false;
  }

  MessageDeliveryStatus? _getDeliveryStatus() {
    final m = widget.message;
    if (m is PrivateMessage) return m.deliveryStatus;
    if (m is GroupMessage) return m.deliveryStatus;
    if (m is ChannelPublication) return m.deliveryStatus;
    return null;
  }

  void _onMessageLinkTap(Uri uri) async {
    final bool canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
