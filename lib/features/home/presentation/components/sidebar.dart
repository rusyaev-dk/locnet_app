// sidebar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/home/presentation/presentation.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class PanelSidebar extends StatefulWidget {
  const PanelSidebar({required this.currentLocation, super.key});

  final String currentLocation;

  @override
  State<PanelSidebar> createState() => _PanelSidebarState();
}

class _PanelSidebarState extends State<PanelSidebar> {
  static const double _collapsedWidth = 80;
  static const double _expandedWidth = 304;

  static const double _collapsedBreakpoint = 120;

  bool _isCollapsed = false;

  double get _targetWidth => _isCollapsed ? _collapsedWidth : _expandedWidth;

  bool _isSelected(String path) {
    if (path == AppRoutes.conversations) {
      return widget.currentLocation == AppRoutes.conversations ||
          widget.currentLocation.startsWith('${AppRoutes.conversations}/');
    }

    return widget.currentLocation == path;
  }

  void _toggleCollapsed() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return AnimatedContainer(
      duration: kThemeChangeDuration,
      curve: Curves.easeOutCubic,
      width: _targetWidth,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isCollapsedLayout =
              constraints.maxWidth <= _collapsedBreakpoint;

          final textScheme = context.textScheme;
          final double horizontalPadding = isCollapsedLayout ? 8 : 12;

          return Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    if (!isCollapsedLayout) ...[
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'LocNet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textScheme.headline.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    RoundedIconButton(
                      buttonSize: isCollapsedLayout ? 28 : 36,
                      icon: _isCollapsed
                          ? Icons.chevron_right
                          : Icons.chevron_left,
                      onPressed: _toggleCollapsed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: isCollapsedLayout
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      SidebarItem(
                        label: l10n.homePage,
                        icon: Icons.home_outlined,
                        isSelected: _isSelected(AppRoutes.home),
                        isCollapsed: isCollapsedLayout,
                        onTap: () {
                          GoRouter.of(context).go(AppRoutes.home);
                        },
                      ),
                      SidebarItem(
                        label: l10n.conversations,
                        icon: Icons.chat_bubble_outline,
                        isSelected: _isSelected(AppRoutes.conversations),
                        isCollapsed: isCollapsedLayout,
                        onTap: () {
                          GoRouter.of(context).go(AppRoutes.conversations);
                        },
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  12,
                ),
                child: Column(
                  children: [
                    SidebarItem(
                      label: l10n.settings,
                      icon: Icons.settings_outlined,
                      isSelected: _isSelected(AppRoutes.settings),
                      isCollapsed: isCollapsedLayout,
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          transitionBuilder: slideFadeDialogTransition,
                          pageBuilder: (context, _, _) =>
                              const SettingsModalCard(),
                        );
                      },
                    ),
                    SidebarItem(
                      label: l10n.profile,
                      icon: Icons.person_outline,
                      isSelected: _isSelected(AppRoutes.profile),
                      isCollapsed: isCollapsedLayout,
                      onTap: () {
                        showGeneralDialog(
                          routeSettings: const RouteSettings(
                            name: AppRoutes.profile,
                          ),
                          context: context,
                          transitionBuilder: slideFadeDialogTransition,
                          pageBuilder: (context, _, _) {
                            return const ProfileModalCard();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
