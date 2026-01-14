import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';

class RegistrationScreenWrapper extends StatelessWidget {
  const RegistrationScreenWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationCubit>(
      create: (BuildContext context) =>
          RegistrationCubit(logger: context.read<ILogger>()),
      child: child,
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _jobPositionController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPasswordController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _jobPositionController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _jobPositionController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: SafeArea(
        child: MultiToastListener(
          listeners: [
            ToastListener<AuthCubit, AuthState, AuthFailureState>(
              bloc: context.read<AuthCubit>(),
              messageOf: (context, AuthFailureState state) =>
                  AuthExceptionsTranslator.translate(context, state.failure),
            ),
            ToastListener<
              RegistrationCubit,
              RegistrationState,
              RegistrationState
            >(
              bloc: context.read<RegistrationCubit>(),
              messageOf: (context, RegistrationState state) =>
                  AuthExceptionsTranslator.translate(context, state.failure),
            ),
          ],
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (BuildContext context, AuthState state) {
              if (state is AuthAuthenticatedState) {
                return const SizedBox.shrink();
              }

              return _RegistrationScrollableForm(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                jobPositionController: _jobPositionController,
                loginController: _usernameController,
                passwordController: _passwordController,
                repeatPasswordController: _repeatPasswordController,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RegistrationScrollableForm extends StatelessWidget {
  const _RegistrationScrollableForm({
    required this.firstNameController,
    required this.lastNameController,
    required this.jobPositionController,
    required this.loginController,
    required this.passwordController,
    required this.repeatPasswordController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController jobPositionController;
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final TextEditingController repeatPasswordController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 64),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 960 : 480),
                child: isWide
                    ? Row(
                        children: <Widget>[
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: LocNetBranding(),
                            ),
                          ),
                          const SizedBox(width: 48),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.topRight,
                                  child: LanguageSwitcherButton(),
                                ),
                                const SizedBox(height: 24),
                                RegistrationCard(
                                  firstNameController: firstNameController,
                                  lastNameController: lastNameController,
                                  descriptionController: jobPositionController,
                                  usernameController: loginController,
                                  passwordController: passwordController,
                                  repeatPasswordController:
                                      repeatPasswordController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.topRight,
                            child: LanguageSwitcherButton(),
                          ),
                          const SizedBox(height: 24),
                          const LocNetBranding(),
                          const SizedBox(height: 32),
                          RegistrationCard(
                            firstNameController: firstNameController,
                            lastNameController: lastNameController,
                            descriptionController: jobPositionController,
                            usernameController: loginController,
                            passwordController: passwordController,
                            repeatPasswordController: repeatPasswordController,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
