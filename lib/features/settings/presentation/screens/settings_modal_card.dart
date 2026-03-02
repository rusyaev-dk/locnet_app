import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SettingsModalCard extends StatelessWidget {
  const SettingsModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return AppModalCard(
      maxWidth: MediaQuery.of(context).size.width * 0.5,
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
  SettingsSection _selectedSection = SettingsSection.appearance;

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
    final User? user = context.select<AuthCubit, User?>((AuthCubit c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.user;
      return null;
    });

    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsHeader(showBackButton: false),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompactSidebar = constraints.maxWidth < 600;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: SettingsSidebar(
                      selectedSection: _selectedSection,
                      compact: isCompactSidebar,
                      profileTrailing: user != null
                          ? SettingsProfilePreview(
                              user: user,
                              compact: isCompactSidebar,
                            )
                          : null,
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
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  Expanded(
                    flex: 5,
                    child: _SettingsSectionContent(
                      section: _selectedSection,
                      session: session,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsSectionContent extends StatelessWidget {
  const _SettingsSectionContent({
    required this.section,
    required this.session,
  });

  final SettingsSection section;
  final Session? session;

  @override
  Widget build(BuildContext context) {
    switch (section) {
      case SettingsSection.appearance:
        return const AppearanceSettingsContent();
      case SettingsSection.profile:
        return const ProfileSettingsContent();
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
