import 'package:flutter/material.dart';
import 'package:locnet_app/features/message/presentation/presentation.dart';

final class MessageContextMenuController {
  MessageContextMenuController();

  OverlayEntry? _entry;

  bool get isShown => _entry != null;

  void show({
    required BuildContext context,
    required RelativeRect position,
    required List<MessageContextMenuAction> actions,
  }) {
    hide();

    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return MessageContextMenuOverlay(
          position: position,
          actions: actions,
          onDismiss: hide,
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
