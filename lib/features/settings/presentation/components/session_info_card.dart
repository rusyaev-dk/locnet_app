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

  String _boolToStatus(bool value) {
    return value ? 'Yes' : 'No';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final bool isTerminated = session.isTerminated ?? false;

    return SettingsGroupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session details',
            style: textScheme.headline.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(
                  session.isExpired ? 'Expired' : 'Active',
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
                    'Terminated',
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  avatar: Icon(
                    Icons.logout,
                    size: 18,
                    color: colorScheme.onSurface,
                  ),
                  backgroundColor:
                      colorScheme.surfaceContainerHighest.withAlpha(200),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _SessionInfoRow(
            label: 'User ID',
            value: session.userId,
          ),
          _SessionInfoRow(
            label: 'Session ID',
            value: session.sessionId,
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'Device name',
            value: session.deviceName ?? 'Unknown',
          ),
          _SessionInfoRow(
            label: 'Device type',
            value: session.deviceType ?? 'Unknown',
          ),
          _SessionInfoRow(
            label: 'OS',
            value: session.os ?? 'Unknown',
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'IP address',
            value: session.ipAddress ?? 'Unknown',
          ),
          _SessionInfoRow(
            label: 'MAC address',
            value: session.macAddress ?? 'Unknown',
          ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'Created at',
            value: _formatDateTime(session.createdAt),
          ),
          _SessionInfoRow(
            label: 'Updated at',
            value: _formatDateTime(session.updatedAt),
          ),
          _SessionInfoRow(
            label: 'Expires at',
            value: _formatDateTime(session.expiresAt),
          ),
          if (isTerminated && session.terminatedAt != null)
            _SessionInfoRow(
              label: 'Terminated at',
              value: _formatDateTime(session.terminatedAt!),
            ),
          const SizedBox(height: 8),
          _SessionInfoRow(
            label: 'Is expired',
            value: _boolToStatus(session.isExpired),
          ),
          _SessionInfoRow(
            label: 'Is terminated',
            value: _boolToStatus(isTerminated),
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
              style: textScheme.label.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
