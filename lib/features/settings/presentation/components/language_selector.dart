import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/blocs/settings_cubit/settings_cubit.dart';
import 'package:locnet_app/uikit/uikit.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.selectedLocale,
    super.key,
    this.onLocaleSelected,
  });

  final Locale selectedLocale;
  final ValueChanged<Locale>? onLocaleSelected;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  static String labelForLanguageCode(String? code) {
    return labelForLocale(
      Locale(normalizeLanguageCode(code)),
    );
  }

  static String labelForLocale(Locale locale) {
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

  int _selectedIndex(Locale current) {
    final int i = supportedLocales.indexWhere(
      (Locale l) => l.languageCode == current.languageCode,
    );
    return i >= 0 ? i : 0;
  }

  @override
  Widget build(BuildContext context) {
    final Locale resolved = supportedLocales.firstWhere(
      (Locale locale) => locale.languageCode == selectedLocale.languageCode,
      orElse: () => supportedLocales.first,
    );

    return SegmentedControl(
      axis: Axis.vertical,
      segments: [
        for (final Locale locale in supportedLocales)
          SegmentedControlSegment(title: labelForLocale(locale)),
      ],
      selectedIndex: _selectedIndex(resolved),
      onSelected: (int index) {
        final Locale locale = supportedLocales[index];
        if (onLocaleSelected != null) {
          onLocaleSelected!(locale);
        } else {
          context.read<SettingsCubit>().changeLanguageCode(locale);
        }
      },
    );
  }
}
