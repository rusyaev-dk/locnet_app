// profile_modal_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileModalWrapper extends StatelessWidget {
  const ProfileModalWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProfileInteractor>(
      create: (context) => ProfileInteractor(
        userRepo: context.read<IUserRepo>(),
        logger: context.read<ILogger>(),
      ),
      child: BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          profileInteractor: context.read<ProfileInteractor>(),
          logger: context.read<ILogger>(),
        )..loadUserData(),
        child: child,
      ),
    );
  }
}

class ProfileModalCard extends StatelessWidget {
  const ProfileModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return ProfileModalWrapper(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420,
              maxHeight: MediaQuery.of(context).size.height - 48,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (BuildContext context, ProfileState state) {
                      switch (state) {
                        case ProfileInitialState():
                        case ProfileLoadingState():
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Loading profile...',
                                    style: textScheme.headline.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        case ProfileFailureState():
                          return InfoWidget(
                            icon: Icons.error,
                            text: state.failure.toString(),
                            iconAnimationEffect: const ShakeEffect(),
                          );
                        case ProfileLoadedState():
                          return _ProfileView(profileState: state);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.profileState});

  final ProfileLoadedState profileState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final User user = profileState.user;

    final Session? session = context.select<AuthCubit, Session?>((
      AuthCubit cubit,
    ) {
      final AuthState state = cubit.state;
      if (state is AuthAuthenticatedState) {
        return state.session;
      }
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(user: user),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ProfileGeneralInfo(user: user),
                ),

                ProfileAdditionalInfo(user: user),

                const SizedBox(height: 16),

                ProfileActionTile(
                  icon: Icons.devices,
                  title: l10n.currentSession,
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
                                onPressed: () => GoRouter.of(context).pop(),
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
                const SizedBox(height: 10),
                ProfileActionTile(
                  icon: Icons.logout,
                  title: l10n.logout,
                  isDestructive: true,
                  onPressed: () async {
                    await showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (context, _, _) {
                        return AppAlertDialog(
                          title: Text(l10n.logOut),
                          content: Text(l10n.logOutConfirmation),
                          actions: [
                            AppAlertDialogAction(
                              isDestructiveAction: true,
                              onPressed: () =>
                                  context.read<AuthCubit>().logOut(),
                              child: Text(l10n.yesLabel),
                            ),
                            AppAlertDialogAction(
                              child: Text(l10n.cancel),
                              onPressed: () => GoRouter.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
