import 'package:flutter/material.dart';

class EmojiSectionData {
  const EmojiSectionData({
    required this.key,
    required this.title,
    required this.emojis,
  });

  final Key? key;
  final String title;
  final List<String> emojis;
}
