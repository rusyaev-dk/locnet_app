import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileEditorHeader extends StatelessWidget {
  const ProfileEditorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            l10n.profileEditing,
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
            icon: Icons.close,
            onPressed: () {
              context.read<ProfileEditorCubit>().resetUpdates();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
