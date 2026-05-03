import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/passcode/presentation/widgets/passcode_settings_section.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/session_info.dart';

class PrivacySettingsContent extends StatelessWidget {
  const PrivacySettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final Session? session = authState is AuthAuthenticatedState
            ? authState.session
            : null;

        final l10n = context.l10n;

        if (session == null) {
          return Center(
            child: Text(
              l10n.sessionIsNotLoadedYet,
              style: context.textScheme.label.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PasscodeSettingsSection(),
              const SizedBox(height: 20),
              SessionInfo(session: session),
              const SizedBox(height: 16),
              SettingsGroupCard(
                title: l10n.aboutApp,
                children: const [SettingsAppVersionTile()],
              ),
            ],
          ),
        );
      },
    );
  }
}
