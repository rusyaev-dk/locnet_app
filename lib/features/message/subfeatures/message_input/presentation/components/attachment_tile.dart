
import 'package:flutter/material.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';

class ReorderableAttachmentTile extends StatelessWidget {
  const ReorderableAttachmentTile({
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
      child: AttachmentItem(file: file, onRemovePressed: (file) => onRemove()),
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
                    child: AttachmentItem(
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

