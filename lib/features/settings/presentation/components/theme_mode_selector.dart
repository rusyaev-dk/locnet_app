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
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final SettingsCubit settingsCubit = context.read<SettingsCubit>();

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
            l10n.themeModeSystem,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            l10n.deviceThemeMode,
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
            l10n.themeModeLight,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
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
            l10n.themeModeDark,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),

          dense: true,
        ),
      ],
    );
  }
}
