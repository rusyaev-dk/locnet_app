import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/components/components.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

class ConversationListTile extends StatefulWidget {
  const ConversationListTile({
    required this.conversationTile,
    required this.isCompact,
    required this.onTap,
    required this.currentUserId,
    this.isSelected = false,
    super.key,
  });

  final ConversationTile conversationTile;
  final bool isCompact;
  final bool isSelected;
  final String currentUserId;
  final VoidCallback onTap;

  @override
  State<ConversationListTile> createState() => _ConversationListTileState();
}

class _ConversationListTileState extends State<ConversationListTile> {
  bool _hovered = false;

  static const Duration _hoverDuration = Duration(milliseconds: 120);

  Color _tileFill(BuildContext context) {
    final colorScheme = context.colorScheme;
    if (widget.isSelected) {
      return colorScheme.surfaceContainer;
    }
    if (_hovered) {
      return colorScheme.hoverOverlay;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final String avatarText = widget.conversationTile.companion != null
        ? ProfileDataExtractor.extractUserInitials(
            widget.conversationTile.companion!,
          )
        : widget.conversationTile.title;

    final Border border = Border.all(
      color: widget.isSelected ? colorScheme.outline : Colors.transparent,
    );

    if (widget.isCompact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: _hoverDuration,
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: _tileFill(context),
                borderRadius: BorderRadius.circular(10),
                border: border,
              ),
              padding: const EdgeInsets.all(5),
              child: ConversationAvatar(text: avatarText, size: 38),
            ),
          ),
        ),
      );
    }

    final String? lastMessageText = widget.conversationTile.lastMessageText;
    final String? lastSenderId = widget.conversationTile.lastMessageSenderId;
    final DateTime? lastAt = widget.conversationTile.lastMessageAt;

    String? timeText;
    String? subtitleText;
    String? subtitlePrefix;
    IconData? typeIcon;

    if (lastMessageText != null && lastAt != null) {
      final bool isOwn = lastSenderId == widget.currentUserId;
      subtitlePrefix = isOwn ? '${l10n.you}: ' : null;
      subtitleText = lastMessageText;
      timeText = DateTimeFormatter.formatConversationTime(
        dateTime: lastAt,
        now: DateTime.now(),
        locale: Localizations.localeOf(context),
        materialLocalizations: MaterialLocalizations.of(context),
      );
    }

    switch (widget.conversationTile.type) {
      case ConversationTileType.private:
        break;
      case ConversationTileType.group:
        typeIcon = Icons.group;
        break;
      case ConversationTileType.channel:
        typeIcon = Icons.campaign;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: _hoverDuration,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: _tileFill(context),
              borderRadius: BorderRadius.circular(10),
              border: border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                ConversationAvatar(text: avatarText, size: 38),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (typeIcon != null) ...[
                            Icon(
                              typeIcon,
                              color: colorScheme.onSurfaceVariant,
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                          ],
                          Expanded(
                            child: Text(
                              widget.conversationTile.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (timeText != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              timeText,
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSurfaceVariant,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (subtitleText != null) ...[
                        const SizedBox(height: 2),
                        ConversationMarkdownPreview(
                          markdown: subtitleText,
                          baseStyle: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                          linkColor: colorScheme.primary,
                          prefixText: subtitlePrefix,
                          prefixStyle: TextStyle(
                            fontSize: 11,
                            color: colorScheme.primary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
