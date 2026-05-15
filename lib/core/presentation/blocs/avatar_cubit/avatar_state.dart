part of 'avatar_cubit.dart';

sealed class AvatarState extends Equatable {
  const AvatarState();
}

final class AvatarInitialState extends AvatarState {
  const AvatarInitialState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class AvatarLoadingState extends AvatarState {
  const AvatarLoadingState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class AvatarLoadedState extends AvatarState {
  const AvatarLoadedState({required this.url});

  final String url;

  @override
  List<Object?> get props => <Object?>[url];
}

final class AvatarEmptyState extends AvatarState {
  const AvatarEmptyState();

  @override
  List<Object?> get props => const <Object?>[];
}
