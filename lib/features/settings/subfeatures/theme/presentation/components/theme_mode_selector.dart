import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Theme mode selector (system / light / dark). Used inside theme subfeature.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    required this.selectedThemeMode,
    required this.onThemeModeSelected,
    super.key,
  });

  final ThemeMode selectedThemeMode;
  final ValueChanged<ThemeMode> onThemeModeSelected;

  static const List<ThemeMode> _segmentModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final selectedIndex = _segmentModes.indexOf(selectedThemeMode);
    final segments = [
      SegmentedControlSegment(
        title: l10n.themeModeSystem,
        icon: Icons.brightness_auto,
      ),
      SegmentedControlSegment(
        title: l10n.themeModeLight,
        icon: Icons.light_mode_outlined,
      ),
      SegmentedControlSegment(
        title: l10n.themeModeDark,
        icon: Icons.dark_mode_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.themeMode,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        SegmentedControl(
          segments: segments,
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onSelected: (int index) {
            onThemeModeSelected(_segmentModes[index]);
          },
        ),
      ],
    );
  }
}
