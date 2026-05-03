import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// A settings row with an inline segmented selector (compact pill bar).
class SettingsSegmentedTile extends StatelessWidget {
  const SettingsSegmentedTile({
    required this.title,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: textScheme.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 10),
          if (options.isEmpty)
            const SizedBox.shrink()
          else
            SegmentedControl(
              compact: true,
              segments: [
                for (final String option in options)
                  SegmentedControlSegment(title: option),
              ],
              selectedIndex: selectedIndex.clamp(0, options.length - 1),
              onSelected: onSelected,
            ),
        ],
      ),
    );
  }
}
