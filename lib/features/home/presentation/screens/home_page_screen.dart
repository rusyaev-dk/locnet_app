import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LocNet',
                style: textScheme.display.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Local network messenger control panel',
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              _SurfaceCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              // TODO: create conversation
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('New conversation'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: create group
                            },
                            icon: const Icon(Icons.group_add_outlined),
                            label: const Text('New group'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: open search
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Search'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System status',
                            style: textScheme.headline.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _KeyValueRow(
                            label: 'Connection',
                            value: 'Online',
                            valueColor: colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          const _KeyValueRow(
                            label: 'API latency',
                            value: '42 ms',
                          ),
                          const SizedBox(height: 8),
                          const _KeyValueRow(
                            label: 'WebSocket',
                            value: 'Connected',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: _SurfaceCard(
                      title: 'Recent activity',
                      subtitle: 'Latest events across the network',
                      child: Column(
                        children: [
                          _ActivityRow(
                            icon: Icons.person_outline,
                            title: 'Admin signed in',
                            subtitle: 'admin@locnet',
                            trailing: '2m',
                          ),
                          Divider(height: 24),
                          _ActivityRow(
                            icon: Icons.devices_other_outlined,
                            title: 'Device linked',
                            subtitle: 'MacBook Pro • Office 2',
                            trailing: '17m',
                          ),
                          Divider(height: 24),
                          _ActivityRow(
                            icon: Icons.warning_amber_outlined,
                            title: 'Failed logins',
                            subtitle: '3 attempts • 185.21.0.12',
                            trailing: '1h',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 360,
                    child: _SurfaceCard(
                      title: 'Sessions',
                      subtitle: 'Today',
                      child: Column(
                        children: [
                          const _KeyValueRow(
                            label: 'Active sessions',
                            value: '12',
                          ),
                          const SizedBox(height: 8),
                          _KeyValueRow(
                            label: 'Expiring soon',
                            value: '3',
                            valueColor: colorScheme.tertiary,
                          ),
                          const SizedBox(height: 8),
                          const _KeyValueRow(
                            label: 'Terminated today',
                            value: '4',
                          ),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: go to sessions page
                              },
                              child: const Text('View all'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.title, this.subtitle});

  final String? title;
  final String? subtitle;
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
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: textScheme.headline.copyWith(color: colorScheme.onSurface),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (title != null || subtitle != null) const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

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
          style: textScheme.label.copyWith(
            color: valueColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

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
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: colorScheme.primary),
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
                subtitle,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          trailing,
          style: textScheme.label.copyWith(color: colorScheme.outline),
        ),
      ],
    );
  }
}
