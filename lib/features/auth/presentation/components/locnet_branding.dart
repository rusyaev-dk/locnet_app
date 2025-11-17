import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class LocNetBranding extends StatelessWidget {
  const LocNetBranding({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Text(
      'LocNet',
      style: textScheme.display.copyWith(
        color: colorScheme.onPrimaryContainer,
        letterSpacing: 2,
      ),
    );
  }
}
