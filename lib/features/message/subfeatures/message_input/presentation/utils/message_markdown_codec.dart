// message_markdown_codec.dart
// ignore_for_file: use_super_parameters

import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';

sealed class MessageMarkdownBlock {
  const MessageMarkdownBlock();
}

final class MessageMarkdownParagraph extends MessageMarkdownBlock {
  const MessageMarkdownParagraph({required this.text, required this.ranges});

  final String text;
  final List<MessageInlineStyleRange> ranges;
}

final class MessageMarkdownCodeBlock extends MessageMarkdownBlock {
  const MessageMarkdownCodeBlock({required this.code, this.language});

  final String code;
  final String? language;
}

final class MessageMarkdownDocument {
  const MessageMarkdownDocument({required this.blocks});
  final List<MessageMarkdownBlock> blocks;

  bool get isEmpty => blocks.isEmpty;
}

final class MessageMarkdownDecoded {
  const MessageMarkdownDecoded({required this.text, required this.ranges});

  final String text;
  final List<MessageInlineStyleRange> ranges;
}

final class MessageMarkdownCodec {
  static MessageMarkdownDocument decodeDocument(String markdown) {
    if (markdown.isEmpty) {
      return const MessageMarkdownDocument(blocks: <MessageMarkdownBlock>[]);
    }

    final List<MessageMarkdownBlock> blocks = <MessageMarkdownBlock>[];

    int cursor = 0;
    while (cursor < markdown.length) {
      final _FenceMatch? fence = _matchFence(markdown, cursor);
      if (fence == null) {
        _appendParagraphBlocks(blocks, markdown.substring(cursor));
        break;
      }

      _appendParagraphBlocks(blocks, markdown.substring(cursor, fence.start));
      blocks.add(
        MessageMarkdownCodeBlock(code: fence.code, language: fence.language),
      );

      cursor = fence.end;
    }

    return MessageMarkdownDocument(blocks: blocks);
  }

  static MessageMarkdownDecoded decodeInline(String markdown) {
    if (markdown.isEmpty) {
      return const MessageMarkdownDecoded(
        text: '',
        ranges: <MessageInlineStyleRange>[],
      );
    }

    final _InlineParser parser = _InlineParser(input: markdown);
    return parser.parse();
  }

  static String encode({
    required String text,
    required List<MessageInlineStyleRange> ranges,
  }) {
    if (text.isEmpty || ranges.isEmpty) {
      return text;
    }

    final List<MessageInlineStyleRange> valid = ranges
        .where((MessageInlineStyleRange range) => range.isValid)
        .map((MessageInlineStyleRange range) {
          final int start = range.start.clamp(0, text.length);
          final int end = range.end.clamp(0, text.length);
          return range.copyWith(start: start, end: end);
        })
        .where((MessageInlineStyleRange range) => range.isValid)
        .toList();

    if (valid.isEmpty) {
      return text;
    }

    final List<MessageInlineStyleRange> codeBlocks =
        valid
            .where(
              (MessageInlineStyleRange r) =>
                  r.type == MessageInlineStyleType.codeBlock,
            )
            .toList()
          ..sort((MessageInlineStyleRange a, MessageInlineStyleRange b) {
            final int byStart = a.start.compareTo(b.start);
            if (byStart != 0) {
              return byStart;
            }
            return a.end.compareTo(b.end);
          });

    final List<MessageInlineStyleRange> inlineRanges = valid
        .where(
          (MessageInlineStyleRange r) =>
              r.type != MessageInlineStyleType.codeBlock,
        )
        .toList();

    if (codeBlocks.isEmpty) {
      return _encodeInline(text: text, ranges: inlineRanges);
    }

    final StringBuffer out = StringBuffer();
    int cursor = 0;

    for (final MessageInlineStyleRange codeBlockRange in codeBlocks) {
      if (codeBlockRange.start > cursor) {
        out.write(
          _encodeInline(
            text: text.substring(cursor, codeBlockRange.start),
            ranges: _sliceShiftRanges(
              ranges: inlineRanges,
              sliceStart: cursor,
              sliceEnd: codeBlockRange.start,
              shift: -cursor,
            ),
          ),
        );
      }

      final String codeText = text.substring(
        codeBlockRange.start,
        codeBlockRange.end,
      );

      out.write('```\n');
      out.write(codeText);
      out.write('\n```');

      cursor = codeBlockRange.end;
      if (cursor < text.length) {
        out.write('\n');
      }
    }

    if (cursor < text.length) {
      out.write(
        _encodeInline(
          text: text.substring(cursor),
          ranges: _sliceShiftRanges(
            ranges: inlineRanges,
            sliceStart: cursor,
            sliceEnd: text.length,
            shift: -cursor,
          ),
        ),
      );
    }

    return out.toString();
  }

