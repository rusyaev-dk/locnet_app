import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            switch (state) {
              case SettingsInitialState():
              case SettingsLoadingState():
                return const _SettingsLoadingView();
              case SettingsFailureState():
                return _SettingsFailureView(failure: state.failure ?? "");
              case SettingsLoadedState():
                return _SettingsLoadedView(settingsState: state);
            }
          },
        ),
      ),
    );
  }
}

class _SettingsLoadingView extends StatelessWidget {
  const _SettingsLoadingView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('Loading settings...', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SettingsFailureView extends StatelessWidget {
  const _SettingsFailureView({required this.failure});

  final Object failure;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              Text(
                'Settings error',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(failure.toString(), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SettingsLoadedView extends StatelessWidget {
  const _SettingsLoadedView({required this.settingsState});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Locale selectedLocale = settingsState.locale;
    final ThemeMode selectedThemeMode = settingsState.themeMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SettingsHeader(),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SettingsSectionTitle(title: 'Appearance'),
                const SizedBox(height: 8),
                _SettingsGroupCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Choose how the app looks',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _ThemeModeSelector(selectedThemeMode: selectedThemeMode),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _SettingsSectionTitle(title: 'Language'),
                const SizedBox(height: 8),
                _SettingsGroupCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('App language', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Select interface language',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _LocaleSelector(selectedLocale: selectedLocale),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _SettingsSectionTitle(title: 'Current session'),
                const SizedBox(height: 8),
                _SessionInfoCard(session: settingsState.session),
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
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text('Settings', style: theme.textTheme.titleLarge),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.close),
            tooltip: 'Close settings',
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium!,
          child: child,
        ),
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.selectedThemeMode});

  final ThemeMode selectedThemeMode;

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingsCubit = context.read<SettingsCubit>();

    return Column(
      children: [
        RadioListTile<ThemeMode>(
          value: ThemeMode.system,
          groupValue: selectedThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              settingsCubit.changeThemeMode(newValue);
            }
          },
          title: const Text('System'),
          subtitle: const Text('Use device theme'),
          dense: true,
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.light,
          groupValue: selectedThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              settingsCubit.changeThemeMode(newValue);
            }
          },
          title: const Text('Light'),
          subtitle: const Text('Bright theme'),
          dense: true,
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: selectedThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              settingsCubit.changeThemeMode(newValue);
            }
          },
          title: const Text('Dark'),
          subtitle: const Text('Dark theme'),
          dense: true,
        ),
      ],
    );
  }
}

class _LocaleSelector extends StatelessWidget {
  const _LocaleSelector({required this.selectedLocale});

  final Locale selectedLocale;

  List<Locale> get _supportedLocales {
    return [const Locale('en'), const Locale('ru')];
  }

  String _mapLocaleToLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingsCubit = context.read<SettingsCubit>();

    return DropdownButtonFormField<Locale>(
      initialValue: _supportedLocales.firstWhere(
        (Locale locale) => locale.languageCode == selectedLocale.languageCode,
        orElse: () => selectedLocale,
      ),
      items: _supportedLocales
          .map(
            (Locale locale) => DropdownMenuItem<Locale>(
              value: locale,
              child: Text(_mapLocaleToLabel(locale)),
            ),
          )
          .toList(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          settingsCubit.changeLanguage(newLocale);
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

class _SessionInfoCard extends StatelessWidget {
  const _SessionInfoCard({required this.session});

  final Session session;

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMMMd().add_Hm();
    return formatter.format(dateTime.toLocal());
  }

  String _boolToStatus(bool value) {
    return value ? 'Yes' : 'No';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isTerminated = session.isTerminated ?? false;

    return _SettingsGroupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session details', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(session.isExpired ? 'Expired' : 'Active'),
                avatar: Icon(
                  session.isExpired
                      ? Icons.lock_clock_outlined
                      : Icons.lock_open_outlined,
                ),
              ),
              if (isTerminated)
                const Chip(
                  label: Text('Terminated'),
                  avatar: Icon(Icons.logout),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _SessionInfoRow(label: 'User ID', value: session.userId),
          _SessionInfoRow(label: 'Session ID', value: session.sessionId),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'Device name',
            value: session.deviceName ?? 'Unknown',
          ),
          _SessionInfoRow(
            label: 'Device type',
            value: session.deviceType ?? 'Unknown',
          ),
          _SessionInfoRow(label: 'OS', value: session.os ?? 'Unknown'),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'IP address',
            value: session.ipAddress ?? 'Unknown',
          ),
          _SessionInfoRow(
            label: 'MAC address',
            value: session.macAddress ?? 'Unknown',
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'Created at',
            value: _formatDateTime(session.createdAt),
          ),
          _SessionInfoRow(
            label: 'Updated at',
            value: _formatDateTime(session.updatedAt),
          ),
          _SessionInfoRow(
            label: 'Expires at',
            value: _formatDateTime(session.expiresAt),
          ),
          if (isTerminated && session.terminatedAt != null)
            _SessionInfoRow(
              label: 'Terminated at',
              value: _formatDateTime(session.terminatedAt!),
            ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'Is expired',
            value: _boolToStatus(session.isExpired),
          ),
          _SessionInfoRow(
            label: 'Is terminated',
            value: _boolToStatus(isTerminated),
          ),
        ],
      ),
    );
  }
}

class _SessionInfoRow extends StatelessWidget {
  const _SessionInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
