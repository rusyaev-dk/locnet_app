import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input_selection_toolbar/presentation/presentation.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({
    required this.onSubmitted,
    super.key,
    this.controller,
    this.onChanged,
    this.maxSymbols,
    this.minLines = 1,
    this.hintText,
  });

  final MessageMarkdownInputController? controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final int? maxSymbols;
  final int minLines;
  final String? hintText;

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  late final TextEditingController _controller;
  late final bool _isExternalController;

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

    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? _createMarkdownController();

    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  MessageMarkdownInputController _createMarkdownController() {
    const TextStyle baseStyle = TextStyle(fontSize: 16);

    return MessageMarkdownInputController(
      baseStyle: baseStyle,
      markerStyle: baseStyle.copyWith(color: Colors.black38),
      boldStyle: baseStyle.copyWith(fontWeight: FontWeight.w700),
      italicStyle: baseStyle.copyWith(fontStyle: FontStyle.italic),
      codeStyle: baseStyle.copyWith(fontFamily: 'monospace'),
      strikeStyle: baseStyle.copyWith(decoration: TextDecoration.lineThrough),
      linkStyle: baseStyle.copyWith(decoration: TextDecoration.underline),
    );
  }

  @override
  void dispose() {
    _toolbarController.dispose();

    _controller.removeListener(_handleControllerChanged);
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();

    if (!_isExternalController) {
      _controller.dispose();
    }

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
    _selectedTextSnapshotForToolbar = TextMarkdownFormatter.selectedText(
      _controller.value,
    );

    _showToolbarNearSelection(selectionSnapshot: selection);
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
            onPressed: () =>
                _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleBold),
          ),
          MessageInputSelectionToolbarAction(
            id: 'italic',
            title: l10n.messageInputToolbarActionFormatItalic,
            icon: Icons.format_italic,
            onPressed: () =>
                _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleItalic),
          ),
          MessageInputSelectionToolbarAction(
            id: 'code',
            title: l10n.messageInputToolbarActionFormatCode,
            icon: Icons.code,
            onPressed: () =>
                _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleCode),
          ),
          MessageInputSelectionToolbarAction(
            id: 'strike',
            title: l10n.messageInputToolbarActionFormatStrike,
            icon: Icons.format_strikethrough,
            onPressed: () =>
                _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleStrike),
          ),
          MessageInputSelectionToolbarAction(
            id: 'link',
            title: l10n.messageInputToolbarActionFormatLink,
            icon: Icons.link,
            onPressed: () =>
                _applyWithSelectionSnapshot(TextMarkdownFormatter.insertLink),
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

    final TextEditingValue updatedValue = TextMarkdownFormatter.cutSelection(
      _controller.value,
    );

    _controller.value = updatedValue;

    _selectionSnapshotForToolbar = null;
    _selectedTextSnapshotForToolbar = null;

    _scheduleToolbarUpdate();
  }

  void _applyWithSelectionSnapshot(
    TextEditingValue Function(TextEditingValue) formatter,
  ) {
    _toolbarController.hide();

    _restoreSelectionSnapshotIfNeeded();

    _apply(formatter);
  }

  void _apply(TextEditingValue Function(TextEditingValue) formatter) {
    final TextEditingValue currentValue = _controller.value;
    final TextEditingValue updatedValue = formatter(currentValue);

    _controller.value = updatedValue;

    _scheduleToolbarUpdate();
  }

  void _snapshotSelectionForHotkey() {
    _selectionSnapshotForToolbar = _controller.selection;
    _selectedTextSnapshotForToolbar = TextMarkdownFormatter.selectedText(
      _controller.value,
    );
  }

  void _submit() {
    final String text = _controller.text;
    if (text.trim().isEmpty) {
      return;
    }

    widget.onSubmitted(text);

    _controller.clear();
    _hideToolbarAndClearSnapshot();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final double maxHeight = MediaQuery.of(context).size.height * 0.35;

    final TextStyle baseStyle = textScheme.label.copyWith(
      color: colorScheme.onSurface,
      fontSize: 16,
    );

    final List<TextInputFormatter> inputFormatters = widget.maxSymbols != null
        ? <TextInputFormatter>[
            LengthLimitingTextInputFormatter(widget.maxSymbols),
          ]
        : const <TextInputFormatter>[];

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        // formatting
        SingleActivator(LogicalKeyboardKey.keyB, control: true): BoldIntent(),
        SingleActivator(LogicalKeyboardKey.keyI, control: true): ItalicIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, control: true): CodeIntent(),
        SingleActivator(LogicalKeyboardKey.keyS, control: true): StrikeIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, control: true): LinkIntent(),

        SingleActivator(LogicalKeyboardKey.keyB, meta: true): BoldIntent(),
        SingleActivator(LogicalKeyboardKey.keyI, meta: true): ItalicIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, meta: true): CodeIntent(),
        SingleActivator(LogicalKeyboardKey.keyS, meta: true): StrikeIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, meta: true): LinkIntent(),

        // send message
        SingleActivator(LogicalKeyboardKey.enter, control: true): SendIntent(),
        SingleActivator(LogicalKeyboardKey.enter, meta: true): SendIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          BoldIntent: CallbackAction<BoldIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleBold);
              return null;
            },
          ),
          ItalicIntent: CallbackAction<ItalicIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleItalic);
              return null;
            },
          ),
          CodeIntent: CallbackAction<CodeIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleCode);
              return null;
            },
          ),
          StrikeIntent: CallbackAction<StrikeIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyWithSelectionSnapshot(TextMarkdownFormatter.toggleStrike);
              return null;
            },
          ),
          LinkIntent: CallbackAction<LinkIntent>(
            onInvoke: (_) {
              _snapshotSelectionForHotkey();
              _applyWithSelectionSnapshot(TextMarkdownFormatter.insertLink);
              return null;
            },
          ),

          // send
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
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: textScheme.label.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(150),
                    fontSize: 16,
                  ),
                  counterText: '',
                ),
                onSubmitted: widget.onSubmitted,
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
