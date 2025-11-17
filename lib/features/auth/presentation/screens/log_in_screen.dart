import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';

class LogInScreenWrapper extends StatelessWidget {
  const LogInScreenWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(logger: context.read<ILogger>()),
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
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final String login = _loginController.text.trim();
    final String password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      return;
    }

    await context.read<AuthCubit>().login(login: login, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: SafeArea(
        child: ToastListener<AuthCubit, AuthState, AuthFailureState>(
          bloc: context.read<AuthCubit>(),
          messageOf: (context, AuthFailureState state) =>
              AppExceptionsTranslator.translate(context, state.failure),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (BuildContext context, AuthState state) {
              switch (state) {
                case AuthLoadingState():
                  return const Center(child: CircularProgressIndicator());

                case AuthInitialState():
                  return _AuthScrollableForm(
                    loginController: _loginController,
                    passwordController: _passwordController,
                    onSubmit: _onSubmit,
                  );

                case AuthUnauthenticatedState():
                  return _AuthScrollableForm(
                    loginController: _loginController,
                    passwordController: _passwordController,
                    onSubmit: _onSubmit,
                  );

                case AuthFailureState():
                  return _AuthScrollableForm(
                    loginController: _loginController,
                    passwordController: _passwordController,
                    onSubmit: _onSubmit,
                  );

                case AuthAuthenticatedState():
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _AuthScrollableForm extends StatelessWidget {
  const _AuthScrollableForm({
    required this.loginController,
    required this.passwordController,
    required this.onSubmit,
  });

  final TextEditingController loginController;
  final TextEditingController passwordController;
  final Future<void> Function() onSubmit;

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
                        children: [
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
                              children: [
                                const Align(
                                  alignment: Alignment.topRight,
                                  child: LanguageSwitcherButton(),
                                ),
                                const SizedBox(height: 24),
                                LogInCard(
                                  loginController: loginController,
                                  passwordController: passwordController,
                                  onSubmit: onSubmit,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: LanguageSwitcherButton(),
                          ),
                          const SizedBox(height: 24),
                          const LocNetBranding(),
                          const SizedBox(height: 32),
                          LogInCard(
                            loginController: loginController,
                            passwordController: passwordController,
                            onSubmit: onSubmit,
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
