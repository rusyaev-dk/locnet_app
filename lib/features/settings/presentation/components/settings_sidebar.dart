import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/models/models.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Sidebar for settings modal: 4 main tabs + Sign Out at bottom.
class SettingsSidebar extends StatelessWidget {
  const SettingsSidebar({
    required this.selectedSection,
    required this.onSectionSelected,
    this.compact = false,
    this.onLogout,
    // kept for backward compat but ignored
    this.profileTrailing,
    super.key,
  });

  final SettingsSection selectedSection;
  final ValueChanged<SettingsSection> onSectionSelected;
  final bool compact;
  final VoidCallback? onLogout;
  final Widget? profileTrailing;

  static const double _sidebarWidth = 160;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final List<(SettingsSection section, IconData icon, String label)> items = [
      (SettingsSection.profile, Icons.person_outline, l10n.settingsMyProfile),
      (SettingsSection.appearance, Icons.palette_outlined, l10n.appearance),
      (
        SettingsSection.notifications,
        Icons.notifications_outlined,
        l10n.settingsNotificationsAndSounds,
      ),
      (SettingsSection.privacy, Icons.visibility_outlined, l10n.settingsPrivacy),
    ];

    Widget sidebar = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return _SettingsSidebarItem(
                icon: item.$2,
                label: item.$3,
                isSelected: item.$1 == selectedSection,
                compact: compact,
                onTap: () => onSectionSelected(item.$1),
                colorScheme: colorScheme,
                textScheme: textScheme,
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 2),
            itemCount: items.length,
          ),
        ),
        if (onLogout != null) ...[
          Divider(height: 1, color: colorScheme.outline),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
            child: _SettingsLogoutTile(
              compact: compact,
              onTap: onLogout!,
              title: l10n.logOut,
              colorScheme: colorScheme,
              textScheme: textScheme,
            ),
          ),
        ],
      ],
    );

    if (!compact) {
      sidebar = SizedBox(width: _sidebarWidth, child: sidebar);
    }

    return sidebar;
  }
}

class _SettingsLogoutTile extends StatelessWidget {
  const _SettingsLogoutTile({
    required this.compact,
    required this.onTap,
    required this.title,
    required this.colorScheme,
    required this.textScheme,
  });

  final bool compact;
  final VoidCallback onTap;
  final String title;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: 10,
          ),
          child: compact
              ? Center(
                  child: Icon(
                    Icons.logout,
                    size: 16,
                    color: colorScheme.error,
                  ),
                )
              : Row(
                  children: [
                    Icon(Icons.logout, size: 16, color: colorScheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textScheme.label.copyWith(
                          color: colorScheme.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SettingsSidebarItem extends StatelessWidget {
  const _SettingsSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.compact,
    required this.onTap,
    required this.colorScheme,
    required this.textScheme,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? colorScheme.primaryContainer
        : Colors.transparent;
    final Color foregroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: 10,
          ),
          child: compact
              ? Center(child: Icon(icon, size: 18, color: foregroundColor))
              : Row(
                  children: [
                    Icon(icon, size: 18, color: foregroundColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textScheme.label.copyWith(
                          color: foregroundColor,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
