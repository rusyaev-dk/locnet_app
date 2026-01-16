// emoji_selector_controller.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';

final class EmojiSelectorController {
  EmojiSelectorController();

  OverlayEntry? _entry;

  bool get isShown => _entry != null;

  void show({
    required BuildContext context,
    required RelativeRect position,
    required TextEditingController textController,
    required VoidCallback onDismiss,
    required void Function({required bool isHovered}) onOverlayHoverChanged,
  }) {
    hide();

    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 55),
          child: MouseRegion(
            onEnter: (_) => onOverlayHoverChanged(isHovered: true),
            onExit: (_) => onOverlayHoverChanged(isHovered: false),
            child: EmojiSelectorOverlay(
              position: position,
              textController: textController,
              onDismiss: onDismiss,
            ),
          ),
        );
      },
    );

    overlayState.insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }

  void dispose() {
    hide();
  }
}
