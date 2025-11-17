// theme_mode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({required this.selectedThemeMode, super.key});

  final ThemeMode selectedThemeMode;

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingsCubit = context.read<SettingsCubit>();
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Column(
      children: [
        RadioListTile<ThemeMode>(
          value: ThemeMode.system,
          groupValue: selectedThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              settingsCubit.changeThemeMode(newValue);
            }
          },
          title: Text(
            'System',
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            'Use device theme',
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          dense: true,
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.light,
          groupValue: selectedThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              settingsCubit.changeThemeMode(newValue);
            }
          },
          title: Text(
            'Light',
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            'Bright theme',
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          dense: true,
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: selectedThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              settingsCubit.changeThemeMode(newValue);
            }
          },
          title: Text(
            'Dark',
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            'Dark theme',
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          dense: true,
        ),
      ],
    );
  }
}