  static List<MessageInlineStyleRange> _sliceShiftRanges({
    required List<MessageInlineStyleRange> ranges,
    required int sliceStart,
    required int sliceEnd,
    required int shift,
  }) {
    final List<MessageInlineStyleRange> out = <MessageInlineStyleRange>[];

    for (final MessageInlineStyleRange range in ranges) {
      final bool intersects = range.start < sliceEnd && range.end > sliceStart;
      if (!intersects) {
        continue;
      }

      final int start = range.start.clamp(sliceStart, sliceEnd) + shift;
      final int end = range.end.clamp(sliceStart, sliceEnd) + shift;

      final MessageInlineStyleRange shifted = range.copyWith(
        start: start,
        end: end,
      );

      if (shifted.isValid) {
        out.add(shifted);
      }
    }

    return out;
  }

  static String _encodeInline({
    required String text,
    required List<MessageInlineStyleRange> ranges,
  }) {
    if (text.isEmpty || ranges.isEmpty) {
      return text;
    }

    final List<MessageInlineStyleRange> normalized = ranges
        .where((MessageInlineStyleRange range) => range.isValid)
        .map((MessageInlineStyleRange range) {
          final int start = range.start.clamp(0, text.length);
          final int end = range.end.clamp(0, text.length);
          return range.copyWith(start: start, end: end);
        })
        .where((MessageInlineStyleRange range) => range.isValid)
        .toList();

    if (normalized.isEmpty) {
      return text;
    }

    final List<int> boundaries =
        <int>{0, text.length}
            .followedBy(
              normalized.expand(
                (MessageInlineStyleRange r) => <int>[r.start, r.end],
              ),
            )
            .where((int v) => v >= 0 && v <= text.length)
            .toSet()
            .toList()
          ..sort();

    final List<_EncodeSegment> segments = <_EncodeSegment>[];

    for (int index = 0; index < boundaries.length - 1; index += 1) {
      final int start = boundaries[index];
      final int end = boundaries[index + 1];
      if (end <= start) {
        continue;
      }

      final String segmentText = text.substring(start, end);

      final Set<MessageInlineStyleType> styles = <MessageInlineStyleType>{};
      _LinkCandidate? linkCandidate;

      for (final MessageInlineStyleRange range in normalized) {
        final bool intersects = range.start < end && range.end > start;
        if (!intersects) {
          continue;
        }

        if (range.type == MessageInlineStyleType.link) {
          final String url = (range.url == null || range.url!.trim().isEmpty)
              ? 'https://'
              : range.url!.trim();

          final _LinkCandidate candidate = _LinkCandidate(
            url: url,
            start: range.start,
            end: range.end,
          );

          if (linkCandidate == null) {
            linkCandidate = candidate;
          } else {
            final int curLen = linkCandidate.end - linkCandidate.start;
            final int candLen = candidate.end - candidate.start;
            if (candLen < curLen) {
              linkCandidate = candidate;
            }
          }

          styles.add(MessageInlineStyleType.link);
          continue;
        }

        if (range.type != MessageInlineStyleType.codeBlock) {
          styles.add(range.type);
        }
      }

      segments.add(
        _EncodeSegment(
          text: segmentText,
          styles: styles,
          linkUrl: linkCandidate?.url,
        ),
      );
    }

    final StringBuffer out = StringBuffer();
    final List<_OpenStyle> openStack = <_OpenStyle>[];

    for (final _EncodeSegment segment in segments) {
      final List<_OpenStyle> desired = _desiredOrderForSegment(
        styles: segment.styles,
        linkUrl: segment.linkUrl,
      );

      int commonPrefix = 0;
      while (commonPrefix < openStack.length &&
          commonPrefix < desired.length &&
          openStack[commonPrefix].equals(desired[commonPrefix])) {
        commonPrefix += 1;
      }

      for (
        int index = openStack.length - 1;
        index >= commonPrefix;
        index -= 1
      ) {
        out.write(_closeToken(openStack[index]));
      }
      openStack.removeRange(commonPrefix, openStack.length);

      for (int index = commonPrefix; index < desired.length; index += 1) {
        out.write(_openToken(desired[index]));
        openStack.add(desired[index]);
      }

      out.write(_escapeTextForOpenStyles(segment.text, desired));
    }

    for (int index = openStack.length - 1; index >= 0; index -= 1) {
      out.write(_closeToken(openStack[index]));
    }

    return out.toString();
  }

