import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class LogInCard extends StatelessWidget {
  const LogInCard({
    required this.usernameController,
    required this.passwordController,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final logInCubit = context.read<LogInCubit>();
    final isLoading = context.watch<AuthCubit>().state is AuthLoadingState;

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
          // ── Branding header ──────────────────────────────────────────
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
                  child: const Icon(Icons.lock, color: Colors.white, size: 20),
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
            child: _AuthTabSwitcher(isSignIn: true),
          ),

          // ── Form fields ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  isActive: !isLoading,
                  controller: usernameController,
                  labelText: l10n.login,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (v) =>
                      logInCubit.updateUsername(updatedUsername: v),
                  onChanged: (v) =>
                      logInCubit.updateUsername(updatedUsername: v),
                  onFocusChange: (v) =>
                      logInCubit.updateUsername(updatedUsername: v),
                  errorText: logInCubit.state.usernameException != null
                      ? AuthExceptionsTranslator.translate(
                          context,
                          logInCubit.state.usernameException,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  isActive: !isLoading,
                  controller: passwordController,
                  labelText: l10n.password,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (v) =>
                      logInCubit.updatePassword(updatedPassword: v),
                  onChanged: (v) =>
                      logInCubit.updatePassword(updatedPassword: v),
                  onFocusChange: (v) =>
                      logInCubit.updatePassword(updatedPassword: v),
                  errorText: logInCubit.state.passwordException != null
                      ? AuthExceptionsTranslator.translate(
                          context,
                          logInCubit.state.passwordException,
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.forgotPassword,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppPrimaryButton(
                  text: l10n.signIn,
                  onPressed: () {
                    final s = context.read<LogInCubit>().state;
                    context.read<AuthCubit>().logIn(
                      username: s.username!,
                      password: s.password!,
                    );
                  },
                  isLoading: isLoading,
                  isActive: context.watch<LogInCubit>().canLogIn(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

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
