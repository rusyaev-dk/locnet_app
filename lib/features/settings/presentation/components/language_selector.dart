// language_selector.dart
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

    return DropdownButtonFormField<Locale>(
      initialValue: _supportedLocales.firstWhere(
        (Locale locale) => locale.languageCode == selectedLocale.languageCode,
        orElse: () => selectedLocale,
      ),
      items: _supportedLocales
          .map(
            (Locale locale) => DropdownMenuItem<Locale>(
              value: locale,
              child: Text(
                _mapLocaleToLabel(locale),
                style: textScheme.label.copyWith(color: colorScheme.onSurface),
              ),
            ),
          )
          .toList(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          settingsCubit.changeLanguage(newLocale);
        }
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        labelStyle: textScheme.label.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dropdownColor: colorScheme.surface,
    );
  }
}
