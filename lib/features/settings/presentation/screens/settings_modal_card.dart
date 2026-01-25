import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class SettingsModalCard extends StatelessWidget {
  const SettingsModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return AppModalCard(
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          switch (state) {
            case SettingsInitialState():
            case SettingsLoadingState():
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading settings...',
                        style: textScheme.headline.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );

            case SettingsFailureState():
              return InfoWidget(
                icon: Icons.error,
                text: state.failure.toString(),
                iconAnimationEffect: const ShakeEffect(),
              );

            case SettingsLoadedState():
              return SettingsView(settingsState: state);
          }
        },
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({required this.settingsState, super.key});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                ThemeModeSelector(
                  selectedThemeMode: settingsState.themeMode,
                ),
                const SizedBox(height: 15),
                LanguageSelector(selectedLocale: settingsState.locale),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
