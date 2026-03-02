// panel_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/side_panel/presentation/presentation.dart';

class PanelScreen extends StatelessWidget {
  const PanelScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final String location = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: colorScheme.surfaceBright,
      body: Row(
        children: [
          PanelSidebar(currentLocation: location),
          Expanded(child: child),
        ],
      ),
    );
  }
}
