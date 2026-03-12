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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.settingsMyProfile,
            description: 'Просмотр и редактирование данных профиля.',
          ),

          _ProfileCard(user: user),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final initials = ProfileDataExtractor.extractUserInitials(user);
    final fullName = ProfileDataExtractor.extractUserFullName(user);
    final displayName = fullName.isNotEmpty ? fullName : user.username;
    final username = user.username.isNotEmpty ? '@${user.username}' : '';
    final description = user.description?.trim() ?? '';

    final bool isActive = user.isActive;

    return SettingsGroupCard(
      title: 'Профиль',
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanionAvatar(text: initials, size: 52),
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
                      style: textScheme.headline.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 17,
                      ),
                    ),
                    if (username.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textScheme.label.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _InfoChip(
                          icon: Icons.language,
                          label: user.languageCode.toUpperCase(),
                        ),
                        _InfoChip(
                          icon: isActive
                              ? Icons.verified_user_outlined
                              : Icons.block,
                          label: isActive ? 'Аккаунт активен' : 'Аккаунт ограничен',
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: textScheme.body.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        const Divider(height: 1),
        SettingsActionTile(
          title: 'Редактировать профиль',
          leadingIcon: Icons.edit_outlined,
          onTap: () {
            showGeneralDialog<void>(
              routeSettings: const RouteSettings(name: AppRoutes.profile),
              context: context,
              transitionBuilder: slideFadeDialogTransition,
              pageBuilder: (dialogContext, _, __) {
                return const ProfileModalCard();
              },
            );
          },
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final chipColor = color ?? colorScheme.surfaceContainerHigh;
    final iconColor =
        color != null ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    final textColor =
        color != null ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: textScheme.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
