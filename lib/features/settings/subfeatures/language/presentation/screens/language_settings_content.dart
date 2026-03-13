import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';

/// Language & region section.
class LanguageSettingsContent extends StatefulWidget {
  const LanguageSettingsContent({super.key});

  @override
  State<LanguageSettingsContent> createState() =>
      _LanguageSettingsContentState();
}

class _LanguageSettingsContentState extends State<LanguageSettingsContent> {
  int _chatLangIndex = 0;
  bool _autoDetectMessage = true;
  bool _preferLocalized = true;
  int _dateFormatIndex = 0;
  int _timeFormatIndex = 0;
  int _numberFormatIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return switch (state) {
          SettingsInitialState() || SettingsLoadingState() =>
            const Center(child: CircularProgressIndicator()),
          SettingsFailureState() => Center(
              child: Text(
                context.l10n.appException,
                style: TextStyle(color: context.colorScheme.error),
              ),
            ),
          SettingsLoadedState() => _LanguageBody(
              selectedLocale: state.locale,
              chatLangIndex: _chatLangIndex,
              autoDetectMessage: _autoDetectMessage,
              preferLocalized: _preferLocalized,
              dateFormatIndex: _dateFormatIndex,
              timeFormatIndex: _timeFormatIndex,
              numberFormatIndex: _numberFormatIndex,
              onLocaleSelected: (locale) =>
                  context.read<SettingsCubit>().changeLanguageCode(locale),
              onChatLangChanged: (i) => setState(() => _chatLangIndex = i),
              onAutoDetectMessageChanged: (v) =>
                  setState(() => _autoDetectMessage = v),
              onPreferLocalizedChanged: (v) =>
                  setState(() => _preferLocalized = v),
              onDateFormatChanged: (i) => setState(() => _dateFormatIndex = i),
              onTimeFormatChanged: (i) => setState(() => _timeFormatIndex = i),
              onNumberFormatChanged: (i) =>
                  setState(() => _numberFormatIndex = i),
            ),
        };
      },
    );
  }
}

class _LanguageBody extends StatelessWidget {
  const _LanguageBody({
    required this.selectedLocale,
    required this.chatLangIndex,
    required this.autoDetectMessage,
    required this.preferLocalized,
    required this.dateFormatIndex,
    required this.timeFormatIndex,
    required this.numberFormatIndex,
    required this.onLocaleSelected,
    required this.onChatLangChanged,
    required this.onAutoDetectMessageChanged,
    required this.onPreferLocalizedChanged,
    required this.onDateFormatChanged,
    required this.onTimeFormatChanged,
    required this.onNumberFormatChanged,
  });

  final Locale selectedLocale;
  final int chatLangIndex;
  final bool autoDetectMessage;
  final bool preferLocalized;
  final int dateFormatIndex;
  final int timeFormatIndex;
  final int numberFormatIndex;
  final ValueChanged<Locale> onLocaleSelected;
  final ValueChanged<int> onChatLangChanged;
  final ValueChanged<bool> onAutoDetectMessageChanged;
  final ValueChanged<bool> onPreferLocalizedChanged;
  final ValueChanged<int> onDateFormatChanged;
  final ValueChanged<int> onTimeFormatChanged;
  final ValueChanged<int> onNumberFormatChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.settingsLanguage,
            description:
                'Выберите язык интерфейса и параметры регионального формата.',
          ),

          // ── Интерфейс ─────────────────────────────────────
          SettingsGroupCard(
            title: 'Интерфейс',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: LanguageSelector(
                  selectedLocale: selectedLocale,
                  onLocaleSelected: onLocaleSelected,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
