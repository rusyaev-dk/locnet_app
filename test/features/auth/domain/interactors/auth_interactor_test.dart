import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/data/models/exceptions.dart';
import 'package:locnet_app/core/domain/models/user.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/data/repositories/mock_user_cache_repo.dart';
import '../../../../core/data/repositories/mock_user_repo.dart';
import '../../../../core/utils/logger/mock_logger.dart';
import '../../data/repositories/mock_auth_repo.dart';
import '../../data/repositories/mock_session_cache_repo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepo mockAuthRepo;
  late MockUserRepo mockUserRepo;
  late MockSessionCacheRepo mockSessionCacheRepo;
  late MockUserCacheRepo mockUserCacheRepo;
  late MockLogger mockLogger;

  late AuthInteractor interactor;

  late Session freshSession;
  late Session expiredSession;
  late Session refreshedSession;
  late User user;

  setUpAll(() {
    registerFallbackValue(
      Session(
        sessionId: 'fallback-session-id',
        userId: 'fallback-user-id',
        refreshToken: 'fallback-refresh-token',
        accessToken: 'fallback-access-token',
        expiresAt: DateTime.utc(2030),
        isExpired: false,
        createdAt: DateTime.utc(2029),
        updatedAt: DateTime.utc(2029, 1, 2),
      ),
    );

    registerFallbackValue(
      User(
        userId: 'fallback-user-id',
        username: 'fallback-username',
        firstName: 'Fallback',
        lastName: 'User',
        languageCode: 'en',
        isDeleted: false,
        isBanned: false,
        createdAt: DateTime.utc(2029),
        updatedAt: DateTime.utc(2029, 1, 2),
      ),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    mockUserRepo = MockUserRepo();
    mockSessionCacheRepo = MockSessionCacheRepo();
    mockUserCacheRepo = MockUserCacheRepo();
    mockLogger = MockLogger();

    interactor = AuthInteractor(
      authRepo: mockAuthRepo,
      userRepo: mockUserRepo,
      sessionCacheRepo: mockSessionCacheRepo,
      userCacheRepo: mockUserCacheRepo,
      logger: mockLogger,
    );

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

    freshSession = Session(
      sessionId: 'session-id',
      userId: 'user-id',
      refreshToken: 'refresh-token',
      accessToken: 'access-token',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      isExpired: false,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 2),
    );

    expiredSession = Session(
      sessionId: 'session-id',
      userId: 'user-id',
      refreshToken: 'refresh-token',
      accessToken: 'access-token',
      expiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
      isExpired: true,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 2),
    );

    refreshedSession = Session(
      sessionId: 'session-id',
      userId: 'user-id',
      refreshToken: 'refresh-token-2',
      accessToken: 'access-token-2',
      expiresAt: DateTime.now().add(const Duration(hours: 2)),
      isExpired: false,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 3),
    );
  });

  group('AuthInteractor', () {
    group('register', () {
      test(
        'should return (Session, User) and persist both to cache on success',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => true);

          final (Session, User) result = await interactor.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
            description: 'desc',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verifyInOrder([
            () => mockAuthRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
              description: 'desc',
            ),
            () => mockSessionCacheRepo.saveSession(session: freshSession),
            () => mockUserRepo.getUserById(userId: freshSession.userId),
            () => mockUserCacheRepo.saveUser(user: user),
          ]);

          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNever(() => mockLogger.exception(any()));
        },
      );

      test(
        'should return (Session, User) even when session cache save returns false and should log the failure',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => false);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => true);

          final (Session, User) result = await interactor.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verify(() => mockSessionCacheRepo.saveSession(session: freshSession)).called(1);
          verify(() => mockUserRepo.getUserById(userId: freshSession.userId)).called(1);
          verify(() => mockUserCacheRepo.saveUser(user: user)).called(1);
        },
      );

      test(
        'should return (Session, User) even when user cache save returns false and should log the failure',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => false);

          final (Session, User) result = await interactor.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verify(() => mockSessionCacheRepo.saveSession(session: freshSession)).called(1);
          verify(() => mockUserRepo.getUserById(userId: freshSession.userId)).called(1);
          verify(() => mockUserCacheRepo.saveUser(user: user)).called(1);

          
        },
      );

      test(
        'should return (Session, User) and log twice when both session and user cache saves return false',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => false);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => false);

          final (Session, User) result = await interactor.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(2);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should map ApiValidationException to UsernameAlreadyTakenException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{},
            ),
          );

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<UsernameAlreadyTakenException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);

          verifyNever(() => mockSessionCacheRepo.saveSession(session: any(named: 'session')));
          verifyNever(() => mockUserRepo.getUserById(userId: any(named: 'userId')));
          verifyNever(() => mockUserCacheRepo.saveUser(user: any(named: 'user')));
        },
      );

      test(
        'should map ApiUnauthorizedException to AuthUnauthorizedException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenThrow(
            ApiUnauthorizedException(message: 'unauthorized', statusCode: 401),
          );

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<AuthUnauthorizedException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      test(
        'should map ApiConnectionException to RegistrationFailedException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenThrow(ApiConnectionException(message: 'no connection'));

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      test(
        'should map unknown exception to RegistrationFailedException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
            ),
          ).thenThrow(Exception('boom'));

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );
    });

    group('logIn', () {
      test(
        'should return (Session, User) and persist both to cache on success',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => true);

          final (Session, User) result = await interactor.logIn(
            username: 'john',
            password: '123',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verifyInOrder([
            () => mockAuthRepo.logIn(username: 'john', password: '123'),
            () => mockSessionCacheRepo.saveSession(session: freshSession),
            () => mockUserRepo.getUserById(userId: freshSession.userId),
            () => mockUserCacheRepo.saveUser(user: user),
          ]);

          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNever(() => mockLogger.exception(any()));
        },
      );

      test(
        'should return (Session, User) even when session cache save returns false and should log the failure',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => false);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => true);

          final (Session, User) result = await interactor.logIn(
            username: 'john',
            password: '123',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should return (Session, User) even when user cache save returns false and should log the failure',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(session: any(named: 'session')),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => false);

          final (Session, User) result = await interactor.logIn(
            username: 'john',
            password: '123',
          );

          expect(result.$1, freshSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should map ApiValidationException to UsernameAlreadyTakenException',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{},
            ),
          );

          await expectLater(
            () => interactor.logIn(username: 'john', password: '123'),
            throwsA(isA<UsernameAlreadyTakenException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNever(() => mockSessionCacheRepo.saveSession(session: any(named: 'session')));
          verifyNever(() => mockUserRepo.getUserById(userId: any(named: 'userId')));
          verifyNever(() => mockUserCacheRepo.saveUser(user: any(named: 'user')));
        },
      );

      test(
        'should map ApiUnauthorizedException to AuthUnauthorizedException',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            ApiUnauthorizedException(message: 'unauthorized', statusCode: 401),
          );

          await expectLater(
            () => interactor.logIn(username: 'john', password: '123'),
            throwsA(isA<AuthUnauthorizedException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      test(
        'should map ApiConnectionException to LogInFailedException',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(ApiConnectionException(message: 'no connection'));

          await expectLater(
            () => interactor.logIn(username: 'john', password: '123'),
            throwsA(isA<LogInFailedException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
        },
      );

      test('should map unknown exception to LogInFailedException', () async {
        when(
          () => mockAuthRepo.logIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('boom'));

        await expectLater(
          () => interactor.logIn(username: 'john', password: '123'),
          throwsA(isA<LogInFailedException>()),
        );

        verify(() => mockLogger.exception(any(), any())).called(1);
      });
    });

    group('restoreSession', () {
      test(
        'should use cached session and not call refresh when session is fresh',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => freshSession);
          when(() => mockUserRepo.getUserById(userId: any(named: 'userId'))).thenAnswer((_) async => user);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, freshSession);
          expect(result.$2, user);

          verifyInOrder([
            () => mockSessionCacheRepo.loadSession(),
            () => mockUserRepo.getUserById(userId: freshSession.userId),
          ]);

          verifyNever(() => mockAuthRepo.refresh(
                refreshToken: any(named: 'refreshToken'),
                sessionId: any(named: 'sessionId'),
              ));
          verifyNever(() => mockSessionCacheRepo.saveSession(session: any(named: 'session')));
          verifyNever(() => mockUserCacheRepo.saveUser(user: any(named: 'user')));
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNever(() => mockLogger.exception(any()));
        },
      );

      test(
        'should refresh session and persist caches when cached session is expired',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
            ),
          ).thenAnswer((_) async => refreshedSession);

          when(() => mockSessionCacheRepo.saveSession(session: any(named: 'session'))).thenAnswer((_) async => true);
          when(() => mockUserRepo.getUserById(userId: any(named: 'userId'))).thenAnswer((_) async => user);
          when(() => mockUserCacheRepo.saveUser(user: any(named: 'user'))).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, refreshedSession);
          expect(result.$2, user);

          verifyInOrder([
            () => mockSessionCacheRepo.loadSession(),
            () => mockAuthRepo.refresh(
              refreshToken: expiredSession.refreshToken,
              sessionId: expiredSession.sessionId,
            ),
            () => mockSessionCacheRepo.saveSession(session: refreshedSession),
            () => mockUserRepo.getUserById(userId: refreshedSession.userId),
            () => mockUserCacheRepo.saveUser(user: user),
          ]);

          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNever(() => mockLogger.exception(any()));
        },
      );

      test(
        'should return (Session, User) even when saveSession returns false after refresh and should log the failure',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
            ),
          ).thenAnswer((_) async => refreshedSession);

          when(() => mockSessionCacheRepo.saveSession(session: any(named: 'session'))).thenAnswer((_) async => false);

          when(() => mockUserRepo.getUserById(userId: any(named: 'userId'))).thenAnswer((_) async => user);
          when(() => mockUserCacheRepo.saveUser(user: any(named: 'user'))).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, refreshedSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should return (Session, User) even when saveUser returns false after refresh and should log the failure',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
            ),
          ).thenAnswer((_) async => refreshedSession);

          when(() => mockSessionCacheRepo.saveSession(session: any(named: 'session'))).thenAnswer((_) async => true);

          when(() => mockUserRepo.getUserById(userId: any(named: 'userId'))).thenAnswer((_) async => user);
          when(() => mockUserCacheRepo.saveUser(user: any(named: 'user'))).thenAnswer((_) async => false);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, refreshedSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should return null when no cached session exists (StorageNotFoundException) and not log out',
        () async {
          when(() => mockSessionCacheRepo.loadSession())
              .thenThrow(StorageNotFoundException(message: 'no session'));

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockAuthRepo.refresh(
                refreshToken: any(named: 'refreshToken'),
                sessionId: any(named: 'sessionId'),
              ));
        },
      );

      test(
        'should log out and return null when refresh throws ApiUnauthorizedException',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized', statusCode: 401));

          when(() => mockSessionCacheRepo.clearSession()).thenAnswer((_) async => true);
          when(() => mockUserCacheRepo.clearUser()).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );

      test(
        'should log out and return null when refresh throws ApiForbiddenException',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
            ),
          ).thenThrow(ApiForbiddenException(message: 'forbidden', statusCode: 403));

          when(() => mockSessionCacheRepo.clearSession()).thenAnswer((_) async => true);
          when(() => mockUserCacheRepo.clearUser()).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );

      test(
        'should return null and not log out when refresh throws ApiConnectionException',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
            ),
          ).thenThrow(ApiConnectionException(message: 'no connection'));

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
        },
      );

      test(
        'should return null and log out when cached session is fresh but getUserById throws',
        () async {
          when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => freshSession);
          when(() => mockUserRepo.getUserById(userId: any(named: 'userId'))).thenThrow(Exception('boom'));

          when(() => mockSessionCacheRepo.clearSession()).thenAnswer((_) async => true);
          when(() => mockUserCacheRepo.clearUser()).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );
    });

    group('logOut', () {
      test('should clear session and user caches', () async {
        when(() => mockSessionCacheRepo.clearSession()).thenAnswer((_) async => true);
        when(() => mockUserCacheRepo.clearUser()).thenAnswer((_) async => true);

        await interactor.logOut();

        verifyInOrder([
          () => mockSessionCacheRepo.clearSession(),
          () => mockUserCacheRepo.clearUser(),
        ]);
      });

      test('should propagate exception if session cache clear throws', () async {
        when(() => mockSessionCacheRepo.clearSession()).thenThrow(StorageDeleteException(message: 'fail'));

        await expectLater(
          () => interactor.logOut(),
          throwsA(isA<StorageDeleteException>()),
        );

        verifyNever(() => mockUserCacheRepo.clearUser());
      });

      test('should propagate exception if user cache clear throws', () async {
        when(() => mockSessionCacheRepo.clearSession()).thenAnswer((_) async => true);
        when(() => mockUserCacheRepo.clearUser()).thenThrow(StorageDeleteException(message: 'fail'));

        await expectLater(
          () => interactor.logOut(),
          throwsA(isA<StorageDeleteException>()),
        );

        verify(() => mockSessionCacheRepo.clearSession()).called(1);
        verify(() => mockUserCacheRepo.clearUser()).called(1);
      });
    });

    group('getCachedSession', () {
      test('should return cached session from sessionCacheRepo', () async {
        when(() => mockSessionCacheRepo.loadSession()).thenAnswer((_) async => freshSession);

        final Session result = await interactor.getCachedSession();

        expect(result, freshSession);
        verify(() => mockSessionCacheRepo.loadSession()).called(1);
      });

      test('should propagate exception from sessionCacheRepo.loadSession', () async {
        when(() => mockSessionCacheRepo.loadSession())
            .thenThrow(StorageNotFoundException(message: 'no session'));

        await expectLater(
          () => interactor.getCachedSession(),
          throwsA(isA<StorageNotFoundException>()),
        );

        verify(() => mockSessionCacheRepo.loadSession()).called(1);
      });
    });
  });
}
