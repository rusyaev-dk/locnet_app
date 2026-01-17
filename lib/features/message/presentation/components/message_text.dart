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

    final List<InlineSpan> spans = MessageInlineSpanBuilder.build(
      plainText: text,
      ranges: ranges,
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

    return SelectableText.rich(TextSpan(children: spans), style: textStyle);
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
