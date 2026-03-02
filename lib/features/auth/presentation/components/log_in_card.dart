import 'package:flutter/gestures.dart';
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
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final logInCubit = context.read<LogInCubit>();
    final isLoading = context.watch<AuthCubit>().state is AuthLoadingState;

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.authorization, style: textScheme.display),
          const SizedBox(height: 32),
          CustomTextField(
            isActive: !isLoading,
            controller: usernameController,
            backgroundColor: colorScheme.surfaceContainerLow,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            labelText: l10n.login,
            onSubmitted: (String? value) {
              logInCubit.updateUsername(updatedUsername: value);
            },
            onChanged: (String? value) {
              logInCubit.updateUsername(updatedUsername: value);
            },
            onFocusChange: (String? value) {
              logInCubit.updateUsername(updatedUsername: value);
            },
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
            backgroundColor: colorScheme.surfaceContainerLow,
            obscureText: true,
            textInputAction: TextInputAction.done,
            labelText: l10n.password,
            onSubmitted: (String? value) {
              logInCubit.updatePassword(updatedPassword: value);
            },
            onChanged: (String? value) {
              logInCubit.updatePassword(updatedPassword: value);
            },
            onFocusChange: (String? value) {
              logInCubit.updatePassword(updatedPassword: value);
            },
            errorText: logInCubit.state.passwordException != null
                ? AuthExceptionsTranslator.translate(
                    context,
                    logInCubit.state.passwordException,
                  )
                : null,
          ),
          const SizedBox(height: 24),
          AppPrimaryButton(
            text: l10n.signIn,
            onPressed: () {
              final logInState = context.read<LogInCubit>().state;

              context.read<AuthCubit>().logIn(
                username: logInState.username!,
                password: logInState.password!,
              );
            },
            isLoading: isLoading,
            isActive: context.watch<LogInCubit>().canLogIn(),
          ),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: textScheme.headline.copyWith(
                color: colorScheme.onSurface.withAlpha(179),
              ),
              children: [
                TextSpan(
                  text: '${l10n.notRegisteredYetQuestion} ',
                  style: textScheme.label.copyWith(fontSize: 18),
                ),
                TextSpan(
                  text: l10n.registration,
                  style: textScheme.label.copyWith(
                    fontSize: 18,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      GoRouter.of(context).go(AppRoutes.registration);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
