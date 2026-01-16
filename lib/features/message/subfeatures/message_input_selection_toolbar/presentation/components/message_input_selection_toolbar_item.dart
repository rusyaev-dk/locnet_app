import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';

class MessageInputSelectionToolbarItem extends StatefulWidget {
  const MessageInputSelectionToolbarItem({
    required this.title,
    required this.icon,
    required this.isEnabled,
    required this.isDestructive,
    required this.onPressed,
    super.key,
  });

  final String title;
  final IconData icon;
  final bool isEnabled;
  final bool isDestructive;
  final VoidCallback onPressed;

  @override
  State<MessageInputSelectionToolbarItem> createState() =>
      _MessageInputSelectionToolbarItemState();
}

class _MessageInputSelectionToolbarItemState
    extends State<MessageInputSelectionToolbarItem> {
  bool _isHovered = false;

  void _handleEnter(PointerEnterEvent event) {
    if (!widget.isEnabled) {
      return;
    }

    setState(() {
      _isHovered = true;
    });
  }

  void _handleExit(PointerExitEvent event) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color foregroundColor = widget.isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    final Color hoverColor = widget.isDestructive
        ? colorScheme.error.withAlpha(20)
        : colorScheme.onSurface.withAlpha(20);

    return MouseRegion(
      onEnter: _handleEnter,
      onExit: _handleExit,
      cursor: widget.isEnabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerUp: (PointerUpEvent event) {
          if (!widget.isEnabled) {
            return;
          }

          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          color: _isHovered ? hoverColor : Colors.transparent,
          child: Opacity(
            opacity: widget.isEnabled ? 1 : 0.45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(widget.icon, size: 20, color: foregroundColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: textScheme.label.copyWith(
                        color: foregroundColor,
                        fontSize: 14.5,
                      ),
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
