import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileEditorModalWrapper extends StatelessWidget {
  const ProfileEditorModalWrapper({
    required this.child,
    required this.profileInteractor,
    super.key,
  });

  final Widget child;
  final ProfileInteractor profileInteractor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileEditorCubit>(
      create: (context) => ProfileEditorCubit(
        profileInteractor: profileInteractor,
        logger: context.read<ILogger>(),
      )..loadUserData(),
      child: child,
    );
  }
}

class ProfileEditorModalCard extends StatefulWidget {
  const ProfileEditorModalCard({required this.initialUser, super.key});

  final User initialUser;

  @override
  State<ProfileEditorModalCard> createState() => _ProfileEditorModalCardState();
}

class _ProfileEditorModalCardState extends State<ProfileEditorModalCard> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();

    final String resolvedFirstName = widget.initialUser.firstName;
    final String resolvedLastName = widget.initialUser.lastName;

    if (_firstNameController.text != resolvedFirstName) {
      _firstNameController.text = resolvedFirstName;
      _firstNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _firstNameController.text.length),
      );
    }

    if (_lastNameController.text != resolvedLastName) {
      _lastNameController.text = resolvedLastName;
      _lastNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _lastNameController.text.length),
      );
    }

    _usernameController.text = widget.initialUser.username;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BlocListener<ProfileEditorCubit, ProfileEditorState>(
      listener: (context, state) {
        if (state is ProfileEditorSuccessState) {
          Navigator.of(context).pop(true);
        }
      },
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420,
              maxHeight: MediaQuery.of(context).size.height - 48,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: BlocBuilder<ProfileEditorCubit, ProfileEditorState>(
                    builder: (BuildContext context, ProfileEditorState state) {
                      if (state is ProfileEditorFailureState) {
                        return InfoWidget(
                          icon: Icons.error,
                          text: state.failure.toString(),
                          iconAnimationEffect: const ShakeEffect(),
                        );
                      }

                      final bool isLoading =
                          state is ProfileEditorInitialState ||
                          state is ProfileEditorLoadingState;

                      final ProfileEditorLoadedState? loadedState =
                          state is ProfileEditorLoadedState ? state : null;

                      return _ProfileEditorView(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        usernameController: _usernameController,
                        isLoading: isLoading,
                        loadedState: loadedState,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileEditorView extends StatelessWidget {
  const _ProfileEditorView({
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.isLoading,
    required this.loadedState,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final bool isLoading;
  final ProfileEditorLoadedState? loadedState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final ProfileEditorCubit editorCubit = context.read<ProfileEditorCubit>();

    final bool isSubmitting = loadedState?.isSubmitting ?? false;
    final bool isBusy = isLoading || isSubmitting;

    final Object? firstNameException = loadedState?.firstNameException;
    final Object? lastNameException = loadedState?.lastNameException;
    final Object? usernameException = loadedState?.usernameException;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileEditorHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        if (isLoading)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading profile...',
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  AppTextField(
                    isActive: !isBusy,
                    controller: firstNameController,
                    labelText: l10n.firstName,
                    textInputAction: TextInputAction.next,
                    onChanged: (String? value) {
                      editorCubit.updateFirstName(newFirstName: value);
                    },
                    onFocusChange: (String? value) {
                      editorCubit.updateFirstName(newFirstName: value);
                    },
                    onSubmitted: (String? value) {
                      editorCubit.updateFirstName(newFirstName: value);
                    },
                    errorText: firstNameException != null
                        ? AppExceptionsTranslator.translate(
                            context,
                            firstNameException,
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    isActive: !isBusy,
                    controller: lastNameController,
                    labelText: l10n.lastName,
                    textInputAction: TextInputAction.next,
                    onChanged: (String? value) {
                      editorCubit.updateLastName(newLastName: value);
                    },
                    onFocusChange: (String? value) {
                      editorCubit.updateLastName(newLastName: value);
                    },
                    onSubmitted: (String? value) {
                      editorCubit.updateLastName(newLastName: value);
                    },
                    errorText: lastNameException != null
                        ? AppExceptionsTranslator.translate(
                            context,
                            lastNameException,
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    isActive: !isBusy,
                    controller: usernameController,
                    labelText: l10n.username,
                    textInputAction: TextInputAction.done,
                    onChanged: (String? value) {
                      editorCubit.updateUsername(newUsername: value);
                    },
                    onFocusChange: (String? value) {
                      editorCubit.updateUsername(newUsername: value);
                    },
                    onSubmitted: (String? value) {
                      editorCubit.updateUsername(newUsername: value);
                    },
                    errorText: usernameException != null
                        ? AppExceptionsTranslator.translate(
                            context,
                            usernameException,
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  _ProfileEditorApplyButton(isPending: isSubmitting),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileEditorApplyButton extends StatelessWidget {
  const _ProfileEditorApplyButton({required this.isPending});

  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocSelector<ProfileEditorCubit, ProfileEditorState, bool>(
      selector: (ProfileEditorState state) {
        final ProfileEditorCubit cubit = context.read<ProfileEditorCubit>();
        return cubit.canApplyUpdates();
      },
      builder: (BuildContext context, bool canApplyUpdates) {
        return AppPrimaryButton(
          width: double.infinity,
          text: l10n.apply,
          onPressed: () => context.read<ProfileEditorCubit>().applyUpdates(),
          isActive: canApplyUpdates && !isPending,
          isLoading: isPending,
        );
      },
    );
  }
}
