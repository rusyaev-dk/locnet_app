import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

class ProfileGeneralInfo extends StatelessWidget {
  const ProfileGeneralInfo({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final String initials = _buildInitials(user: user);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  initials,
                  style: textScheme.headline.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      textAlign: TextAlign.start,
                      style: textScheme.display.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      textAlign: TextAlign.start,
                      style: textScheme.label.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (user.description != null || user.languageCode.isNotEmpty) ...[
            const SizedBox(height: 16),
            if (user.description != null) ...[
              Text(
                l10n.description,
                style: textScheme.label.copyWith(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.description!,
                maxLines: 4,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: textScheme.label.copyWith(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              if (user.languageCode.isNotEmpty) const SizedBox(height: 12),
            ],
            if (user.languageCode.isNotEmpty)
              Text(
                '${l10n.language}: ${user.languageCode}',
                textAlign: TextAlign.start,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _buildInitials({required User user}) {
    final String firstName = user.firstName.trim();
    final String lastName = user.lastName.trim();

    if (firstName.isEmpty && lastName.isEmpty) {
      return '?';
    }

    final String firstLetter = firstName.isEmpty
        ? ''
        : firstName.characters.first.toUpperCase();
    final String lastLetter = lastName.isEmpty
        ? ''
        : lastName.characters.first.toUpperCase();

    final String initials = '$firstLetter$lastLetter';
    return initials.isEmpty ? '?' : initials;
  }
}
