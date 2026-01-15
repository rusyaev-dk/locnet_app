import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    required this.icon,
    required this.title,
    required this.onPressed,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final bool isDisabled = onPressed == null;

    final Color accentColor = isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    final Color iconColor = isDisabled
        ? colorScheme.onSurfaceVariant
        : accentColor;

    final Color titleColor = isDisabled
        ? colorScheme.onSurfaceVariant.withAlpha(0x7A)
        : colorScheme.onSurface;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(0x6A)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 21),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: textScheme.label.copyWith(
                    color: titleColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
