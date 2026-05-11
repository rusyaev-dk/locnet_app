import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/components.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({
    required this.user,
    required this.isEditing,
    required this.isSubmitting,
    required this.isUploadingAvatar,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.descriptionController,
    required this.firstNameError,
    required this.lastNameError,
    required this.usernameError,
    required this.screenError,
    required this.onStartEdit,
    required this.onCancelEdit,
    required this.onSave,
    required this.onChangePhoto,
    required this.onDeletePhoto,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onUsernameChanged,
    required this.onDescriptionChanged,
    super.key,
  });

  final User user;
  final bool isEditing;
  final bool isSubmitting;
  final bool isUploadingAvatar;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController descriptionController;
  final String? firstNameError;
  final String? lastNameError;
  final String? usernameError;
  final String? screenError;
  final VoidCallback onStartEdit;
  final VoidCallback onCancelEdit;
  final VoidCallback onSave;
  final VoidCallback onChangePhoto;
  final VoidCallback onDeletePhoto;
  final ValueChanged<String?> onFirstNameChanged;
  final ValueChanged<String?> onLastNameChanged;
  final ValueChanged<String?> onUsernameChanged;
  final ValueChanged<String?> onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final String fullName = ProfileDataExtractor.extractUserFullName(user);
    final String displayName = fullName.isNotEmpty ? fullName : user.username;
    final String description = (user.description ?? '').trim();
    final bool hasAvatar =
        user.avatarId != null && user.avatarId!.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar row ───────────────────────────────────────────
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Avatar.user(
                    user: user,
                    size: 72,
                    isOnline: true,
                  ),
                  if (isUploadingAvatar)
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _PhotoButton(
                          label: context.l10n.profileChangePhoto,
                          onTap: isUploadingAvatar ? null : onChangePhoto,
                        ),
                        if (hasAvatar) ...[
                          const SizedBox(width: 8),
                          _PhotoButton(
                            label: context.l10n.profileDeletePhoto,
                            onTap: isUploadingAvatar ? null : onDeletePhoto,
                            isDestructive: true,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(height: 1, thickness: 1, color: colorScheme.outline),
          const SizedBox(height: 20),
          // ── Form fields ──────────────────────────────────────────
          ProfileEditorForm(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            usernameController: usernameController,
            descriptionController: descriptionController,
            firstNameError: firstNameError,
            lastNameError: lastNameError,
            usernameError: usernameError,
            screenError: screenError,
            isSubmitting: isSubmitting,
            onCancelEdit: onCancelEdit,
            onSave: onSave,
            onFirstNameChanged: onFirstNameChanged,
            onLastNameChanged: onLastNameChanged,
            onUsernameChanged: onUsernameChanged,
            onDescriptionChanged: onDescriptionChanged,
          ),
        ],
      ),
    );
  }
}

/// Small labelled button with hover highlight used in the avatar row.
class _PhotoButton extends StatefulWidget {
  const _PhotoButton({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  State<_PhotoButton> createState() => _PhotoButtonState();
}

class _PhotoButtonState extends State<_PhotoButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bool disabled = widget.onTap == null;
    final Color normalBg = colorScheme.secondary;
    final Color hoverBg = disabled
        ? normalBg
        : widget.isDestructive
        ? colorScheme.error.withValues(alpha: 0.12)
        : colorScheme.primary.withValues(alpha: 0.12);

    final Color textColor = disabled
        ? colorScheme.onSurfaceVariant
        : widget.isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return MouseRegion(
      onEnter: disabled ? null : (_) => setState(() => _hovered = true),
      onExit: disabled ? null : (_) => setState(() => _hovered = false),
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? hoverBg : normalBg,
            border: Border.all(
              color: widget.isDestructive && _hovered
                  ? colorScheme.error.withValues(alpha: 0.4)
                  : colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
