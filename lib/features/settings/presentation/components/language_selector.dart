import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({required this.selectedLocale, super.key});

  final Locale selectedLocale;

  List<Locale> get _supportedLocales {
    return <Locale>[const Locale('en'), const Locale('ru'), const Locale('uz')];
  }

  String _mapLocaleToLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'uz':
        return "O'zbek";
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingsCubit = context.read<SettingsCubit>();
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    const double borderRadiusValue = 16;
    final BorderRadius borderRadius = BorderRadius.circular(borderRadiusValue);

    final Locale value = _supportedLocales.firstWhere(
      (Locale locale) => locale.languageCode == selectedLocale.languageCode,
      orElse: () => selectedLocale,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: borderRadius,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<Locale>(
                isExpanded: true,
                value: value,
                borderRadius: borderRadius,
                dropdownColor: colorScheme.surface,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                style: textScheme.label.copyWith(color: colorScheme.onSurface),
                items: _supportedLocales
                    .map(
                      (Locale locale) => DropdownMenuItem<Locale>(
                        value: locale,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(_mapLocaleToLabel(locale)),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    settingsCubit.changeLanguageCode(newLocale);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
