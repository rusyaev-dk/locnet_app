import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/domain/profile_interactor.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SettingsModalCard extends StatelessWidget {
  const SettingsModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return AppModalCard(
      maxWidth: 600,
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
                        context.l10n.settingsLoading,
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
                useErrorStyle: true,
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

class SettingsView extends StatefulWidget {
  const SettingsView({required this.settingsState, super.key});

  final SettingsLoadedState settingsState;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsSection _selectedSection = SettingsSection.profile;

  void _showLogoutConfirmation(BuildContext context) {
    final l10n = context.l10n;
    showGeneralDialog<void>(
      context: context,
      transitionBuilder: slideFadeDialogTransition,
      pageBuilder: (dialogContext, _, __) {
        return AppAlertDialog(
          title: Text(l10n.logOut),
          content: Text(l10n.logOutConfirmation),
          actions: [
            AppAlertDialogAction(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            AppAlertDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().logOut();
              },
              child: Text(l10n.yesLabel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Session? session = context.select<AuthCubit, Session?>((AuthCubit c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.session;
      return null;
    });

    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Modal header ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outline, width: 1),
            ),
          ),
          child: Row(
            children: [
              Text(
                context.l10n.settings,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    border: Border.all(color: colorScheme.outline, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        // ── Sidebar + Content ─────────────────────────────────────────
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: colorScheme.outline, width: 1),
                  ),
                ),
                child: SettingsSidebar(
                  selectedSection: _selectedSection,
                  onLogout: session != null
                      ? () => _showLogoutConfirmation(context)
                      : null,
                  onSectionSelected: (section) {
                    setState(() {
                      _selectedSection = section;
                    });
                  },
                ),
              ),
              Expanded(
                child: _SettingsSectionContent(
                  section: _selectedSection,
                  session: session,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsSectionContent extends StatelessWidget {
  const _SettingsSectionContent({required this.section, required this.session});

  final SettingsSection section;
  final Session? session;

  @override
  Widget build(BuildContext context) {
    switch (section) {
      case SettingsSection.appearance:
        return const AppearanceSettingsContent();
      case SettingsSection.profile:
        return BlocProvider<ProfileEditorCubit>(
          create: (context) => ProfileEditorCubit(
            profileInteractor: ProfileInteractor(
              userRepo: context.read<IUserRepo>(),
              logger: context.read<ILogger>(),
            ),
            authInteractor: context.read<AuthInteractor>(),
            logger: context.read<ILogger>(),
          )..loadProfile(),
          child: const ProfileSettingsContent(),
        );
      case SettingsSection.security:
        return PrivacySettingsContent(session: session);
      case SettingsSection.notifications:
        return BlocProvider<NotificationsSettingsCubit>(
          create: (context) => NotificationsSettingsCubit(
            settingsInteractor: context.read<SettingsInteractor>(),
          ),
          child: const NotificationsSettingsContent(),
        );
      case SettingsSection.chats:
        return BlocProvider<ChatSettingsCubit>(
          create: (context) => ChatSettingsCubit(
            settingsInteractor: context.read<SettingsInteractor>(),
          )..load(),
          child: const ChatSettingsContent(),
        );
      case SettingsSection.language:
        return const LanguageSettingsContent();
      case SettingsSection.privacy:
        return PrivacySettingsContent(session: session);
    }
  }
}
