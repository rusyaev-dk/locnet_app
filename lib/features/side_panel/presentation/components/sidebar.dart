// sidebar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/side_panel/presentation/presentation.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class PanelSidebar extends StatefulWidget {
  const PanelSidebar({required this.currentLocation, super.key});

  final String currentLocation;

  @override
  State<PanelSidebar> createState() => _PanelSidebarState();
}

class _PanelSidebarState extends State<PanelSidebar> {
  bool _isSelected(String path) {
    if (path == AppRoutes.conversations) {
      return widget.currentLocation == AppRoutes.conversations ||
          widget.currentLocation.startsWith('${AppRoutes.conversations}/');
    }

    return widget.currentLocation == path;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(color: colorScheme.secondary),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 42),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SidebarItem(
                      label: l10n.conversations,
                      icon: Icons.chat_bubble_outline,
                      isSelected: _isSelected(AppRoutes.conversations),
                      onTap: () {
                        GoRouter.of(context).go(AppRoutes.conversations);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SidebarItem(
              label: l10n.settings,
              icon: Icons.settings_outlined,
              isSelected: _isSelected(AppRoutes.settings),
              onTap: () {
                showGeneralDialog(
                  context: context,
                  transitionBuilder: slideFadeDialogTransition,
                  pageBuilder: (context, _, _) => const SettingsModalCard(),
                );
              },
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
