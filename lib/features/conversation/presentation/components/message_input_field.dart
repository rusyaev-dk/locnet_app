import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';

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
  late final TextEditingController _textEditingController;
  late final bool _isExternalController;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;
    _textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _textEditingController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final double maxHeight = MediaQuery.of(context).size.height * 0.35;

    final List<TextInputFormatter> inputFormatters = widget.maxSymbols != null
        ? <TextInputFormatter>[
            LengthLimitingTextInputFormatter(widget.maxSymbols),
          ]
        : const <TextInputFormatter>[];

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        child: TextField(
          controller: _textEditingController,
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
          style: textScheme.label.copyWith(
            color: colorScheme.onSurface,
            fontSize: 16,
          ),
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
          onChanged: (String text) {
            if (widget.onChanged == null) {
              return;
            }
            widget.onChanged!(text);
          },
          onSubmitted: (String text) {
            if (widget.onSubmitted == null) {
              return;
            }
            widget.onSubmitted!(text);
          },
        ),
      ),
    );
  }
}