  static String _escapeTextForOpenStyles(String text, List<_OpenStyle> open) {
    if (text.isEmpty) {
      return text;
    }

    final bool inCode = open.any(
      (_OpenStyle style) => style.type == MessageInlineStyleType.code,
    );

    if (inCode) {
      return text;
    }

    final StringBuffer out = StringBuffer();
    for (int index = 0; index < text.length; index += 1) {
      final String ch = text[index];
      final bool shouldEscape =
          ch == r'\' ||
          ch == '*' ||
          ch == '~' ||
          ch == '_' ||
          ch == '`' ||
          ch == '[' ||
          ch == ']' ||
          ch == '(' ||
          ch == ')';

      if (shouldEscape) {
        out.write(r'\');
      }
      out.write(ch);
    }
    return out.toString();
  }

  static List<_OpenStyle> _desiredOrderForSegment({
    required Set<MessageInlineStyleType> styles,
    required String? linkUrl,
  }) {
    final List<_OpenStyle> result = <_OpenStyle>[];

    if (styles.contains(MessageInlineStyleType.link)) {
      result.add(_OpenStyle(type: MessageInlineStyleType.link, url: linkUrl));
    }
    if (styles.contains(MessageInlineStyleType.strike)) {
      result.add(
        const _OpenStyle(type: MessageInlineStyleType.strike, url: null),
      );
    }
    if (styles.contains(MessageInlineStyleType.underline)) {
      result.add(
        const _OpenStyle(type: MessageInlineStyleType.underline, url: null),
      );
    }
    if (styles.contains(MessageInlineStyleType.bold)) {
      result.add(
        const _OpenStyle(type: MessageInlineStyleType.bold, url: null),
      );
    }
    if (styles.contains(MessageInlineStyleType.italic)) {
      result.add(
        const _OpenStyle(type: MessageInlineStyleType.italic, url: null),
      );
    }
    if (styles.contains(MessageInlineStyleType.code)) {
      result.add(
        const _OpenStyle(type: MessageInlineStyleType.code, url: null),
      );
    }

    return result;
  }

  static String _openToken(_OpenStyle style) {
    switch (style.type) {
      case MessageInlineStyleType.bold:
        return '**';
      case MessageInlineStyleType.italic:
        return '*';
      case MessageInlineStyleType.underline:
        return '__';
      case MessageInlineStyleType.code:
        return '`';
      case MessageInlineStyleType.strike:
        return '~~';
      case MessageInlineStyleType.link:
        return '[';
      case MessageInlineStyleType.codeBlock:
        return '';
    }
  }

  static String _closeToken(_OpenStyle style) {
    switch (style.type) {
      case MessageInlineStyleType.bold:
        return '**';
      case MessageInlineStyleType.italic:
        return '*';
      case MessageInlineStyleType.underline:
        return '__';
      case MessageInlineStyleType.code:
        return '`';
      case MessageInlineStyleType.strike:
        return '~~';
      case MessageInlineStyleType.link:
        final String url = (style.url == null || style.url!.trim().isEmpty)
            ? 'https://'
            : style.url!.trim();
        return ']($url)';
      case MessageInlineStyleType.codeBlock:
        return '';
    }
  }

  static void _appendParagraphBlocks(
    List<MessageMarkdownBlock> blocks,
    String rawText,
  ) {
    if (rawText.isEmpty) {
      return;
    }

    final List<String> lines = rawText.split('\n');
    for (int lineIndex = 0; lineIndex < lines.length; lineIndex += 1) {
      final String line = lines[lineIndex];

      if (line.isEmpty) {
        blocks.add(
          const MessageMarkdownParagraph(
            text: '',
            ranges: <MessageInlineStyleRange>[],
          ),
        );
        continue;
      }

      final MessageMarkdownDecoded decoded = decodeInline(line);
      blocks.add(
        MessageMarkdownParagraph(text: decoded.text, ranges: decoded.ranges),
      );
    }
  }

  static _FenceMatch? _matchFence(String input, int from) {
    final int start = input.indexOf('```', from);
    if (start == -1) {
      return null;
    }

    if (start > 0) {
      final int lineStart = input.lastIndexOf('\n', start - 1) + 1;
      final String prefix = input.substring(lineStart, start);
      if (prefix.trim().isNotEmpty) {
        return _matchFence(input, start + 3);
      }
    }

    final int headerLineEnd = input.indexOf('\n', start + 3);
    final int headerEnd = headerLineEnd == -1 ? input.length : headerLineEnd;

    final String header = input.substring(start + 3, headerEnd).trim();
    final String? language = header.isEmpty ? null : header;

    final int codeStart = headerLineEnd == -1 ? headerEnd : headerEnd + 1;

    final int close = input.indexOf('```', codeStart);
    if (close == -1) {
      return null;
    }

    final String code = input.substring(codeStart, close);

    int end = close + 3;
    if (end < input.length && input[end] == '\n') {
      end += 1;
    }

    return _FenceMatch(start: start, end: end, code: code, language: language);
  }
}

final class _InlineParser {
  _InlineParser({required this.input});

