import 'package:flutter/material.dart';

class PrivateConversationScreenWrapper extends StatelessWidget {
  const PrivateConversationScreenWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PrivateConversationScreen extends StatelessWidget {
  const PrivateConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrivateConversationScreenWrapper(child: Placeholder());
  }
}
