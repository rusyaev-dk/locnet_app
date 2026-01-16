// profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              l10n.profile,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textScheme.display.copyWith(
                color: colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          RoundedIconButton(
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
            icon: Icons.edit,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 10),
          RoundedIconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icons.close,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
