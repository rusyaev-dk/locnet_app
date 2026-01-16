import 'package:flutter/material.dart';

final class MessageContextMenuAction {
  const MessageContextMenuAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
    this.isEnabled = true,
  });

  final String id;
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isEnabled;
}
