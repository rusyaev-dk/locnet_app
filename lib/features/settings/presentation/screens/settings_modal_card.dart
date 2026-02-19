import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/profile/presentation/modals/modals.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/domain/interactors/settings_interactor.dart';
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
    final User? user = context.select<AuthCubit, User?>((AuthCubit c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.user;
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsHeader(showBackButton: false),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null) ...[
                  _SettingsProfilePreview(user: user),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                ],
                AppTileButtonGroupCard(
              backgroundColor: Colors.transparent,
              children: [
                AppTileButton(
                  title: l10n.appearance,
                  value: '',
                  icon: Icons.palette_outlined,
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (dialogContext, _, _) {
                        return BlocProvider<ThemeSettingsCubit>(
                          create: (_) => ThemeSettingsCubit(
                            settingsInteractor:
                                dialogContext.read<SettingsInteractor>(),
                            settingsCubit:
                                dialogContext.read<SettingsCubit>(),
                          )..load(),
                          child: const _AppearanceSettingsModalCard(),
                        );
                      },
                    );
                  },
                ),
                AppTileButton(
                  title: l10n.settingsMyProfile,
                  value: '',
                  icon: Icons.person_outline,
                  onPressed: () {
                    showGeneralDialog(
                      routeSettings: const RouteSettings(
                        name: AppRoutes.profile,
                      ),
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (context, _, _) {
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
                      pageBuilder: (dialogContext, _, _) {
                        return BlocProvider<NotificationsSettingsCubit>(
                          create: (_) => NotificationsSettingsCubit(
                            settingsInteractor:
                                dialogContext.read<SettingsInteractor>(),
                          ),
                          child: const _NotificationsSettingsModalCard(),
                        );
                      },
                    );
                  },
                ),
                AppTileButton(
                  title: l10n.settingsPrivacy,
                  value: '',
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
                        pageBuilder: (context, _, _) {
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
                      pageBuilder: (dialogContext, _, _) {
                        return BlocProvider<ChatSettingsCubit>(
                          create: (_) => ChatSettingsCubit(
                            settingsInteractor:
                                dialogContext.read<SettingsInteractor>(),
                          )..load(),
                          child: const _ChatsSettingsModalCard(),
                        );
                      },
                    );
                  },
                ),
                AppTileButton(
                  title: l10n.settingsLanguage,
                  value: '',
                  icon: Icons.language,
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (dialogContext, _, _) {
                        return BlocProvider<LanguageSettingsCubit>(
                          create: (_) => LanguageSettingsCubit(
                            settingsInteractor:
                                dialogContext.read<SettingsInteractor>(),
                            settingsCubit:
                                dialogContext.read<SettingsCubit>(),
                          )..load(),
                          child: const _LanguageSettingsModalCard(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsProfilePreview extends StatelessWidget {
  const _SettingsProfilePreview({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final initials = ProfileDataExtractor.extractUserInitials(user);
    final fullName = ProfileDataExtractor.extractUserFullName(user);
    final displayName = fullName.isNotEmpty ? fullName : user.username;
    final username = user.username.isNotEmpty ? '@${user.username}' : '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          CompanionAvatar(
            text: initials,
            size: 56,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: textScheme.headline.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                if (username.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    username,
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceSettingsModalCard extends StatelessWidget {
  const _AppearanceSettingsModalCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(title: l10n.appearance, popsOnClose: 2),
          Expanded(
            child: BlocBuilder<ThemeSettingsCubit, ThemeSettingsState>(
              builder: (context, state) {
                switch (state) {
                  case ThemeSettingsInitialState():
                  case ThemeSettingsLoadingState():
                    return const Center(child: CircularProgressIndicator());
                  case ThemeSettingsFailureState():
                    return Center(
                      child: Text(
                        l10n.appException,
                        style: TextStyle(color: colorScheme.error),
                      ),
                    );
                  case ThemeSettingsLoadedState():
                    final accentIndex = state.themeType.accentIndex;
                    final isLight = state.themeType.isLight;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorSchemeSelector(
                            selectedAccentIndex: accentIndex,
                            onAccentSelected: (index) {
                              final newType =
                                  AppThemeType.fromAccentAndBrightness(
                                accentIndex: index,
                                isLight: isLight,
                              );
                              context
                                  .read<ThemeSettingsCubit>()
                                  .setThemeType(newType);
                            },
                          ),
                          const SizedBox(height: 28),
                          BrightnessSelector(
                            isLight: isLight,
                            onBrightnessChanged: (light) {
                              final newType =
                                  AppThemeType.fromAccentAndBrightness(
                                accentIndex: accentIndex,
                                isLight: light,
                              );
                              context
                                  .read<ThemeSettingsCubit>()
                                  .setThemeType(newType);
                            },
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textScheme.label.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  const _NotificationSwitchTile({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: SwitchListTile(
          title: Text(
            title,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                )
              : null,
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ChatSettingsContent extends StatelessWidget {
  const _ChatSettingsContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return BlocBuilder<ChatSettingsCubit, ChatSettingsState>(
      builder: (context, state) {
        if (state is! ChatSettingsLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsSection(
                title: l10n.settingsChatsShortcuts,
                child: Text(
                  l10n.settingsChatsShortcutsDescription,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageSettingsContent extends StatelessWidget {
  const _LanguageSettingsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<LanguageSettingsCubit, LanguageSettingsState>(
      builder: (context, state) {
        if (state is! LanguageSettingsLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsSection(
                title: l10n.language,
                child: LanguageSelector(
                  selectedLocale: state.locale,
                  onLocaleSelected: (locale) {
                    context.read<LanguageSettingsCubit>().setLocale(locale);
                  },
                ),
              ),
              const SizedBox(height: 28),
              _SettingsSection(
                title: l10n.aboutApp,
                child: const AppVersionWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationsSettingsModalCard extends StatelessWidget {
  const _NotificationsSettingsModalCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(
            title: l10n.settingsNotificationsAndSounds,
            popsOnClose: 2,
          ),
          const Expanded(
            child: _NotificationsSettingsContent(),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSettingsContent extends StatelessWidget {
  const _NotificationsSettingsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<NotificationsSettingsCubit,
        NotificationsSettingsState>(
      builder: (context, state) {
        if (state is! NotificationsSettingsLoadedState) {
          return const SizedBox.shrink();
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsSection(
                title: l10n.settingsNotificationsPlaceholder,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _NotificationSwitchTile(
                      title: l10n.toggleNotificationsOn,
                      subtitle: l10n.toggleNotificationsOff,
                      value: state.messageNotifications,
                      onChanged: (value) {
                        context
                            .read<NotificationsSettingsCubit>()
                            .setMessageNotifications(value: value);
                      },
                    ),
                    _NotificationSwitchTile(
                      title: l10n.settingsSound,
                      subtitle: null,
                      value: state.soundEnabled,
                      onChanged: (value) {
                        context
                            .read<NotificationsSettingsCubit>()
                            .setSoundEnabled(value: value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatsSettingsModalCard extends StatelessWidget {
  const _ChatsSettingsModalCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(title: l10n.settingsChats, popsOnClose: 2),
          const Expanded(child: _ChatSettingsContent()),
        ],
      ),
    );
  }
}

class _LanguageSettingsModalCard extends StatelessWidget {
  const _LanguageSettingsModalCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsHeader(title: l10n.settingsLanguage, popsOnClose: 2),
          const Expanded(child: _LanguageSettingsContent()),
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
