import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/theme_preview_colors.dart';
import 'package:locnet_app/uikit/tokens/app_radii.dart';

/// Ten accent presets (0–9); compact trigger opens an anchored palette grid.
class ColorSchemeSelector extends StatefulWidget {
  const ColorSchemeSelector({
    required this.selectedAccentIndex,
    required this.onAccentSelected,
    super.key,
  });

  final int selectedAccentIndex;
  final ValueChanged<int> onAccentSelected;

  @override
  State<ColorSchemeSelector> createState() => _ColorSchemeSelectorState();
}

class _ColorSchemeSelectorState extends State<ColorSchemeSelector> {
  final GlobalKey _anchorKey = GlobalKey();

  static const List<int> _accents = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  int get _effectiveSelection {
    final i = widget.selectedAccentIndex;
    if (i >= 0 && i <= 9) return i;
    return 0;
  }

  Future<void> _openPalette() async {
    final BuildContext ctx = context;
    final renderObject = _anchorKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final NavigatorState nav = Navigator.of(ctx);
    final RenderBox overlay =
        nav.overlay!.context.findRenderObject()! as RenderBox;

    final Rect anchorRect = Rect.fromPoints(
      renderObject.localToGlobal(Offset.zero, ancestor: overlay),
      renderObject.localToGlobal(
        renderObject.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    );

    final Size overlaySize = overlay.size;
    const double paletteWidth = 272;
    double left = anchorRect.left + (anchorRect.width - paletteWidth) / 2;
    left = left.clamp(8.0, overlaySize.width - paletteWidth - 8);
    final double top = anchorRect.bottom + 6;

    await showGeneralDialog<void>(
      context: ctx,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(ctx).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        final radii =
            Theme.of(dialogContext).extension<AppRadii>() ?? AppRadii.standard();

        return SizedBox.expand(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(dialogContext),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.black.withValues(alpha: 0.35),
                    color: colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: radii.largeRadius,
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withAlpha(0xAA),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: SizedBox(
                        width: paletteWidth - 24,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final int idx in _accents)
                              _PaletteDot(
                                color: themeAccentColor(idx),
                                selected: _effectiveSelection == idx,
                                diameter: 30,
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                  widget.onAccentSelected(idx);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final radii = context.radii;

    return Semantics(
      button: true,
      label: context.l10n.colorSchemeTitle,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: _anchorKey,
          onTap: _openPalette,
          borderRadius: radii.largeRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final int idx in _accents)
                        _MiniDot(
                          color: themeAccentColor(idx),
                          selected: _effectiveSelection == idx,
                          diameter: 17,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniDot extends StatelessWidget {
  const _MiniDot({
    required this.color,
    required this.selected,
    this.diameter = 22,
  });

  final Color color;
  final bool selected;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final double inset = (diameter * 0.18).clamp(2.0, 4.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(0x44),
            blurRadius: selected ? 6 : 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(inset),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(0xEE),
          ),
        ),
      ),
    );
  }
}

class _PaletteDot extends StatelessWidget {
  const _PaletteDot({
    required this.color,
    required this.selected,
    required this.onTap,
    this.diameter = 34,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Ink(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(0x55),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
