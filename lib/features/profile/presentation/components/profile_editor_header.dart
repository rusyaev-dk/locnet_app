import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileEditorHeader extends StatelessWidget {
  const ProfileEditorHeader({this.popsOnClose = 3, super.key});

  /// Number of Navigator.pop() when close is pressed (e.g. 3 for Settings → Profile → Editor).
  final int popsOnClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          RoundedIconButton(
            onPressed: () {
              context.read<ProfileEditorCubit>().resetUpdates();
              Navigator.of(context).pop();
            },
            icon: Icons.chevron_left,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              l10n.profileEditing,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textScheme.display.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
              ),
            ),
          ),
          const Spacer(),
          RoundedIconButton(
            icon: Icons.close,
            onPressed: () {
              context.read<ProfileEditorCubit>().resetUpdates();
              for (int i = 0; i < popsOnClose; i++) {
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
