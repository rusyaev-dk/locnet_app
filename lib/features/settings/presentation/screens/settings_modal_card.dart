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
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 420,
            maxHeight: MediaQuery.of(context).size.height - 48,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
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
              ),
            ),
          ),
        ),
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
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final TextStyle sectionTitleStyle = textScheme.label.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      fontSize: 15,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appearance, style: sectionTitleStyle),
                const SizedBox(height: 8),
                SettingsGroupCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.themeMode,
                        style: textScheme.label.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ThemeModeSelectorChips(
                          selectedThemeMode: settingsState.themeMode,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.language, style: sectionTitleStyle),
                const SizedBox(height: 8),
                SettingsGroupCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectInterfaceLanguage,
                        style: textScheme.label.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LanguageSelector(selectedLocale: settingsState.locale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shared group card used in settings modal.
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: textScheme.label.copyWith(color: colorScheme.onSurface),
          child: child,
        ),
      ),
    );
  }
}
