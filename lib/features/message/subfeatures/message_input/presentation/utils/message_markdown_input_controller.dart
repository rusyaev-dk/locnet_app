// message_markdown_input_controller.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MessageMarkdownInputController extends TextEditingController {
  MessageMarkdownInputController({
    required TextStyle baseStyle,
    required TextStyle markerStyle,
    required TextStyle boldStyle,
    required TextStyle italicStyle,
    required TextStyle codeStyle,
    required TextStyle strikeStyle,
    required TextStyle linkStyle,
    String? text,
  }) : _baseStyle = baseStyle,
       _markerStyle = markerStyle,
       _boldStyle = boldStyle,
       _italicStyle = italicStyle,
       _codeStyle = codeStyle,
       _strikeStyle = strikeStyle,
       _linkStyle = linkStyle,
       super(text: text);

  final TextStyle _baseStyle;
  final TextStyle _markerStyle;
  final TextStyle _boldStyle;
  final TextStyle _italicStyle;
  final TextStyle _codeStyle;
  final TextStyle _strikeStyle;
  final TextStyle _linkStyle;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final String raw = text;
    if (raw.isEmpty) {
      return TextSpan(text: '', style: _baseStyle);
    }

    final List<_Token> tokens = _MarkdownTokenizer.tokenize(raw);
    final List<InlineSpan> spans = <InlineSpan>[];

    for (final _Token token in tokens) {
      switch (token.type) {
        case _TokenType.plain:
          spans.add(TextSpan(text: token.text, style: _baseStyle));
        case _TokenType.marker:
          spans.add(TextSpan(text: token.text, style: _markerStyle));
        case _TokenType.bold:
          spans.addAll(
            _wrapWithMarkers(
              open: '**',
              content: token.text,
              close: '**',
              contentStyle: _boldStyle,
            ),
          );
        case _TokenType.italic:
          spans.addAll(
            _wrapWithMarkers(
              open: '*',
              content: token.text,
              close: '*',
              contentStyle: _italicStyle,
            ),
          );
        case _TokenType.code:
          spans.addAll(
            _wrapWithMarkers(
              open: '`',
              content: token.text,
              close: '`',
              contentStyle: _codeStyle,
            ),
          );
        case _TokenType.strike:
          spans.addAll(
            _wrapWithMarkers(
              open: '~~',
              content: token.text,
              close: '~~',
              contentStyle: _strikeStyle,
            ),
          );
        case _TokenType.link:
          spans.addAll(_wrapLink(label: token.text, url: token.meta ?? ''));
      }
    }

    return TextSpan(style: _baseStyle, children: spans);
  }

  List<InlineSpan> _wrapWithMarkers({
    required String open,
    required String content,
    required String close,
    required TextStyle contentStyle,
  }) {
    return <InlineSpan>[
      TextSpan(text: open, style: _markerStyle),
      TextSpan(text: content, style: contentStyle),
      TextSpan(text: close, style: _markerStyle),
    ];
  }

  List<InlineSpan> _wrapLink({required String label, required String url}) {
    return <InlineSpan>[
      TextSpan(text: '[', style: _markerStyle),
      TextSpan(text: label, style: _linkStyle),
      TextSpan(text: '](', style: _markerStyle),
      TextSpan(text: url, style: _markerStyle),
      TextSpan(text: ')', style: _markerStyle),
    ];
  }
}

enum _TokenType { plain, marker, bold, italic, code, strike, link }

class _Token {
  const _Token({required this.type, required this.text, this.meta});

  final _TokenType type;
  final String text;
  final String? meta;
}

class _MarkdownTokenizer {
  static List<_Token> tokenize(String input) {
    final List<_Token> tokens = <_Token>[];

    int index = 0;
    while (index < input.length) {
      final _MatchResult? match = _tryMatch(input, index);

      if (match == null) {
        tokens.add(_Token(type: _TokenType.plain, text: input[index]));
        index += 1;
        continue;
      }

      if (match.start > index) {
        tokens.add(
          _Token(
            type: _TokenType.plain,
            text: input.substring(index, match.start),
          ),
        );
      }

      tokens.addAll(match.tokens);
      index = match.end;
    }

    return _mergePlain(tokens);
  }

  static List<_Token> _mergePlain(List<_Token> tokens) {
    final List<_Token> out = <_Token>[];
    for (final _Token token in tokens) {
      if (out.isNotEmpty &&
          out.last.type == _TokenType.plain &&
          token.type == _TokenType.plain) {
        final _Token last = out.removeLast();
        out.add(_Token(type: _TokenType.plain, text: last.text + token.text));
      } else {
        out.add(token);
      }
    }
    return out;
  }

  static _MatchResult? _tryMatch(String input, int from) {
    final _MatchResult? link = _matchLink(input, from);
    if (link != null) {
      return link;
    }

    final _MatchResult? code = _matchWrapped(
      input: input,
      from: from,
      open: '`',
      close: '`',
      type: _TokenType.code,
    );
    if (code != null) {
      return code;
    }

    final _MatchResult? bold = _matchWrapped(
      input: input,
      from: from,
      open: '**',
      close: '**',
      type: _TokenType.bold,
    );
    if (bold != null) {
      return bold;
    }

    final _MatchResult? strike = _matchWrapped(
      input: input,
      from: from,
      open: '~~',
      close: '~~',
      type: _TokenType.strike,
    );
    if (strike != null) {
      return strike;
    }

    final _MatchResult? italic = _matchWrapped(
      input: input,
      from: from,
      open: '*',
      close: '*',
      type: _TokenType.italic,
    );
    if (italic != null) {
      return italic;
    }

    return null;
  }

  static _MatchResult? _matchWrapped({
    required String input,
    required int from,
    required String open,
    required String close,
    required _TokenType type,
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
    if (content.isEmpty) {
      return null;
    }

    return _MatchResult(
      start: from,
      end: closeIndex + close.length,
      tokens: <_Token>[_Token(type: type, text: content)],
    );
  }

  static _MatchResult? _matchLink(String input, int from) {
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

    return _MatchResult(
      start: from,
      end: urlEnd + 1,
      tokens: <_Token>[_Token(type: _TokenType.link, text: label, meta: url)],
    );
  }
}

class _MatchResult {
  const _MatchResult({
    required this.start,
    required this.end,
    required this.tokens,
  });

  final int start;
  final int end;
  final List<_Token> tokens;
}
