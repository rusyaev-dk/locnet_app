import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class CompanionInfoModalCard extends StatelessWidget {
  const CompanionInfoModalCard({required this.companion, super.key});

  final User companion;

  static const Color _onlineColor = Color(0xFF4CAF79);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final String fullName = "${companion.firstName} ${companion.lastName}"
        .trim();
    final String initials = ProfileDataExtractor.extractUserInitials(companion);

    return AppModalCard(
      maxWidth: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gradient header ───────────────────────────────────────
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                // Gradient background
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.secondary,
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                // Close button top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: SurfaceIconButton(
                    icon: Icons.close,
                    dimension: 28,
                    iconSize: 14,
                    margin: EdgeInsets.zero,
                    foregroundColor: colorScheme.onSurfaceVariant,
                    tooltip: context.l10n.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          // ── Avatar overlap + name/role/status ─────────────────────
          Transform.translate(
            offset: const Offset(0, -44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConversationAvatar(text: initials, size: 80),
                  const SizedBox(height: 10),
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${companion.username}',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.companionStatusOnline,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _onlineColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Offset the content to compensate for the avatar overlap translation
          Transform.translate(
            offset: const Offset(0, -44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(height: 1, thickness: 1, color: colorScheme.outline),
                // ── Info rows ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.language,
                        label: context.l10n.companionFieldLanguage,
                        value: companion.languageCode,
                        colorScheme: colorScheme,
                      ),
                      if ((companion.description ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.article_outlined,
                          label: context.l10n.companionFieldAbout,
                          value: companion.description!.trim(),
                          colorScheme: colorScheme,
                        ),
                      ],
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colorScheme.outline),
                // ── Action row ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: context.l10n.companionActionMessage,
                    onPressed: () => Navigator.of(context).pop(),
                    colorScheme: colorScheme,
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface,
                height: 1.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.colorScheme,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final AppColorScheme colorScheme;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final Color bg = isPrimary ? colorScheme.primary : colorScheme.secondary;
    final BorderRadius br = BorderRadius.circular(8);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: br,
          hoverColor: colorScheme.onSurface.withValues(alpha: 0.08),
          splashColor: colorScheme.primary.withValues(alpha: 0.15),
          child: Ink(
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: colorScheme.outline, width: 1),
              borderRadius: br,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isPrimary ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPrimary
                          ? Colors.white
                          : colorScheme.onSurfaceVariant,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
