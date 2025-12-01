import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';

class MessageAttachmentsPreview extends StatefulWidget {
  const MessageAttachmentsPreview({
    required this.files,
    required this.onRemovePressed,
    required this.onOrderChanged,
    super.key,
  });

  final List<UploadableFile> files;
  final ValueChanged<UploadableFile> onRemovePressed;
  final ValueChanged<List<UploadableFile>> onOrderChanged;

  @override
  State<MessageAttachmentsPreview> createState() =>
      _MessageAttachmentsPreviewState();
}

class _MessageAttachmentsPreviewState extends State<MessageAttachmentsPreview> {
  late final ScrollController _scrollController;
  late List<UploadableFile> _files;
  int? _draggingIndex;

  static const double _imageTileSize = 80;
  static const double _fileTileWidth = 220;
  static const double _tileSpacing = 8;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _files = List<UploadableFile>.from(widget.files);
  }

  @override
  void didUpdateWidget(covariant MessageAttachmentsPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.files, widget.files)) {
      _files = List<UploadableFile>.from(widget.files);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent && _scrollController.hasClients) {
      final double targetOffset =
          (_scrollController.offset + event.scrollDelta.dy)
              .clamp(
                _scrollController.position.minScrollExtent,
                _scrollController.position.maxScrollExtent,
              )
              .toDouble();

      if (targetOffset != _scrollController.offset) {
        _scrollController.jumpTo(targetOffset);
      }
    }
  }

  void _reorder(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) {
      return;
    }

    setState(() {
      final UploadableFile moved = _files.removeAt(fromIndex);
      final int safeTo = toIndex.clamp(0, _files.length);
      _files.insert(safeTo, moved);
      _draggingIndex = safeTo;
    });

    widget.onOrderChanged(List<UploadableFile>.from(_files));
  }

  @override
  Widget build(BuildContext context) {
    if (_files.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.surfaceContainer.withAlpha(80)),
        ),
      ),
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        behavior: HitTestBehavior.opaque,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: _files.length,
            separatorBuilder: (_, __) => const SizedBox(width: _tileSpacing),
            itemBuilder: (BuildContext context, int index) {
              final UploadableFile file = _files[index];

              final double tileWidth = file.fileType == UploadableFileType.image
                  ? _imageTileSize
                  : _fileTileWidth;
              const double tileHeight = _imageTileSize;

              return _ReorderableAttachmentTile(
                key: ObjectKey(file),
                index: index,
                file: file,
                isDragging: _draggingIndex == index,
                width: tileWidth,
                height: tileHeight,
                onRemove: () {
                  setState(() {
                    _files.removeAt(index);
                  });
                  widget.onRemovePressed(file);
                  widget.onOrderChanged(List<UploadableFile>.from(_files));
                },
                onDragStarted: () {
                  setState(() {
                    _draggingIndex = index;
                  });
                },
                onDragEnded: () {
                  setState(() {
                    _draggingIndex = null;
                  });
                },
                onMoveOver: (int fromIndex) {
                  if (fromIndex != index) {
                    _reorder(fromIndex, index);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ReorderableAttachmentTile extends StatelessWidget {
  const _ReorderableAttachmentTile({
    required this.index,
    required this.file,
    required this.onRemove,
    required this.onMoveOver,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.isDragging,
    required this.width,
    required this.height,
    super.key,
  });

  final int index;
  final UploadableFile file;
  final VoidCallback onRemove;
  final ValueChanged<int> onMoveOver;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;
  final bool isDragging;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final Widget content = SizedBox(
      width: width,
      height: height,
      child: _AttachmentItem(file: file, onRemovePressed: (file) => onRemove()),
    );

    return DragTarget<int>(
      onWillAcceptWithDetails: (DragTargetDetails<int> details) {
        return details.data != index;
      },
      onAcceptWithDetails: (DragTargetDetails<int> details) {
        onMoveOver(details.data);
      },
      builder:
          (
            BuildContext context,
            List<int?> candidateData,
            List<dynamic> rejectedData,
          ) {
            final bool isHovered = candidateData.isNotEmpty;
            final double visualScale = isHovered ? 0.96 : 1.0;

            return MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Draggable<int>(
                data: index,
                onDragStarted: onDragStarted,
                onDragEnd: (_) => onDragEnded(),
                feedback: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: _AttachmentItem(
                      file: file,
                      onRemovePressed: (file) => onRemove(),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.35,
                  child: SizedBox(width: width, height: height, child: content),
                ),
                child: AnimatedScale(
                  scale: isDragging ? 0.92 : visualScale,
                  duration: const Duration(milliseconds: 120),
                  child: SizedBox(width: width, height: height, child: content),
                ),
              ),
            );
          },
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  const _AttachmentItem({required this.file, required this.onRemovePressed});

  final UploadableFile file;
  final ValueChanged<UploadableFile> onRemovePressed;

  @override
  Widget build(BuildContext context) {
    if (file.fileType == UploadableFileType.image) {
      return _ImagePreview(file: file, onRemovePressed: onRemovePressed);
    }

    return _GenericPreview(file: file, onRemovePressed: onRemovePressed);
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.file,
    required this.onRemovePressed,
  });

  final UploadableFile file;
  final ValueChanged<UploadableFile> onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Stack(
      children: [
        RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox.expand(
              child: Image.memory(
                Uint8List.fromList(file.bytes),
                fit: BoxFit.cover,
                gaplessPlayback: true,
                filterQuality: FilterQuality.low,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 2,
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => onRemovePressed(file),
              customBorder: const CircleBorder(),
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withAlpha(180),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 15,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _GenericPreview extends StatelessWidget {
  const _GenericPreview({required this.file, required this.onRemovePressed});

  final UploadableFile file;
  final ValueChanged<UploadableFile> onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_resolveIcon(file.fileType), color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              file.fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => onRemovePressed(file),
            child: Icon(
              Icons.close,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(UploadableFileType type) {
    switch (type) {
      case UploadableFileType.image:
        return Icons.image;
      case UploadableFileType.video:
        return Icons.videocam;
      case UploadableFileType.audio:
        return Icons.audiotrack;
      case UploadableFileType.doc:
        return Icons.description;
      case UploadableFileType.file:
        return Icons.insert_drive_file;
    }
  }
}
