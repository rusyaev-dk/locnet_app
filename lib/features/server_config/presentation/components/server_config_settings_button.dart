import 'package:flutter/material.dart';
import 'package:locnet_app/features/server_config/presentation/components/server_config_dialog.dart';
import 'package:locnet_app/gen/gen.dart';

class ServerConfigSettingsButton extends StatelessWidget {
  const ServerConfigSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      tooltip: S.of(context).serverSettings,
      onPressed: () => showServerConfigDialog(context),
    );
  }
}
