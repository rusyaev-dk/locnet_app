import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

Future<void> showImageGalleryViewerModal({
  required BuildContext context,
  required List<String> imageUrls,
  required int initialIndex,
}) {
  if (imageUrls.isEmpty) {
    return Future<void>.value();
  }

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withAlpha(90),
    builder: (BuildContext context) {
      return _ImageGalleryViewer(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
      );
    },
  );
}

class _ImageGalleryViewer extends StatefulWidget {
  const _ImageGalleryViewer({
    required this.imageUrls,
    required this.initialIndex,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<_ImageGalleryViewer> createState() => _ImageGalleryViewerState();
}

class _ImageGalleryViewerState extends State<_ImageGalleryViewer> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int index) async {
    final int clamped = index.clamp(0, widget.imageUrls.length - 1);
    if (clamped == _currentIndex) {
      return;
    }
    await _pageController.animateToPage(
      clamped,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool multi = widget.imageUrls.length > 1;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ColoredBox(
        color: Colors.black.withAlpha(90),
        child: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: InteractiveViewer(
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrls[index],
                        fit: BoxFit.contain,
                        placeholder: (BuildContext context, String _) =>
                            const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget:
                            (BuildContext context, String _, Object _) {
                              return const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: SurfaceIconButton(
                  variant: SurfaceIconVariant.ghost,
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                  margin: EdgeInsets.zero,
                  foregroundColor: Colors.white,
                  tooltip: context.l10n.close,
                ),
              ),
              if (multi) ...[
                Positioned(
                  left: 4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _GalleryNavArrow(
                      icon: Icons.chevron_left_rounded,
                      enabled: _currentIndex > 0,
                      onPressed: () => _goToPage(_currentIndex - 1),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _GalleryNavArrow(
                      icon: Icons.chevron_right_rounded,
                      enabled: _currentIndex < widget.imageUrls.length - 1,
                      onPressed: () => _goToPage(_currentIndex + 1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${_currentIndex + 1} / ${widget.imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryNavArrow extends StatelessWidget {
  const _GalleryNavArrow({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(110),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: SizedBox(
          width: 44,
          height: 52,
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.white.withAlpha(90),
            size: 32,
          ),
        ),
      ),
    );
  }
}
