import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/profile/presentation/modals/modals.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

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
    final l10n = context.l10n;
    final Session? session = context.select<AuthCubit, Session?>((AuthCubit c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.session;
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AppTileButtonGroupCard(
              children: [
                AppTileButton(
                  title: l10n.settingsMyProfile,
                  value: '',
                  icon: Icons.person_outline,
                  onPressed: () {
                    showGeneralDialog(
                      routeSettings: const RouteSettings(name: AppRoutes.profile),
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (context, _, __) {
                        return const ProfileModalCard();
                      },
                    );
                  },
                ),
                AppTileButton(
                  title: l10n.settingsNotificationsAndSounds,
                  value: '',
                  icon: Icons.notifications_outlined,
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (context, _, __) {
                        return const _NotificationsSettingsModalCard();
                      },
                    );
                  },
                ),
                AppTileButton(
                  title: l10n.settingsPrivacy,
                  value: session != null
                      ? l10n.sessionDetails
                      : l10n.unknownValue,
                  icon: Icons.lock_outline,
                  onPressed: () async {
                    if (session == null) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AppAlertDialog(
                            title: Text(l10n.appException),
                            content: Text(l10n.sessionIsNotLoadedYet),
                            actions: [
                              AppAlertDialogAction(
                                child: Text(l10n.ok),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      await showGeneralDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        transitionBuilder: slideFadeDialogTransition,
                        pageBuilder: (context, _, __) {
                          return SessionModalCard(session: session);
                        },
                      );
                    }
                  },
                ),
                AppTileButton(
                  title: l10n.settingsChats,
                  value: '',
                  icon: Icons.chat_bubble_outline,
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (context, _, __) {
                        return _ChatsSettingsModalCard(
                          settingsState: settingsState,
                        );
                      },
                    );
                  },
                ),
                AppTileButton(
                  title: l10n.settingsLanguage,
                  value: settingsState.locale.languageCode,
                  icon: Icons.language,
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (context, _, __) {
                        return _LanguageSettingsModalCard(
                          settingsState: settingsState,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatSettingsContent extends StatelessWidget {
  const _ChatSettingsContent({required this.settingsState});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsChatsAppearance,
            style: textScheme.label.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ThemeModeSelector(
            selectedThemeMode: settingsState.themeMode,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settingsChatsShortcuts,
            style: textScheme.label.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsChatsShortcutsDescription,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSettingsContent extends StatelessWidget {
  const _LanguageSettingsContent({required this.settingsState});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.language,
            style: textScheme.label.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          LanguageSelector(selectedLocale: settingsState.locale),
          const SizedBox(height: 24),
          Text(
            l10n.aboutApp,
            style: textScheme.label.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const AppVersionWidget(),
        ],
      ),
    );
  }
}

class _NotificationsSettingsModalCard extends StatelessWidget {
  const _NotificationsSettingsModalCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(
            title: l10n.settingsNotificationsAndSounds,
            popsOnClose: 2,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _NotificationsSettingsSectionBody(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSettingsSectionBody extends StatefulWidget {
  const _NotificationsSettingsSectionBody();

  @override
  State<_NotificationsSettingsSectionBody> createState() =>
      _NotificationsSettingsSectionBodyState();
}

class _NotificationsSettingsSectionBodyState
    extends State<_NotificationsSettingsSectionBody> {
  bool _messageNotifications = true;
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsNotificationsPlaceholder,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              l10n.toggleNotificationsOn,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              l10n.toggleNotificationsOff,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            value: _messageNotifications,
            onChanged: (value) {
              setState(() => _messageNotifications = value);
            },
          ),
          SwitchListTile(
            title: Text(
              'Sound',
              style: textScheme.label.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() => _soundEnabled = value);
            },
          ),
        ],
      ),
    );
  }
}

class _ChatsSettingsModalCard extends StatelessWidget {
  const _ChatsSettingsModalCard({required this.settingsState});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(
            title: l10n.settingsChats,
            popsOnClose: 2,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _ChatSettingsContent(settingsState: settingsState),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSettingsModalCard extends StatelessWidget {
  const _LanguageSettingsModalCard({required this.settingsState});

  final SettingsLoadedState settingsState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(
            title: l10n.settingsLanguage,
            popsOnClose: 2,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _LanguageSettingsContent(settingsState: settingsState),
            ),
          ),
        ],
      ),
    );
  }
}

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final String? version = dotenv.env['VERSION'];
    final String displayVersion = version ?? 'Unknown';

    return Center(
      child: Text(
        'Version $displayVersion',
        style: textScheme.label.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
    );
  }
}
