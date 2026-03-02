import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Data for a single segment in [SegmentedControl].
class SegmentedControlSegment {
  const SegmentedControlSegment({
    required this.title,
    this.icon,
    this.leading,
  });

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
///   a `surfaceContainer` pill track with an `AnimatedContainer` indicator
///   per segment.
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
    final double outerPadding = compact ? 3.0 : 4.0;
    final double outerRadius = compact ? 10.0 : 12.0;
    final double innerRadius = compact ? 7.0 : 9.0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(outerRadius),
      ),
      padding: EdgeInsets.all(outerPadding),
      child: Row(
        children: [
          for (int i = 0; i < count; i++)
            Expanded(
              child: _HorizontalSegmentButton(
                title: segments[i].title,
                icon: segments[i].icon,
                isSelected: selectedIndex == i,
                compact: compact,
                innerRadius: innerRadius,
                onTap: () => onSelected(i),
              ),
            ),
        ],
      ),
    );
  }
}

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
        color: isSelected
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
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
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_rounded, size: 18, color: colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Horizontal pill button ────────────────────────────────────────────────────

class _HorizontalSegmentButton extends StatelessWidget {
  const _HorizontalSegmentButton({
    required this.title,
    required this.isSelected,
    required this.compact,
    required this.innerRadius,
    required this.onTap,
    this.icon,
  });

  final String title;
  final IconData? icon;
  final bool isSelected;
  final bool compact;
  final double innerRadius;
  final VoidCallback onTap;

  static const Duration _duration = Duration(milliseconds: 160);
  static const Curve _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final double verticalPadding = compact ? 7.0 : 9.0;
    final double iconSize = compact ? 14.0 : 16.0;
    final double iconGap = compact ? 5.0 : 6.0;

    final Color selectedColor = colorScheme.onSurface;
    final Color unselectedColor = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.surfaceContainerHighest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(innerRadius),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: _duration,
            curve: _curve,
            style: textScheme.caption.copyWith(
              color: isSelected ? selectedColor : unselectedColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: iconSize,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  SizedBox(width: iconGap),
                ],
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
    );
  }
}
