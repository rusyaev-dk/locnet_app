import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class MessagesSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MessagesSelectionAppBar({
    required this.selectedCount,
    required this.onClosePressed,
    required this.onDeletePressed,
    required this.onForwardPressed,
    this.canDelete = true,
    this.canForward = true,
    super.key,
  });

  final int selectedCount;
  final bool canDelete;
  final bool canForward;
  final VoidCallback onClosePressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onForwardPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return AppBar(
      leading: SurfaceIconButton(
        variant: SurfaceIconVariant.ghost,
        icon: Icons.close,
        margin: EdgeInsets.zero,
        tooltip: l10n.close,
        onPressed: onClosePressed,
      ),
      title: Text(
        '$selectedCount',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: colorScheme.onSurface),
      ),
      actions: <Widget>[
        Opacity(
          opacity: canForward ? 1 : 0.45,
          child: IgnorePointer(
            ignoring: !canForward,
            child: SurfaceIconButton(
              variant: SurfaceIconVariant.ghost,
              icon: Icons.forward,
              margin: EdgeInsets.zero,
              tooltip: l10n.messageContextActionForward,
              onPressed: onForwardPressed,
            ),
          ),
        ),
        Opacity(
          opacity: canDelete ? 1 : 0.45,
          child: IgnorePointer(
            ignoring: !canDelete,
            child: SurfaceIconButton(
              variant: SurfaceIconVariant.ghost,
              icon: Icons.delete_outline,
              margin: EdgeInsets.zero,
              tooltip: l10n.messageContextActionDelete,
              onPressed: onDeletePressed,
            ),
          ),
        ),
      ],
    );
  }
}

