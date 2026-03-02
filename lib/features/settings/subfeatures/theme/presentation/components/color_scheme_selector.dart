import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/theme_preview_colors.dart';

/// Section: color scheme (Default, Blue, Green, Purple). Compact cards.
class ColorSchemeSelector extends StatelessWidget {
  const ColorSchemeSelector({
    required this.selectedAccentIndex,
    required this.onAccentSelected,
    super.key,
  });

  final int selectedAccentIndex;
  final ValueChanged<int> onAccentSelected;

  static const int _accentCount = 4;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final labels = [
      l10n.colorSchemeDefault,
      l10n.colorSchemeBlue,
      l10n.colorSchemeGreen,
      l10n.colorSchemePurple,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.colorSchemeTitle,
          style: textScheme.label.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const double gap = 10;

            return Row(
              children: List.generate(_accentCount, (int index) {
                final isSelected = index == selectedAccentIndex;
                final accentColor = themeAccentColor(index);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < _accentCount - 1 ? gap : 0,
                    ),
                    child: _ColorSchemeCard(
                      label: labels[index],
                      accentColor: accentColor,
                      isSelected: isSelected,
                      onTap: () => onAccentSelected(index),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class _ColorSchemeCard extends StatelessWidget {
  const _ColorSchemeCard({
    required this.label,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withAlpha(0x80),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? colorScheme.primaryContainer.withAlpha(0x40)
                : colorScheme.surfaceContainerLow.withAlpha(0x60),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(0xDD),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withAlpha(0x44),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textScheme.label.copyWith(
                  fontSize: 12,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
