import 'package:flutter/material.dart';
import 'package:locnet_app/features/message/subfeatures/message_input_selection_toolbar/presentation/presentation.dart';

final class MessageInputSelectionToolbarController {
  MessageInputSelectionToolbarController();

  OverlayEntry? _entry;

  bool get isShown => _entry != null;

  void show({
    required BuildContext context,
    required RelativeRect position,
    required List<MessageInputSelectionToolbarAction> actions,
    required VoidCallback onDismiss,
  }) {
    hide();

    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return MessageInputSelectionToolbarOverlay(
          position: position,
          actions: actions,
          onDismiss: onDismiss,
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
