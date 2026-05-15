import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Data for a single segment in [SegmentedControl].
class SegmentedControlSegment {
  const SegmentedControlSegment({required this.title, this.icon, this.leading});

  final String title;

  /// Icon shown before the label in horizontal mode, or as leading in vertical
  /// mode when [leading] is not provided.
  final IconData? icon;

  /// Optional arbitrary leading widget (e.g. a color-swatch row).
  /// Takes priority over [icon] in vertical mode.
  final Widget? leading;
}

/// A segmented picker that adapts to its [axis].
///
/// **Horizontal** (default) — compact pill-style tab bar:
///   a `surfaceContainer` track with one sliding thumb
///   (`surfaceContainerHighest`) and animated label/icon colors.
///
/// **Vertical** — tile-list style matching the settings theme selector:
///   a column of full-width [InkWell] rows with an optional [leading] widget,
///   label text (primary color when selected) and a check-mark on the right.
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.onSelected,
    this.compact = false,
    this.axis = Axis.horizontal,
    super.key,
  });

  final List<SegmentedControlSegment> segments;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Enables a more compact sizing in horizontal mode.
  final bool compact;

  /// [Axis.horizontal] → pill tab bar, [Axis.vertical] → tile list.
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final count = segments.length;
    if (count == 0) return const SizedBox.shrink();

    if (axis == Axis.vertical) {
      return _VerticalSegmentedControl(
        segments: segments,
        selectedIndex: selectedIndex,
        onSelected: onSelected,
      );
    }

    // ── Horizontal pill track ─────────────────────────────────────────────
    final colorScheme = context.colorScheme;
    final double outerPadding = compact ? 2.0 : 2.5;
    final double outerRadius = compact ? 8.0 : 9.0;
    final double innerRadius = compact ? 6.0 : 7.0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(outerRadius),
      ),
      padding: EdgeInsets.all(outerPadding),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double segmentWidth = constraints.maxWidth / count;
          return Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              AnimatedPositionedDirectional(
                duration: _kSegmentSlideDuration,
                curve: _kSegmentSlideCurve,
                start: selectedIndex * segmentWidth,
                width: segmentWidth,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(innerRadius),
                  ),
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < count; i++)
                    Expanded(
                      child: _HorizontalSegmentCell(
                        title: segments[i].title,
                        icon: segments[i].icon,
                        isSelected: selectedIndex == i,
                        compact: compact,
                        onTap: () => onSelected(i),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

const Duration _kSegmentSlideDuration = Duration(milliseconds: 280);
const Curve _kSegmentSlideCurve = Curves.easeOutCubic;

// ── Vertical list ─────────────────────────────────────────────────────────────

class _VerticalSegmentedControl extends StatelessWidget {
  const _VerticalSegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<SegmentedControlSegment> segments;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < segments.length; i++)
          _VerticalSegmentTile(
            title: segments[i].title,
            icon: segments[i].icon,
            leading: segments[i].leading,
            isSelected: selectedIndex == i,
            isLast: i == segments.length - 1,
            onTap: () => onSelected(i),
          ),
      ],
    );
  }
}

class _VerticalSegmentTile extends StatelessWidget {
  const _VerticalSegmentTile({
    required this.title,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
    this.icon,
    this.leading,
  });

  final String title;
  final IconData? icon;
  final Widget? leading;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    Widget? resolvedLeading;
    if (leading != null) {
      resolvedLeading = leading;
    } else if (icon != null) {
      resolvedLeading = Icon(
        icon,
        size: 18,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                if (resolvedLeading != null) ...[
                  resolvedLeading,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: textScheme.subtitle.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Horizontal segment cell (thumb is animated separately in the track stack) ──

class _HorizontalSegmentCell extends StatelessWidget {
  const _HorizontalSegmentCell({
    required this.title,
    required this.isSelected,
    required this.compact,
    required this.onTap,
    this.icon,
  });

  final String title;
  final IconData? icon;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;

  static const Duration _duration = Duration(milliseconds: 220);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final double verticalPadding = compact ? 5.0 : 6.0;
    final double iconSize = compact ? 13.0 : 14.0;
    final double iconGap = compact ? 4.0 : 5.0;

    final Color selectedColor = colorScheme.onSurface;
    final Color unselectedColor = colorScheme.onSurfaceVariant;

    final ThemeData baseTheme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Center(
          child: AnimatedTheme(
            duration: _duration,
            curve: _curve,
            data: baseTheme.copyWith(
              iconTheme: IconThemeData(
                color: isSelected ? selectedColor : unselectedColor,
                size: iconSize,
              ),
            ),
            child: AnimatedDefaultTextStyle(
              duration: _duration,
              curve: _curve,
              style: textScheme.caption.copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: compact ? 12.5 : 13,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[Icon(icon), SizedBox(width: iconGap)],
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
