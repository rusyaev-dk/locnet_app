part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState({required this.failure});

  final Object? failure;
}

final class ProfileInitialState extends ProfileState {
  const ProfileInitialState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState({required this.user, super.failure});

  final User user;

  @override
  List<Object?> get props => [user, failure];
}

final class ProfileFailureState extends ProfileState {
  const ProfileFailureState({required super.failure});

  @override
  List<Object?> get props => [failure];
}