  final String input;

  final StringBuffer _plain = StringBuffer();
  final List<MessageInlineStyleRange> _ranges = <MessageInlineStyleRange>[];

  final Map<MessageInlineStyleType, List<int>> _openPositions =
      <MessageInlineStyleType, List<int>>{
        MessageInlineStyleType.bold: <int>[],
        MessageInlineStyleType.italic: <int>[],
        MessageInlineStyleType.underline: <int>[],
        MessageInlineStyleType.strike: <int>[],
      };

  MessageMarkdownDecoded parse() {
    int cursor = 0;

    while (cursor < input.length) {
      final String ch = input[cursor];

      if (ch == r'\') {
        if (cursor + 1 < input.length) {
          _plain.write(input[cursor + 1]);
          cursor += 2;
          continue;
        }
        cursor += 1;
        continue;
      }

      final _LinkMatch? link = _tryMatchLink(cursor);
      if (link != null) {
        _plain.write(input.substring(cursor, link.start));
        _appendLink(link);
        cursor = link.end;
        continue;
      }

      if (ch == '`') {
        final int close = _findUnescaped('`', cursor + 1);
        if (close != -1) {
          _plain.write(input.substring(cursor + 1, close));
          final int end = _plain.length;
          final int start = end - (close - (cursor + 1));
          if (end > start) {
            _ranges.add(
              MessageInlineStyleRange(
                type: MessageInlineStyleType.code,
                start: start,
                end: end,
              ),
            );
          }
          cursor = close + 1;
          continue;
        }
      }

      if (input.startsWith('~~', cursor)) {
        _toggle(MessageInlineStyleType.strike);
        cursor += 2;
        continue;
      }

      if (input.startsWith('__', cursor)) {
        _toggle(MessageInlineStyleType.underline);
        cursor += 2;
        continue;
      }

      if (input.startsWith('**', cursor)) {
        _toggle(MessageInlineStyleType.bold);
        cursor += 2;
        continue;
      }

      if (ch == '*') {
        _toggle(MessageInlineStyleType.italic);
        cursor += 1;
        continue;
      }

      _plain.write(ch);
      cursor += 1;
    }

    return MessageMarkdownDecoded(
      text: _plain.toString(),
      ranges: List<MessageInlineStyleRange>.unmodifiable(
        _ranges.where((MessageInlineStyleRange range) => range.isValid),
      ),
    );
  }

