import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class RegistrationCard extends StatelessWidget {
  const RegistrationCard({
    required this.firstNameController,
    required this.lastNameController,
    required this.descriptionController,
    required this.usernameController,
    required this.passwordController,
    required this.repeatPasswordController,
    super.key,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController descriptionController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController repeatPasswordController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final isLoading = context.read<AuthCubit>().state is AuthLoadingState;

    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (BuildContext context, RegistrationState state) {
        final RegistrationCubit reg = context.read<RegistrationCubit>();

        return Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Branding header ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.appName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _AuthTabSwitcher(isSignIn: false),
              ),

              // ── Form fields ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name + Last Name side by side
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _AuthFieldLabel(
                                label: l10n.firstName.toUpperCase(),
                              ),
                              const SizedBox(height: 6),
                              CustomTextField(
                                isActive: !isLoading,
                                controller: firstNameController,
                                textInputAction: TextInputAction.next,
                                onChanged: (v) =>
                                    reg.updateFirstName(newFirstName: v),
                                onFocusChange: (v) =>
                                    reg.updateFirstName(newFirstName: v),
                                errorText: reg.state.firstNameException != null
                                    ? AuthExceptionsTranslator.translate(
                                        context,
                                        reg.state.firstNameException,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _AuthFieldLabel(
                                label: l10n.lastName.toUpperCase(),
                              ),
                              const SizedBox(height: 6),
                              CustomTextField(
                                isActive: !isLoading,
                                controller: lastNameController,
                                textInputAction: TextInputAction.next,
                                onChanged: (v) =>
                                    reg.updateLastName(newLastName: v),
                                onFocusChange: (v) =>
                                    reg.updateLastName(newLastName: v),
                                errorText: reg.state.lastNameException != null
                                    ? AuthExceptionsTranslator.translate(
                                        context,
                                        reg.state.lastNameException,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _AuthFieldLabel(label: l10n.description.toUpperCase()),
                    const SizedBox(height: 6),
                    CustomTextField(
                      isActive: !isLoading,
                      controller: descriptionController,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) =>
                          reg.updateDescription(newUserDescription: v),
                      onFocusChange: (v) =>
                          reg.updateDescription(newUserDescription: v),
                      errorText: reg.state.descriptionException != null
                          ? AuthExceptionsTranslator.translate(
                              context,
                              reg.state.descriptionException,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _AuthFieldLabel(label: l10n.username.toUpperCase()),
                    const SizedBox(height: 6),
                    CustomTextField(
                      isActive: !isLoading,
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) => reg.updateUsername(newUsername: v),
                      onFocusChange: (v) => reg.updateUsername(newUsername: v),
                      errorText: reg.state.usernameException != null
                          ? AuthExceptionsTranslator.translate(
                              context,
                              reg.state.usernameException,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _AuthFieldLabel(label: l10n.password.toUpperCase()),
                    const SizedBox(height: 6),
                    CustomTextField(
                      isActive: !isLoading,
                      controller: passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) => reg.updatePassword(newPassword: v),
                      onFocusChange: (v) => reg.updatePassword(newPassword: v),
                      errorText: reg.state.passwordException != null
                          ? AuthExceptionsTranslator.translate(
                              context,
                              reg.state.passwordException,
                            )
                          : null,
                    ),
                    // Password requirements hint
                    PasswordRequirementsHint(
                      password: state.password ?? '',
                      isActive: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    _AuthFieldLabel(label: l10n.repeatPassword.toUpperCase()),
                    const SizedBox(height: 6),
                    CustomTextField(
                      isActive: !isLoading,
                      controller: repeatPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onChanged: (v) =>
                          reg.updateRepeatPassword(newRepeatPassword: v),
                      onFocusChange: (v) =>
                          reg.updateRepeatPassword(newRepeatPassword: v),
                      errorText: reg.state.repeatPasswordException != null
                          ? AuthExceptionsTranslator.translate(
                              context,
                              reg.state.repeatPasswordException,
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AppPrimaryButton(
                      text: l10n.createAccount,
                      onPressed: () {
                        final s = context.read<RegistrationCubit>().state;
                        context.read<AuthCubit>().register(
                          firstName: s.firstName!,
                          lastName: s.lastName!,
                          username: s.username!,
                          password: s.password!,
                          description: s.description,
                        );
                      },
                      isLoading: isLoading,
                      isActive: context
                          .watch<RegistrationCubit>()
                          .canRegister(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Shared helpers (tab switcher, field label) ────────────────────────────────

class _AuthFieldLabel extends StatelessWidget {
  const _AuthFieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.8,
        height: 1.2,
      ),
    );
  }
}

class _AuthTabSwitcher extends StatelessWidget {
  const _AuthTabSwitcher({required this.isSignIn});
  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border.all(color: colorScheme.outline, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AuthTab(
              label: l10n.signIn,
              isSelected: isSignIn,
              onTap: () => GoRouter.of(context).go(AppRoutes.login),
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            child: _AuthTab(
              label: l10n.createAccount,
              isSelected: !isSignIn,
              onTap: () => GoRouter.of(context).go(AppRoutes.registration),
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
