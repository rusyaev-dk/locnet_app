import 'package:flutter/material.dart';
import 'package:locnet_app/app/app_context_ext.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "${l10n.loading}...",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.02,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
