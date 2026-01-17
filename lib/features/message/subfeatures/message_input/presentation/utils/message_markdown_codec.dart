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
  /// Bubble rendering entry point (supports fenced code blocks).
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

  /// Inline-only decode (no fenced blocks).
  ///
  /// Supports:
  /// - ***text*** (bold + italic on same range)
  /// - **text**
  /// - *text*
  /// - `text`
  /// - ~~text~~
  /// - [label](url)
  static MessageMarkdownDecoded decodeInline(String markdown) {
    if (markdown.isEmpty) {
      return const MessageMarkdownDecoded(
        text: '',
        ranges: <MessageInlineStyleRange>[],
      );
    }

    final StringBuffer plain = StringBuffer();
    final List<MessageInlineStyleRange> ranges = <MessageInlineStyleRange>[];

    int cursor = 0;
    while (cursor < markdown.length) {
      final _MdMatch? match = _tryMatchInline(markdown, cursor);
      if (match == null) {
        plain.write(markdown[cursor]);
        cursor += 1;
        continue;
      }

      if (match.start > cursor) {
        plain.write(markdown.substring(cursor, match.start));
      }

      final int rangeStart = plain.length;
      plain.write(match.contentText);
      final int rangeEnd = plain.length;

      if (match.isBoldItalic) {
        ranges
          ..add(
            MessageInlineStyleRange(
              type: MessageInlineStyleType.bold,
              start: rangeStart,
              end: rangeEnd,
            ),
          )
          ..add(
            MessageInlineStyleRange(
              type: MessageInlineStyleType.italic,
              start: rangeStart,
              end: rangeEnd,
            ),
          );
      } else {
        ranges.add(
          MessageInlineStyleRange(
            type: match.type,
            start: rangeStart,
            end: rangeEnd,
            url: match.url,
          ),
        );
      }

      cursor = match.end;
    }

    return MessageMarkdownDecoded(text: plain.toString(), ranges: ranges);
  }

  /// Encode plain text + ranges to markdown.
  ///
  /// Notes:
  /// - Overlaps are not fully supported. (Telegram solves this with entity nesting rules.)
  /// - Bold+Italic on the exact same [start,end] will be encoded as ***...***.
  /// - codeBlock is encoded as fenced block and should not overlap other ranges.
  static String encode({
    required String text,
    required List<MessageInlineStyleRange> ranges,
  }) {
    if (text.isEmpty || ranges.isEmpty) {
      return text;
    }

    final List<MessageInlineStyleRange> valid = ranges
        .where((MessageInlineStyleRange r) => r.isValid)
        .toList();

    final Set<String> boldKeys = <String>{};
    final Set<String> italicKeys = <String>{};

    for (final MessageInlineStyleRange r in valid) {
      final String key = '${r.start}:${r.end}';
      if (r.type == MessageInlineStyleType.bold) {
        boldKeys.add(key);
      } else if (r.type == MessageInlineStyleType.italic) {
        italicKeys.add(key);
      }
    }

    final Set<String> boldItalicKeys = <String>{};
    for (final String key in boldKeys) {
      if (italicKeys.contains(key)) {
        boldItalicKeys.add(key);
      }
    }

    final List<_Insertion> insertions = <_Insertion>[];

    for (final MessageInlineStyleRange r in valid) {
      final String key = '${r.start}:${r.end}';

      // Emit ***...*** once (skip individual **/* for the same segment).
      if (boldItalicKeys.contains(key)) {
        if (r.type != MessageInlineStyleType.bold) {
          continue;
        }
        insertions
          ..add(_Insertion(offset: r.start, value: '***'))
          ..add(_Insertion(offset: r.end, value: '***'));
        continue;
      }

      switch (r.type) {
        case MessageInlineStyleType.bold:
          insertions.add(_Insertion(offset: r.start, value: '**'));
          insertions.add(_Insertion(offset: r.end, value: '**'));
          break;
        case MessageInlineStyleType.italic:
          insertions.add(_Insertion(offset: r.start, value: '*'));
          insertions.add(_Insertion(offset: r.end, value: '*'));
          break;
        case MessageInlineStyleType.code:
          insertions.add(_Insertion(offset: r.start, value: '`'));
          insertions.add(_Insertion(offset: r.end, value: '`'));
          break;
        case MessageInlineStyleType.strike:
          insertions.add(_Insertion(offset: r.start, value: '~~'));
          insertions.add(_Insertion(offset: r.end, value: '~~'));
          break;
        case MessageInlineStyleType.link:
          final String url = (r.url == null || r.url!.isEmpty)
              ? 'https://'
              : r.url!;
          insertions.add(_Insertion(offset: r.start, value: '['));
          insertions.add(_Insertion(offset: r.end, value: ']($url)'));
          break;
        case MessageInlineStyleType.codeBlock:
          insertions.add(_Insertion(offset: r.start, value: '```\n'));
          insertions.add(_Insertion(offset: r.end, value: '\n```'));
          break;
      }
    }

    insertions.sort((_Insertion a, _Insertion b) {
      final int byOffset = b.offset.compareTo(a.offset);
      if (byOffset != 0) {
        return byOffset;
      }
      return b.value.length.compareTo(a.value.length);
    });

    String result = text;
    for (final _Insertion insertion in insertions) {
      if (insertion.offset < 0 || insertion.offset > result.length) {
        continue;
      }
      result = result.replaceRange(
        insertion.offset,
        insertion.offset,
        insertion.value,
      );
    }

    return result;
  }

  static void _appendParagraphBlocks(
    List<MessageMarkdownBlock> blocks,
    String rawText,
  ) {
    if (rawText.isEmpty) {
      return;
    }

    final List<String> lines = rawText.split('\n');
    for (int index = 0; index < lines.length; index += 1) {
      final String line = lines[index];

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

    // Require fence to be at line start (allow indentation).
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

    // Closing fence. Telegram-like: just the next ```.
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

  static _MdMatch? _tryMatchInline(String input, int from) {
    final _MdMatch? link = _matchLink(input, from);
    if (link != null) {
      return link;
    }

    final _MdMatch? code = _matchWrapped(
      input: input,
      from: from,
      open: '`',
      close: '`',
      type: MessageInlineStyleType.code,
      isBoldItalic: false,
    );
    if (code != null) {
      return code;
    }

    // Must go before ** and *.
    final _MdMatch? boldItalic = _matchWrapped(
      input: input,
      from: from,
      open: '***',
      close: '***',
      type: MessageInlineStyleType.bold,
      isBoldItalic: true,
    );
    if (boldItalic != null) {
      return boldItalic;
    }

    final _MdMatch? bold = _matchWrapped(
      input: input,
      from: from,
      open: '**',
      close: '**',
      type: MessageInlineStyleType.bold,
      isBoldItalic: false,
    );
    if (bold != null) {
      return bold;
    }

    final _MdMatch? strike = _matchWrapped(
      input: input,
      from: from,
      open: '~~',
      close: '~~',
      type: MessageInlineStyleType.strike,
      isBoldItalic: false,
    );
    if (strike != null) {
      return strike;
    }

    final _MdMatch? italic = _matchWrapped(
      input: input,
      from: from,
      open: '*',
      close: '*',
      type: MessageInlineStyleType.italic,
      isBoldItalic: false,
    );
    if (italic != null) {
      return italic;
    }

    return null;
  }

  static _MdMatch? _matchWrapped({
    required String input,
    required int from,
    required String open,
    required String close,
    required MessageInlineStyleType type,
    required bool isBoldItalic,
  }) {
    if (!input.startsWith(open, from)) {
      return null;
    }

    final int contentStart = from + open.length;
    final int closeIndex = input.indexOf(close, contentStart);
    if (closeIndex == -1) {
      return null;
    }

    final String content = input.substring(contentStart, closeIndex);
    if (content.isEmpty || content.trim().isEmpty) {
      return null;
    }

    return _MdMatch(
      start: from,
      end: closeIndex + close.length,
      type: type,
      contentText: content,
      url: null,
      isBoldItalic: isBoldItalic,
    );
  }

  static _MdMatch? _matchLink(String input, int from) {
    if (!input.startsWith('[', from)) {
      return null;
    }

    final int labelEnd = input.indexOf(']', from + 1);
    if (labelEnd == -1) {
      return null;
    }
    if (labelEnd + 1 >= input.length || input[labelEnd + 1] != '(') {
      return null;
    }

    final int urlStart = labelEnd + 2;
    final int urlEnd = input.indexOf(')', urlStart);
    if (urlEnd == -1) {
      return null;
    }

    final String label = input.substring(from + 1, labelEnd);
    final String url = input.substring(urlStart, urlEnd);

    if (label.isEmpty || url.isEmpty) {
      return null;
    }

    return _MdMatch(
      start: from,
      end: urlEnd + 1,
      type: MessageInlineStyleType.link,
      contentText: label,
      url: url,
      isBoldItalic: false,
    );
  }
}

final class _MdMatch {
  const _MdMatch({
    required this.start,
    required this.end,
    required this.type,
    required this.contentText,
    required this.url,
    required this.isBoldItalic,
  });

  final int start;
  final int end;
  final MessageInlineStyleType type;
  final String contentText;
  final String? url;
  final bool isBoldItalic;
}

final class _Insertion {
  const _Insertion({required this.offset, required this.value});
  final int offset;
  final String value;
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
