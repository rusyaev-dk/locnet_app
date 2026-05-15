// panel_screen.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/side_panel/presentation/presentation.dart';

class PanelScreen extends StatelessWidget {
  const PanelScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          const PanelSidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
