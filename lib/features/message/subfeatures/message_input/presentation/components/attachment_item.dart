import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';

class AttachmentItem extends StatelessWidget {
  const AttachmentItem({
    required this.file,
    required this.onRemovePressed,
    super.key,
  });

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
  const _ImagePreview({required this.file, required this.onRemovePressed});

  final UploadableFile file;
  final ValueChanged<UploadableFile> onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final radii = context.radii;
    final BorderRadius removeRadius = radii.smallRadius;

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
            borderRadius: removeRadius,
            child: InkWell(
              onTap: () => onRemovePressed(file),
              borderRadius: removeRadius,
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withAlpha(180),
                  borderRadius: removeRadius,
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
    final radii = context.radii;

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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onRemovePressed(file),
              borderRadius: radii.smallRadius,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
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
