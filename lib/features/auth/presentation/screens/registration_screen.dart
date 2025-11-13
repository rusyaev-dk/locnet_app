import 'package:flutter/material.dart';

class RegistrationScreenWrapper extends StatelessWidget {
  const RegistrationScreenWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Placeholder(child: child);
  }
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
