// panel_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/features/home/presentation/presentation.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class PanelScreen extends StatelessWidget {
  const PanelScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return Scaffold(
      drawer: const SettingsDrawer(),
      body: Row(
        children: [
          PanelSidebar(currentLocation: location),
          Expanded(child: child),
        ],
      ),
    );
  }
}
