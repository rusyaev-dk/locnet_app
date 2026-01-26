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

  IconData _mapLocaleToIcon(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return Icons.language;
      case 'en':
        return Icons.language;
      case 'uz':
        return Icons.language;
      default:
        return Icons.language;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final Locale value = _supportedLocales.firstWhere(
      (Locale locale) => locale.languageCode == selectedLocale.languageCode,
      orElse: () => selectedLocale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectInterfaceLanguage,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        LanguageList(
          selectedLocale: value,
          supportedLocales: _supportedLocales,
          onLocaleSelected: (Locale locale) {
            context.read<SettingsCubit>().changeLanguageCode(locale);
          },
          localeToLabel: _mapLocaleToLabel,
          localeToIcon: _mapLocaleToIcon,
        ),
      ],
    );
  }
}

class LanguageList extends StatelessWidget {
  const LanguageList({
    required this.selectedLocale,
    required this.supportedLocales,
    required this.onLocaleSelected,
    required this.localeToLabel,
    required this.localeToIcon,
    super.key,
  });

  final Locale selectedLocale;
  final List<Locale> supportedLocales;
  final ValueChanged<Locale> onLocaleSelected;
  final String Function(Locale) localeToLabel;
  final IconData Function(Locale) localeToIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: supportedLocales.asMap().entries.map((entry) {
          final int index = entry.key;
          final Locale locale = entry.value;
          final bool isSelected =
              locale.languageCode == selectedLocale.languageCode;
          final bool isLast = index == supportedLocales.length - 1;

          return Column(
            children: [
              _LanguageItem(
                locale: locale,
                isSelected: isSelected,
                onPressed: () => onLocaleSelected(locale),
                localeToLabel: localeToLabel,
                localeToIcon: localeToIcon,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 48,
                  color: colorScheme.outlineVariant,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  const _LanguageItem({
    required this.locale,
    required this.isSelected,
    required this.onPressed,
    required this.localeToLabel,
    required this.localeToIcon,
  });

  final Locale locale;
  final bool isSelected;
  final VoidCallback onPressed;
  final String Function(Locale) localeToLabel;
  final IconData Function(Locale) localeToIcon;

  static const Duration _styleDuration = Duration(milliseconds: 220);
  static const Curve _styleCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color targetIconColor =
        isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final Color targetTextColor =
        isSelected ? colorScheme.primary : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              TweenAnimationBuilder<Color?>(
                duration: _styleDuration,
                curve: _styleCurve,
                tween: ColorTween(end: targetIconColor),
                builder: (context, animatedColor, child) {
                  return Icon(
                    localeToIcon(locale),
                    size: 20,
                    color: animatedColor ?? targetIconColor,
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TweenAnimationBuilder<Color?>(
                  duration: _styleDuration,
                  curve: _styleCurve,
                  tween: ColorTween(end: targetTextColor),
                  builder: (context, animatedColor, child) {
                    return AnimatedDefaultTextStyle(
                      duration: _styleDuration,
                      curve: _styleCurve,
                      style: textScheme.label.copyWith(
                        color: animatedColor ?? targetTextColor,
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      child: Text(localeToLabel(locale)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              AnimatedOpacity(
                duration: _styleDuration,
                opacity: isSelected ? 1.0 : 0.0,
                child: Icon(
                  Icons.check_circle,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