  int _findUnescaped(String needle, int from) {
    int index = from;
    while (index < input.length) {
      if (input[index] == r'\') {
        index += 2;
        continue;
      }
      if (input[index] == needle) {
        return index;
      }
      index += 1;
    }
    return -1;
  }

  void _toggle(MessageInlineStyleType type) {
    final List<int> stack = _openPositions[type] ?? <int>[];
    if (stack.isEmpty) {
      stack.add(_plain.length);
      _openPositions[type] = stack;
      return;
    }

    final int start = stack.removeLast();
    final int end = _plain.length;

    if (end > start) {
      _ranges.add(MessageInlineStyleRange(type: type, start: start, end: end));
    }

    _openPositions[type] = stack;
  }

  _LinkMatch? _tryMatchLink(int from) {
    if (!input.startsWith('[', from)) {
      return null;
    }

    final int labelEnd = _findUnescaped(']', from + 1);
    if (labelEnd == -1) {
      return null;
    }

    if (labelEnd + 1 >= input.length || input[labelEnd + 1] != '(') {
      return null;
    }

    final int urlStart = labelEnd + 2;
    final int urlEnd = _findUnescaped(')', urlStart);
    if (urlEnd == -1) {
      return null;
    }

    final String label = input.substring(from + 1, labelEnd);
    final String url = input.substring(urlStart, urlEnd);

    if (label.isEmpty || url.isEmpty) {
      return null;
    }

    return _LinkMatch(start: from, end: urlEnd + 1, label: label, url: url);
  }

  void _appendLink(_LinkMatch link) {
    final int labelStart = _plain.length;

    final _InlineParser nested = _InlineParser(input: link.label);
    final MessageMarkdownDecoded decoded = nested.parse();

    _plain.write(decoded.text);
    final int labelEnd = _plain.length;

    if (labelEnd <= labelStart) {
      return;
    }

    _ranges.add(
      MessageInlineStyleRange(
        type: MessageInlineStyleType.link,
        start: labelStart,
        end: labelEnd,
        url: link.url,
      ),
    );

    for (final MessageInlineStyleRange nestedRange in decoded.ranges) {
      _ranges.add(
        MessageInlineStyleRange(
          type: nestedRange.type,
          start: labelStart + nestedRange.start,
          end: labelStart + nestedRange.end,
          url: nestedRange.url,
        ),
      );
    }
  }
}

final class _LinkMatch {
  const _LinkMatch({
    required this.start,
    required this.end,
    required this.label,
    required this.url,
  });

  final int start;
  final int end;
  final String label;
  final String url;
}

final class _FenceMatch {
  const _FenceMatch({
    required this.start,
    required this.end,
    required this.code,
    required this.language,
  });

  final int start;
  final int end;
  final String code;
  final String? language;
}

final class _EncodeSegment {
  const _EncodeSegment({
    required this.text,
    required this.styles,
    required this.linkUrl,
  });

  final String text;
  final Set<MessageInlineStyleType> styles;
  final String? linkUrl;
}

final class _LinkCandidate {
  const _LinkCandidate({
    required this.url,
    required this.start,
    required this.end,
  });

  final String url;
  final int start;
  final int end;
}

final class _OpenStyle {
  const _OpenStyle({required this.type, required this.url});

  final MessageInlineStyleType type;
  final String? url;

  bool equals(_OpenStyle other) {
    if (type != other.type) {
      return false;
    }
    if (type != MessageInlineStyleType.link) {
      return true;
    }
    return (url ?? '') == (other.url ?? '');
  }
}
