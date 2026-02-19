// profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/buttons/buttons.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.user,
    this.showCloseButton = true,
    this.showBackButton = true,
    this.popsOnClose = 1,
    super.key,
  });

  final User user;
  final bool showCloseButton;
  final bool showBackButton;
  final int popsOnClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 6),
              ConversationAvatar(
                text: ProfileDataExtractor.extractUserInitials(user),
                size: 85,
              ),
              const SizedBox(height: 10),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: textScheme.headline.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '@${user.username}',
                textAlign: TextAlign.center,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        if (showBackButton)
          Align(
            alignment: Alignment.topLeft,
            child: RoundedIconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: Icons.chevron_left,
              backgroundColor: Colors.transparent,
            ),
          ),
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedIconButton(
                icon: Icons.edit,
                foregroundColor: colorScheme.onSurfaceVariant,
                onPressed: () async {
                  final profileInteractor = context.read<ProfileInteractor>();
                  final bool shouldUpdate =
                      await showGeneralDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        transitionBuilder: slideFadeDialogTransition,
                        pageBuilder: (context, _, _) {
                          return ProfileEditorModalWrapper(
                            profileInteractor: profileInteractor,
                            child: ProfileEditorModalCard(initialUser: user),
                          );
                        },
                      ) ??
                      false;

                  if (shouldUpdate && context.mounted) {
                    await context.read<ProfileCubit>().loadUserData();
                  }
                },
                tooltip: 'Edit',
              ),
              const SizedBox(width: 8),
              if (showCloseButton)
                RoundedIconButton(
                  icon: Icons.close,
                  foregroundColor: colorScheme.onSurfaceVariant,
                  onPressed: () {
                    for (int i = 0; i < popsOnClose; i++) {
                      if (context.mounted) GoRouter.of(context).pop();
                    }
                  },
                  tooltip: 'Close',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
