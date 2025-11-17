// sidebar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/home/presentation/presentation.dart';

class PanelSidebar extends StatefulWidget {
  const PanelSidebar({required this.currentLocation, super.key});

  final String currentLocation;

  @override
  State<PanelSidebar> createState() => _PanelSidebarState();
}

class _PanelSidebarState extends State<PanelSidebar> {
  static const double _collapsedWidth = 80;
  static const double _expandedWidth = 304;

  // Breakpoint for switching layout from collapsed to expanded
  static const double _collapsedBreakpoint = 120;

  bool _isCollapsed = false;

  double get _targetWidth => _isCollapsed ? _collapsedWidth : _expandedWidth;

  bool _isSelected(String path) {
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
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // This depends on the actual animated width, so
          // layout switches only when реально есть место
          final bool isCollapsedLayout =
              constraints.maxWidth <= _collapsedBreakpoint;

          final textScheme = context.textScheme;

          return Column(
            crossAxisAlignment: isCollapsedLayout
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsedLayout ? 8 : 16,
                ),
                child: Align(
                  alignment: isCollapsedLayout
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: isCollapsedLayout
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: isCollapsedLayout ? 28 : 36,
                        height: isCollapsedLayout ? 28 : 36,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha(24),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.bubble_chart_outlined,
                          size: isCollapsedLayout ? 16 : 20,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (!isCollapsedLayout) ...[
                        const SizedBox(width: 15),
                        Flexible(
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
                      _SidebarToggleButton(
                        isCollapsed: _isCollapsed,
                        onToggle: _toggleCollapsed,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCollapsedLayout ? 4 : 12,
                    vertical: 4,
                  ),
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
                    SidebarItem(
                      label: l10n.storage,
                      icon: Icons.folder_outlined,
                      isSelected: _isSelected(AppRoutes.storage),
                      isCollapsed: isCollapsedLayout,
                      onTap: () {
                        GoRouter.of(context).go(AppRoutes.storage);
                      },
                    ),
                    SidebarItem(
                      label: l10n.settings,
                      icon: Icons.settings_outlined,
                      isSelected: _isSelected(AppRoutes.settings),
                      isCollapsed: isCollapsedLayout,
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}

class _SidebarToggleButton extends StatelessWidget {
  const _SidebarToggleButton({
    required this.isCollapsed,
    required this.onToggle,
  });

  final bool isCollapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colorScheme.secondary,
          ),
          child: Center(
            child: AnimatedRotation(
              duration: kThemeChangeDuration,
              curve: Curves.easeOutCubic,
              turns: isCollapsed ? 0.5 : 0.0,
              child: Icon(
                Icons.chevron_left,
                size: 22,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
