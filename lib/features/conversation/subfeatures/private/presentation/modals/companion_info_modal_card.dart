import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

class CompanionInfoModalCard extends StatelessWidget {
  const CompanionInfoModalCard({required this.companion, super.key});

  final User companion;

  @override
  Widget build(BuildContext context) {
    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanionInfoHeader(companion: companion),
          Divider(height: 1, color: context.colorScheme.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  CompanionInfoActionRow(
                    onChatPressed: () {},
                    onMutePressed: () {},
                    onCallPressed: () {},
                    onMorePressed: () {},
                  ),
                  const SizedBox(height: 16),
                  const CompanionInfoSectionTitle(title: 'Info'),
                  const SizedBox(height: 8),
                  CompanionInfoGroupCard(
                    child: Column(
                      children: [
                        CompanionInfoTile(
                          title: 'Username',
                          value: '@${companion.username}',
                          icon: Icons.alternate_email,
                          onPressed: () {},
                        ),
                        Divider(
                          height: 1,
                          indent: 48,
                          color: context.colorScheme.outlineVariant,
                        ),
                        CompanionInfoTile(
                          title: 'Language',
                          value: companion.languageCode,
                          icon: Icons.language,
                          onPressed: () {},
                        ),
                        if ((companion.description ?? '')
                            .trim()
                            .isNotEmpty) ...[
                          Divider(
                            height: 1,
                            indent: 48,
                            color: context.colorScheme.outlineVariant,
                          ),
                          CompanionInfoTile(
                            title: 'About',
                            value: companion.description!.trim(),
                            icon: Icons.info_outline,
                            onPressed: () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CompanionInfoSectionTitle(title: 'More'),
                  const SizedBox(height: 8),
                  CompanionInfoGroupCard(
                    child: Column(
                      children: [
                        CompanionInfoTile(
                          title: 'Shared media',
                          value: '0',
                          icon: Icons.photo_library_outlined,
                          onPressed: () {},
                        ),
                        Divider(
                          height: 1,
                          indent: 48,
                          color: context.colorScheme.outlineVariant,
                        ),
                        CompanionInfoTile(
                          title: 'Shared files',
                          value: '0',
                          icon: Icons.insert_drive_file_outlined,
                          onPressed: () {},
                        ),
                        Divider(
                          height: 1,
                          indent: 48,
                          color: context.colorScheme.outlineVariant,
                        ),
                        CompanionInfoTile(
                          title: 'Shared links',
                          value: '0',
                          icon: Icons.link_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanionInfoActionRow extends StatelessWidget {
  const CompanionInfoActionRow({
    required this.onChatPressed,
    required this.onMutePressed,
    required this.onCallPressed,
    required this.onMorePressed,
    super.key,
  });

  final VoidCallback onChatPressed;
  final VoidCallback onMutePressed;
  final VoidCallback onCallPressed;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CompanionInfoActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            onPressed: onChatPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CompanionInfoActionButton(
            icon: Icons.notifications_off_outlined,
            label: 'Mute',
            onPressed: onMutePressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CompanionInfoActionButton(
            icon: Icons.call_outlined,
            label: 'Call',
            onPressed: onCallPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CompanionInfoActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onPressed: onMorePressed,
          ),
        ),
      ],
    );
  }
}

class CompanionInfoActionButton extends StatelessWidget {
  const CompanionInfoActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color backgroundColor = colorScheme.surfaceContainer.withAlpha(140);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                label,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanionInfoSectionTitle extends StatelessWidget {
  const CompanionInfoSectionTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Text(
      title,
      style: textScheme.label.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        fontSize: 15,
      ),
    );
  }
}

class CompanionInfoGroupCard extends StatelessWidget {
  const CompanionInfoGroupCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class CompanionInfoTile extends StatelessWidget {
  const CompanionInfoTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textScheme.label.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: textScheme.label.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
