import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Reusable profile body: personal info, settings (session), account status.
/// Used in profile modal and in settings profile section.
class ProfileBodyContent extends StatelessWidget {
  const ProfileBodyContent({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final Session? session = context.select<AuthCubit, Session?>((AuthCubit c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.session;
      return null;
    });

    return Container(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              l10n.personalInformation,
              style: textScheme.label.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            AppTileButtonGroupCard(
              children: [
                AppTileButton(
                  title: l10n.username,
                  value: '@${user.username}',
                  icon: Icons.alternate_email,
                  onPressed: () {},
                ),
                if (user.languageCode.isNotEmpty)
                  AppTileButton(
                    title: l10n.language,
                    value: user.languageCode,
                    icon: Icons.language,
                    onPressed: () {},
                  ),
                if ((user.description ?? '').trim().isNotEmpty)
                  AppTileButton(
                    title: l10n.description,
                    value: user.description!.trim(),
                    icon: Icons.info_outline,
                    onPressed: () {},
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.settings,
              style: textScheme.label.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            AppTileButtonGroupCard(
              children: [
                AppTileButton(
                  title: l10n.currentSession,
                  value: session != null
                      ? l10n.sessionDetails
                      : l10n.unknownValue,
                  icon: Icons.devices,
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
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.accountStatus,
              style: textScheme.label.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            AppTileButtonGroupCard(
              children: [
                AppTileButton(
                  title: l10n.logout,
                  value: l10n.logOutConfirmation,
                  icon: Icons.logout,
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
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
