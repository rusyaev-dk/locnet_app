import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';

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

  bool _canScrollBackward = false;
  bool _canScrollForward = false;

  static const double _imageTileSize = 80;
  static const double _fileTileWidth = 220;
  static const double _tileSpacing = 8;
  static const double _innerHorizontalPadding = 10;
  static const double _innerVerticalPadding = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollEdges);

    _files = List<UploadableFile>.from(widget.files);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollEdges();
    });
  }

  @override
  void didUpdateWidget(covariant MessageAttachmentsPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.files, widget.files)) {
      _files = List<UploadableFile>.from(widget.files);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateScrollEdges();
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateScrollEdges)
      ..dispose();
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

  void _updateScrollEdges() {
    if (!_scrollController.hasClients) {
      return;
    }

    final ScrollPosition position = _scrollController.position;

    final bool canScrollBackward = position.extentBefore > 0.5;
    final bool canScrollForward = position.extentAfter > 0.5;

    if (canScrollBackward != _canScrollBackward ||
        canScrollForward != _canScrollForward) {
      setState(() {
        _canScrollBackward = canScrollBackward;
        _canScrollForward = canScrollForward;
      });
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollEdges();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_files.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;

    final EdgeInsets innerPadding = EdgeInsets.only(
      left: _canScrollBackward ? 0 : _innerHorizontalPadding,
      right: _canScrollForward ? 0 : _innerHorizontalPadding,
      top: _innerVerticalPadding,
      bottom: _innerVerticalPadding,
    );

    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 180))],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 100,
        padding: innerPadding,
        decoration: BoxDecoration(color: colorScheme.surfaceBright),
        child: Listener(
          onPointerSignal: _handlePointerSignal,
          behavior: HitTestBehavior.opaque,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: true),
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: _files.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: _tileSpacing),
              itemBuilder: (BuildContext context, int index) {
                final UploadableFile file = _files[index];

                final double tileWidth =
                    file.fileType == UploadableFileType.image
                    ? _imageTileSize
                    : _fileTileWidth;
                const double tileHeight = _imageTileSize;

                return ReorderableAttachmentTile(
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

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _updateScrollEdges();
                    });
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
      ),
    );
  }
}
