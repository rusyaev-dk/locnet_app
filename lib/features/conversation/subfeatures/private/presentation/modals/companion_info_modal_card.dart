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
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
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
                  ConversationAvatar(text: initials, size: 80, isOnline: true),
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
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: const BoxDecoration(
                          color: _onlineColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        context.l10n.companionStatusOnline,
                        style: TextStyle(
                          fontSize: 12,
                          color: _onlineColor,
                          height: 1.2,
                        ),
                      ),
                    ],
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
                          icon: Icons.info_outline,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.call_outlined,
                          label: context.l10n.companionActionCall,
                          onPressed: () {},
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.videocam_outlined,
                          label: context.l10n.companionActionVideo,
                          onPressed: () {},
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? colorScheme.primary : colorScheme.secondary,
          border: Border.all(color: colorScheme.outline, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
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
                color: isPrimary ? Colors.white : colorScheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
          ],
        ),
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
          child: ConversationInfoActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            onPressed: onChatPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.call_outlined,
            label: 'Call',
            onPressed: onCallPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ConversationInfoActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onPressed: onMorePressed,
          ),
        ),
      ],
    );
  }
}
