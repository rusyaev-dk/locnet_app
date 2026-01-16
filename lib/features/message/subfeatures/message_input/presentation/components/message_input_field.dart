// message_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/components/message_input_format_toolbar.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/utils/utils.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.maxSymbols,
    this.minLines = 1,
    this.hintText,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _toolbarEntry;

  bool _toolbarUpdateScheduled = false;

  @override
  void initState() {
    super.initState();

    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? _createMarkdownController();

    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  TextEditingController _createMarkdownController() {
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
    _removeToolbarImmediate();

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
    _scheduleToolbarUpdate();
  }

  void _handleControllerChanged() {
    widget.onChanged?.call(_controller.text);
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
      _removeToolbarImmediate();
      return;
    }

    final TextSelection selection = _controller.selection;
    final bool hasSelection =
        selection.isValid && !selection.isCollapsed && selection.start >= 0;

    if (!hasSelection) {
      _removeToolbarImmediate();
      return;
    }

    _showToolbarIfNeeded();
  }

  void _showToolbarIfNeeded() {
    if (_toolbarEntry != null) {
      return;
    }

    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);

    _toolbarEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned.fill(
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                offset: const Offset(0, -46),
                showWhenUnlinked: false,
                child: MessageInputFormatToolbar(
                  onKeepFocus: () {
                    if (!_focusNode.hasFocus) {
                      _focusNode.requestFocus();
                    }
                  },
                  onBold: () => _apply(TextMarkdownFormatter.toggleBold),
                  onItalic: () => _apply(TextMarkdownFormatter.toggleItalic),
                  onCode: () => _apply(TextMarkdownFormatter.toggleCode),
                  onStrike: () => _apply(TextMarkdownFormatter.toggleStrike),
                  onLink: () => _apply(TextMarkdownFormatter.insertLink),
                  onCopy: _copySelection,
                  onCut: _cutSelection,
                ),
              ),
            ],
          ),
        );
      },
    );

    overlayState.insert(_toolbarEntry!);
  }

  Future<void> _copySelection() async {
    final String? selected = TextMarkdownFormatter.selectedText(
      _controller.value,
    );
    if (selected == null || selected.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: selected));
  }

  Future<void> _cutSelection() async {
    final String? selected = TextMarkdownFormatter.selectedText(
      _controller.value,
    );
    if (selected == null || selected.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: selected));

    final TextEditingValue updatedValue = TextMarkdownFormatter.cutSelection(
      _controller.value,
    );

    _controller.value = updatedValue;
    _scheduleToolbarUpdate();
  }

  void _removeToolbarImmediate() {
    _toolbarEntry?.remove();
    _toolbarEntry = null;
  }

  void _apply(TextEditingValue Function(TextEditingValue) formatter) {
    final TextEditingValue currentValue = _controller.value;
    final TextEditingValue updatedValue = formatter(currentValue);

    _controller.value = updatedValue;

    // Avoid updating overlay synchronously in the same call stack.
    _scheduleToolbarUpdate();
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
        SingleActivator(LogicalKeyboardKey.keyB, control: true): BoldIntent(),
        SingleActivator(LogicalKeyboardKey.keyI, control: true): ItalicIntent(),
        SingleActivator(LogicalKeyboardKey.keyE, control: true): CodeIntent(),
        SingleActivator(LogicalKeyboardKey.keyS, control: true): StrikeIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, control: true): LinkIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          BoldIntent: CallbackAction<BoldIntent>(
            onInvoke: (_) => _apply(TextMarkdownFormatter.toggleBold),
          ),
          ItalicIntent: CallbackAction<ItalicIntent>(
            onInvoke: (_) => _apply(TextMarkdownFormatter.toggleItalic),
          ),
          CodeIntent: CallbackAction<CodeIntent>(
            onInvoke: (_) => _apply(TextMarkdownFormatter.toggleCode),
          ),
          StrikeIntent: CallbackAction<StrikeIntent>(
            onInvoke: (_) => _apply(TextMarkdownFormatter.toggleStrike),
          ),
          LinkIntent: CallbackAction<LinkIntent>(
            onInvoke: (_) => _apply(TextMarkdownFormatter.insertLink),
          ),
        },
        child: CompositedTransformTarget(
          link: _layerLink,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
