// profile_modal_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/presentation.dart';

class ProfileModalWrapper extends StatelessWidget {
  const ProfileModalWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProfileInteractor>(
      create: (context) => ProfileInteractor(
        userRepo: context.read<IUserRepo>(),
        logger: context.read<ILogger>(),
      ),
      child: BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          profileInteractor: context.read<ProfileInteractor>(),
          logger: context.read<ILogger>(),
        )..loadUserData(),
        child: child,
      ),
    );
  }
}

class ProfileModalCard extends StatelessWidget {
  const ProfileModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return ProfileModalWrapper(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420,
              maxHeight: MediaQuery.of(context).size.height - 48,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (BuildContext context, ProfileState state) {
                      switch (state) {
                        case ProfileInitialState():
                        case ProfileLoadingState():
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Loading profile...',
                                    style: textScheme.headline.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        case ProfileFailureState():
                          return InfoWidget(
                            icon: Icons.error,
                            text: state.failure.toString(),
                            iconAnimationEffect: const ShakeEffect(),
                          );
                        case ProfileLoadedState():
                          return _ProfileView(profileState: state);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.profileState});

  final ProfileLoadedState profileState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final User user = profileState.user;

    final TextStyle sectionTitleStyle = textScheme.label.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(user: user),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileMainInfo(user: user),
                const SizedBox(height: 24),
                Text(l10n.accountStatus, style: sectionTitleStyle),
                const SizedBox(height: 8),
                Text(
                  '${l10n.language}: ${user.languageCode}',
                  style: context.textScheme.label.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
