import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/components/settings_value_tile.dart';

/// Build / package version row for the About block in settings.
class SettingsAppVersionTile extends StatelessWidget {
  const SettingsAppVersionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final String? version = dotenv.env['VERSION'];
    final String display =
        version?.trim().isNotEmpty == true ? version!.trim() : context.l10n.appVersionUnknown;

    return SettingsValueTile(
      label: context.l10n.settingsAppVersionTitle,
      value: display,
      leadingIcon: Icons.info_outline,
    );
  }
}
