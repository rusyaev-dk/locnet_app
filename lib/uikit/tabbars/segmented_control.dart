import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Data for a single segment in [SegmentedControl].
class SegmentedControlSegment {
  const SegmentedControlSegment({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

/// A horizontal segmented control (tabbar) with animated indicator.
/// Use [segments] to define items and [selectedIndex] / [onSelected] for state.
/// Set [compact] to true for a smaller variant (e.g. under search fields).
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.onSelected,
    this.compact = false,
    super.key,
  });

  final List<SegmentedControlSegment> segments;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool compact;

  static const Duration _moveDuration = Duration(milliseconds: 260);
  static const Curve _moveCurve = Curves.easeOutCubic;

  Alignment _indicatorAlignment(int index, int count) {
    if (count <= 1) return Alignment.center;
    return Alignment(2 * index / (count - 1) - 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textScheme;
    final count = segments.length;
    if (count == 0) return const SizedBox.shrink();

    final double height = compact ? 40 : 52;
    final double padding = compact ? 3 : 4;
    final double gap = compact ? 2 : 4;
    final double containerRadius = compact ? 12 : 16;
    final double indicatorRadius = compact ? 8 : 12;
    final double iconSize = compact ? 16 : 20;
    final double fontSize = compact ? 13 : 15;
    final double iconGap = compact ? 6 : 8;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double segmentWidth =
            (constraints.maxWidth - (count - 1) * gap) / count;

        return Container(
          height: height,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(containerRadius),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: _moveDuration,
                curve: _moveCurve,
                alignment: _indicatorAlignment(selectedIndex, count),
                child: _SegmentIndicator(
                  width: segmentWidth,
                  borderRadius: indicatorRadius,
                ),
              ),
              Row(
                children: List.generate(
                  count,
                  (int index) => Expanded(
                    child: _SegmentButton(
                      title: segments[index].title,
                      icon: segments[index].icon,
                      isSelected: selectedIndex == index,
                      onPressed: () => onSelected(index),
                      textStyle: textTheme.label,
                      iconSize: iconSize,
                      fontSize: fontSize,
                      iconGap: iconGap,
                      borderRadius: indicatorRadius,
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
}

class _SegmentIndicator extends StatelessWidget {
  const _SegmentIndicator({required this.width, this.borderRadius = 12});

  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colorScheme.primary.withAlpha(0x14),
        border: Border.all(color: colorScheme.primary.withAlpha(0x3D)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: -6,
            offset: const Offset(0, 4),
            color: colorScheme.primary.withAlpha(0x22),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
    required this.textStyle,
    this.iconSize = 20,
    this.fontSize = 15,
    this.iconGap = 8,
    this.borderRadius = 12,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double iconSize;
  final double fontSize;
  final double iconGap;
  final double borderRadius;

  static const Duration _styleDuration = Duration(milliseconds: 220);
  static const Curve _styleCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle =
        textStyle ??
        Theme.of(context).textTheme.labelMedium ??
        const TextStyle();

    final Color targetForegroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Center(
        child: TweenAnimationBuilder<Color?>(
          duration: _styleDuration,
          curve: _styleCurve,
          tween: ColorTween(end: targetForegroundColor),
          builder: (BuildContext context, Color? animatedColor, Widget? child) {
            final Color resolvedColor = animatedColor ?? targetForegroundColor;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: resolvedColor),
                SizedBox(width: iconGap),
                Flexible(
                  child: TweenAnimationBuilder<double>(
                    duration: _styleDuration,
                    curve: _styleCurve,
                    tween: Tween<double>(end: isSelected ? 1.0 : 0.0),
                    builder: (BuildContext context, double t, Widget? child) {
                      final FontWeight fontWeight =
                          FontWeight.lerp(
                            FontWeight.w500,
                            FontWeight.w700,
                            t,
                          ) ??
                          FontWeight.w500;

                      return Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: baseStyle.copyWith(
                          color: resolvedColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
