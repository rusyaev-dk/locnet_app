// message_rich_input_controller.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

enum MessageInlineStyleType { bold, italic, code, strike, link, codeBlock }

final class MessageInlineStyleRange {
  const MessageInlineStyleRange({
    required this.type,
    required this.start,
    required this.end,
    this.url,
  });

  final MessageInlineStyleType type;
  final int start;
  final int end;
  final String? url;

  bool get isValid => start >= 0 && end > start;

  MessageInlineStyleRange copyWith({int? start, int? end, String? url}) {
    return MessageInlineStyleRange(
      type: type,
      start: start ?? this.start,
      end: end ?? this.end,
      url: url ?? this.url,
    );
  }
}

final class MessageRichInputController extends TextEditingController {
  MessageRichInputController({
    required TextStyle baseStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
    required TextStyle codeStyle,
    required TextStyle strikeStyle,
    required TextStyle linkStyle,
    required TextStyle codeBlockStyle,
    String? text,
  }) : _baseStyle = baseStyle,
       _boldStyle = boldStyle,
       _italicStyle = italicStyle,
       _codeStyle = codeStyle,
       _strikeStyle = strikeStyle,
       _linkStyle = linkStyle,
       _codeBlockStyle = codeBlockStyle,
       super(text: text);

  final TextStyle _baseStyle;
  final TextStyle _boldStyle;
  final TextStyle _italicStyle;
  final TextStyle _codeStyle;
  final TextStyle _strikeStyle;
  final TextStyle _linkStyle;
  final TextStyle _codeBlockStyle;

  final List<MessageInlineStyleRange> _ranges = <MessageInlineStyleRange>[];

  List<MessageInlineStyleRange> get ranges =>
      List<MessageInlineStyleRange>.unmodifiable(_ranges);

  void setRanges(List<MessageInlineStyleRange> newRanges) {
    _ranges
      ..clear()
      ..addAll(newRanges.where((MessageInlineStyleRange r) => r.isValid));
    notifyListeners();
  }

  void clearAllFormatting() {
    _ranges.clear();
    notifyListeners();
  }

  void toggleBold() => _toggleStyle(MessageInlineStyleType.bold);
  void toggleItalic() => _toggleStyle(MessageInlineStyleType.italic);
  void toggleCode() => _toggleStyle(MessageInlineStyleType.code);
  void toggleStrike() => _toggleStyle(MessageInlineStyleType.strike);

  void toggleCodeBlock() {
    final TextSelection currentSelection = selection;
    if (!currentSelection.isValid || currentSelection.isCollapsed) {
      return;
    }

    // Code block should not overlap with other styles.
    final int start = currentSelection.start;
    final int end = currentSelection.end;

    _ranges.removeWhere((MessageInlineStyleRange r) {
      final bool intersects = r.start < end && r.end > start;
      return intersects;
    });

    _toggleStyle(MessageInlineStyleType.codeBlock);
  }

  void setLink({required String url}) {
    _toggleStyle(MessageInlineStyleType.link, url: url);
  }

  void _toggleStyle(MessageInlineStyleType type, {String? url}) {
    final TextSelection currentSelection = selection;
    if (!currentSelection.isValid || currentSelection.isCollapsed) {
      return;
    }

    final int start = currentSelection.start;
    final int end = currentSelection.end;

    final int existingIndex = _ranges.indexWhere(
      (MessageInlineStyleRange r) =>
          r.type == type && r.start == start && r.end == end,
    );

    if (existingIndex != -1) {
      _ranges.removeAt(existingIndex);
      notifyListeners();
      return;
    }

    _ranges.add(
      MessageInlineStyleRange(type: type, start: start, end: end, url: url),
    );
    notifyListeners();
  }

  @override
  set value(TextEditingValue newValue) {
    final TextEditingValue oldValue = super.value;
    super.value = newValue;

    if (oldValue.text == newValue.text) {
      return;
    }

    _clampRangesToTextLength(newValue.text.length);
  }

  void _clampRangesToTextLength(int length) {
    _ranges.removeWhere((MessageInlineStyleRange r) {
      if (!r.isValid) {
        return true;
      }
      return r.start >= length || r.end > length;
    });

    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final String plain = text;
    if (plain.isEmpty) {
      return TextSpan(text: '', style: _baseStyle);
    }

    final List<int> boundaries =
        <int>{0, plain.length}
            .followedBy(
              _ranges.expand(
                (MessageInlineStyleRange r) => <int>[r.start, r.end],
              ),
            )
            .where((int v) => v >= 0 && v <= plain.length)
            .toSet()
            .toList()
          ..sort();

    final List<InlineSpan> spans = <InlineSpan>[];

    for (int index = 0; index < boundaries.length - 1; index += 1) {
      final int start = boundaries[index];
      final int end = boundaries[index + 1];
      if (end <= start) {
        continue;
      }

      final String segment = plain.substring(start, end);
      final TextStyle segmentStyle = _resolveStyleForSegment(
        start: start,
        end: end,
      );

      spans.add(TextSpan(text: segment, style: segmentStyle));
    }

    return TextSpan(style: _baseStyle, children: spans);
  }

  TextStyle _resolveStyleForSegment({required int start, required int end}) {
    TextStyle resolved = _baseStyle;

    for (final MessageInlineStyleRange range in _ranges) {
      final bool intersects = range.start < end && range.end > start;
      if (!intersects) {
        continue;
      }

      switch (range.type) {
        case MessageInlineStyleType.bold:
          resolved = resolved.merge(_boldStyle);
          break;
        case MessageInlineStyleType.italic:
          resolved = resolved.merge(_italicStyle);
          break;
        case MessageInlineStyleType.code:
          resolved = resolved.merge(_codeStyle);
          break;
        case MessageInlineStyleType.strike:
          resolved = resolved.merge(_strikeStyle);
          break;
        case MessageInlineStyleType.link:
          resolved = resolved.merge(_linkStyle);
          break;
        case MessageInlineStyleType.codeBlock:
          resolved = resolved.merge(_codeBlockStyle);
          break;
      }
    }

    return resolved;
  }
}
