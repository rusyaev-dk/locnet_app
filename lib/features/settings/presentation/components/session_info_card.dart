// session_info_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class SessionInfoCard extends StatelessWidget {
  const SessionInfoCard({required this.session, super.key});

  final Session session;

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMMMd().add_Hm();
    return formatter.format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final bool isTerminated = session.isTerminated ?? false;

    return SettingsGroupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sessionDetails,
            style: textScheme.headline.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(
                  session.isExpired
                      ? l10n.sessionStatusExpired
                      : l10n.sessionStatusActive,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                avatar: Icon(
                  session.isExpired
                      ? Icons.lock_clock_outlined
                      : Icons.lock_open_outlined,
                  size: 18,
                  color: colorScheme.onPrimary,
                ),
                backgroundColor: session.isExpired
                    ? colorScheme.error.withAlpha(210)
                    : colorScheme.primary.withAlpha(210),
              ),
              if (isTerminated)
                Chip(
                  label: Text(
                    l10n.sessionStatusTerminated,
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  avatar: Icon(
                    Icons.logout,
                    size: 18,
                    color: colorScheme.onSurface,
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withAlpha(200),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _SessionInfoRow(label: l10n.sessionUserId, value: session.userId),
          _SessionInfoRow(
            label: l10n.sessionSessionId,
            value: session.sessionId,
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: l10n.sessionDeviceName,
            value: session.deviceName ?? l10n.unknownValue,
          ),
          _SessionInfoRow(
            label: l10n.sessionDeviceType,
            value: session.deviceType ?? l10n.unknownValue,
          ),
          _SessionInfoRow(
            label: l10n.sessionOs,
            value: session.os ?? l10n.unknownValue,
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: l10n.sessionIpAddress,
            value: session.ipAddress ?? l10n.unknownValue,
          ),
          _SessionInfoRow(
            label: l10n.sessionMacAddress,
            value: session.macAddress ?? l10n.unknownValue,
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: l10n.sessionExpiresAt,
            value: _formatDateTime(session.expiresAt),
          ),
        ],
      ),
    );
  }
}

class _SessionInfoRow extends StatelessWidget {
  const _SessionInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textScheme.label.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
