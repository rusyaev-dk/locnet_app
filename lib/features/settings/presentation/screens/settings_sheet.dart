import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.4,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Align(child: BottomSheetDragger()),
              const SizedBox(height: 12),
              SingleChildScrollView(
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    switch (state) {
                      case SettingsInitialState():
                      case SettingsLoadingState():
                        return const Center(child: CircularProgressIndicator());
                      case SettingsLoadedState():
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SettingsContent(
                            selectedLocale: state.locale,
                            selectedThemeMode: state.themeMode,
                          ),
                        );
                      case SettingsFailureState():
                        return InfoWidget(
                          icon: Icons.error,
                          text: state.failure.toString(),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    required this.selectedLocale,
    required this.selectedThemeMode,
    super.key,
  });

  final Locale selectedLocale;
  final ThemeMode selectedThemeMode;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settings,
          style: textScheme.headline.copyWith(fontSize: 23),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.language,
          style: textScheme.headline.copyWith(
            fontSize: 23,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoSlidingSegmentedControl<Locale>(
          groupValue: selectedLocale,
          children: <Locale, Widget>{
            const Locale('uz'): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'O‘zbek',
                style: textScheme.headline.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Locale('ru'): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'Русский',
                style: textScheme.headline.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          },
          onValueChanged: (Locale? locale) {
            if (locale == null) return;
            context.read<SettingsCubit>().changeLanguageCode(locale);
          },
        ),

        const SizedBox(height: 20),

        Text(
          l10n.themeMode,
          style: textScheme.headline.copyWith(
            fontSize: 23,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoSlidingSegmentedControl<ThemeMode>(
          groupValue: selectedThemeMode,
          children: <ThemeMode, Widget>{
            ThemeMode.system: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                l10n.themeModeSystem,
                style: textScheme.headline.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ThemeMode.light: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                l10n.themeModeLight,
                style: textScheme.headline.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ThemeMode.dark: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                l10n.themeModeDark,
                style: textScheme.headline.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          },
          onValueChanged: (ThemeMode? mode) {
            if (mode == null) return;
            context.read<SettingsCubit>().changeThemeMode(mode);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
