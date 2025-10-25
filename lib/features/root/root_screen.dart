import 'package:flutter/material.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiToastListener(
      listeners: [
        ToastListener<SettingsCubit, SettingsState, SettingsLoadedState>(
          bloc: context.read<SettingsCubit>(),
          messageOf: (SettingsLoadedState state) => state.message,
        ),
      ],
      child: child,
    );
  }
}
