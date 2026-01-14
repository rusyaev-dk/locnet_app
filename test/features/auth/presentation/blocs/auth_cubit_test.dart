import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/interactors/mock_auth_interactor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthInteractor mockAuthInteractor;
  late MockLogger mockLogger;

  late User user;
  late Session session;

  setUp(() {
    mockAuthInteractor = MockAuthInteractor();
    mockLogger = MockLogger();

    user = User(
      userId: 'user-id',
      username: 'john',
      firstName: 'John',
      lastName: 'Doe',
      languageCode: 'en',
      isDeleted: false,
      isBanned: false,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 2),
    );

    session = Session(
      sessionId: 'session-id',
      userId: 'user-id',
      refreshToken: 'refresh-token',
      accessToken: 'access-token',
      expiresAt: DateTime.utc(2030),
      isExpired: false,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 2),
    );
  });

  AuthCubit buildCubit() {
    return AuthCubit(authInteractor: mockAuthInteractor, logger: mockLogger);
  }

  group('AuthCubit', () {
    group('logIn', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [Loading, Authenticated] when interactor returns session and user',
        build: () {
          when(
            () => mockAuthInteractor.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => (session, user));

          return buildCubit();
        },
        act: (cubit) => cubit.logIn(username: 'john', password: '123'),
        expect: () => <AuthState>[
          const AuthLoadingState(),
          AuthAuthenticatedState(user: user),
        ],
        verify: (_) {
          verify(
            () => mockAuthInteractor.logIn(username: 'john', password: '123'),
          ).called(1);

          verify(() => mockLogger.info(any())).called(2);
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should not emit Loading twice when already in Loading state',
        build: () {
          when(
            () => mockAuthInteractor.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => (session, user));

          return buildCubit();
        },
        seed: () => const AuthLoadingState(),
        act: (cubit) => cubit.logIn(username: 'john', password: '123'),
        expect: () => <AuthState>[AuthAuthenticatedState(user: user)],
        verify: (_) {
          verify(
            () => mockAuthInteractor.logIn(username: 'john', password: '123'),
          ).called(1);

          verify(() => mockLogger.info(any())).called(2);
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit Failure with the same AppException when interactor throws AppException',
        build: () {
          when(
            () => mockAuthInteractor.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            AuthInvalidCredentialsException(message: 'bad credentials'),
          );

          return buildCubit();
        },
        act: (cubit) => cubit.logIn(username: 'john', password: 'bad'),
        expect: () => <dynamic>[
          const AuthLoadingState(),
          isA<AuthFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AuthInvalidCredentialsException>(),
          ),
        ],
        verify: (_) {
          verify(
            () => mockAuthInteractor.logIn(username: 'john', password: 'bad'),
          ).called(1);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should wrap non-AppException into AppUnknownException in Failure state',
        build: () {
          when(
            () => mockAuthInteractor.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('boom'));

          return buildCubit();
        },
        act: (cubit) => cubit.logIn(username: 'john', password: '123'),
        expect: () => <dynamic>[
          const AuthLoadingState(),
          isA<AuthFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(
            () => mockAuthInteractor.logIn(username: 'john', password: '123'),
          ).called(1);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should keep failure stackTrace when wrapping non-AppException',
        build: () {
          when(
            () => mockAuthInteractor.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(StateError('boom'));

          return buildCubit();
        },
        act: (cubit) =>
            cubit.logIn(username: 'john', password: 'SKFJJDSF@^!&sdfsdmd'),
        expect: () => <dynamic>[
          const AuthLoadingState(),
          isA<AuthFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(
            () => mockAuthInteractor.logIn(
              username: any(named: "username"),
              password: any(named: "password"),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );
    });

    group('register', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [Loading, Authenticated] when interactor returns session and user',
        build: () {
          when(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => (session, user));

          return buildCubit();
        },
        act: (cubit) => cubit.register(
          firstName: 'John',
          lastName: 'Doe',
          username: 'john',
          password: '123',
          description: 'desc',
        ),
        expect: () => <AuthState>[
          const AuthLoadingState(),
          AuthAuthenticatedState(user: user),
        ],
        verify: (_) {
          verify(
            () => mockAuthInteractor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
              description: 'desc',
            ),
          ).called(1);

          verify(() => mockLogger.info(any())).called(2);
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should pass null description when not provided',
        build: () {
          when(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => (session, user));

          return buildCubit();
        },
        act: (cubit) => cubit.register(
          firstName: 'John',
          lastName: 'Doe',
          username: 'john',
          password: '123',
        ),
        expect: () => <AuthState>[
          const AuthLoadingState(),
          AuthAuthenticatedState(user: user),
        ],
        verify: (_) {
          verify(
            () => mockAuthInteractor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
          ).called(1);

          verify(() => mockLogger.info(any())).called(2);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should not emit Loading twice when already in Loading state',
        build: () {
          when(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => (session, user));

          return buildCubit();
        },
        seed: () => const AuthLoadingState(),
        act: (cubit) => cubit.register(
          firstName: 'John',
          lastName: 'Doe',
          username: 'john',
          password: '123',
        ),
        expect: () => <AuthState>[AuthAuthenticatedState(user: user)],
        verify: (_) {
          verify(
            () => mockAuthInteractor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
          ).called(1);

          verify(() => mockLogger.info(any())).called(2);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit Failure with the same AppException when interactor throws AppException',
        build: () {
          when(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).thenThrow(AuthException(message: 'register failed'));

          return buildCubit();
        },
        act: (cubit) => cubit.register(
          firstName: 'John',
          lastName: 'Doe',
          username: 'john',
          password: '123',
        ),
        expect: () => <dynamic>[
          const AuthLoadingState(),
          isA<AuthFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AuthException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should wrap non-AppException into AppUnknownException in Failure state',
        build: () {
          when(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).thenThrow(StateError('boom'));

          return buildCubit();
        },
        act: (cubit) => cubit.register(
          firstName: 'John',
          lastName: 'Doe',
          username: 'john',
          password: '123',
        ),
        expect: () => <dynamic>[
          const AuthLoadingState(),
          isA<AuthFailureState>().having(
            (state) => state.failure,
            'failure',
            isA<AppUnknownException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(
            () => mockAuthInteractor.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              description: any(named: 'description'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );
    });

    group('tryRestoreSession', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [Loading, Unauthenticated] when restoreSession returns null',
        build: () {
          when(
            () => mockAuthInteractor.restoreSession(),
          ).thenAnswer((_) async => null);
          return buildCubit();
        },
        act: (cubit) => cubit.tryRestoreSession(),
        expect: () => <AuthState>[
          const AuthLoadingState(),
          const AuthUnauthenticatedState(),
        ],
        verify: (_) {
          verify(() => mockAuthInteractor.restoreSession()).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [Loading, Authenticated] when restoreSession returns session and user',
        build: () {
          when(
            () => mockAuthInteractor.restoreSession(),
          ).thenAnswer((_) async => (session, user));
          return buildCubit();
        },
        act: (cubit) => cubit.tryRestoreSession(),
        expect: () => <AuthState>[
          const AuthLoadingState(),
          AuthAuthenticatedState(user: user),
        ],
        verify: (_) {
          verify(() => mockAuthInteractor.restoreSession()).called(1);
          verify(() => mockLogger.info(any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [Unauthenticated] when restoreSession throws (and should not emit Failure)',
        build: () {
          when(
            () => mockAuthInteractor.restoreSession(),
          ).thenThrow(Exception('boom'));
          return buildCubit();
        },
        act: (cubit) => cubit.tryRestoreSession(),
        expect: () => <AuthState>[
          const AuthLoadingState(),
          const AuthUnauthenticatedState(),
        ],
        verify: (_) {
          verify(() => mockAuthInteractor.restoreSession()).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should not emit Loading twice when already in Loading state',
        build: () {
          when(
            () => mockAuthInteractor.restoreSession(),
          ).thenAnswer((_) async => (session, user));
          return buildCubit();
        },
        seed: () => const AuthLoadingState(),
        act: (cubit) => cubit.tryRestoreSession(),
        expect: () => <AuthState>[AuthAuthenticatedState(user: user)],
        verify: (_) {
          verify(() => mockAuthInteractor.restoreSession()).called(1);
          verify(() => mockLogger.info(any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );
    });

    group('logOut', () {
      blocTest<AuthCubit, AuthState>(
        'should emit Unauthenticated when logOut succeeds',
        build: () {
          when(() => mockAuthInteractor.logOut()).thenAnswer((_) async {});
          return buildCubit();
        },
        seed: () => AuthAuthenticatedState(user: user),
        act: (cubit) => cubit.logOut(),
        expect: () => <AuthState>[const AuthUnauthenticatedState()],
        verify: (_) {
          verify(() => mockAuthInteractor.logOut()).called(1);
          verify(() => mockLogger.info(any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit Unauthenticated even when logOut throws',
        build: () {
          when(() => mockAuthInteractor.logOut()).thenThrow(Exception('boom'));
          return buildCubit();
        },
        seed: () => AuthAuthenticatedState(user: user),
        act: (cubit) => cubit.logOut(),
        expect: () => <AuthState>[const AuthUnauthenticatedState()],
        verify: (_) {
          verify(() => mockAuthInteractor.logOut()).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit Unauthenticated when called from Initial state',
        build: () {
          when(() => mockAuthInteractor.logOut()).thenAnswer((_) async {});
          return buildCubit();
        },
        act: (cubit) => cubit.logOut(),
        expect: () => <AuthState>[const AuthUnauthenticatedState()],
        verify: (_) {
          verify(() => mockAuthInteractor.logOut()).called(1);
          verify(() => mockLogger.info(any())).called(1);
          verifyNoMoreInteractions(mockAuthInteractor);
        },
      );
    });
  });
}
