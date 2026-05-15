import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/components.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Top padding inside [ProfileIdentityCard] before the avatar (must stay in sync for overlays).
const double _kProfileCardAvatarTop = 16;

const double _kAvatarSize = 88;

const double _kProfileContentMaxWidth = 420;

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
    final bool hasAvatar =
        user.avatarId != null && user.avatarId!.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kProfileContentMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        ProfileIdentityCard(user: user),
                        Positioned(
                          top: _kProfileCardAvatarTop,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            ignoring: !isEditing || isUploadingAvatar,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: isEditing && !isUploadingAvatar
                                    ? 1
                                    : 0,
                                duration: const Duration(milliseconds: 180),
                                child: _AvatarChangePhotoHitTarget(
                                  size: _kAvatarSize,
                                  onTap: onChangePhoto,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isUploadingAvatar)
                          Positioned(
                            top: _kProfileCardAvatarTop,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: _kAvatarSize,
                                height: _kAvatarSize,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withValues(
                                    alpha: 0.6,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isEditing)
                    Positioned(
                      top: 4,
                      right: 0,
                      child: Opacity(
                        opacity: isSubmitting ? 0.45 : 1,
                        child: IgnorePointer(
                          ignoring: isSubmitting,
                          child: SurfaceIconButton(
                            icon: Icons.edit_outlined,
                            dimension: 32,
                            margin: EdgeInsets.zero,
                            foregroundColor: colorScheme.onSurfaceVariant,
                            tooltip: context.l10n.edit,
                            onPressed: onStartEdit,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 220),
                crossFadeState: isEditing
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeIn,
                sizeCurve: Curves.easeInOut,
                firstChild: const _ProfileViewBody(),
                secondChild: _ProfileEditBody(
                  isUploadingAvatar: isUploadingAvatar,
                  hasAvatar: hasAvatar,
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
                  onDeletePhoto: onDeletePhoto,
                  onFirstNameChanged: onFirstNameChanged,
                  onLastNameChanged: onLastNameChanged,
                  onUsernameChanged: onUsernameChanged,
                  onDescriptionChanged: onDescriptionChanged,
                ),
              ),
              const SizedBox(height: 20),
              _ProfileAccountMetaCard(user: user),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular hit target over the avatar in edit mode: hover dimming + click to pick photo.
class _AvatarChangePhotoHitTarget extends StatefulWidget {
  const _AvatarChangePhotoHitTarget({required this.size, required this.onTap});

  final double size;
  final VoidCallback onTap;

  @override
  State<_AvatarChangePhotoHitTarget> createState() =>
      _AvatarChangePhotoHitTargetState();
}

class _AvatarChangePhotoHitTargetState
    extends State<_AvatarChangePhotoHitTarget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color base = Colors.black.withValues(alpha: _hover ? 0.48 : 0.36);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(color: base, shape: BoxShape.circle),
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class _ProfileAccountMetaCard extends StatelessWidget {
  const _ProfileAccountMetaCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final String languageLabel = LanguageSelector.labelForLanguageCode(
      user.languageCode,
    );
    final String registered = DateFormat.yMMMd(
      localeTag,
    ).format(user.createdAt.toLocal());

    return SettingsGroupCard(
      children: [
        SettingsValueTile(
          label: l10n.profileAccountLanguage,
          value: languageLabel,
          leadingIcon: Icons.translate_outlined,
        ),
        SettingsValueTile(
          label: l10n.profileRegistrationDate,
          value: registered,
          leadingIcon: Icons.event_outlined,
        ),
      ],
    );
  }
}

/// View-mode body: identity is shown in the header card only.
class _ProfileViewBody extends StatelessWidget {
  const _ProfileViewBody();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}

class _ProfileEditBody extends StatelessWidget {
  const _ProfileEditBody({
    required this.isUploadingAvatar,
    required this.hasAvatar,
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
    required this.onDeletePhoto,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onUsernameChanged,
    required this.onDescriptionChanged,
  });

  final bool isUploadingAvatar;
  final bool hasAvatar;
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
  final VoidCallback onDeletePhoto;
  final ValueChanged<String?> onFirstNameChanged;
  final ValueChanged<String?> onLastNameChanged;
  final ValueChanged<String?> onUsernameChanged;
  final ValueChanged<String?> onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final radii = context.radii;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasAvatar) ...[
          const SizedBox(height: 8),
          Opacity(
            opacity: isUploadingAvatar ? 0.5 : 1,
            child: IgnorePointer(
              ignoring: isUploadingAvatar,
              child: Center(
                child: ChipButton(
                  icon: Icons.delete_outline,
                  label: context.l10n.profileDeletePhoto,
                  borderRadius: radii.smallRadius,
                  textColor: colorScheme.error,
                  iconColor: colorScheme.error,
                  borderColor: colorScheme.error.withValues(alpha: 0.35),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  onPressed: onDeletePhoto,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ] else
          const SizedBox(height: 4),
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
    );
  }
}
