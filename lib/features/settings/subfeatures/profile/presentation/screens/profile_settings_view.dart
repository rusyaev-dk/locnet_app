import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
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
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsGroupCard(children: [ProfileIdentityCard(user: user)]),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: isEditing ? l10n.edit : l10n.settingsMyProfile,
            children: [
              if (!isEditing) ...[
                ProfileInfoTile(title: l10n.firstName, value: user.firstName),
                ProfileInfoTile(title: l10n.lastName, value: user.lastName),
                ProfileInfoTile(
                  title: l10n.username,
                  value: '@${user.username}',
                ),
                ProfileInfoTile(
                  title: l10n.language,
                  value: user.languageCode.toUpperCase(),
                ),
                ProfileInfoTile(
                  title: l10n.description,
                  value: _descriptionOrFallback(
                    description: user.description,
                    fallback: l10n.unknownValue,
                  ),
                ),
              ] else
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
              if (!isEditing)
                SettingsActionTile(
                  title: l10n.edit,
                  leadingIcon: Icons.edit_outlined,
                  onTap: onStartEdit,
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _descriptionOrFallback({
    required String? description,
    required String fallback,
  }) {
    final String normalized = description?.trim() ?? '';
    if (normalized.isEmpty) {
      return fallback;
    }

    return normalized;
  }
}
