import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Circular avatar crop — body for [AppModalCard] / `showGeneralDialog`.
///
/// Returns [Uint8List] (PNG bytes of the cropped circle) on confirm,
/// or `null` if the user cancels.
class AvatarCropModal extends StatefulWidget {
  const AvatarCropModal({required this.imageBytes, super.key});

  final Uint8List imageBytes;

  @override
  State<AvatarCropModal> createState() => _AvatarCropModalState();
}

class _AvatarCropModalState extends State<AvatarCropModal> {
  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformController =
      TransformationController();

  bool _isProcessing = false;

  /// Natural pixel size of the picked image (null until decoded).
  int? _imageWidth;
  int? _imageHeight;

  /// Inner diameter of the circular viewport (crop preview).
  static const double _diameter = 236;

  @override
  void initState() {
    super.initState();
    _decodeImageSize();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _decodeImageSize() async {
    try {
      final ui.Codec codec = await ui.instantiateImageCodec(widget.imageBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;
      final int w = image.width;
      final int h = image.height;
      image.dispose();
      codec.dispose();
      if (!mounted) return;
      setState(() {
        _imageWidth = w;
        _imageHeight = h;
      });
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  /// Size of the image layer such that it **covers** [_diameter]×[_diameter]
  /// without distortion (same as BoxFit.cover for this aspect ratio).
  Size _coverLayerSize(int iw, int ih) {
    final double scale = math.max(_diameter / iw, _diameter / ih);
    return Size(iw * scale, ih * scale);
  }

  /// Minimum scale so the user can zoom out slightly past “cover” when useful.
  double _minScale(double layerW, double layerH) {
    final double raw = math.min(_diameter / layerW, _diameter / layerH);
    return raw.clamp(0.35, 1.0);
  }

  Future<void> _onConfirm() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final RenderRepaintBoundary boundary = _cropKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      image.dispose();

      if (!mounted) return;
      final Uint8List? bytes = byteData?.buffer.asUint8List();
      Navigator.of(context).pop(bytes);
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _onCancel() => Navigator.of(context).pop();

  Widget _buildCropViewport(BuildContext context) {
    final scheme = context.colorScheme;
    if (_imageWidth == null || _imageHeight == null) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: scheme.primary,
            ),
          ),
        ),
      );
    }
    final Size layer = _coverLayerSize(_imageWidth!, _imageHeight!);
    return _CropInteractiveContent(
      cropKey: _cropKey,
      diameter: _diameter,
      imageBytes: widget.imageBytes,
      layerSize: layer,
      minScale: _minScale(layer.width, layer.height),
      transformController: _transformController,
      borderColor: scheme.primary.withValues(alpha: 0.75),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AvatarCropModalHeader(
          title: context.l10n.profileCropPhoto,
          onClose: () {
            if (_isProcessing) return;
            _onCancel();
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text(
            context.l10n.profileCropPhotoHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.3,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: SizedBox(
              width: _diameter,
              height: _diameter,
              child: _buildCropViewport(context),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colorScheme.outline)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isProcessing ? null : _onCancel,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                child: Text(context.l10n.cancel),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _isProcessing ? null : _onConfirm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.apply),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarCropModalHeader extends StatelessWidget {
  const _AvatarCropModalHeader({
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
          ),
          SurfaceIconButton(
            icon: Icons.close,
            dimension: 32,
            iconSize: 18,
            margin: EdgeInsets.zero,
            foregroundColor: colorScheme.onSurfaceVariant,
            tooltip: l10n.close,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _CropInteractiveContent extends StatelessWidget {
  const _CropInteractiveContent({
    required this.cropKey,
    required this.diameter,
    required this.imageBytes,
    required this.layerSize,
    required this.minScale,
    required this.transformController,
    required this.borderColor,
  });

  final GlobalKey cropKey;
  final double diameter;
  final Uint8List imageBytes;
  final Size layerSize;
  final double minScale;
  final TransformationController transformController;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          key: cropKey,
          child: ClipOval(
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                width: diameter,
                height: diameter,
                child: InteractiveViewer(
                  transformationController: transformController,
                  minScale: minScale,
                  maxScale: 5,
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(160),
                  child: SizedBox(
                    width: layerSize.width,
                    height: layerSize.height,
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      width: layerSize.width,
                      height: layerSize.height,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        IgnorePointer(
          child: CustomPaint(
            size: Size(diameter, diameter),
            painter: _CircleMaskPainter(borderColor: borderColor),
          ),
        ),
      ],
    );
  }
}

/// Semi-transparent overlay outside the circle + ring on the hole edge.
class _CircleMaskPainter extends CustomPainter {
  const _CircleMaskPainter({required this.borderColor});

  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect fullRect = Offset.zero & size;

    final Path outer = Path()..addRect(fullRect);
    final Path hole = Path()..addOval(fullRect);
    final Path mask = Path.combine(PathOperation.difference, outer, hole);

    canvas
      ..drawPath(
        mask,
        Paint()..color = Colors.black.withValues(alpha: 0.52),
      )
      ..drawOval(
        fullRect,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
  }

  @override
  bool shouldRepaint(_CircleMaskPainter old) =>
      old.borderColor != borderColor;
}
