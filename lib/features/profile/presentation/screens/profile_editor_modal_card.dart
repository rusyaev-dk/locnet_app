import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ProfileEditorModalWrapper extends StatelessWidget {
  const ProfileEditorModalWrapper({
    required this.child,
    required this.profileEditorCubit,
    super.key,
  });

  final Widget child;
  final ProfileEditorCubit profileEditorCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: profileEditorCubit, child: child);
  }
}

class ProfileEditorModalCard extends StatefulWidget {
  const ProfileEditorModalCard({
    required this.initialUser,
    required this.profileEditorCubit,
    super.key,
  });

  final User initialUser;
  final ProfileEditorCubit profileEditorCubit;

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
    final textScheme = context.textScheme;

    return ProfileEditorModalWrapper(
      profileEditorCubit: widget.profileEditorCubit,
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
                      switch (state) {
                        case ProfileEditorInitialState():
                        case ProfileEditorLoadingState():
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Loading profile...',
                                    style: textScheme.headline.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        case ProfileEditorFailureState():
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: InfoWidget(
                              icon: Icons.error,
                              text: state.failure.toString(),
                              iconAnimationEffect: const ShakeEffect(),
                            ),
                          );
                        case ProfileEditorLoadedState():
                          return _ProfileEditorLoadedView(
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            usernameController: _usernameController,
                            isPending: false,
                          );
                        case ProfileEditorPendingState():
                          return _ProfileEditorLoadedView(
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            usernameController: _usernameController,
                            isPending: true,
                          );
                        case ProfileEditorSuccessState():
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'Profile update state...',
                                style: textScheme.headline.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          );
                      }
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

class _ProfileEditorLoadedView extends StatelessWidget {
  const _ProfileEditorLoadedView({
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.isPending,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final ProfileEditorCubit editorCubit = context.read<ProfileEditorCubit>();

    final state = editorCubit.state as ProfileEditorLoadedState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileEditorHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  isActive: !isPending,
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
                  errorText: state.firstNameException != null
                      ? AppExceptionsTranslator.translate(
                          context,
                          state.firstNameException,
                        )
                      : null,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  isActive: !isPending,
                  controller: lastNameController,
                  labelText: l10n.lastName,
                  textInputAction: TextInputAction.done,
                  onChanged: (String? value) {
                    editorCubit.updateLastName(newLastName: value);
                  },
                  onFocusChange: (String? value) {
                    editorCubit.updateLastName(newLastName: value);
                  },
                  onSubmitted: (String? value) {
                    editorCubit.updateLastName(newLastName: value);
                  },
                  errorText: state.lastNameException != null
                      ? AppExceptionsTranslator.translate(
                          context,
                          state.lastNameException,
                        )
                      : null,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  isActive: !isPending,
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
                  errorText: state.usernameException != null
                      ? AppExceptionsTranslator.translate(
                          context,
                          state.usernameException,
                        )
                      : null,
                ),
                const SizedBox(height: 15),
                AppPrimaryButton(
                  width: double.infinity,
                  text: l10n.apply,
                  onPressed: () =>
                      context.read<ProfileEditorCubit>().applyUpdates(),
                  isActive: context.watch<ProfileEditorCubit>().canApplyUpdates(),
                  isLoading: isPending,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
