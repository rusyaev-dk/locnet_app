import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HomeHeaderSection(
                  title: 'LocNet panel',
                  subtitle:
                      'Monitor conversations, sessions and storage in one place.',
                  primaryActionLabel: 'New conversation',
                  secondaryActionLabel: 'View analytics',
                ),
                const SizedBox(height: 24),
                const Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _OverviewStatCard(
                      iconData: Icons.lock_outline,
                      title: 'Active sessions',
                      value: '12',
                      caption: '2 new in the last 24 hours',
                    ),
                    _OverviewStatCard(
                      iconData: Icons.chat_bubble_outline,
                      title: 'Conversations',
                      value: '248',
                      caption: '18 unread threads',
                    ),
                    _OverviewStatCard(
                      iconData: Icons.storage_outlined,
                      title: 'Storage used',
                      value: '32.4 GB',
                      caption: 'Of 100 GB available',
                    ),
                    _OverviewStatCard(
                      iconData: Icons.security_outlined,
                      title: 'Security status',
                      value: 'No incidents',
                      caption: 'Last check 5 minutes ago',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _SectionCard(
                        title: 'Recent activity',
                        subtitle: 'Latest events across the network',
                        child: Column(
                          children: [
                            _RecentActivityItem(
                              iconData: Icons.person_outline,
                              title: 'New admin logged in',
                              description: 'Account: admin@locnet.io',
                              timeLabel: '2 minutes ago',
                            ),
                            Divider(height: 24),
                            _RecentActivityItem(
                              iconData: Icons.devices_other_outlined,
                              title: 'New device linked',
                              description: 'MacBook Pro • Tashkent office',
                              timeLabel: '17 minutes ago',
                            ),
                            Divider(height: 24),
                            _RecentActivityItem(
                              iconData: Icons.warning_amber_outlined,
                              title: 'Unusual activity detected',
                              description:
                                  '3 failed login attempts from IP 185.21.0.12',
                              timeLabel: '1 hour ago',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          _SectionCard(
                            title: 'Sessions overview',
                            subtitle: 'Today',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _MiniMetricRow(
                                  label: 'Active sessions',
                                  value: '12',
                                ),
                                SizedBox(height: 8),
                                _MiniMetricRow(
                                  label: 'Terminated today',
                                  value: '4',
                                ),
                                SizedBox(height: 8),
                                _MiniMetricRow(
                                  label: 'Expiring in 1 hour',
                                  value: '3',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          _SectionCard(
                            title: 'System health',
                            subtitle: 'Infrastructure status',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _HealthStatusRow(
                                  label: 'API latency',
                                  status: 'Stable',
                                ),
                                SizedBox(height: 8),
                                _HealthStatusRow(
                                  label: 'Database',
                                  status: 'Operational',
                                ),
                                SizedBox(height: 8),
                                _HealthStatusRow(
                                  label: 'Notification service',
                                  status: 'Degraded in EU region',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.sessionDetails, // просто пример использования локализации
                  style: textScheme.label.copyWith(color: colorScheme.outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeaderSection extends StatelessWidget {
  const _HomeHeaderSection({
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
  });

  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final String secondaryActionLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textScheme.display.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Row(
          children: [
            FilledButton.icon(
              onPressed: () {
                // TODO: navigation to create conversation
              },
              icon: const Icon(Icons.add),
              label: Text(primaryActionLabel),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                // TODO: navigation to analytics
              },
              child: Text(secondaryActionLabel),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewStatCard extends StatelessWidget {
  const _OverviewStatCard({
    required this.iconData,
    required this.title,
    required this.value,
    required this.caption,
  });

  final IconData iconData;
  final String title;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return SizedBox(
      width: 260,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, size: 20, color: colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: textScheme.headline.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              style: textScheme.label.copyWith(color: colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textScheme.headline.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _RecentActivityItem extends StatelessWidget {
  const _RecentActivityItem({
    required this.iconData,
    required this.title,
    required this.description,
    required this.timeLabel,
  });

  final IconData iconData;
  final String title;
  final String description;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(24),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(iconData, size: 20, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textScheme.label.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          timeLabel,
          style: textScheme.label.copyWith(color: colorScheme.outline),
        ),
      ],
    );
  }
}

class _MiniMetricRow extends StatelessWidget {
  const _MiniMetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: textScheme.label.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }
}

class _HealthStatusRow extends StatelessWidget {
  const _HealthStatusRow({required this.label, required this.status});

  final String label;
  final String status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          status,
          style: textScheme.label.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
