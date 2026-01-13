import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiToastListener(
      listeners: [
        ToastListener<AuthCubit, AuthState, AuthFailureState>(
          bloc: context.read<AuthCubit>(),
          messageOf: (context, AuthFailureState state) =>
              AppExceptionsTranslator.translate(
                context,
                state.failure,
                fallback: "Auth error",
              ),
        ),
        ToastListener<SettingsCubit, SettingsState, SettingsState>(
          bloc: context.read<SettingsCubit>(),
          messageOf: (context, SettingsState state) =>
              AppExceptionsTranslator.translate(context, state.failure),
        ),
      ],
      child: child,
    );
  }
}
