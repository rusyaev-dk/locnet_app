import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

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
      leading: IconButton(
        icon: const Icon(Icons.close),
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
        IconButton(
          icon: const Icon(Icons.forward),
          onPressed: canForward ? onForwardPressed : null,
          tooltip: l10n.messageContextActionForward,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: canDelete ? onDeletePressed : null,
          tooltip: l10n.messageContextActionDelete,
        ),
      ],
    );
  }
}

