import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';

class SessionModalCard extends StatelessWidget {
  const SessionModalCard({required this.session, super.key});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 420,
            maxHeight: MediaQuery.of(context).size.height - 48,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SessionModalHeader(
                      onClosePressed: () => Navigator.of(context).pop(),
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: SessionInfo(session: session),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SessionModalHeader extends StatelessWidget {
  const SessionModalHeader({required this.onClosePressed, super.key});

  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.sessionDetails,
              style: textScheme.headline.copyWith(color: colorScheme.onSurface),
            ),
          ),
          IconButton(
            onPressed: onClosePressed,
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
