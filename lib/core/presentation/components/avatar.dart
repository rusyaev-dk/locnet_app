import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/domain/models/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/models/group.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/interactors/media_interactor.dart';

class Avatar extends StatelessWidget {
  const Avatar.user({
    required User this.user,
    this.size = 32,
    this.isOnline,
    super.key,
  }) : channel = null,
       group = null;

  const Avatar.channel({
    required Channel this.channel,
    this.size = 32,
    this.isOnline,
    super.key,
  }) : user = null,
       group = null;

  const Avatar.group({
    required Group this.group,
    this.size = 32,
    this.isOnline,
    super.key,
  }) : user = null,
       channel = null;

  final User? user;
  final Channel? channel;
  final Group? group;
  final double size;
  final bool? isOnline;

  static const Color onlineIndicatorColor = Color(0xFF4CAF79);

  String? get _avatarId {
    if (user != null) return user!.avatarId;
    if (channel != null) return channel!.avatarFileId;
    if (group != null) return group!.avatarFileId;
    return null;
  }

  String get _fallbackText {
    if (user != null) return ProfileDataExtractor.extractUserInitials(user!);
    if (channel != null) return _initials(channel!.title);
    if (group != null) return _initials(group!.title);
    return '?';
  }

  static String _initials(String title) {
    final String trimmed = title.trim();
    if (trimmed.isEmpty) return '?';
    if (trimmed.length == 1) return trimmed.toUpperCase();
    return trimmed.substring(0, 2).toUpperCase();
  }

  static Gradient generateAvatarGradient({required String seed}) {
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AvatarCubit>(
      key: ValueKey<String>(_avatarId ?? _fallbackText),
      create: (BuildContext ctx) =>
          AvatarCubit(mediaInteractor: ctx.read<MediaInteractor>())
            ..resolve(_avatarId),
      child: BlocBuilder<AvatarCubit, AvatarState>(
        builder: (_, AvatarState state) => _AvatarView(
          text: _fallbackText,
          url: state is AvatarLoadedState ? state.url : null,
          size: size,
          isOnline: isOnline,
        ),
      ),
    );
  }
}

class _AvatarView extends StatelessWidget {
  const _AvatarView({
    required this.text,
    required this.url,
    required this.size,
    required this.isOnline,
  });

  final String text;
  final String? url;
  final double size;
  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final Gradient? backgroundGradient = url == null
        ? Avatar.generateAvatarGradient(seed: text.isEmpty ? 'default' : text)
        : null;

    final BoxDecoration decoration = BoxDecoration(
      gradient: backgroundGradient,
      color: backgroundGradient == null ? colorScheme.surfaceBright : null,
      shape: BoxShape.circle,
    );

    Widget avatar;
    if (url != null && url!.isNotEmpty) {
      avatar = ClipOval(
        child: CachedNetworkImage(
          imageUrl: url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, _) =>
              _Placeholder(size: size, decoration: decoration, text: text),
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
        children: <Widget>[
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isOnline!
                    ? Avatar.onlineIndicatorColor
                    : colorScheme.onSurfaceVariant,
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
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.size,
    required this.decoration,
    required this.text,
  });

  final double size;
  final BoxDecoration decoration;
  final String text;

  @override
  Widget build(BuildContext context) {
    final String normalizedText = _normalizeText(text);
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
    if (trimmed.isEmpty) return '';
    if (trimmed.length <= 2) return trimmed.toUpperCase();
    return trimmed.substring(0, 2).toUpperCase();
  }
}
