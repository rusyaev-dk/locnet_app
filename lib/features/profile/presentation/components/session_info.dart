import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/gen/gen.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SessionInfo extends StatelessWidget {
  const SessionInfo({required this.session, super.key});

  final Session session;

  static final DateFormat _dateTimeFormatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final SessionStatusViewModel status = _buildStatus(
      l10n: l10n,
      colorScheme: colorScheme,
      session: session,
    );

    final List<SessionInfoItem> items = _buildItems(
      l10n: l10n,
      session: session,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionStatusChip(label: status.label, color: status.color),
        const SizedBox(height: 15),
        SessionInfoCard(items: items),
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

  static List<SessionInfoItem> _buildItems({
    required S l10n,
    required Session session,
  }) {
    final List<SessionInfoItem> items = [
      SessionInfoItem(
        title: l10n.sessionDeviceName,
        value: _nullableOrDash(session.deviceName),
      ),
      SessionInfoItem(
        title: l10n.sessionDeviceType,
        value: _nullableOrDash(session.deviceType),
      ),
      SessionInfoItem(
        title: l10n.sessionOs,
        value: _nullableOrDash(session.os),
      ),
      SessionInfoItem(
        title: l10n.sessionIpAddress,
        value: _nullableOrDash(session.ipAddress),
      ),
      SessionInfoItem(
        title: l10n.sessionMacAddress,
        value: _nullableOrDash(session.macAddress),
      ),
      SessionInfoItem(
        title: l10n.sessionCreatedAt,
        value: _dateTimeFormatter.format(session.createdAt),
      ),
      SessionInfoItem(
        title: l10n.sessionUpdatedAt,
        value: _dateTimeFormatter.format(session.updatedAt),
      ),
      SessionInfoItem(
        title: l10n.sessionExpiresAt,
        value: _dateTimeFormatter.format(session.expiresAt),
      ),
    ];

    if (session.terminatedAt != null) {
      items.add(
        SessionInfoItem(
          title: l10n.sessionTerminatedAt,
          value: _dateTimeFormatter.format(session.terminatedAt!),
        ),
      );
    }

    return items;
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(0x1F),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(0x5A)),
      ),
      child: Text(label, style: textScheme.label.copyWith(color: color)),
    );
  }
}

class SessionInfoCard extends StatelessWidget {
  const SessionInfoCard({required this.items, super.key});

  final List<SessionInfoItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (entry) {
                final int index = entry.key;
                final SessionInfoItem item = entry.value;
                final bool isLast = index == items.length - 1;
                
                return Column(
                  children: [
                    SessionInfoRow(item: item),
                    if (!isLast) ...[
                      const SizedBox(height: 12),
                      Divider(
                        height: 1,
                        color: colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
            )
            .toList(),
      ),
    );
  }
}

class SessionInfoRow extends StatelessWidget {
  const SessionInfoRow({required this.item, super.key});

  final SessionInfoItem item;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            item.title,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            item.value,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurface,
              fontSize: 14,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class SessionInfoItem {
  const SessionInfoItem({required this.title, required this.value});

  final String title;
  final String value;
}

class SessionStatusViewModel {
  const SessionStatusViewModel({required this.label, required this.color});

  final String label;
  final Color color;
}
