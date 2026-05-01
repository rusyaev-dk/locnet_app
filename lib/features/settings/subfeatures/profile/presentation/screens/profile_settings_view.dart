import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/components.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({
    required this.user,
    required this.isEditing,
    required this.isSubmitting,
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
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onUsernameChanged,
    required this.onDescriptionChanged,
    super.key,
  });

  final User user;
  final bool isEditing;
  final bool isSubmitting;
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
  final ValueChanged<String?> onFirstNameChanged;
  final ValueChanged<String?> onLastNameChanged;
  final ValueChanged<String?> onUsernameChanged;
  final ValueChanged<String?> onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final String initials = ProfileDataExtractor.extractUserInitials(user);
    final String fullName = ProfileDataExtractor.extractUserFullName(user);
    final String displayName = fullName.isNotEmpty ? fullName : user.username;
    final String description = (user.description ?? '').trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar row ───────────────────────────────────────────
          Row(
            children: [
              Stack(
                children: [
                  CompanionAvatar(text: initials, size: 72, isOnline: true),
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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.l10n.profileChangePhoto,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
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
