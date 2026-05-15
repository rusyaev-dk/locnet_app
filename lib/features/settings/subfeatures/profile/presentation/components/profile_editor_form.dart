import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

const double _kProfileFormActionButtonWidth = 140;
const double _kProfileFormActionButtonHeight = 40;

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
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onUsernameChanged,
    required this.onDescriptionChanged,
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
  final ValueChanged<String?> onFirstNameChanged;
  final ValueChanged<String?> onLastNameChanged;
  final ValueChanged<String?> onUsernameChanged;
  final ValueChanged<String?> onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final radii = context.radii;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: firstNameController,
          labelText: l10n.firstName,
          textInputAction: TextInputAction.next,
          errorText: firstNameError,
          isActive: !isSubmitting,
          onChanged: onFirstNameChanged,
          onFocusChange: onFirstNameChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: lastNameController,
          labelText: l10n.lastName,
          textInputAction: TextInputAction.next,
          errorText: lastNameError,
          isActive: !isSubmitting,
          onChanged: onLastNameChanged,
          onFocusChange: onLastNameChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: usernameController,
          labelText: l10n.username,
          textInputAction: TextInputAction.next,
          errorText: usernameError,
          isActive: !isSubmitting,
          onChanged: onUsernameChanged,
          onFocusChange: onUsernameChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: descriptionController,
          labelText: l10n.description,
          maxLines: 4,
          minLines: 2,
          expandable: true,
          isActive: !isSubmitting,
          onChanged: onDescriptionChanged,
          onFocusChange: onDescriptionChanged,
        ),
        if (screenError != null) ...[
          const SizedBox(height: 10),
          Text(
            screenError!,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.error,
              height: 1.3,
            ),
          ),
        ],
        const SizedBox(height: 22),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _kProfileFormActionButtonWidth,
                height: _kProfileFormActionButtonHeight,
                child: Opacity(
                  opacity: isSubmitting ? 0.45 : 1,
                  child: IgnorePointer(
                    ignoring: isSubmitting,
                    child: ChipButton(
                      label: l10n.cancel,
                      height: _kProfileFormActionButtonHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      borderRadius: radii.defaultRadiusValue,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      borderColor: colorScheme.outline,
                      onPressed: onCancelEdit,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: _kProfileFormActionButtonWidth,
                height: _kProfileFormActionButtonHeight,
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
    );
  }
}
