import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PanelScreen extends StatefulWidget {
  const PanelScreen({required this.child, super.key});

  final Widget child;

  @override
  State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  static const double _minSidebarWidth = 72;
  static const double _maxSidebarWidth = 320;

  double _sidebarWidth = 240;

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      final double newWidth = _sidebarWidth + details.delta.dx;
      _sidebarWidth = newWidth.clamp(_minSidebarWidth, _maxSidebarWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Row(
        children: <Widget>[
          _PanelSidebar(width: _sidebarWidth, currentLocation: location),
          // ресайзер как раньше
          MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: _handleHorizontalDragUpdate,
              child: const SizedBox(width: 4, child: VerticalDivider(width: 4)),
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class _PanelSidebar extends StatelessWidget {
  const _PanelSidebar({required this.width, required this.currentLocation});

  final double width;
  final String currentLocation;

  bool _isSelected(String startsWithPath) {
    return currentLocation.startsWith(startsWithPath);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: width,
      color: theme.colorScheme.surfaceContainerHighest,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isCollapsed = constraints.maxWidth <= 96;

          return Column(
            crossAxisAlignment: isCollapsed
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: isCollapsed
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: isCollapsed
                      ? const Icon(Icons.bubble_chart_outlined, size: 24)
                      : Text('LocNet', style: theme.textTheme.titleLarge),
                ),
              ),
              const SizedBox(height: 24),
              _SidebarItem(
                label: 'Welcome',
                icon: Icons.home_outlined,
                isSelected: _isSelected('/panel/welcome'),
                isCollapsed: isCollapsed,
                onTap: () {
                  context.go('/panel/welcome');
                },
              ),
              _SidebarItem(
                label: 'Conversations',
                icon: Icons.chat_bubble_outline,
                isSelected: _isSelected('/panel/conversations'),
                isCollapsed: isCollapsed,
                onTap: () {
                  context.go('/panel/conversations');
                },
              ),
              _SidebarItem(
                label: 'Storage',
                icon: Icons.folder_outlined,
                isSelected: _isSelected('/panel/storage'),
                isCollapsed: isCollapsed,
                onTap: () {
                  context.go('/panel/storage');
                },
              ),
              _SidebarItem(
                label: 'Settings',
                icon: Icons.settings_outlined,
                isSelected: _isSelected('/panel/settings'),
                isCollapsed: isCollapsed,
                onTap: () {
                  context.go('/panel/settings');
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: isCollapsed
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              // TODO: implement logout flow.
                            },
                            icon: const Icon(Icons.logout),
                            tooltip: 'Logout',
                          ),
                        )
                      : OutlinedButton.icon(
                          onPressed: () {
                            // TODO: implement logout flow.
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 16,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
              if (!isCollapsed) ...<Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
