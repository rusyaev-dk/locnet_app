import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/uikit/buttons/buttons.dart';

class CompanionInfoHeader extends StatelessWidget {
  const CompanionInfoHeader({required this.companion, super.key});

  final User companion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final bool isActive = companion.isActive;

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 6),
              CompanionAvatar(user: companion, size: 86),
              const SizedBox(height: 10),
              Text(
                companion.fullName,
                textAlign: TextAlign.center,
                style: textScheme.headline.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isActive
                    ? l10n.companionStatusOnline
                    : l10n.companionStatusOffline,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: RoundedIconButton(
            icon: Icons.close,
            foregroundColor: colorScheme.onSurfaceVariant,
            onPressed: () => GoRouter.of(context).pop(),
            tooltip: l10n.close,
          ),
        ),
      ],
    );
  }
}

class CompanionAvatar extends StatelessWidget {
  const CompanionAvatar({required this.user, required this.size, super.key});

  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final String initials = _initialsFromName(user.fullName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primaryContainer,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: textScheme.headline.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  String _initialsFromName(String fullName) {
    final List<String> parts = fullName
        .split(' ')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    final String firstLetter = parts.first.characters.isEmpty
        ? '?'
        : parts.first.characters.first;

    final String secondLetter =
        parts.length > 1 && parts[1].characters.isNotEmpty
        ? parts[1].characters.first
        : '';

    return (firstLetter + secondLetter).toUpperCase();
  }
}
