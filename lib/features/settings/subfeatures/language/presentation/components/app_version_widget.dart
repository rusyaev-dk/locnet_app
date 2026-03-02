import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:locnet_app/app/app.dart';

/// Displays app version from env (e.g. VERSION).
class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final String? version = dotenv.env['VERSION'];
    final String displayVersion = version ?? 'Unknown';

    return Center(
      child: Text(
        'Version $displayVersion',
        style: textScheme.label.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
    );
  }
}
