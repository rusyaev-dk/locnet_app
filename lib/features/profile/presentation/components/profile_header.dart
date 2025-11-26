// profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
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
    final profileEditorCubit = context.read<ProfileEditorCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            l10n.profile,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: textScheme.display.copyWith(
              color: colorScheme.onSurface,
              fontSize: 24,
            ),
          ),
          const Spacer(),
          AppIconButton(
            buttonSize: 35,
            iconSize: 18.5,
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, _, _) {
                  profileEditorCubit.loadUserData();
                  return ProfileEditorModalCard(
                    initialUser: user,
                    profileEditorCubit: profileEditorCubit,
                  );
                },
              );
            },
            icon: Icons.edit,
          ),
          const SizedBox(width: 10),
          AppIconButton(
            buttonSize: 35,
            iconSize: 18.5,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.close,
          ),
        ],
      ),
    );
  }
}
