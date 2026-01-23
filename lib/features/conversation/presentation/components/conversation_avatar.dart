import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({super.key, this.text, this.url, this.size = 44})
    : assert(
        text != null || url != null,
        'Either text or url must be provided',
      );

  final String? text;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final BoxDecoration decoration = BoxDecoration(
      color: colorScheme.surfaceBright,
      shape: BoxShape.circle,
      border: Border.all(color: colorScheme.outlineVariant),
    );

    if (url != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, _) =>
              _Placeholder(size: size, decoration: decoration),
          errorWidget: (_, _, _) =>
              _Placeholder(size: size, decoration: decoration, text: text),
        ),
      );
    }

    return _Placeholder(
      size: size,
      decoration: decoration,
      text: text,
      textStyle: textScheme.label.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.size,
    required this.decoration,
    this.text,
    this.textStyle,
  });

  final double size;
  final BoxDecoration decoration;
  final String? text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: decoration,
      alignment: Alignment.center,
      child: text != null && text!.trim().isNotEmpty
          ? Text(_normalizeText(text!), style: textStyle)
          : const SizedBox.shrink(),
    );
  }

  String _normalizeText(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.length <= 2) {
      return trimmed.toUpperCase();
    }
    return trimmed.substring(0, 2).toUpperCase();
  }
}
