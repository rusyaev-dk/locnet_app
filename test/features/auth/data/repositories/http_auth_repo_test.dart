import 'package:flutter_test/flutter_test.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/data/http/mock_http_client.dart';
import '../models/fake_response.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late HttpAuthRepo authRepo;

  setUpAll(() {
    registerFallbackValue(FakeResponse());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    authRepo = HttpAuthRepo(httpClient: mockHttpClient);
  });

  Map<String, dynamic> buildSessionJson({
    String refreshToken = 'refresh-token',
    String accessToken = 'access-token',
  }) {
    return <String, dynamic>{
      'sessionId': 'session-id',
      'userId': 'user-id',
      'refreshToken': refreshToken,
      'accessToken': accessToken,
      'expiresAt': DateTime.utc(2030).toIso8601String(),
      'isExpired': false,
      'createdAt': DateTime.utc(2029).toIso8601String(),
      'updatedAt': DateTime.utc(2029, 1, 2).toIso8601String(),
    };
  }

  group('HttpAuthRepo', () {
    group('logIn', () {
      test(
        'should return Session when response data is a valid json map',
        () async {
          final Map<String, dynamic> sessionJson = buildSessionJson();

          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: sessionJson));

          final Session session = await authRepo.logIn(
            username: 'john',
            password: '123',
          );

          expect(session, isA<Session>());
          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: <String, dynamic>{'username': 'john', 'password': '123'},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should throw AppUnknownException when response data is not a map',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: 'invalid'));

          await expectLater(
            () => authRepo.logIn(username: 'john', password: '123'),
            throwsA(isA<AppUnknownException>()),
          );

          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: <String, dynamic>{'username': 'john', 'password': '123'},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should map ApiUnauthorizedException to AuthInvalidCredentialsException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiUnauthorizedException(message: 'unauthorized', statusCode: 401),
          );

          await expectLater(
            () => authRepo.logIn(username: 'john', password: 'bad'),
            throwsA(isA<AuthInvalidCredentialsException>()),
          );

          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: <String, dynamic>{'username': 'john', 'password': 'bad'},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should map ApiValidationException with username error to AuthInvalidCredentialsException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{'username': 'invalid username'},
            ),
          );

          await expectLater(
            () => authRepo.logIn(username: 'john', password: '123'),
            throwsA(
              predicate<AuthInvalidCredentialsException>(
                (exception) => exception.message.contains('invalid username'),
              ),
            ),
          );
        },
      );

      test(
        'should map ApiValidationException with password error list to AuthInvalidCredentialsException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{
                'password': <dynamic>['too short'],
              },
            ),
          );

          await expectLater(
            () => authRepo.logIn(username: 'john', password: '123'),
            throwsA(
              predicate<AuthInvalidCredentialsException>(
                (exception) => exception.message.contains('too short'),
              ),
            ),
          );
        },
      );

      test(
        'should map ApiValidationException with errors == null to LogInFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(message: 'validation', statusCode: 422),
          );

          await expectLater(
            () => authRepo.logIn(username: 'john', password: '123'),
            throwsA(isA<LogInFailedException>()),
          );
        },
      );

      test(
        'should map ApiValidationException with unsupported field error type to LogInFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{'username': 123},
            ),
          );

          await expectLater(
            () => authRepo.logIn(username: 'john', password: '123'),
            throwsA(isA<LogInFailedException>()),
          );
        },
      );

      test('should map AppApiException to LogInFailedException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logIn,
            data: any(named: 'data'),
          ),
        ).thenThrow(ApiServerException(message: 'server', statusCode: 500));

        await expectLater(
          () => authRepo.logIn(username: 'john', password: '123'),
          throwsA(isA<LogInFailedException>()),
        );
      });

      test('should rethrow AppException unchanged', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logIn,
            data: any(named: 'data'),
          ),
        ).thenThrow(AppUnknownException(message: 'app-level'));

        await expectLater(
          () => authRepo.logIn(username: 'john', password: '123'),
          throwsA(isA<AppUnknownException>()),
        );
      });

      test('should map unknown exception to LogInFailedException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logIn,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('boom'));

        await expectLater(
          () => authRepo.logIn(username: 'john', password: '123'),
          throwsA(isA<LogInFailedException>()),
        );
      });
    });

    group('register', () {
      test(
        'should return Session when response data is a valid json map',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: buildSessionJson()));

          final Session session = await authRepo.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
            description: 'desc',
          );

          expect(session, isA<Session>());
          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: <String, dynamic>{
                'username': 'john',
                'firstName': 'John',
                'lastName': 'Doe',
                'patronymic': null,
                'description': 'desc',
                'password': '123',
              },
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should throw AppUnknownException when response data is not a map',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: 123));

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<AppUnknownException>()),
          );
        },
      );

      test(
        'should map ApiValidationException with username error to UsernameAlreadyTakenException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{'username': 'already taken'},
            ),
          );

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<UsernameAlreadyTakenException>()),
          );
        },
      );

      test(
        'should map ApiValidationException with username error list to UsernameAlreadyTakenException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{
                'username': <dynamic>['already taken'],
              },
            ),
          );

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<UsernameAlreadyTakenException>()),
          );
        },
      );

      test(
        'should map ApiValidationException with password error to RegistrationFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{'password': 'weak password'},
            ),
          );

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );
        },
      );

      test(
        'should map ApiValidationException with errors == null to RegistrationFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(message: 'validation', statusCode: 422),
          );

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );
        },
      );

      test(
        'should map ApiValidationException with unsupported field error type to RegistrationFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{
                'username': <String, dynamic>{'msg': 'x'},
              },
            ),
          );

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );
        },
      );

      test(
        'should map ApiUnauthorizedException to AuthUnauthorizedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiUnauthorizedException(message: 'unauthorized', statusCode: 401),
          );

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<AuthUnauthorizedException>()),
          );
        },
      );

      test(
        'should map AppApiException to RegistrationFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiServerException(message: 'server', statusCode: 500));

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );
        },
      );

      test('should rethrow AppException unchanged', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.register,
            data: any(named: 'data'),
          ),
        ).thenThrow(AppUnknownException(message: 'app-level'));

        await expectLater(
          () => authRepo.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
          ),
          throwsA(isA<AppUnknownException>()),
        );
      });

      test(
        'should map unknown exception to RegistrationFailedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(Exception('boom'));

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<RegistrationFailedException>()),
          );
        },
      );
    });

    group('refresh', () {
      test(
        'should return Session when response data is a valid json map',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenAnswer(
            (_) async => FakeResponse(
              data: buildSessionJson(refreshToken: 'rt2', accessToken: 'at2'),
            ),
          );

          final Session session = await authRepo.refresh(
            refreshToken: 'refresh-token',
            sessionId: 'session-id',
          );

          expect(session, isA<Session>());
          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: <String, dynamic>{
                'refreshToken': 'refresh-token',
                'sessionId': 'session-id',
              },
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should throw AppUnknownException when response data is not a map',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse());

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<AppUnknownException>()),
          );
        },
      );

      test(
        'should map ApiUnauthorizedException to AuthExpiredSessionException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiUnauthorizedException(message: 'unauthorized', statusCode: 401),
          );

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<AuthExpiredSessionException>()),
          );
        },
      );

      test(
        'should map ApiForbiddenException to AuthExpiredSessionException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiForbiddenException(message: 'forbidden', statusCode: 403),
          );

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<AuthExpiredSessionException>()),
          );
        },
      );

      test(
        'should map ApiValidationException to AuthExpiredSessionException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiValidationException(
              message: 'validation',
              statusCode: 422,
              errors: <String, dynamic>{},
            ),
          );

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<AuthExpiredSessionException>()),
          );
        },
      );

      test(
        'should map AppApiException to AuthExpiredSessionException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiServerException(message: 'server', statusCode: 500));

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<AuthExpiredSessionException>()),
          );
        },
      );

      test('should rethrow AppException unchanged', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.refresh,
            data: any(named: 'data'),
          ),
        ).thenThrow(AppUnknownException(message: 'app-level'));

        await expectLater(
          () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
          throwsA(isA<AppUnknownException>()),
        );
      });

      test(
        'should map unknown exception to AuthExpiredSessionException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(Exception('boom'));

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<AuthExpiredSessionException>()),
          );
        },
      );
    });

    group('logOut', () {
      test('should complete when API call succeeds', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logOut,
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => FakeResponse());

        await authRepo.logOut(sessionId: 'session-id');

        verify(
          () => mockHttpClient.post(
            path: ApiEndpoints.logOut,
            data: <String, dynamic>{'sessionId': 'session-id'},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test(
        'should map ApiUnauthorizedException to AuthUnauthorizedException',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logOut,
              data: any(named: 'data'),
            ),
          ).thenThrow(
            ApiUnauthorizedException(message: 'unauthorized', statusCode: 401),
          );

          await expectLater(
            () => authRepo.logOut(sessionId: 'session-id'),
            throwsA(isA<AuthUnauthorizedException>()),
          );
        },
      );

      test('should map AppApiException to AppUnknownException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logOut,
            data: any(named: 'data'),
          ),
        ).thenThrow(ApiServerException(message: 'server', statusCode: 500));

        await expectLater(
          () => authRepo.logOut(sessionId: 'session-id'),
          throwsA(isA<AppUnknownException>()),
        );
      });

      test('should rethrow AppException unchanged', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logOut,
            data: any(named: 'data'),
          ),
        ).thenThrow(AppUnknownException(message: 'app-level'));

        await expectLater(
          () => authRepo.logOut(sessionId: 'session-id'),
          throwsA(isA<AppUnknownException>()),
        );
      });

      test('should map unknown exception to AppUnknownException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logOut,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('boom'));

        await expectLater(
          () => authRepo.logOut(sessionId: 'session-id'),
          throwsA(isA<AppUnknownException>()),
        );
      });
    });
  });
}
