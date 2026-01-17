// app_message_text.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';

class AppMessageText extends StatelessWidget {
  const AppMessageText({
    required this.data,
    required this.textStyle,
    required this.linkColor,
    this.onLinkTap,
    super.key,
  });

  final String data;
  final TextStyle textStyle;
  final Color linkColor;
  final void Function(Uri uri)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    final MessageMarkdownDocument document =
        MessageMarkdownCodec.decodeDocument(data);

    if (document.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> children = <Widget>[];

    for (final MessageMarkdownBlock block in document.blocks) {
      if (block is MessageMarkdownParagraph) {
        children.add(
          _ParagraphBlock(
            text: block.text,
            ranges: block.ranges,
            textStyle: textStyle,
            linkColor: linkColor,
            onLinkTap: onLinkTap,
          ),
        );
        continue;
      }

      if (block is MessageMarkdownCodeBlock) {
        children.add(
          _CodeBlock(
            code: block.code,
            language: block.language,
            baseStyle: textStyle,
          ),
        );
        continue;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

final class _ParagraphBlock extends StatelessWidget {
  const _ParagraphBlock({
    required this.text,
    required this.ranges,
    required this.textStyle,
    required this.linkColor,
    required this.onLinkTap,
  });

  final String text;
  final List<MessageInlineStyleRange> ranges;
  final TextStyle textStyle;
  final Color linkColor;
  final void Function(Uri uri)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox(height: 6);
    }

    final List<MessageInlineStyleRange> rangesWithAutoLinks =
        _withAutoLinkRanges(plainText: text, ranges: ranges);

    final List<_SpanSegment> segments = _buildSegments(
      plainText: text,
      ranges: rangesWithAutoLinks,
      baseStyle: textStyle,
      linkStyle: textStyle.copyWith(
        color: linkColor,
        decoration: TextDecoration.underline,
      ),
      boldStyle: textStyle.copyWith(fontWeight: FontWeight.w700),
      italicStyle: textStyle.copyWith(fontStyle: FontStyle.italic),
      codeStyle: textStyle.copyWith(
        fontFamily: 'monospace',
        backgroundColor: (textStyle.color ?? Colors.black).withAlpha(18),
      ),
      strikeStyle: textStyle.copyWith(decoration: TextDecoration.lineThrough),
    );

    final List<InlineSpan> spans = segments
        .map((segment) => segment.toTextSpan(onLinkTap))
        .toList();

    return SelectableText.rich(TextSpan(children: spans), style: textStyle);
  }

  List<MessageInlineStyleRange> _withAutoLinkRanges({
    required String plainText,
    required List<MessageInlineStyleRange> ranges,
  }) {
    final List<MessageInlineStyleRange> out =
        List<MessageInlineStyleRange>.from(ranges);

    final List<_UrlHit> urlHits = _detectUrlsTelegramLike(plainText);
    if (urlHits.isEmpty) {
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

    for (final _UrlHit hit in urlHits) {
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

  List<_UrlHit> _detectUrlsTelegramLike(String text) {
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

      // Simple email guard.
      if (match.start > 0 && text[match.start - 1] == '@') {
        continue;
      }

      hits.add(_UrlHit(start: match.start, end: endOffset, url: trimmed));
    }

    return hits;
  }

  String _trimUrlTail(String url) {
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

  List<_SpanSegment> _buildSegments({
    required String plainText,
    required List<MessageInlineStyleRange> ranges,
    required TextStyle baseStyle,
    required TextStyle linkStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
    required TextStyle codeStyle,
    required TextStyle strikeStyle,
  }) {
    if (plainText.isEmpty) {
      return const <_SpanSegment>[];
    }

    final List<int> boundaries =
        <int>{0, plainText.length}
            .followedBy(
              ranges.expand(
                (MessageInlineStyleRange r) => <int>[r.start, r.end],
              ),
            )
            .where((int v) => v >= 0 && v <= plainText.length)
            .toSet()
            .toList()
          ..sort();

    final List<_SpanSegment> segments = <_SpanSegment>[];

    for (int index = 0; index < boundaries.length - 1; index += 1) {
      final int start = boundaries[index];
      final int end = boundaries[index + 1];
      if (end <= start) {
        continue;
      }

      final String partText = plainText.substring(start, end);

      TextStyle resolved = baseStyle;
      String? linkUrl;

      for (final MessageInlineStyleRange range in ranges) {
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
            // Code blocks are rendered as separate blocks, not inline.
            break;
        }
      }

      segments.add(
        _SpanSegment(text: partText, style: resolved, linkUrl: linkUrl),
      );
    }

    return segments;
  }
}

final class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    required this.code,
    required this.language,
    required this.baseStyle,
  });

  final String code;
  final String? language;
  final TextStyle baseStyle;

  @override
  Widget build(BuildContext context) {
    final Color bg = (baseStyle.color ?? Colors.black).withAlpha(16);

    final TextStyle codeStyle = baseStyle.copyWith(
      fontFamily: 'monospace',
      height: 1.25,
    );

    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (language != null && language!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                language!.trim(),
                style: baseStyle.copyWith(
                  fontSize: (baseStyle.fontSize ?? 14) * 0.85,
                  color: (baseStyle.color ?? Colors.black).withAlpha(140),
                ),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(code, style: codeStyle),
          ),
        ],
      ),
    );
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
