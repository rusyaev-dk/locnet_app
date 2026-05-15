// emoji_selector_controller.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';

final class EmojiSelectorController {
  EmojiSelectorController();

  OverlayEntry? _entry;

  final ValueNotifier<bool> _isVisibleNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<RelativeRect?> _positionNotifier =
      ValueNotifier<RelativeRect?>(null);

  TextEditingController? _textController;
  VoidCallback? _onDismiss;
  void Function({required bool isHovered})? _onOverlayHoverChanged;

  bool get isShown => _isVisibleNotifier.value;

  void show({
    required BuildContext context,
    required RelativeRect position,
    required TextEditingController textController,
    required VoidCallback onDismiss,
    required void Function({required bool isHovered}) onOverlayHoverChanged,
  }) {
    _textController = textController;
    _onDismiss = onDismiss;
    _onOverlayHoverChanged = onOverlayHoverChanged;

    _ensureEntryInserted(context);

    _positionNotifier.value = position;
    _isVisibleNotifier.value = true;
  }

  void hide() {
    _isVisibleNotifier.value = false;
  }

  void dispose() {
    _isVisibleNotifier.dispose();
    _positionNotifier.dispose();

    _entry?.remove();
    _entry = null;
  }

  void _ensureEntryInserted(BuildContext context) {
    if (_entry != null) {
      return;
    }

    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 55),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isVisibleNotifier,
            builder: (BuildContext context, bool isVisible, Widget? child) {
              return Offstage(
                offstage: !isVisible,
                child: IgnorePointer(ignoring: !isVisible, child: child),
              );
            },
            child: MouseRegion(
              onEnter: (_) => _onOverlayHoverChanged?.call(isHovered: true),
              onExit: (_) => _onOverlayHoverChanged?.call(isHovered: false),
              child: ValueListenableBuilder<RelativeRect?>(
                valueListenable: _positionNotifier,
                builder:
                    (
                      BuildContext context,
                      RelativeRect? position,
                      Widget? child,
                    ) {
                      final RelativeRect effectivePosition =
                          position ?? const RelativeRect.fromLTRB(0, 0, 0, 0);

                      final TextEditingController? controller = _textController;
                      if (controller == null) {
                        return const SizedBox.shrink();
                      }

                      return EmojiSelectorOverlay(
                        position: effectivePosition,
                        textController: controller,
                        onDismiss: () {
                          _onDismiss?.call();
                          hide();
                        },
                      );
                    },
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(_entry!);
  }
}
