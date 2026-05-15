// emoji_button.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';
import 'package:locnet_app/uikit/buttons/buttons.dart';

class EmojiButton extends StatefulWidget {
  const EmojiButton({required this.textController, super.key});

  final TextEditingController textController;

  @override
  State<EmojiButton> createState() => _EmojiButtonState();
}

class _EmojiButtonState extends State<EmojiButton> {
  final GlobalKey _buttonKey = GlobalKey();
  final EmojiSelectorController _emojiController = EmojiSelectorController();

  Timer? _openDebounceTimer;
  Timer? _closeDebounceTimer;

  bool _isPointerOverButton = false;
  bool _isPointerOverOverlay = false;

  @override
  void dispose() {
    _openDebounceTimer?.cancel();
    _closeDebounceTimer?.cancel();
    _emojiController.dispose();
    super.dispose();
  }

  void _scheduleOpen() {
    _closeDebounceTimer?.cancel();
    _openDebounceTimer?.cancel();

    _openDebounceTimer = Timer(const Duration(), () {
      if (!mounted) {
        return;
      }
      if (_isPointerOverButton && !_emojiController.isShown) {
        _showEmojiPicker();
      }
    });
  }

  void _scheduleClose() {
    _openDebounceTimer?.cancel();
    _closeDebounceTimer?.cancel();

    _closeDebounceTimer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }
      final bool shouldClose = !_isPointerOverButton && !_isPointerOverOverlay;
      if (shouldClose && _emojiController.isShown) {
        _emojiController.hide();
      }
    });
  }

  void _showEmojiPicker() {
    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);
    final RenderObject? overlayObject = overlayState.context.findRenderObject();
    final BuildContext? buttonContext = _buttonKey.currentContext;

    if (overlayObject is! RenderBox || buttonContext == null) {
      return;
    }

    final RenderObject? buttonObject = buttonContext.findRenderObject();
    if (buttonObject is! RenderBox) {
      return;
    }

    final Offset buttonGlobal = buttonObject.localToGlobal(Offset.zero);
    final Offset buttonInOverlay = overlayObject.globalToLocal(buttonGlobal);

    final double overlayWidth = overlayObject.size.width;
    final double overlayHeight = overlayObject.size.height;

    final double panelHeight = overlayHeight * 0.35;
    const double gap = 8;

    final double desiredLeft = buttonInOverlay.dx;
    final double desiredTop = buttonInOverlay.dy - panelHeight - gap;

    final double clampedLeft = desiredLeft.clamp(8, overlayWidth - 8);
    final double clampedTop = desiredTop.clamp(8, overlayHeight - 8);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(
        clampedLeft,
        clampedTop,
        buttonObject.size.width,
        buttonObject.size.height,
      ),
      Offset.zero & overlayObject.size,
    );

    _emojiController.show(
      context: context,
      position: position,
      textController: widget.textController,
      onDismiss: () {
        _isPointerOverOverlay = false;
        _emojiController.hide();
      },
      onOverlayHoverChanged: ({required bool isHovered}) {
        _isPointerOverOverlay = isHovered;
        if (isHovered) {
          _scheduleOpen();
        } else {
          _scheduleClose();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isPointerOverButton = true;
        _scheduleOpen();
      },
      onExit: (_) {
        _isPointerOverButton = false;
        _scheduleClose();
      },
      child: SurfaceIconButton(
        key: _buttonKey,
        dimension: 35,
        iconSize: 25,
        margin: EdgeInsets.zero,
        tooltip: context.l10n.searchEmoji,
        onPressed: _emojiController.isShown
            ? _emojiController.hide
            : _showEmojiPicker,
        icon: Icons.emoji_emotions_outlined,
      ),
    );
  }
}
