import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileEditorForm extends StatelessWidget {
  const ProfileEditorForm({
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.descriptionController,
    required this.firstNameError,
    required this.lastNameError,
    required this.usernameError,
    required this.screenError,
    required this.isSubmitting,
    required this.onCancelEdit,
    required this.onSave,
    super.key,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController descriptionController;
  final String? firstNameError;
  final String? lastNameError;
  final String? usernameError;
  final String? screenError;
  final bool isSubmitting;
  final VoidCallback onCancelEdit;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsMyProfileDescription,
            style: textScheme.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: firstNameController,
            labelText: l10n.firstName,
            textInputAction: TextInputAction.next,
            errorText: firstNameError,
            isActive: !isSubmitting,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: lastNameController,
            labelText: l10n.lastName,
            textInputAction: TextInputAction.next,
            errorText: lastNameError,
            isActive: !isSubmitting,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: usernameController,
            labelText: l10n.username,
            textInputAction: TextInputAction.next,
            errorText: usernameError,
            isActive: !isSubmitting,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: descriptionController,
            labelText: l10n.description,
            maxLines: 5,
            minLines: 3,
            expandable: true,
            isActive: !isSubmitting,
          ),
          if (screenError != null) ...[
            const SizedBox(height: 10),
            Text(
              screenError!,
              style: textScheme.caption.copyWith(color: colorScheme.error),
            ),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: isSubmitting ? null : onCancelEdit,
                  child: Text(l10n.cancel),
                ),
                SizedBox(
                  width: 160,
                  child: AppPrimaryButton(
                    text: l10n.apply,
                    onPressed: onSave,
                    isLoading: isSubmitting,
                    isActive: !isSubmitting,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
