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
        LanguageSegmentedControl(
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

class LanguageSegmentedControl extends StatelessWidget {
  const LanguageSegmentedControl({
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

  static const Duration _moveDuration = Duration(milliseconds: 260);
  static const Curve _moveCurve = Curves.easeOutCubic;

  Alignment _getIndicatorAlignment(Locale locale) {
    final int index = supportedLocales.indexWhere(
      (l) => l.languageCode == locale.languageCode,
    );
    if (index == -1) return Alignment.centerLeft;

    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final Alignment indicatorAlignment = _getIndicatorAlignment(selectedLocale);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double segmentWidth = (constraints.maxWidth - 8) / 3;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: _moveDuration,
                curve: _moveCurve,
                alignment: indicatorAlignment,
                child: _SegmentIndicator(width: segmentWidth),
              ),
              Row(
                children: supportedLocales.map((locale) {
                  final bool isSelected =
                      locale.languageCode == selectedLocale.languageCode;
                  return Expanded(
                    child: _SegmentButton(
                      title: localeToLabel(locale),
                      icon: localeToIcon(locale),
                      isSelected: isSelected,
                      onPressed: () => onLocaleSelected(locale),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentIndicator extends StatelessWidget {
  const _SegmentIndicator({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.primary.withAlpha(0x14),
        border: Border.all(color: colorScheme.primary.withAlpha(0x3D)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: -6,
            offset: const Offset(0, 4),
            color: colorScheme.primary.withAlpha(0x22),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  static const Duration _styleDuration = Duration(milliseconds: 220);
  static const Curve _styleCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color targetForegroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: TweenAnimationBuilder<Color?>(
          duration: _styleDuration,
          curve: _styleCurve,
          tween: ColorTween(end: targetForegroundColor),
          builder: (BuildContext context, Color? animatedColor, Widget? child) {
            final Color resolvedColor = animatedColor ?? targetForegroundColor;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: resolvedColor),
                const SizedBox(width: 8),
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: _styleDuration,
                    curve: _styleCurve,
                    style: textScheme.label.copyWith(
                      color: resolvedColor,
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
