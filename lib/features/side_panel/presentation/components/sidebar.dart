// sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class PanelSidebar extends StatelessWidget {
  const PanelSidebar({super.key});

  bool _isConversationsSelected(String currentLocation) {
    return currentLocation == AppRoutes.conversations ||
        currentLocation.startsWith('${AppRoutes.conversations}/');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final String currentLocation = GoRouterState.of(context).uri.path;
    final bool chatSelected = _isConversationsSelected(currentLocation);

    final User? currentUser = context.select<AuthCubit, User?>((c) {
      final state = c.state;
      if (state is AuthAuthenticatedState) return state.user;
      return null;
    });

    final String userInitials = currentUser != null
        ? ProfileDataExtractor.extractUserInitials(currentUser)
        : '?';

    return Container(
      width: 58,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: Border(right: BorderSide(color: colorScheme.outline, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          // Logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 20),
          // Chat nav button
          _SidebarIconButton(
            icon: Icons.chat_bubble_outline,
            isSelected: chatSelected,
            onTap: () => GoRouter.of(context).go(AppRoutes.conversations),
            colorScheme: colorScheme,
          ),
          const Spacer(),
          // Settings button
          _SidebarIconButton(
            icon: Icons.settings_outlined,
            isSelected: false,
            onTap: () {
              showGeneralDialog(
                context: context,
                transitionBuilder: slideFadeDialogTransition,
                pageBuilder: (context, _, _) => const SettingsModalCard(),
              );
            },
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          // Current user avatar → opens settings on Profile (default section).
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  transitionBuilder: slideFadeDialogTransition,
                  pageBuilder: (context, _, _) => const SettingsModalCard(),
                );
              },
              child: CompanionAvatar(
                text: userInitials,
                size: 34,
                isOnline: true,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _SidebarIconButton extends StatelessWidget {
  const _SidebarIconButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
