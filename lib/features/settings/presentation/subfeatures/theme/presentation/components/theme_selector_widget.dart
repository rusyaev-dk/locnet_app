import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/subfeatures/theme/presentation/components/theme_preview_colors.dart';

/// Theme type selector with name and color preview. Minimal tiles.
/// Used inside theme subfeature with [onThemeTypeSelected].
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: AppThemeType.values.map((AppThemeType type) {
        final bool isSelected = type == selectedThemeType;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _ThemeOptionTile(
            themeType: type,
            isSelected: isSelected,
            onTap: () => onThemeTypeSelected(type),
          ),
        );
      }).toList(),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.themeType,
    required this.isSelected,
    required this.onTap,
  });

  final AppThemeType themeType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final colors = themePreviewColors(themeType);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              _ColorPreview(colors: colors),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  themeType.label,
                  style: textScheme.subtitle.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, size: 18, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    const double size = 12;
    return SizedBox(
      width: size * 4 + 6,
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
