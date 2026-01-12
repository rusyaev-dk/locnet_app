import 'package:flutter/gestures.dart';
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
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final isLoading = context.read<AuthCubit>().state is AuthLoadingState;

    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (BuildContext context, RegistrationState state) {
        final RegistrationCubit registrationCubit = context
            .read<RegistrationCubit>();

        return Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: <BoxShadow>[
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
            children: <Widget>[
              Text(l10n.registration, style: textScheme.display),
              const SizedBox(height: 32),
              CustomTextField(
                isActive: !isLoading,
                controller: firstNameController,
                labelText: l10n.firstName,
                textInputAction: TextInputAction.next,
                onChanged: (String? value) {
                  registrationCubit.updateFirstName(newFirstName: value);
                },
                onFocusChange: (String? value) {
                  registrationCubit.updateFirstName(newFirstName: value);
                },
                errorText: registrationCubit.state.firstNameException != null
                    ? AppExceptionsTranslator.translate(
                        context,
                        registrationCubit.state.firstNameException,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isActive: !isLoading,
                controller: lastNameController,
                labelText: l10n.lastName,
                textInputAction: TextInputAction.next,
                onChanged: (String? value) {
                  registrationCubit.updateLastName(newLastName: value);
                },
                onFocusChange: (String? value) {
                  registrationCubit.updateLastName(newLastName: value);
                },
                errorText: registrationCubit.state.lastNameException != null
                    ? AppExceptionsTranslator.translate(
                        context,
                        registrationCubit.state.lastNameException,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isActive: !isLoading,
                controller: descriptionController,
                labelText: l10n.description,
                textInputAction: TextInputAction.next,
                onChanged: (String? value) {
                  registrationCubit.updateDescription(
                    newUserDescription: value,
                  );
                },
                onFocusChange: (String? value) {
                  registrationCubit.updateDescription(
                    newUserDescription: value,
                  );
                },
                errorText: registrationCubit.state.descriptionException != null
                    ? AppExceptionsTranslator.translate(
                        context,
                        registrationCubit.state.descriptionException,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isActive: !isLoading,
                controller: usernameController,
                labelText: l10n.login,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (String? value) {
                  registrationCubit.updateUsername(newUsername: value);
                },
                onFocusChange: (String? value) {
                  registrationCubit.updateUsername(newUsername: value);
                },
                errorText: registrationCubit.state.usernameException != null
                    ? AppExceptionsTranslator.translate(
                        context,
                        registrationCubit.state.usernameException,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isActive: !isLoading,
                controller: passwordController,
                labelText: l10n.password,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onChanged: (String? value) {
                  registrationCubit.updatePassword(newPassword: value);
                },
                onFocusChange: (String? value) {
                  registrationCubit.updatePassword(newPassword: value);
                },
                errorText: registrationCubit.state.passwordException != null
                    ? AppExceptionsTranslator.translate(
                        context,
                        registrationCubit.state.passwordException,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isActive: !isLoading,
                controller: repeatPasswordController,
                labelText: l10n.repeatPassword,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onChanged: (String? value) {
                  registrationCubit.updateRepeatPassword(
                    newRepeatPassword: value,
                  );
                },
                onFocusChange: (String? value) {
                  registrationCubit.updateRepeatPassword(
                    newRepeatPassword: value,
                  );
                },
                errorText:
                    registrationCubit.state.repeatPasswordException != null
                    ? AppExceptionsTranslator.translate(
                        context,
                        registrationCubit.state.repeatPasswordException,
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                text: l10n.registration,
                onPressed: () {
                  final regState = context.read<RegistrationCubit>().state;

                  context.read<AuthCubit>().register(
                    firstName: regState.firstName!,
                    lastName: regState.lastName!,
                    username: regState.username!,
                    password: regState.password!,
                    description: regState.description,
                  );
                },
                isLoading: isLoading,
                isActive: context.watch<RegistrationCubit>().canRegister(),
              ),
              const SizedBox(height: 32),
              RichText(
                text: TextSpan(
                  style: textScheme.headline.copyWith(
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${l10n.alreadyRegisteredQuestion} ',
                      style: textScheme.label.copyWith(fontSize: 18),
                    ),
                    TextSpan(
                      text: l10n.signIn,
                      style: textScheme.label.copyWith(
                        fontSize: 18,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context).go(AppRoutes.login);
                        },
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
