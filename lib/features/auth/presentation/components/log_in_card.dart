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
    required this.loginController,
    required this.passwordController,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController loginController;
  final TextEditingController passwordController;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final loginCubit = context.read<LoginCubit>();

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
          TextField(
            controller: loginController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (String value) {
              loginCubit.updateLogin(newLogin: value);
            },
            decoration: InputDecoration(
              labelText: l10n.login,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              onSubmit();
            },
            onChanged: (String value) {
              loginCubit.updatePassword(newPassword: value);
            },
            decoration: InputDecoration(
              labelText: l10n.password,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppPrimaryButton(
            text: l10n.signIn,
            onPressed: onSubmit,
            isLoading: context.read<AuthCubit>().state is AuthLoadingState,
            isActive: context.watch<LoginCubit>().canLogIn(),
          ),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: textScheme.headline.copyWith(
                color: colorScheme.onSurface.withAlpha(179),
              ),
              children: [
                TextSpan(
                  text: '${l10n.registrationQuestion} ',
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
