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

    final String initials = _buildInitials(user: user);

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.tertiary,
          child: Text(
            initials,
            style: textScheme.headline.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
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
      ],
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

class ProfileAdditionalInfo extends StatelessWidget {
  const ProfileAdditionalInfo({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final String? description = _normalizeOptionalText(value: user.description);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxDescriptionHeight = constraints.maxHeight * 0.6;

        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(color: colorScheme.secondary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null) ...[
                Text(
                  '${l10n.description}:',
                  style: textScheme.label.copyWith(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxDescriptionHeight),
                  child: Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.label.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                '${l10n.language}: ${user.languageCode}',
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String? _normalizeOptionalText({required String? value}) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
