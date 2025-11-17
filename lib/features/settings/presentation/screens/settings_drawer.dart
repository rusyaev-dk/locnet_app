// settings_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (BuildContext context, SettingsState state) {
              switch (state) {
                case SettingsInitialState():
                case SettingsLoadingState():
                  return Center(
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
                  );
                case SettingsFailureState():
                  return InfoWidget(
                    icon: Icons.error,
                    text: state.failure.toString(),
                    iconAnimationEffect: const ShakeEffect(),
                  );
                case SettingsLoadedState():
                  return _SettingsLoadedView(settingsState: state);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _SettingsLoadedView extends StatelessWidget {
  const _SettingsLoadedView({required this.settingsState});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Locale selectedLocale = settingsState.locale;
    final ThemeMode selectedThemeMode = settingsState.themeMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SettingsHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SettingsSectionTitle(title: 'Appearance'),
                const SizedBox(height: 8),
                SettingsGroupCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: textScheme.headline.copyWith(
                          fontSize: textScheme.headline.fontSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose how the app looks',
                        style: textScheme.label.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ThemeModeSelector(selectedThemeMode: selectedThemeMode),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _SettingsSectionTitle(title: 'Language'),
                const SizedBox(height: 8),
                SettingsGroupCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App language',
                        style: textScheme.headline.copyWith(
                          fontSize: textScheme.headline.fontSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select interface language',
                        style: textScheme.label.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LanguageSelector(selectedLocale: selectedLocale),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _SettingsSectionTitle(title: 'Current session'),
                const SizedBox(height: 8),
                SessionInfoCard(session: settingsState.session),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Settings',
            style: textScheme.display.copyWith(color: colorScheme.onSurface),
          ),
          const Spacer(),
          _SettingsCloseButton(),
        ],
      ),
    );
  }
}

class _SettingsCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).maybePop();
        },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surfaceContainerHighest.withAlpha(180),
          ),
          child: Icon(
            Icons.close,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Text(
      title,
      style: textScheme.label.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

/// Shared group card used both in settings drawer and session info.
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
