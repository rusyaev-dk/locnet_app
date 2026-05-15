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
  const AuthAuthenticatedState({
    required this.user,
    required this.session,
    super.failure,
  });

  final User user;
  final Session session;

  AuthAuthenticatedState copyWith({
    User? user,
    Session? session,
    Object? failure,
  }) {
    return AuthAuthenticatedState(
      user: user ?? this.user,
      session: session ?? this.session,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    user,
    session,
    failure,
  ];
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
