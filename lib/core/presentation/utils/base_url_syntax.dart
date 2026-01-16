import 'package:markdown/markdown.dart' as md;

class BareUrlSyntax extends md.InlineSyntax {
  BareUrlSyntax()
    : super(
        r'(?:(?:https?:\/\/)|(?:www\.))'
        r'[\w\-]+(\.[\w\-]+)+'
        r'([\/\?\#][^\s<]*)?',
      );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String raw = match.group(0) ?? '';
    final String href = raw.startsWith('http') ? raw : 'https://$raw';

    parser.addNode(md.Element.text('a', raw)..attributes['href'] = href);

    return true;
  }
}
