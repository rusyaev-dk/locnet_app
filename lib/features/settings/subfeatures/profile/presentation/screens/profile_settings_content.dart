import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/screens/screens.dart';

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
        return (previous.isEditing != current.isEditing) ||
            (!current.isEditing && previous.user != current.user);
      },
      listener: (context, state) {
        _syncControllersFromState(state);
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

        // Auto-start editing so form is always shown
        if (!state.isEditing && !state.isSubmitting) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<ProfileEditorCubit>().startEditing();
            }
          });
        }

        return ProfileSettingsView(
          user: loadedUser,
          isEditing: state.isEditing,
          isSubmitting: state.isSubmitting,
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
            context.read<ProfileEditorCubit>().startEditing();
          },
          onCancelEdit: () {
            context.read<ProfileEditorCubit>().cancelEditing();
          },
          onSave: () {
            context.read<ProfileEditorCubit>().submitChanges();
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
