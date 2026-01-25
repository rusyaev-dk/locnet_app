import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/presentation.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';

class SessionModalCard extends StatelessWidget {
  const SessionModalCard({required this.session, super.key});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SessionHeader(),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  SessionInfo(session: session),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
