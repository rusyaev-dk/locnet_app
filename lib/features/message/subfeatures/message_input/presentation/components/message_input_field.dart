// message_input_field.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input_selection_toolbar/presentation/presentation.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({
    required this.onSubmitted,
    required this.controller,
    super.key,
    this.onChanged,
    this.maxSymbols,
    this.minLines = 1,
    this.hintText,
  });

  final MessageRichInputController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final int? maxSymbols;
  final int minLines;
  final String? hintText;

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  late final MessageRichInputController _controller;

  final FocusNode _focusNode = FocusNode();
  final GlobalKey _textFieldKey = GlobalKey();

  final MessageInputSelectionToolbarController _toolbarController =
      MessageInputSelectionToolbarController();

  bool _toolbarUpdateScheduled = false;

  TextSelection? _selectionSnapshotForToolbar;
  String? _selectedTextSnapshotForToolbar;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;

    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _toolbarController.dispose();

    _controller.removeListener(_handleControllerChanged);
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();

    super.dispose();
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) {
      _hideToolbarAndClearSnapshot();
      return;
    }

    _scheduleToolbarUpdate();
  }

  void _handleControllerChanged() {
    widget.onChanged?.call(_controller.text);

    if (_toolbarController.isShown) {
      return;
    }

    _scheduleToolbarUpdate();
  }

  void _scheduleToolbarUpdate() {
    if (_toolbarUpdateScheduled) {
      return;
    }

    _toolbarUpdateScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _toolbarUpdateScheduled = false;

      if (!mounted) {
        return;
      }

      _updateToolbarVisibilityNow();
    });
  }

  void _updateToolbarVisibilityNow() {
    if (!_focusNode.hasFocus) {
      _hideToolbarAndClearSnapshot();
      return;
    }

    if (_toolbarController.isShown) {
      return;
    }

    final TextSelection selection = _controller.selection;
    final bool hasSelection =
        selection.isValid && !selection.isCollapsed && selection.start >= 0;

    if (!hasSelection) {
      _hideToolbarAndClearSnapshot();
    }
  }

  void _hideToolbarAndClearSnapshot() {
    _toolbarController.hide();
    _selectionSnapshotForToolbar = null;
    _selectedTextSnapshotForToolbar = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    final bool isSecondaryClick = (event.buttons & kSecondaryMouseButton) != 0;
    if (!isSecondaryClick) {
      return;
    }

    final TextSelection selection = _controller.selection;
    final bool hasSelection =
        selection.isValid && !selection.isCollapsed && selection.start >= 0;

    if (!hasSelection) {
      _hideToolbarAndClearSnapshot();
      return;
    }

    _selectionSnapshotForToolbar = selection;
    _selectedTextSnapshotForToolbar = _selectedTextFromSelection(
      _controller.value,
    );

    _showToolbarNearSelection(selectionSnapshot: selection);
  }

  String? _selectedTextFromSelection(TextEditingValue value) {
    final TextSelection selection = value.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return null;
    }

    final int start = selection.start;
    final int end = selection.end;

    if (start < 0 ||
        end < 0 ||
        start > value.text.length ||
        end > value.text.length) {
      return null;
    }

    return value.text.substring(start, end);
  }

  RenderEditable? _findRenderEditable(RenderObject root) {
    RenderEditable? found;

    void visit(RenderObject object) {
      if (object is RenderEditable) {
        found = object;
        return;
      }

      object.visitChildren((RenderObject child) {
        if (found != null) {
          return;
        }
        visit(child);
      });
    }

    visit(root);
    return found;
  }

  void _showToolbarNearSelection({required TextSelection selectionSnapshot}) {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    final bool hasSelection =
        selectionSnapshot.isValid &&
        !selectionSnapshot.isCollapsed &&
        selectionSnapshot.start >= 0;

    if (!hasSelection) {
      _hideToolbarAndClearSnapshot();
      return;
    }

    final BuildContext? textFieldContext = _textFieldKey.currentContext;
    if (textFieldContext == null) {
      return;
    }

    final RenderObject? textFieldRenderObject = textFieldContext
        .findRenderObject();
    if (textFieldRenderObject == null) {
      return;
    }

    final RenderEditable? renderEditable = _findRenderEditable(
      textFieldRenderObject,
    );
    if (renderEditable == null) {
      return;
    }

    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);
    final RenderObject? overlayRenderObject = overlayState.context
        .findRenderObject();
    if (overlayRenderObject is! RenderBox) {
      return;
    }

    final List<TextSelectionPoint> endpoints = renderEditable
        .getEndpointsForSelection(selectionSnapshot);

    final Offset localAnchor = endpoints.isNotEmpty
        ? endpoints.last.point
        : renderEditable
              .getLocalRectForCaret(
                TextPosition(offset: selectionSnapshot.extentOffset),
              )
              .bottomLeft;

    final Offset globalAnchor = renderEditable.localToGlobal(localAnchor);
    final RenderBox overlayBox = overlayRenderObject;
    final Offset anchorInOverlay = overlayBox.globalToLocal(globalAnchor);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(anchorInOverlay.dx, anchorInOverlay.dy, 0, 0),
      Offset.zero & overlayBox.size,
    );

    final l10n = context.l10n;
    final String selectedText = (_selectedTextSnapshotForToolbar ?? '').trim();

    final List<MessageInputSelectionToolbarAction> actions =
        <MessageInputSelectionToolbarAction>[
          MessageInputSelectionToolbarAction(
            id: 'copy',
            title: l10n.messageInputToolbarActionCopy,
            icon: Icons.copy,
            isEnabled: selectedText.isNotEmpty,
            onPressed: () async {
              _toolbarController.hide();
              await _copySelectionFromSnapshot();
            },
          ),
          MessageInputSelectionToolbarAction(
            id: 'cut',
            title: l10n.messageInputToolbarActionCut,
            icon: Icons.content_cut,
            isEnabled: selectedText.isNotEmpty,
            onPressed: () async {
              _toolbarController.hide();
              await _cutSelectionFromSnapshot();
            },
          ),
          MessageInputSelectionToolbarAction(
            id: 'bold',
            title: l10n.messageInputToolbarActionFormatBold,
            icon: Icons.format_bold,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.toggleBold(),
            ),
          ),
          MessageInputSelectionToolbarAction(
            id: 'italic',
            title: l10n.messageInputToolbarActionFormatItalic,
            icon: Icons.format_italic,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.toggleItalic(),
            ),
          ),
          MessageInputSelectionToolbarAction(
            id: 'underline',
            title: l10n.messageInputToolbarActionFormatUnderline,
            icon: Icons.format_underline,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.toggleUnderline(),
            ),
          ),
          MessageInputSelectionToolbarAction(
            id: 'code',
            title: l10n.messageInputToolbarActionFormatCode,
            icon: Icons.code,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.toggleCode(),
            ),
          ),
          MessageInputSelectionToolbarAction(
            id: 'code_block',
            title: l10n.messageInputToolbarActionFormatCodeBlock,
            icon: Icons.data_object,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.toggleCodeBlock(),
            ),
          ),
          MessageInputSelectionToolbarAction(
            id: 'strike',
            title: l10n.messageInputToolbarActionFormatStrike,
            icon: Icons.format_strikethrough,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.toggleStrike(),
            ),
          ),
          MessageInputSelectionToolbarAction(
            id: 'link',
            title: l10n.messageInputToolbarActionFormatLink,
            icon: Icons.link,
            onPressed: () => _applyFormattingWithSelectionSnapshot(
              (MessageRichInputController controller) =>
                  controller.setLink(url: 'https://'),
            ),
          ),
        ];

    _toolbarController.show(
      context: context,
      position: position,
      actions: actions,
      onDismiss: _hideToolbarAndClearSnapshot,
    );
  }

  void _restoreSelectionSnapshotIfNeeded() {
    final TextSelection? snapshot = _selectionSnapshotForToolbar;
    if (snapshot == null) {
      return;
    }

    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    _controller.selection = snapshot;
  }

  void _applyFormattingWithSelectionSnapshot(
    void Function(MessageRichInputController controller) action,
  ) {
    _toolbarController.hide();
    _restoreSelectionSnapshotIfNeeded();

    action(_controller);
    _scheduleToolbarUpdate();
  }

  Future<void> _copySelectionFromSnapshot() async {
    final String selected = (_selectedTextSnapshotForToolbar ?? '').trim();
    if (selected.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: selected));
  }

  Future<void> _cutSelectionFromSnapshot() async {
    final String selected = (_selectedTextSnapshotForToolbar ?? '').trim();
    if (selected.isEmpty) {
      return;
    }

    _restoreSelectionSnapshotIfNeeded();

    await Clipboard.setData(ClipboardData(text: selected));

    final TextEditingValue value = _controller.value;
    final TextSelection selection = value.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    final int start = selection.start;
    final int end = selection.end;

    final String newText = value.text.replaceRange(start, end, '');

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start),
    );

    final List<MessageInlineStyleRange> updatedRanges =
        _removeRangesIntersectingSelection(
          ranges: _controller.ranges,
          selectionStart: start,
          selectionEnd: end,
        );

    _controller.setRanges(updatedRanges);

    _selectionSnapshotForToolbar = null;
    _selectedTextSnapshotForToolbar = null;

    _scheduleToolbarUpdate();
  }

  List<MessageInlineStyleRange> _removeRangesIntersectingSelection({
    required List<MessageInlineStyleRange> ranges,
    required int selectionStart,
    required int selectionEnd,
  }) {
    final List<MessageInlineStyleRange> out = <MessageInlineStyleRange>[];

    for (final MessageInlineStyleRange range in ranges) {
      final bool intersects =
          range.start < selectionEnd && range.end > selectionStart;
      if (intersects) {
        continue;
      }

      final int removedLength = selectionEnd - selectionStart;

      if (range.start >= selectionEnd) {
        out.add(
          range.copyWith(
            start: range.start - removedLength,
            end: range.end - removedLength,
          ),
        );
        continue;
      }

      out.add(range);
    }

    return out;
  }

  void _snapshotSelectionForHotkey() {
    _selectionSnapshotForToolbar = _controller.selection;
    _selectedTextSnapshotForToolbar = _selectedTextFromSelection(
      _controller.value,
    );
  }

  void _submit() {
    final String plainText = _controller.text;
    if (plainText.trim().isEmpty) {
      // Parent (`MessageInputBar`) may still send attachments-only.
      widget.onSubmitted('');
      return;
    }

    final String markdown = MessageMarkdownCodec.encode(
      text: _controller.text,
      ranges: _controller.ranges,
    );

    widget.onSubmitted(markdown);

    _controller
      ..clear()
      ..clearAllFormatting();

    _hideToolbarAndClearSnapshot();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputForeground = isDark ? Colors.white : colorScheme.onSurface;

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double visibleViewportHeight =
        (mediaQuery.size.height - mediaQuery.viewInsets.bottom).clamp(
          120.0,
          double.infinity,
        );
    final double maxHeight = visibleViewportHeight * 0.35;

    final TextStyle baseStyle = textScheme.label.copyWith(
      color: inputForeground,
      fontSize: 16,
    );

    final List<TextInputFormatter> inputFormatters = widget.maxSymbols != null
        ? <TextInputFormatter>[
            LengthLimitingTextInputFormatter(widget.maxSymbols),
          ]
        : const <TextInputFormatter>[];

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyB, control: true): BoldIntent(),
        SingleActivator(LogicalKeyboardKey.keyI, control: true): ItalicIntent(),
        SingleActivator(LogicalKeyboardKey.keyU, control: true):
            UnderlineIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, control: true): CodeIntent(),
        SingleActivator(LogicalKeyboardKey.keyS, control: true): StrikeIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, control: true): LinkIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, control: true, shift: true):
            CodeBlockIntent(),
        SingleActivator(LogicalKeyboardKey.keyB, meta: true): BoldIntent(),
        SingleActivator(LogicalKeyboardKey.keyI, meta: true): ItalicIntent(),
        SingleActivator(LogicalKeyboardKey.keyU, meta: true): UnderlineIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, meta: true): CodeIntent(),
        SingleActivator(LogicalKeyboardKey.keyS, meta: true): StrikeIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, meta: true): LinkIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, meta: true, shift: true):
            CodeBlockIntent(),
        SingleActivator(LogicalKeyboardKey.enter, control: true): SendIntent(),
        SingleActivator(LogicalKeyboardKey.enter, meta: true): SendIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          BoldIntent: CallbackAction<BoldIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.toggleBold(),
              );
              return null;
            },
          ),
          ItalicIntent: CallbackAction<ItalicIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.toggleItalic(),
              );
              return null;
            },
          ),
          UnderlineIntent: CallbackAction<UnderlineIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.toggleUnderline(),
              );
              return null;
            },
          ),
          CodeIntent: CallbackAction<CodeIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.toggleCode(),
              );
              return null;
            },
          ),
          CodeBlockIntent: CallbackAction<CodeBlockIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.toggleCodeBlock(),
              );
              return null;
            },
          ),
          StrikeIntent: CallbackAction<StrikeIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.toggleStrike(),
              );
              return null;
            },
          ),
          LinkIntent: CallbackAction<LinkIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyFormattingWithSelectionSnapshot(
                (MessageRichInputController controller) =>
                    controller.setLink(url: 'https://'),
              );
              return null;
            },
          ),
          SendIntent: CallbackAction<SendIntent>(
            onInvoke: (_) {
              _submit();
              return null;
            },
          ),
        },
        child: Listener(
          onPointerDown: _handlePointerDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                key: _textFieldKey,
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                minLines: widget.minLines,
                inputFormatters: inputFormatters,
                maxLength: widget.maxSymbols,
                maxLengthEnforcement: widget.maxSymbols != null
                    ? MaxLengthEnforcement.enforced
                    : MaxLengthEnforcement.none,
                buildCounter:
                    (
                      BuildContext buildContext, {
                      required int currentLength,
                      required bool isFocused,
                      required int? maxLength,
                    }) {
                      return const SizedBox.shrink();
                    },
                style: baseStyle,
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: widget.hintText,
                  hintStyle: textScheme.label.copyWith(
                    color: isDark
                        ? Colors.white.withAlpha(140)
                        : colorScheme.onSurfaceVariant.withAlpha(150),
                    fontSize: 16,
                  ),
                  counterText: '',
                  // Remove borders in all states
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                onSubmitted: (_) => _submit(),
                contextMenuBuilder:
                    (
                      BuildContext context,
                      EditableTextState editableTextState,
                    ) {
                      return const SizedBox.shrink();
                    },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
