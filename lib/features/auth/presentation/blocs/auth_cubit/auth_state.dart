part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState({this.failure});

  final Object? failure;
}

final class AuthInitialState extends AuthState {
  const AuthInitialState({ super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class AuthLoadingState extends AuthState {
  const AuthLoadingState({ super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class AuthAuthenticatedState extends AuthState {
  const AuthAuthenticatedState({required this.user, super.failure});

  final User user;

  AuthAuthenticatedState copyWith({User? user, Object? failure}) {
    return AuthAuthenticatedState(user: user ?? this.user, failure: failure);
  }

  @override
  List<Object?> get props => <Object?>[user, failure];
}

final class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState({ super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class AuthFailureState extends AuthState {
  const AuthFailureState({required super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}
