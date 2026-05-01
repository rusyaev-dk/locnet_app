import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({
    super.key,
    this.text,
    this.url,
    this.size = 44,
    this.isOnline,
  }) : assert(
         text != null || url != null,
         'Either text or url must be provided',
       );

  final String? text;
  final String? url;
  final double size;

  /// When non-null, shows the online indicator dot.
  final bool? isOnline;

  static const Color _onlineColor = Color(0xFF4CAF79);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final Gradient? backgroundGradient = url == null
        ? _generateAvatarGradient(seed: text ?? 'default')
        : null;

    final BoxDecoration decoration = BoxDecoration(
      gradient: backgroundGradient,
      color: backgroundGradient == null ? colorScheme.surfaceBright : null,
      shape: BoxShape.circle,
      border: Border.all(color: colorScheme.outlineVariant),
    );

    Widget avatar;
    if (url != null) {
      avatar = ClipOval(
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
    } else {
      avatar = _Placeholder(size: size, decoration: decoration, text: text);
    }

    if (isOnline == null) {
      return avatar;
    }

    final double dotSize = (size * 0.28).clamp(7.0, 14.0);
    final double borderWidth = dotSize * 0.22;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isOnline! ? _onlineColor : colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.secondary,
                  width: borderWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Gradient _generateAvatarGradient({required String seed}) {
    final int hash = seed.hashCode;
    final Random random = Random(hash);

    final double hue = random.nextDouble() * 360;
    const double saturation = 0.55;
    const double baseLightness = 0.68;

    final HSLColor baseColor = HSLColor.fromAHSL(
      1,
      hue,
      saturation,
      baseLightness,
    );

    final Color topColor = baseColor
        .withLightness((baseLightness + 0.08).clamp(0, 1))
        .toColor();

    final Color bottomColor = baseColor
        .withLightness((baseLightness - 0.12).clamp(0, 1))
        .toColor();

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[topColor, bottomColor],
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size, required this.decoration, this.text});

  final double size;
  final BoxDecoration decoration;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final String normalizedText = text != null ? _normalizeText(text!) : '';
    final double fontSize = _calculateFontSize(
      avatarSize: size,
      textLength: normalizedText.length,
    );

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      alignment: Alignment.center,
      child: normalizedText.isNotEmpty
          ? Text(
              normalizedText,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  double _calculateFontSize({
    required double avatarSize,
    required int textLength,
  }) {
    final double baseRatio = textLength == 1 ? 0.50 : 0.34;
    final double rawSize = avatarSize * baseRatio;

    return rawSize.clamp(12.0, avatarSize * 0.6);
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
