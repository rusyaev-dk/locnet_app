import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';

/// Interface language.
class LanguageSettingsContent extends StatelessWidget {
  const LanguageSettingsContent({super.key});

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
          SettingsLoadedState() => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SettingsGroupCard(
                title: context.l10n.settingsLanguage,
                description: context.l10n.selectInterfaceLanguage,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
                    child: LanguageSelector(
                      selectedLocale: state.locale,
                      onLocaleSelected: (locale) => context
                          .read<SettingsCubit>()
                          .changeLanguageCode(locale),
                    ),
                  ),
                ],
              ),
            ),
        };
      },
    );
  }
}
