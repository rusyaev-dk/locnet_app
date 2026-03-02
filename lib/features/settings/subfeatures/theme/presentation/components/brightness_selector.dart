import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Section: light or dark theme (two options).
class BrightnessSelector extends StatelessWidget {
  const BrightnessSelector({
    required this.isLight,
    required this.onBrightnessChanged,
    super.key,
  });

  final bool isLight;
  final ValueChanged<bool> onBrightnessChanged;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.brightnessTitle,
          style: textScheme.label.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SegmentedControl(
          segments: [
            SegmentedControlSegment(
              title: l10n.themeModeLight,
              icon: Icons.light_mode_outlined,
            ),
            SegmentedControlSegment(
              title: l10n.themeModeDark,
              icon: Icons.dark_mode_outlined,
            ),
          ],
          selectedIndex: isLight ? 0 : 1,
          onSelected: (index) {
            onBrightnessChanged(index == 0);
          },
        ),
      ],
    );
  }
}
