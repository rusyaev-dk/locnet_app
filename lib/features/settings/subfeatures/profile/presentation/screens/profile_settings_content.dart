import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/profile/presentation/modals/modals.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';

/// Profile section: user preview and link to profile modal (edit).
class ProfileSettingsContent extends StatelessWidget {
  const ProfileSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final User? user = context.select<AuthCubit, User?>((AuthCubit c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.user;
      return null;
    });

    if (user == null) {
      return Center(
        child: Text(
          l10n.sessionIsNotLoadedYet,
          style: context.textScheme.label.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final initials = ProfileDataExtractor.extractUserInitials(user);
    final fullName = ProfileDataExtractor.extractUserFullName(user);
    final displayName = fullName.isNotEmpty ? fullName : user.username;
    final username = user.username.isNotEmpty ? '@${user.username}' : '';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.settingsMyProfile,
            description: 'Просмотр и редактирование данных профиля.',
          ),

          SettingsGroupCard(
            title: 'Профиль',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    CompanionAvatar(text: initials, size: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textScheme.label.copyWith(
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (username.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textScheme.label.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SettingsNavTile(
                title: l10n.settingsMyProfile,
                trailingText: null,
                showChevron: true,
                leadingIcon: Icons.person_outline,
                onTap: () {
                  showGeneralDialog<void>(
                    routeSettings: const RouteSettings(name: AppRoutes.profile),
                    context: context,
                    transitionBuilder: slideFadeDialogTransition,
                    pageBuilder: (context, _, __) {
                      return const ProfileModalCard();
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
