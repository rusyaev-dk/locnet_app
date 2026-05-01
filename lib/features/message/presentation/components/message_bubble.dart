import 'dart:math' show min;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/media_viewer/media_viewer.dart';
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
    this.replyPreviewText,
    this.replyPreviewAuthor,
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
  final String? replyPreviewText;
  final String? replyPreviewAuthor;

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
  final Map<String, Future<MediaDownloadInfo>> _downloadInfoCache =
      <String, Future<MediaDownloadInfo>>{};

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

    final Color bubbleColor = isMine
        ? colorScheme.primary
        : colorScheme.secondary;

    final TextStyle messageTextStyle = isMine
        ? textScheme.label.copyWith(
            color: Colors.white,
            fontSize: 14.5,
          )
        : textScheme.label.copyWith(
            color: colorScheme.onSurface,
            fontSize: 14.5,
          );

    final TextStyle metaTextStyle = messageTextStyle.copyWith(
      fontSize: 10,
      color: isMine
          ? Colors.white.withAlpha(170)
          : colorScheme.onSurfaceVariant,
    );

    final BorderRadius borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMine ? 16 : 4),
      bottomRight: Radius.circular(isMine ? 4 : 16),
    );

    final String messageMarkdown = _getText().trim();
    final String timeText = _timeFormatter.format(_getCreatedAt());
    final String replyPreviewText = (widget.replyPreviewText ?? '').trim();
    final String? replyPreviewAuthor = widget.replyPreviewAuthor;
    final bool hasReplyPreview = replyPreviewText.isNotEmpty;

    final Color selectionColor = isMine
        ? Colors.white.withAlpha(80)
        : colorScheme.primary.withAlpha(80);

    final Color linkColor = isMine
        ? Colors.white.withAlpha(220)
        : colorScheme.primary;

    return Listener(
      onPointerDown: _handlePointerDown,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = MediaQuery.sizeOf(context).width;
          final double laneWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : screenWidth;
          final double maxBubbleWidth = min(laneWidth, laneWidth * 0.62);

          return Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: borderRadius,
                    border: isMine
                        ? null
                        : Border.all(color: colorScheme.outline, width: 1),
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
                                    ? Colors.white.withAlpha(200)
                                    : colorScheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if (hasReplyPreview)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isMine
                                ? Colors.white.withAlpha(20)
                                : colorScheme.onSurface.withAlpha(14),
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(
                                color: isMine
                                    ? Colors.white.withAlpha(180)
                                    : colorScheme.primary,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (replyPreviewAuthor != null &&
                                  replyPreviewAuthor.trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    replyPreviewAuthor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: messageTextStyle.copyWith(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              Text(
                                replyPreviewText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: messageTextStyle.copyWith(
                                  fontSize: 12.5,
                                  color:
                                      (messageTextStyle.color ??
                                              colorScheme.onSurface)
                                          .withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                        ),
                      _buildMessageContent(
                        messageMarkdown: messageMarkdown,
                        selectionColor: selectionColor,
                        messageTextStyle: messageTextStyle,
                        linkColor: linkColor,
                        maxBubbleWidth: maxBubbleWidth,
                        laneWidth: laneWidth,
                        isMine: isMine,
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                                  isRead: _isReadByCompanion(),
                                  color:
                                      metaTextStyle.color ??
                                      colorScheme.onSurface,
                                  size: 14,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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

  bool _isReadByCompanion() {
    final Object m = widget.message;
    if (m is PrivateMessage) {
      return m.readAt != null;
    }
    return false;
  }

  bool _hasAttachments() {
    final Object m = widget.message;
    if (m is PrivateMessage) {
      return m.attachments.isNotEmpty;
    }
    return false;
  }

  Widget _buildMessageContent({
    required String messageMarkdown,
    required Color selectionColor,
    required TextStyle messageTextStyle,
    required Color linkColor,
    required double maxBubbleWidth,
    required double laneWidth,
    required bool isMine,
  }) {
    final bool hasAttachments = _hasAttachments();
    final bool hasText = messageMarkdown.isNotEmpty;
    final Widget? messageText = hasText
        ? TextSelectionTheme(
            data: TextSelectionThemeData(selectionColor: selectionColor),
            child: AppMessageText(
              data: messageMarkdown,
              textStyle: messageTextStyle,
              linkColor: linkColor,
              onLinkTap: _onMessageLinkTap,
            ),
          )
        : null;

    if (!hasAttachments) {
      return messageText ?? const SizedBox.shrink();
    }

    final Widget attachments = _buildAttachments(
      messageTextStyle: messageTextStyle,
      maxBubbleWidth: maxBubbleWidth,
      laneWidth: laneWidth,
      isMine: isMine,
    );

    if (!hasText) {
      return attachments;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [attachments, const SizedBox(height: 6), messageText!],
    );
  }

  Widget _buildAttachments({
    required TextStyle messageTextStyle,
    required double maxBubbleWidth,
    required double laneWidth,
    required bool isMine,
  }) {
    final Object m = widget.message;
    if (m is! PrivateMessage || m.attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<MediaDownloadInfo>>(
      future: Future.wait(
        m.attachments
            .map(
              (PrivateMessageAttachment attachment) => _resolveDownloadInfo(
                mediaId: attachment.fileId,
                conversationId: m.conversationId,
              ),
            )
            .toList(growable: false),
      ),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<MediaDownloadInfo>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Failed to load attachment',
                  style: messageTextStyle.copyWith(fontSize: 12.5),
                ),
              );
            }

            final List<_AttachmentViewData> items = <_AttachmentViewData>[];
            for (int index = 0; index < m.attachments.length; index++) {
              final PrivateMessageAttachment attachment = m.attachments[index];
              final MediaDownloadInfo info = snapshot.data![index];
              final String kind = attachment.fileType ?? info.mimeType;
              items.add(
                _AttachmentViewData(
                  mediaId: attachment.fileId,
                  kind: kind,
                  url: info.downloadUrl,
                ),
              );
            }

            final double maxAttachmentWidth = (laneWidth * 0.6).clamp(
              160.0,
              maxBubbleWidth,
            );

            return Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxAttachmentWidth),
                child: _AttachmentsGrid(
                  items: items,
                  onTap: (int index) {
                    final _AttachmentViewData item = items[index];
                    if (item.isImage) {
                      final List<String> imageUrls = items
                          .where((_AttachmentViewData entry) => entry.isImage)
                          .map((_AttachmentViewData entry) => entry.url)
                          .toList(growable: false);
                      final int initialImageIndex = imageUrls.indexOf(item.url);
                      _openImageViewer(
                        imageUrls: imageUrls,
                        initialIndex: initialImageIndex >= 0
                            ? initialImageIndex
                            : 0,
                      );
                      return;
                    }
                    if (item.isVideo) {
                      _openVideoPlayer(item.url);
                      return;
                    }
                  },
                ),
              ),
            );
          },
    );
  }

  void _openImageViewer({
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    if (imageUrls.isEmpty) {
      return;
    }
    showImageGalleryViewerModal(
      context: context,
      imageUrls: imageUrls,
      initialIndex: initialIndex,
    );
  }

  void _openVideoPlayer(String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return MessageVideoPlayerScreen(videoUrl: videoUrl);
        },
      ),
    );
  }

  Future<MediaDownloadInfo> _resolveDownloadInfo({
    required String mediaId,
    required String conversationId,
  }) {
    return _downloadInfoCache.putIfAbsent(mediaId, () {
      return context.read<MediaInteractor>().getDownloadInfo(
        mediaId: mediaId,
        scope: 'private_conversation',
        scopeId: conversationId,
      );
    });
  }

  void _onMessageLinkTap(Uri uri) async {
    final bool canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

final class _AttachmentViewData {
  const _AttachmentViewData({
    required this.mediaId,
    required this.kind,
    required this.url,
  });

  final String mediaId;
  final String kind;
  final String url;

  bool get isImage => kind.startsWith('image');
  bool get isVideo => kind.startsWith('video');
}

class _AttachmentsGrid extends StatelessWidget {
  const _AttachmentsGrid({required this.items, required this.onTap});

  final List<_AttachmentViewData> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (items.length == 1) {
      return _AttachmentTile(
        item: items.first,
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(0),
      );
    }

    if (items.length == 2) {
      return Row(
        children: [
          Expanded(
            child: _AttachmentTile(
              item: items[0],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              onTap: () => onTap(0),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: _AttachmentTile(
              item: items[1],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              onTap: () => onTap(1),
            ),
          ),
        ],
      );
    }

    if (items.length == 3) {
      return Column(
        children: [
          _AttachmentTile(
            item: items[0],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            onTap: () => onTap(0),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: _AttachmentTile(
                  item: items[1],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                  onTap: () => onTap(1),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: _AttachmentTile(
                  item: items[2],
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  ),
                  onTap: () => onTap(2),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AttachmentTile(
                item: items[0],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                ),
                onTap: () => onTap(0),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _AttachmentTile(
                item: items[1],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
                onTap: () => onTap(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: _AttachmentTile(
                item: items[2],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
                onTap: () => onTap(2),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _AttachmentTile(
                item: items[3],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
                onTap: () => onTap(3),
                overlayText: items.length > 4 ? '+${items.length - 4}' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.item,
    required this.borderRadius,
    required this.onTap,
    this.overlayText,
  });

  final _AttachmentViewData item;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final String? overlayText;

  @override
  Widget build(BuildContext context) {
    final bool isVideo = item.isVideo;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: item.url,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String _) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (BuildContext context, String _, Object _) =>
                      const Center(child: Icon(Icons.broken_image_outlined)),
                ),
                if (isVideo)
                  Center(
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(140),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                if (overlayText != null)
                  ColoredBox(
                    color: Colors.black.withAlpha(120),
                    child: Center(
                      child: Text(
                        overlayText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
