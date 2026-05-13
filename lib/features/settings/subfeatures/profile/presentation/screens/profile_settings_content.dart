import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/screens/screens.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Profile section in Settings: compact profile view + inline editor.
class ProfileSettingsContent extends StatefulWidget {
  const ProfileSettingsContent({super.key});

  @override
  State<ProfileSettingsContent> createState() => _ProfileSettingsContentState();
}

class _ProfileSettingsContentState extends State<ProfileSettingsContent> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _syncControllersFromState(ProfileEditorState state) {
    _firstNameController.text = state.firstName ?? '';
    _lastNameController.text = state.lastName ?? '';
    _usernameController.text = state.username ?? '';
    _descriptionController.text = state.description ?? '';
  }

  /// Show the crop modal and, on confirmation, upload the cropped bytes.
  Future<void> _showCropModal(BuildContext context) async {
    final cubit = context.read<ProfileEditorCubit>();
    final Uint8List? bytes = cubit.pendingAvatarBytes;
    if (bytes == null) return;

    final Uint8List? cropped = await showGeneralDialog<Uint8List>(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: context.colorScheme.scrim.withValues(alpha: 0.45),
      transitionBuilder: slideFadeDialogTransition,
      pageBuilder: (BuildContext dialogContext, _, _) {
        return AppModalCard(
          maxWidth: 440,
          verticalInset: 80,
          child: AvatarCropModal(imageBytes: bytes),
        );
      },
    );

    if (!context.mounted) return;

    if (cropped != null) {
      await cubit.uploadAvatarBytes(croppedBytes: cropped);
    } else {
      cubit.cancelAvatarPick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final AuthAuthenticatedState? authState = context
        .select<AuthCubit, AuthAuthenticatedState?>((AuthCubit c) {
          final state = c.state;
          if (state is AuthAuthenticatedState) return state;
          return null;
        });
    final User? user = authState?.user;

    if (user == null) {
      return Center(
        child: Text(
          l10n.sessionIsNotLoadedYet,
          style: context.textScheme.label.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return BlocConsumer<ProfileEditorCubit, ProfileEditorState>(
      listenWhen: (previous, current) {
        final bool editingChanged = previous.isEditing != current.isEditing;
        final bool userChanged =
            !current.isEditing && previous.user != current.user;
        final bool pendingAvatarAppeared =
            !previous.hasPendingAvatar && current.hasPendingAvatar;
        return editingChanged || userChanged || pendingAvatarAppeared;
      },
      listener: (context, state) {
        if (!state.isEditing) {
          _syncControllersFromState(state);
        }
        if (state.hasPendingAvatar) {
          _showCropModal(context);
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final User? loadedUser = state.user;
        if (loadedUser == null) {
          return Center(
            child: Text(
              l10n.sessionIsNotLoadedYet,
              style: context.textScheme.label.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return ProfileSettingsView(
          user: loadedUser,
          isEditing: state.isEditing,
          isSubmitting: state.isSubmitting,
          isUploadingAvatar: state.isUploadingAvatar,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          usernameController: _usernameController,
          descriptionController: _descriptionController,
          firstNameError: state.firstNameException != null
              ? AuthExceptionsTranslator.translate(
                  context,
                  state.firstNameException,
                )
              : null,
          lastNameError: state.lastNameException != null
              ? AuthExceptionsTranslator.translate(
                  context,
                  state.lastNameException,
                )
              : null,
          usernameError: state.usernameException != null
              ? AuthExceptionsTranslator.translate(
                  context,
                  state.usernameException,
                )
              : null,
          screenError: state.failure != null
              ? AppExceptionsTranslator.translate(context, state.failure)
              : null,
          onStartEdit: () {
            final cubit = context.read<ProfileEditorCubit>()..startEditing();
            _syncControllersFromState(cubit.state);
          },
          onCancelEdit: () {
            context.read<ProfileEditorCubit>().cancelEditing();
          },
          onSave: () {
            context.read<ProfileEditorCubit>().submitChanges();
          },
          onChangePhoto: () {
            context.read<ProfileEditorCubit>().pickImageForAvatar();
          },
          onDeletePhoto: () async {
            final l10n = context.l10n;
            final bool? confirm = await showAppAlertDialog<bool>(
              context: context,
              title: Text(l10n.profileDeletePhotoTitle),
              content: Text(l10n.profileDeletePhotoBody),
              buildActions: (BuildContext dialogContext) => <AppAlertDialogAction>[
                AppAlertDialogAction(
                  child: Text(l10n.cancel),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                AppAlertDialogAction(
                  isDestructiveAction: true,
                  child: Text(l10n.delete),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
            if (!context.mounted || confirm != true) return;
            await context.read<ProfileEditorCubit>().deleteAvatar();
          },
          onFirstNameChanged: (value) {
            context.read<ProfileEditorCubit>().updateFirstName(value: value);
          },
          onLastNameChanged: (value) {
            context.read<ProfileEditorCubit>().updateLastName(value: value);
          },
          onUsernameChanged: (value) {
            context.read<ProfileEditorCubit>().updateUsername(value: value);
          },
          onDescriptionChanged: (value) {
            context.read<ProfileEditorCubit>().updateDescription(value: value);
          },
        );
      },
    );
  }
}
