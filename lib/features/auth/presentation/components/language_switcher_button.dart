import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/gen/gen.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final colorScheme = context.colorScheme;

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
      borderRadius: BorderRadius.circular(14),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
          color: colorScheme.surface.withOpacity(0.9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            currentIcon.svg(width: 20, height: 20),
            const SizedBox(width: 8),
            Text(currentCode.toUpperCase()),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 18),
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
