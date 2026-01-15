import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/gen/gen.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SessionInfo extends StatelessWidget {
  const SessionInfo({required this.session, super.key});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final bool isTerminated = session.isTerminated == true;
    final bool isExpired = session.isExpired;

    final String statusLabel = _buildStatusLabel(
      l10n: l10n,
      isExpired: isExpired,
      isTerminated: isTerminated,
    );

    final Color statusColor = _buildStatusColor(
      colorScheme: colorScheme,
      isExpired: isExpired,
      isTerminated: isTerminated,
    );

    final DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm');

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(0x1F),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: statusColor.withAlpha(0x5A)),
            ),
            child: Text(
              statusLabel,
              style: textScheme.label.copyWith(color: statusColor),
            ),
          ),
          const SizedBox(height: 16),
          _SessionInfoCard(
            items: [
              _SessionInfoItem(
                title: l10n.sessionDeviceName,
                value: _nullableOrDash(session.deviceName),
              ),
              _SessionInfoItem(
                title: l10n.sessionDeviceType,
                value: _nullableOrDash(session.deviceType),
              ),
              _SessionInfoItem(
                title: l10n.sessionOs,
                value: _nullableOrDash(session.os),
              ),
              _SessionInfoItem(
                title: l10n.sessionIpAddress,
                value: _nullableOrDash(session.ipAddress),
              ),
              _SessionInfoItem(
                title: l10n.sessionMacAddress,
                value: _nullableOrDash(session.macAddress),
              ),
              _SessionInfoItem(
                title: l10n.sessionCreatedAt,
                value: formatter.format(session.createdAt),
              ),
              _SessionInfoItem(
                title: l10n.sessionUpdatedAt,
                value: formatter.format(session.updatedAt),
              ),
              _SessionInfoItem(
                title: l10n.sessionExpiresAt,
                value: formatter.format(session.expiresAt),
              ),
              if (session.terminatedAt != null)
                _SessionInfoItem(
                  title: l10n.sessionTerminatedAt,
                  value: formatter.format(session.terminatedAt!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildStatusLabel({
    required S l10n,
    required bool isExpired,
    required bool isTerminated,
  }) {
    if (isTerminated) {
      return l10n.sessionStatusTerminated;
    }
    if (isExpired) {
      return l10n.sessionStatusExpired;
    }
    return l10n.sessionStatusActive;
  }

  Color _buildStatusColor({
    required AppColorScheme colorScheme,
    required bool isExpired,
    required bool isTerminated,
  }) {
    if (isTerminated) {
      return colorScheme.error;
    }
    if (isExpired) {
      return colorScheme.tertiary;
    }
    return colorScheme.primary;
  }

  static String _nullableOrDash(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '—';
    }
    return normalized;
  }
}

class _SessionInfoCard extends StatelessWidget {
  const _SessionInfoCard({required this.items});

  final List<_SessionInfoItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(0x6A)),
      ),
      child: Column(
        children: items
            .map(
              (_SessionInfoItem item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: _SessionInfoRow(item: item),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SessionInfoRow extends StatelessWidget {
  const _SessionInfoRow({required this.item});

  final _SessionInfoItem item;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            item.title,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item.value,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

class _SessionInfoItem {
  const _SessionInfoItem({required this.title, required this.value});

  final String title;
  final String value;
}
