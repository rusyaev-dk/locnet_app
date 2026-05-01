// message_rich_input_controller.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum MessageInlineStyleType {
  bold,
  italic,
  underline,
  code,
  strike,
  link,
  codeBlock,
}

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
  MessageRichInputController({required TextStyle baseStyle, String? text})
    : _baseStyle = baseStyle,
      super(text: text);

  /// Initial / fallback style; merged with [TextField.style] in [buildTextSpan].
  final TextStyle _baseStyle;

  final List<MessageInlineStyleRange> _ranges = <MessageInlineStyleRange>[];

  List<MessageInlineStyleRange> get ranges =>
      List<MessageInlineStyleRange>.unmodifiable(_ranges);

  void setRanges(List<MessageInlineStyleRange> newRanges) {
    _ranges
      ..clear()
      ..addAll(
        newRanges.where((MessageInlineStyleRange range) => range.isValid),
      );
    notifyListeners();
  }

  void clearAllFormatting() {
    _ranges.clear();
    notifyListeners();
  }

  void toggleBold() => _toggleStyle(MessageInlineStyleType.bold);
  void toggleItalic() => _toggleStyle(MessageInlineStyleType.italic);
  void toggleUnderline() => _toggleStyle(MessageInlineStyleType.underline);
  void toggleCode() => _toggleStyle(MessageInlineStyleType.code);
  void toggleStrike() => _toggleStyle(MessageInlineStyleType.strike);

  void toggleCodeBlock() {
    final TextSelection currentSelection = selection;
    if (!currentSelection.isValid || currentSelection.isCollapsed) {
      return;
    }

    final int start = currentSelection.start;
    final int end = currentSelection.end;

    _ranges.removeWhere((MessageInlineStyleRange range) {
      final bool intersects = range.start < end && range.end > start;
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
      (MessageInlineStyleRange range) =>
          range.type == type && range.start == start && range.end == end,
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
    _ranges.removeWhere((MessageInlineStyleRange range) {
      if (!range.isValid) {
        return true;
      }
      return range.start >= length || range.end > length;
    });

    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    // Merge TextField's live `style` so theme / brightness changes apply without
    // recreating the controller (see MessageInputField).
    final ColorScheme materialScheme = Theme.of(context).colorScheme;
    final TextStyle rootStyle = style != null
        ? _baseStyle.merge(style)
        : _baseStyle;

    final TextStyle boldStyle = rootStyle.copyWith(fontWeight: FontWeight.w700);
    final TextStyle italicStyle = rootStyle.copyWith(
      fontStyle: FontStyle.italic,
    );
    final TextStyle underlineStyle = rootStyle.copyWith(
      decoration: TextDecoration.underline,
    );
    final TextStyle codeStyle = rootStyle.copyWith(fontFamily: 'monospace');
    final TextStyle strikeStyle = rootStyle.copyWith(
      decoration: TextDecoration.lineThrough,
    );
    final TextStyle linkStyle = rootStyle.copyWith(
      color: materialScheme.primary,
      decoration: TextDecoration.none,
    );
    final TextStyle codeBlockStyle = rootStyle.copyWith(
      fontFamily: 'monospace',
      height: 1.25,
      backgroundColor: materialScheme.onSurface.withAlpha(18),
    );

    final String plainText = text;
    if (plainText.isEmpty) {
      return TextSpan(text: '', style: rootStyle);
    }

    final List<InlineSpan> spans = MessageInlineSpanBuilder.build(
      plainText: plainText,
      ranges: _ranges,
      baseStyle: rootStyle,
      boldStyle: boldStyle,
      italicStyle: italicStyle,
      underlineStyle: underlineStyle,
      codeStyle: codeStyle,
      strikeStyle: strikeStyle,
      linkStyle: linkStyle,
      codeBlockStyle: codeBlockStyle,
      onLinkTap: null,
      autoDetectLinks: false,
    );

    return TextSpan(style: rootStyle, children: spans);
  }
}

final class MessageInlineSpanBuilder {
  static List<InlineSpan> build({
    required String plainText,
    required List<MessageInlineStyleRange> ranges,
    required TextStyle baseStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
    required TextStyle underlineStyle,
    required TextStyle codeStyle,
    required TextStyle strikeStyle,
    required TextStyle linkStyle,
    required TextStyle? codeBlockStyle,
    required void Function(Uri uri)? onLinkTap,
    required bool autoDetectLinks,
  }) {
    if (plainText.isEmpty) {
      return const <InlineSpan>[];
    }

    final List<MessageInlineStyleRange> normalized = ranges
        .where((MessageInlineStyleRange range) => range.isValid)
        .map((MessageInlineStyleRange range) {
          final int start = range.start.clamp(0, plainText.length);
          final int end = range.end.clamp(0, plainText.length);
          return range.copyWith(start: start, end: end);
        })
        .where((MessageInlineStyleRange range) => range.isValid)
        .toList();

    final List<MessageInlineStyleRange> effectiveRanges = autoDetectLinks
        ? _withAutoLinkRanges(plainText: plainText, ranges: normalized)
        : normalized;

    final List<int> boundaries =
        <int>{0, plainText.length}
            .followedBy(
              effectiveRanges.expand(
                (MessageInlineStyleRange range) => <int>[
                  range.start,
                  range.end,
                ],
              ),
            )
            .where((int value) => value >= 0 && value <= plainText.length)
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

      final String segmentText = plainText.substring(start, end);

      TextStyle resolved = baseStyle;
      String? linkUrl;

      for (final MessageInlineStyleRange range in effectiveRanges) {
        final bool intersects = range.start < end && range.end > start;
        if (!intersects) {
          continue;
        }

        switch (range.type) {
          case MessageInlineStyleType.bold:
            resolved = resolved.merge(boldStyle);
            break;
          case MessageInlineStyleType.italic:
            resolved = resolved.merge(italicStyle);
            break;
          case MessageInlineStyleType.underline:
            resolved = resolved.merge(underlineStyle);
            break;
          case MessageInlineStyleType.code:
            resolved = resolved.merge(codeStyle);
            break;
          case MessageInlineStyleType.strike:
            resolved = resolved.merge(strikeStyle);
            break;
          case MessageInlineStyleType.link:
            resolved = resolved.merge(linkStyle);
            linkUrl ??= range.url;
            break;
          case MessageInlineStyleType.codeBlock:
            if (codeBlockStyle != null) {
              resolved = resolved.merge(codeBlockStyle);
            }
            break;
        }
      }

      spans.add(
        _SpanSegment(
          text: segmentText,
          style: resolved,
          linkUrl: linkUrl,
        ).toTextSpan(onLinkTap),
      );
    }

    return spans;
  }

  static List<MessageInlineStyleRange> _withAutoLinkRanges({
    required String plainText,
    required List<MessageInlineStyleRange> ranges,
  }) {
    final List<MessageInlineStyleRange> out =
        List<MessageInlineStyleRange>.from(ranges);

    final List<_UrlHit> hits = _detectUrlsTelegramLike(plainText);
    if (hits.isEmpty) {
      return out;
    }

    bool intersectsAnyLink(int start, int end) {
      for (final MessageInlineStyleRange range in out) {
        if (range.type != MessageInlineStyleType.link) {
          continue;
        }
        final bool intersects = range.start < end && range.end > start;
        if (intersects) {
          return true;
        }
      }
      return false;
    }

    for (final _UrlHit hit in hits) {
      if (intersectsAnyLink(hit.start, hit.end)) {
        continue;
      }

      out.add(
        MessageInlineStyleRange(
          type: MessageInlineStyleType.link,
          start: hit.start,
          end: hit.end,
          url: hit.url,
        ),
      );
    }

    return out;
  }

  static List<_UrlHit> _detectUrlsTelegramLike(String text) {
    final RegExp regExp = RegExp(
      r'((?:https?:\/\/|www\.)[^\s<]+|(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+(?:[a-z]{2,})(?:\/[^\s<]*)?)',
      caseSensitive: false,
    );

    final Iterable<RegExpMatch> matches = regExp.allMatches(text);

    final List<_UrlHit> hits = <_UrlHit>[];
    for (final RegExpMatch match in matches) {
      final String? raw = match.group(0);
      if (raw == null || raw.isEmpty) {
        continue;
      }

      final String trimmed = _trimUrlTail(raw);
      if (trimmed.isEmpty) {
        continue;
      }

      final int endOffset = match.start + trimmed.length;

      if (match.start > 0 && text[match.start - 1] == '@') {
        continue;
      }

      hits.add(_UrlHit(start: match.start, end: endOffset, url: trimmed));
    }

    return hits;
  }

  static String _trimUrlTail(String url) {
    String out = url;
    while (out.isNotEmpty) {
      final String last = out[out.length - 1];
      final bool shouldTrim =
          last == '.' ||
          last == ',' ||
          last == '!' ||
          last == '?' ||
          last == ':' ||
          last == ';' ||
          last == ')' ||
          last == ']' ||
          last == '}' ||
          last == '"' ||
          last == "'";
      if (!shouldTrim) {
        break;
      }
      out = out.substring(0, out.length - 1);
    }
    return out;
  }
}

final class _SpanSegment {
  const _SpanSegment({
    required this.text,
    required this.style,
    required this.linkUrl,
  });

  final String text;
  final TextStyle style;
  final String? linkUrl;

  InlineSpan toTextSpan(void Function(Uri uri)? onLinkTap) {
    final String? url = linkUrl;
    if (url == null || onLinkTap == null) {
      return TextSpan(text: text, style: style);
    }

    final Uri? uri = _normalizeAndParseUrl(url);
    if (uri == null) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(
      text: text,
      style: style,
      recognizer: TapGestureRecognizer()..onTap = () => onLinkTap(uri),
    );
  }

  Uri? _normalizeAndParseUrl(String raw) {
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Uri.tryParse(trimmed);
    }

    if (trimmed.startsWith('www.')) {
      return Uri.tryParse('https://$trimmed');
    }

    return Uri.tryParse('https://$trimmed');
  }
}

final class _UrlHit {
  const _UrlHit({required this.start, required this.end, required this.url});

  final int start;
  final int end;
  final String url;
}
