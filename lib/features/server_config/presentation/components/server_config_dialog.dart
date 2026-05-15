import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/server_config/domain/domain.dart';
import 'package:locnet_app/features/server_config/presentation/blocs/server_config_cubit/server_config_cubit.dart';
import 'package:locnet_app/features/server_config/presentation/blocs/server_config_cubit/server_config_state.dart';
import 'package:locnet_app/features/server_config/presentation/utils/server_config_validator.dart';
import 'package:locnet_app/gen/gen.dart';
import 'package:locnet_app/uikit/uikit.dart';

Future<void> showServerConfigDialog(BuildContext context) async {
  await context.read<ServerConfigCubit>().load();
  if (!context.mounted) return;

  final formKey = GlobalKey<_ServerConfigDialogBodyState>();

  await showAppAlertDialog<void>(
    context: context,
    title: Text(S.of(context).serverSettings),
    content: BlocProvider.value(
      value: context.read<ServerConfigCubit>(),
      child: _ServerConfigDialogBody(key: formKey),
    ),
    buildActions: (dialogContext) => [
      AppAlertDialogAction(
        onPressed: () => Navigator.of(dialogContext).pop(),
        child: Text(S.of(dialogContext).cancel),
      ),
      AppAlertDialogAction(
        onPressed: () => formKey.currentState?._onReset(),
        child: Text(S.of(dialogContext).serverSettingsReset),
      ),
      AppAlertDialogAction(
        isDefaultAction: true,
        onPressed: () => formKey.currentState?._onSave(),
        child: Text(S.of(dialogContext).serverSettingsSave),
      ),
    ],
  );
}

class _ServerConfigDialogBody extends StatefulWidget {
  const _ServerConfigDialogBody({super.key});

  @override
  State<_ServerConfigDialogBody> createState() =>
      _ServerConfigDialogBodyState();
}

class _ServerConfigDialogBodyState extends State<_ServerConfigDialogBody> {
  late final TextEditingController _baseUrlController;
  late final TextEditingController _socketUrlController;

  @override
  void initState() {
    super.initState();
    final config = _configFromState(context.read<ServerConfigCubit>().state);
    _baseUrlController = TextEditingController(text: config?.baseUrl ?? '');
    _socketUrlController =
        TextEditingController(text: config?.socketBaseUrl ?? '');
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _socketUrlController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final error = ServerConfigValidator.validate(
      baseUrl: _baseUrlController.text,
      socketUrl: _socketUrlController.text,
    );
    if (error != null) {
      ToastManager.show(
        context,
        message: S.of(context).serverSettingsInvalidUrl,
      );
      return;
    }

    await context.read<ServerConfigCubit>().save(
          baseUrl: _baseUrlController.text,
          socketBaseUrl: _socketUrlController.text,
        );
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _onReset() async {
    final cubit = context.read<ServerConfigCubit>();
    await cubit.resetToDefaults();
    if (!mounted) return;

    final state = cubit.state;
    if (state is ServerConfigLoadedState) {
      _baseUrlController.text = state.config.baseUrl;
      _socketUrlController.text = state.config.socketBaseUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: _baseUrlController,
          labelText: S.of(context).serverBaseUrl,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _socketUrlController,
          labelText: S.of(context).serverSocketUrl,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

ServerConfig? _configFromState(ServerConfigState state) {
  return switch (state) {
    ServerConfigLoadedState(:final config) => config,
    ServerConfigSavingState(:final config) => config,
    _ => null,
  };
}
