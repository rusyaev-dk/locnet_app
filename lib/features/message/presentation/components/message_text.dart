// message_text.dart
// ignore_for_file: use_super_parameters

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
    final List<InlineSpan> allParagraphSpans = <InlineSpan>[];
    bool hasCodeBlocks = false;

    for (final MessageMarkdownBlock block in document.blocks) {
      if (block is MessageMarkdownParagraph) {
        if (block.text.isEmpty) {
          // Empty paragraph - add spacing
          allParagraphSpans.add(const TextSpan(text: '\n'));
          continue;
        }

        final TextStyle linkStyle = textStyle.copyWith(
          color: linkColor,
          decoration: TextDecoration.none,
        );

        final TextStyle boldStyle = textStyle.copyWith(fontWeight: FontWeight.w700);
        final TextStyle italicStyle = textStyle.copyWith(
          fontStyle: FontStyle.italic,
        );
        final TextStyle underlineStyle = textStyle.copyWith(
          decoration: TextDecoration.underline,
        );
        final TextStyle codeStyle = textStyle.copyWith(
          fontFamily: 'monospace',
          backgroundColor: (textStyle.color ?? Colors.black).withAlpha(18),
        );
        final TextStyle strikeStyle = textStyle.copyWith(
          decoration: TextDecoration.lineThrough,
        );

        final List<InlineSpan> paragraphSpans = MessageInlineSpanBuilder.build(
          plainText: block.text,
          ranges: block.ranges,
          baseStyle: textStyle,
          boldStyle: boldStyle,
          italicStyle: italicStyle,
          underlineStyle: underlineStyle,
          codeStyle: codeStyle,
          strikeStyle: strikeStyle,
          linkStyle: linkStyle,
          codeBlockStyle: null,
          onLinkTap: onLinkTap,
          autoDetectLinks: true,
        );

        allParagraphSpans.addAll(paragraphSpans);
        // Add newline between paragraphs for visual separation
        allParagraphSpans.add(const TextSpan(text: '\n'));
        continue;
      }

      if (block is MessageMarkdownCodeBlock) {
        hasCodeBlocks = true;
        // If we have accumulated paragraphs, add them first
        if (allParagraphSpans.isNotEmpty) {
          // Remove the last newline before code block
          if (allParagraphSpans.length > 1 &&
              allParagraphSpans.last is TextSpan &&
              (allParagraphSpans.last as TextSpan).text == '\n') {
            allParagraphSpans.removeLast();
          }
          children.add(
            SelectableText.rich(
              TextSpan(children: allParagraphSpans),
              style: textStyle,
            ),
          );
          allParagraphSpans.clear();
        }
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

    // Add remaining paragraphs if any
    if (allParagraphSpans.isNotEmpty) {
      // Remove the last newline if present
      if (allParagraphSpans.length > 1 &&
          allParagraphSpans.last is TextSpan &&
          (allParagraphSpans.last as TextSpan).text == '\n') {
        allParagraphSpans.removeLast();
      }
      children.add(
        SelectableText.rich(
          TextSpan(children: allParagraphSpans),
          style: textStyle,
        ),
      );
    }

    // If we have only paragraphs (no code blocks), return single SelectableText
    if (!hasCodeBlocks && children.length == 1) {
      return children.first;
    }

    // If we have code blocks mixed with paragraphs, use Column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Single-line preview for conversation list (inline markdown only).
class ConversationMarkdownPreview extends StatelessWidget {
  const ConversationMarkdownPreview({
    required this.markdown,
    required this.baseStyle,
    required this.linkColor,
    this.prefixText,
    this.prefixStyle,
    super.key,
  });

  final String markdown;
  final TextStyle baseStyle;
  final Color linkColor;
  final String? prefixText;
  final TextStyle? prefixStyle;

  static List<InlineSpan> buildPreviewSpans({
    required String markdown,
    required TextStyle baseStyle,
    required Color linkColor,
  }) {
    final MessageMarkdownDocument doc =
        MessageMarkdownCodec.decodeDocument(markdown.trim());
    if (doc.isEmpty) {
      if (markdown.isEmpty) {
        return const <InlineSpan>[];
      }
      return <InlineSpan>[TextSpan(text: markdown, style: baseStyle)];
    }

    for (final MessageMarkdownBlock block in doc.blocks) {
      if (block is MessageMarkdownParagraph && block.text.isNotEmpty) {
        final TextStyle linkStyle = baseStyle.copyWith(
          color: linkColor,
          decoration: TextDecoration.none,
        );
        final TextStyle boldStyle =
            baseStyle.copyWith(fontWeight: FontWeight.w700);
        final TextStyle italicStyle =
            baseStyle.copyWith(fontStyle: FontStyle.italic);
        final TextStyle underlineStyle = baseStyle.copyWith(
          decoration: TextDecoration.underline,
        );
        final TextStyle codeStyle = baseStyle.copyWith(
          fontFamily: 'monospace',
          backgroundColor: (baseStyle.color ?? Colors.black).withAlpha(18),
        );
        final TextStyle strikeStyle = baseStyle.copyWith(
          decoration: TextDecoration.lineThrough,
        );

        return MessageInlineSpanBuilder.build(
          plainText: block.text,
          ranges: block.ranges,
          baseStyle: baseStyle,
          boldStyle: boldStyle,
          italicStyle: italicStyle,
          underlineStyle: underlineStyle,
          codeStyle: codeStyle,
          strikeStyle: strikeStyle,
          linkStyle: linkStyle,
          codeBlockStyle: null,
          onLinkTap: null,
          autoDetectLinks: true,
        );
      }

      if (block is MessageMarkdownCodeBlock) {
        final List<String> lines =
            block.code.replaceAll('\r\n', '\n').split('\n');
        String line = lines.isEmpty ? '' : lines.first.trimRight();
        if (line.length > 80) {
          line = '${line.substring(0, 80)}…';
        }
        return <InlineSpan>[
          TextSpan(
            text: line.isEmpty ? '…' : line,
            style: baseStyle.copyWith(fontFamily: 'monospace'),
          ),
        ];
      }
    }

    return <InlineSpan>[TextSpan(text: markdown, style: baseStyle)];
  }

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = <InlineSpan>[];
    if (prefixText != null && prefixText!.isNotEmpty) {
      spans.add(
        TextSpan(
          text: prefixText,
          style: prefixStyle ?? baseStyle,
        ),
      );
    }
    spans.addAll(
      buildPreviewSpans(
        markdown: markdown,
        baseStyle: baseStyle,
        linkColor: linkColor,
      ),
    );

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
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
    final Color backgroundColor = (baseStyle.color ?? Colors.black).withAlpha(
      16,
    );

    final TextStyle codeStyle = baseStyle.copyWith(
      fontFamily: 'monospace',
      height: 1.25,
    );

    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
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
