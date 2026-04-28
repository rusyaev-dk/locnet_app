// sidebar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/side_panel/presentation/presentation.dart';

class PanelSidebar extends StatelessWidget {
  const PanelSidebar({super.key});

  bool _isSelected({required String currentLocation, required String path}) {
    if (path == AppRoutes.conversations) {
      return currentLocation == AppRoutes.conversations ||
          currentLocation.startsWith('${AppRoutes.conversations}/');
    }

    return currentLocation == path;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final spacing = context.designTokens.spacing;
    final l10n = context.l10n;
    final String currentLocation = GoRouterState.of(context).uri.path;

    return ColoredBox(
      color: colorScheme.secondary,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: spacing.xxl + spacing.sm - spacing.xxs / 2),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SidebarItem(
                      label: l10n.conversations,
                      icon: Icons.chat_bubble_outline,
                      isSelected: _isSelected(
                        currentLocation: currentLocation,
                        path: AppRoutes.conversations,
                      ),
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
              isSelected: _isSelected(
                currentLocation: currentLocation,
                path: AppRoutes.settings,
              ),
              onTap: () {
                showGeneralDialog(
                  context: context,
                  transitionBuilder: slideFadeDialogTransition,
                  pageBuilder: (context, _, _) => const SettingsModalCard(),
                );
              },
            ),
            SizedBox(height: spacing.xxl + spacing.xs - spacing.xxs / 4),
          ],
        ),
      ),
    );
  }
}
