import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/core/data/data.dart' hide MockUserRepo;
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/domain/models/user.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/data/repositories/mock_user_cache_repo.dart';
import '../../../../core/data/repositories/mock_user_repo.dart';
import '../../../../core/utils/logger/mock_logger.dart';
import '../../data/repositories/mock_auth_repo.dart';
import '../../data/repositories/mock_device_info_repo.dart';
import '../../data/repositories/mock_session_cache_repo.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepo mockAuthRepo;
  late MockUserRepo mockUserRepo;
  late MockSessionCacheRepo mockSessionCacheRepo;
  late MockUserCacheRepo mockUserCacheRepo;
  late MockDeviceInfoRepo mockDeviceInfoRepo;
  late MockLogger mockLogger;
  late MockAppDatabase mockAppDatabase;

  late AuthInteractor interactor;

  late Session freshSession;
  late Session expiredSession;
  late Session refreshedSession;
  late User user;

  const DeviceInfo deviceInfo = DeviceInfo();

  setUpAll(() {
    registerFallbackValue(
      Session(
        sessionId: 'fallback-session-id',
        userId: 'fallback-user-id',
        refreshToken: 'fallback-refresh-token',
        accessToken: 'fallback-access-token',
        accessExpiresAt: DateTime.utc(2030),
        refreshExpiresAt: DateTime.utc(2030),
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

    registerFallbackValue(deviceInfo);
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    mockUserRepo = MockUserRepo();
    mockSessionCacheRepo = MockSessionCacheRepo();
    mockUserCacheRepo = MockUserCacheRepo();
    mockDeviceInfoRepo = MockDeviceInfoRepo();
    mockLogger = MockLogger();
    mockAppDatabase = MockAppDatabase();

    when(
      () => mockDeviceInfoRepo.getDeviceInfo(),
    ).thenAnswer((_) async => deviceInfo);
    when(
      () => mockAppDatabase.clearAll(),
    ).thenAnswer((_) async {});

    interactor = AuthInteractor(
      authRepo: mockAuthRepo,
      userRepo: mockUserRepo,
      sessionCacheRepo: mockSessionCacheRepo,
      userCacheRepo: mockUserCacheRepo,
      deviceInfoRepo: mockDeviceInfoRepo,
      logger: mockLogger,
      db: mockAppDatabase,
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
      accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      refreshExpiresAt: DateTime.now().add(const Duration(hours: 24)),
      isExpired: false,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 2),
    );

    expiredSession = Session(
      sessionId: 'session-id',
      userId: 'user-id',
      refreshToken: 'refresh-token',
      accessToken: 'access-token',
      accessExpiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
      refreshExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      isExpired: true,
      createdAt: DateTime.utc(2029),
      updatedAt: DateTime.utc(2029, 1, 2),
    );

    refreshedSession = Session(
      sessionId: 'session-id',
      userId: 'user-id',
      refreshToken: 'refresh-token-2',
      accessToken: 'access-token-2',
      accessExpiresAt: DateTime.now().add(const Duration(hours: 2)),
      refreshExpiresAt: DateTime.now().add(const Duration(hours: 48)),
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
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockAuthRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
              description: 'desc',
              deviceInfo: deviceInfo,
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
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
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
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
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
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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
        'should throw AuthException when authRepo throws ApiValidationException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiValidationException(message: 'validation'));

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<AuthException>()),
          );

          verifyInOrder([
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockLogger.exception(any(), any()),
          ]);

          verifyNever(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
          );
          verifyNever(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          );
          verifyNever(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          );
        },
      );

      test(
        'should throw AuthUnauthorizedException when authRepo throws ApiUnauthorizedException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<AuthUnauthorizedException>()),
          );

          verifyInOrder([
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockLogger.exception(any(), any()),
          ]);
        },
      );

      test(
        'should rethrow StorageException when caching session throws StorageException',
        () async {
          when(
            () => mockAuthRepo.register(
              username: any(named: 'username'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password'),
              patronymic: any(named: 'patronymic'),
              description: any(named: 'description'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
          ).thenThrow(StorageIOException(message: 'cache failed'));

          await expectLater(
            () => interactor.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<StorageException>()),
          );

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNever(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          );
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
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockAuthRepo.logIn(
              username: 'john',
              password: '123',
              deviceInfo: deviceInfo,
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
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
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
        'should throw AuthInvalidCredentialsException when authRepo throws ApiUnauthorizedException',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          await expectLater(
            () => interactor.logIn(username: 'john', password: '123'),
            throwsA(isA<AuthInvalidCredentialsException>()),
          );

          verifyInOrder([
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockLogger.exception(any(), any()),
          ]);
        },
      );

      test(
        'should throw AuthUnauthorizedException when authRepo throws ApiForbiddenException',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiForbiddenException(message: 'forbidden'));

          await expectLater(
            () => interactor.logIn(username: 'john', password: '123'),
            throwsA(isA<AuthUnauthorizedException>()),
          );

          verifyInOrder([
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockLogger.exception(any(), any()),
          ]);
        },
      );

      test(
        'should throw AuthException when authRepo throws ApiValidationException',
        () async {
          when(
            () => mockAuthRepo.logIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiValidationException(message: 'validation'));

          await expectLater(
            () => interactor.logIn(username: 'john', password: '123'),
            throwsA(isA<AuthException>()),
          );

          verifyInOrder([
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockLogger.exception(any(), any()),
          ]);
        },
      );
    });

    group('restoreSession', () {
      test(
        'should use cached session and not call refresh when session is fresh',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, freshSession);
          expect(result.$2, user);

          verifyInOrder([
            () => mockSessionCacheRepo.loadSession(),
            () => mockUserRepo.getUserById(userId: freshSession.userId),
          ]);

          verifyNever(() => mockDeviceInfoRepo.getDeviceInfo());
          verifyNever(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          );
          verifyNever(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
          );
          verifyNever(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          );
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockLogger.exception(any(), any()));
          verifyNever(() => mockLogger.exception(any()));
        },
      );

      test(
        'should refresh session and persist caches when cached session is expired',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => refreshedSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, refreshedSession);
          expect(result.$2, user);

          verifyInOrder([
            () => mockSessionCacheRepo.loadSession(),
            () => mockDeviceInfoRepo.getDeviceInfo(),
            () => mockAuthRepo.refresh(
              refreshToken: expiredSession.refreshToken,
              sessionId: expiredSession.sessionId,
              deviceInfo: deviceInfo,
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
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => refreshedSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
          ).thenAnswer((_) async => false);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, refreshedSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should return (Session, User) even when saveUser returns false after refresh and should log the failure',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenAnswer((_) async => refreshedSession);

          when(
            () => mockSessionCacheRepo.saveSession(
              session: any(named: 'session'),
            ),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenAnswer((_) async => user);

          when(
            () => mockUserCacheRepo.saveUser(user: any(named: 'user')),
          ).thenAnswer((_) async => false);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNotNull);
          expect(result!.$1, refreshedSession);
          expect(result.$2, user);

          verify(() => mockLogger.exception(any())).called(1);
          verifyNever(() => mockLogger.exception(any(), any()));
        },
      );

      test(
        'should return null when sessionCacheRepo.loadSession throws StorageException and not log out',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenThrow(StorageException(message: 'no session'));

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verifyNever(() => mockSessionCacheRepo.clearSession());
          verifyNever(() => mockUserCacheRepo.clearUser());
          verifyNever(() => mockDeviceInfoRepo.getDeviceInfo());
          verifyNever(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          );
        },
      );

      test(
        'should log out and return null when refresh throws ApiUnauthorizedException',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          when(
            () => mockSessionCacheRepo.clearSession(),
          ).thenAnswer((_) async => true);
          when(
            () => mockUserCacheRepo.clearUser(),
          ).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockDeviceInfoRepo.getDeviceInfo()).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );

      test(
        'should log out and return null when refresh throws ApiForbiddenException',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(ApiForbiddenException(message: 'forbidden'));

          when(
            () => mockSessionCacheRepo.clearSession(),
          ).thenAnswer((_) async => true);
          when(
            () => mockUserCacheRepo.clearUser(),
          ).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockDeviceInfoRepo.getDeviceInfo()).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );

      test(
        'should return null and log out when refresh throws ApiException',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => expiredSession);

          when(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          ).thenThrow(
            ApiServerException(message: 'server error', statusCode: 500),
          );

          when(
            () => mockSessionCacheRepo.clearSession(),
          ).thenAnswer((_) async => true);
          when(
            () => mockUserCacheRepo.clearUser(),
          ).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockDeviceInfoRepo.getDeviceInfo()).called(1);
          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );

      test(
        'should return null and log out when cached session is fresh but getUserById throws',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenAnswer((_) async => freshSession);

          when(
            () => mockUserRepo.getUserById(userId: any(named: 'userId')),
          ).thenThrow(Exception('boom'));

          when(
            () => mockSessionCacheRepo.clearSession(),
          ).thenAnswer((_) async => true);
          when(
            () => mockUserCacheRepo.clearUser(),
          ).thenAnswer((_) async => true);

          final (Session, User)? result = await interactor.restoreSession();

          expect(result, isNull);

          verify(() => mockLogger.exception(any(), any())).called(1);
          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);

          verifyNever(() => mockDeviceInfoRepo.getDeviceInfo());
          verifyNever(
            () => mockAuthRepo.refresh(
              refreshToken: any(named: 'refreshToken'),
              sessionId: any(named: 'sessionId'),
              deviceInfo: any(named: 'deviceInfo'),
            ),
          );
        },
      );
    });

    group('logOut', () {
      test('should clear session and user caches', () async {
        when(
          () => mockSessionCacheRepo.clearSession(),
        ).thenAnswer((_) async => true);
        when(() => mockUserCacheRepo.clearUser()).thenAnswer((_) async => true);

        await interactor.logOut();

        verifyInOrder([
          () => mockSessionCacheRepo.clearSession(),
          () => mockUserCacheRepo.clearUser(),
        ]);
      });

      test(
        'should propagate exception if session cache clear throws StorageException',
        () async {
          when(
            () => mockSessionCacheRepo.clearSession(),
          ).thenThrow(StorageIOException(message: 'fail'));

          await expectLater(
            () => interactor.logOut(),
            throwsA(isA<StorageException>()),
          );

          verifyNever(() => mockUserCacheRepo.clearUser());
        },
      );

      test(
        'should propagate exception if user cache clear throws StorageException',
        () async {
          when(
            () => mockSessionCacheRepo.clearSession(),
          ).thenAnswer((_) async => true);

          when(
            () => mockUserCacheRepo.clearUser(),
          ).thenThrow(StorageIOException(message: 'fail'));

          await expectLater(
            () => interactor.logOut(),
            throwsA(isA<StorageException>()),
          );

          verify(() => mockSessionCacheRepo.clearSession()).called(1);
          verify(() => mockUserCacheRepo.clearUser()).called(1);
        },
      );
    });

    group('getCachedSession', () {
      test('should return cached session from sessionCacheRepo', () async {
        when(
          () => mockSessionCacheRepo.loadSession(),
        ).thenAnswer((_) async => freshSession);

        final Session result = await interactor.getCachedSession();

        expect(result, freshSession);
        verify(() => mockSessionCacheRepo.loadSession()).called(1);
      });

      test(
        'should propagate StorageException from sessionCacheRepo.loadSession',
        () async {
          when(
            () => mockSessionCacheRepo.loadSession(),
          ).thenThrow(StorageException(message: 'no session'));

          await expectLater(
            () => interactor.getCachedSession(),
            throwsA(isA<StorageException>()),
          );

          verify(() => mockSessionCacheRepo.loadSession()).called(1);
        },
      );
    });
  });
}
