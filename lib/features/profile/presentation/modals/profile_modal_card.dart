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
    return ProfileModalWrapper(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          final textScheme = context.textScheme;
          final colorScheme = context.colorScheme;

          switch (state) {
            case ProfileInitialState():
            case ProfileLoadingState():
              return AppModalCard(
                child: Padding(
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
                ),
              );

            case ProfileFailureState():
              return AppModalCard(
                child: InfoWidget(
                  icon: Icons.error,
                  text: state.failure.toString(),
                  iconAnimationEffect: const ShakeEffect(),
                ),
              );

            case ProfileLoadedState():
              return _ProfileView(profileState: state);
          }
        },
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
    final User user = profileState.user;

    return AppModalCard(
      child: Container(
        color: colorScheme.secondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: ProfileHeader(user: user, popsOnClose: 2),
            ),
            Expanded(child: ProfileBodyContent(user: user)),
          ],
        ),
      ),
    );
  }
}
