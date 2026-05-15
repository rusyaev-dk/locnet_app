import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/server_config/presentation/presentation.dart';

class LogInScreenWrapper extends StatelessWidget {
  const LogInScreenWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInCubit(logger: context.read<ILogger>()),
      child: child,
    );
  }
}

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: MultiToastListener(
              listeners: [
                ToastListener<AuthCubit, AuthState, AuthFailureState>(
                  bloc: context.read<AuthCubit>(),
                  messageOf: (context, AuthFailureState state) =>
                      AuthExceptionsTranslator.translate(
                        context,
                        state.failure,
                      ),
                ),
                ToastListener<LogInCubit, LogInState, LogInState>(
                  bloc: context.read<LogInCubit>(),
                  messageOf: (context, LogInState state) =>
                      AuthExceptionsTranslator.translate(
                        context,
                        state.failure,
                      ),
                ),
              ],
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (BuildContext context, AuthState state) {
                  if (state is AuthAuthenticatedState) {
                    return const SizedBox.shrink();
                  }

                  return _AuthScrollableForm(
                    loginController: _usernameController,
                    passwordController: _passwordController,
                  );
                },
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            child: SafeArea(child: ServerConfigSettingsButton()),
          ),
        ],
      ),
    );
  }
}

class _AuthScrollableForm extends StatelessWidget {
  const _AuthScrollableForm({
    required this.loginController,
    required this.passwordController,
  });

  final TextEditingController loginController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: LanguageSwitcherButton(),
                      ),
                    ),
                    LogInCard(
                      usernameController: loginController,
                      passwordController: passwordController,
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
