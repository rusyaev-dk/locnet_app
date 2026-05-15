import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/gen/gen.dart';

/// Compact language control aligned with auth cards (outline + surface container).
class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final radii = context.radii;

    Locale? currentLocale;
    if (settingsState is SettingsLoadedState) {
      currentLocale = settingsState.locale;
    }

    final String currentCode = (currentLocale?.languageCode ?? 'en')
        .toLowerCase();
    final SvgGenImage currentIcon = LocaleIconRegistry.iconFor(currentCode);

    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) async {
        await context.read<SettingsCubit>().changeLanguageCode(locale);
      },
      borderRadius: radii.defaultRadiusValue,
      itemBuilder: (BuildContext context) {
        return const <PopupMenuEntry<Locale>>[
          PopupMenuItem<Locale>(
            value: Locale('uz'),
            child: _LocaleMenuItemRow(code: 'uz', label: 'Oʻzbekcha'),
          ),
          PopupMenuItem<Locale>(
            value: Locale('ru'),
            child: _LocaleMenuItemRow(code: 'ru', label: 'Русский'),
          ),
          PopupMenuItem<Locale>(
            value: Locale('en'),
            child: _LocaleMenuItemRow(code: 'en', label: 'English'),
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: radii.defaultRadiusValue,
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            currentIcon.svg(width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              currentCode.toUpperCase(),
              style: textScheme.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _LocaleMenuItemRow extends StatelessWidget {
  const _LocaleMenuItemRow({required this.code, required this.label});

  final String code;
  final String label;

  @override
  Widget build(BuildContext context) {
    final SvgGenImage icon = LocaleIconRegistry.iconFor(code);

    return Row(
      children: [
        icon.svg(width: 20, height: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
