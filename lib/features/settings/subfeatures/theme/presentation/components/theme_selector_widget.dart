import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/theme_preview_colors.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Vertical list of selectable theme types with a colour-swatch leading widget.
/// Delegates rendering to [SegmentedControl] with [Axis.vertical].
class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({
    required this.selectedThemeType,
    required this.onThemeTypeSelected,
    super.key,
  });

  final AppThemeType selectedThemeType;
  final ValueChanged<AppThemeType> onThemeTypeSelected;

  @override
  Widget build(BuildContext context) {
    const types = AppThemeType.values;

    return SegmentedControl(
      axis: Axis.vertical,
      selectedIndex: types.indexOf(selectedThemeType),
      onSelected: (int i) => onThemeTypeSelected(types[i]),
      segments: types
          .map(
            (AppThemeType type) => SegmentedControlSegment(
              title: type.label,
              leading: _ColorSwatches(colors: themePreviewColors(type)),
            ),
          )
          .toList(),
    );
  }
}

/// Four small colour circles representing a theme's palette.
class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    const double size = 12;
    return SizedBox(
      width: size * colors.length + (colors.length - 1) * 2,
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          colors.length,
          (int i) => Container(
            width: size,
            height: size,
            margin: EdgeInsets.only(right: i < colors.length - 1 ? 2 : 0),
            decoration: BoxDecoration(
              color: colors[i],
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colorScheme.outline.withAlpha(0x80),
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
