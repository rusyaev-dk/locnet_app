import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/uikit/uikit.dart';
import 'package:markdown/markdown.dart' as md;

class AppMarkdownText extends StatelessWidget {
  const AppMarkdownText({
    required this.data,
    required this.textStyle,
    required this.linkColor,
    required this.selectionColor,
    this.onLinkTap,
    super.key,
  });

  final String data;
  final TextStyle textStyle;
  final Color linkColor;
  final Color selectionColor;
  final void Function(Uri uri)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    final AppTextScheme textScheme = context.textScheme;

    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: textStyle,
        a: textStyle.copyWith(
          color: linkColor,
          decoration: TextDecoration.underline,
        ),
        strong: textStyle.copyWith(fontWeight: FontWeight.w700),
        em: textStyle.copyWith(fontStyle: FontStyle.italic),
        code: textScheme.label.copyWith(
          color: textStyle.color,
          fontSize: textStyle.fontSize,
          fontFamily: 'monospace',
          backgroundColor: Colors.transparent,
        ),
        blockquote: textStyle,
      ),
      extensionSet: md.ExtensionSet.gitHubFlavored,
      inlineSyntaxes: [BareUrlSyntax()],
      onTapLink: (String text, String? href, String title) {
        final Uri? uri = href == null ? null : Uri.tryParse(href);
        if (uri == null) {
          return;
        }
        if (onLinkTap == null) {
          return;
        }
        onLinkTap!(uri);
      },
    );
  }
}
