import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class ThemeModeSelectorChips extends StatelessWidget {
  const ThemeModeSelectorChips({required this.selectedThemeMode, super.key});

  final ThemeMode selectedThemeMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _ThemeModeChip(
          label: l10n.themeModeSystem,
          icon: Icons.brightness_auto,
          isSelected: selectedThemeMode == ThemeMode.system,
          onTap: () =>
              context.read<SettingsCubit>().changeThemeMode(ThemeMode.system),
        ),
        _ThemeModeChip(
          label: l10n.themeModeLight,
          icon: Icons.light_mode_outlined,
          isSelected: selectedThemeMode == ThemeMode.light,
          onTap: () =>
              context.read<SettingsCubit>().changeThemeMode(ThemeMode.light),
        ),
        _ThemeModeChip(
          label: l10n.themeModeDark,
          icon: Icons.dark_mode_outlined,
          isSelected: selectedThemeMode == ThemeMode.dark,
          onTap: () =>
              context.read<SettingsCubit>().changeThemeMode(ThemeMode.dark),
        ),
      ],
    );
  }
}

class _ThemeModeChip extends StatelessWidget {
  const _ThemeModeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color backgroundColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.14)
        : colorScheme.surface;

    final Color borderColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.55)
        : colorScheme.outlineVariant;

    final Color foregroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface;

    final Color iconColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: textScheme.label.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
