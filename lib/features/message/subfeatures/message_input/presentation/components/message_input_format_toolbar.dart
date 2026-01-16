// message_input_format_toolbar.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class MessageInputFormatToolbar extends StatelessWidget {
  const MessageInputFormatToolbar({
    required this.onBold,
    required this.onItalic,
    required this.onCode,
    required this.onStrike,
    required this.onLink,
    required this.onCopy,
    required this.onCut,
    required this.onKeepFocus,
    super.key,
  });

  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onCode;
  final VoidCallback onStrike;
  final VoidCallback onLink;
  final VoidCallback onCopy;
  final VoidCallback onCut;

  final VoidCallback onKeepFocus;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(110)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToolbarButton(
              tooltip: 'Copy (Ctrl+C)',
              icon: Icons.copy,
              onPressed: onCopy,
              onTapDown: onKeepFocus,
            ),
            _ToolbarButton(
              tooltip: 'Cut (Ctrl+X)',
              icon: Icons.content_cut,
              onPressed: onCut,
              onTapDown: onKeepFocus,
            ),
            const SizedBox(
              height: 24,
              child: VerticalDivider(thickness: 1, width: 12),
            ),
            _ToolbarButton(
              tooltip: 'Bold (Ctrl+B)',
              icon: Icons.format_bold,
              onPressed: onBold,
              onTapDown: onKeepFocus,
            ),
            _ToolbarButton(
              tooltip: 'Italic (Ctrl+I)',
              icon: Icons.format_italic,
              onPressed: onItalic,
              onTapDown: onKeepFocus,
            ),
            _ToolbarButton(
              tooltip: 'Code (Ctrl+E)',
              icon: Icons.code,
              onPressed: onCode,
              onTapDown: onKeepFocus,
            ),
            _ToolbarButton(
              tooltip: 'Strike (Ctrl+S)',
              icon: Icons.format_strikethrough,
              onPressed: onStrike,
              onTapDown: onKeepFocus,
            ),
            _ToolbarButton(
              tooltip: 'Link (Ctrl+K)',
              icon: Icons.link,
              onPressed: onLink,
              onTapDown: onKeepFocus,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.onTapDown,
    // ignore: unused_element_parameter
    this.isHidden = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback? onTapDown;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        label: tooltip,
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTapDown: (_) => onTapDown?.call(),
          onTap: onPressed,
          child: SizedBox(
            height: 32,
            width: 32,
            child: Icon(icon, size: 18, color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
