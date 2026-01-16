import 'package:flutter/material.dart';

final class MessageInputSelectionToolbarAction {
  const MessageInputSelectionToolbarAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
    this.isDestructive = false,
  });

  final String id;
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isDestructive;
}
