import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Session details for Privacy / profile: status + device + validity rows.
class SessionInfo extends StatelessWidget {
  const SessionInfo({required this.session, super.key});

  final Session session;

  static final DateFormat _dateTimeFormatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final SessionStatusViewModel status = _buildStatus(
      l10n: l10n,
      colorScheme: colorScheme,
      session: session,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsGroupCard(
          title: l10n.currentSession,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _SessionStatusChip(label: status.label, color: status.color),
              ),
            ),
            SettingsValueTile(
              label: l10n.sessionDeviceName,
              value: _nullableOrDash(session.deviceName),
              leadingIcon: Icons.smartphone_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionDeviceType,
              value: _nullableOrDash(session.deviceType),
              leadingIcon: Icons.devices_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionOs,
              value: _nullableOrDash(session.os),
              leadingIcon: Icons.memory_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionIpAddress,
              value: _nullableOrDash(session.ipAddress),
              leadingIcon: Icons.language_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionMacAddress,
              value: _nullableOrDash(session.macAddress),
              leadingIcon: Icons.router_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SettingsGroupCard(
          title: l10n.settingsPrivacyTimingSection,
          children: [
            SettingsValueTile(
              label: l10n.sessionCreatedAt,
              value: _dateTimeFormatter.format(session.createdAt.toLocal()),
              leadingIcon: Icons.schedule_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionUpdatedAt,
              value: _dateTimeFormatter.format(session.updatedAt.toLocal()),
              leadingIcon: Icons.update_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionAccessExpiresAt,
              value: _dateTimeFormatter.format(
                session.accessExpiresAt.toLocal(),
              ),
              leadingIcon: Icons.timer_outlined,
            ),
            SettingsValueTile(
              label: l10n.sessionRefreshExpiresAt,
              value: _dateTimeFormatter.format(
                session.refreshExpiresAt.toLocal(),
              ),
              leadingIcon: Icons.refresh_outlined,
            ),
            if (session.terminatedAt != null)
              SettingsValueTile(
                label: l10n.sessionTerminatedAt,
                value: _dateTimeFormatter.format(
                  session.terminatedAt!.toLocal(),
                ),
                leadingIcon: Icons.block_outlined,
              ),
          ],
        ),
      ],
    );
  }

  static SessionStatusViewModel _buildStatus({
    required S l10n,
    required AppColorScheme colorScheme,
    required Session session,
  }) {
    final bool isTerminated = session.isTerminated == true;
    final bool isExpired = session.isExpired;

    if (isTerminated) {
      return SessionStatusViewModel(
        label: l10n.sessionStatusTerminated,
        color: colorScheme.error,
      );
    }

    if (isExpired) {
      return SessionStatusViewModel(
        label: l10n.sessionStatusExpired,
        color: colorScheme.tertiary,
      );
    }

    return SessionStatusViewModel(
      label: l10n.sessionStatusActive,
      color: colorScheme.primary,
    );
  }

  static String _nullableOrDash(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '—';
    }
    return normalized;
  }
}

class _SessionStatusChip extends StatelessWidget {
  const _SessionStatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withAlpha(0x24),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(0x66)),
      ),
      child: Text(
        label,
        style: textScheme.label.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class SessionStatusViewModel {
  const SessionStatusViewModel({required this.label, required this.color});

  final String label;
  final Color color;
}
