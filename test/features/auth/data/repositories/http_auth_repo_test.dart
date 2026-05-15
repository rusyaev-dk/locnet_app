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
            throwsA(
              isA<AppUnknownException>().having(
                (exception) => exception.message,
                'message',
                contains('Invalid API response format'),
              ),
            ),
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
        'should rethrow AppException unchanged (ApiUnauthorizedException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          await expectLater(
            () => authRepo.logIn(username: 'john', password: 'bad'),
            throwsA(isA<ApiUnauthorizedException>()),
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
        'should rethrow AppException unchanged (ApiValidationException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiValidationException(message: 'validation'));

          await expectLater(
            () => authRepo.logIn(username: 'john', password: '123'),
            throwsA(isA<ApiValidationException>()),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (AppUnknownException)',
        () async {
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
        },
      );

      test('should wrap unknown exception into AppUnknownException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logIn,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('boom'));

        await expectLater(
          () => authRepo.logIn(username: 'john', password: '123'),
          throwsA(
            isA<AppUnknownException>()
                .having(
                  (exception) => exception.message,
                  'message',
                  'Failed to login',
                )
                .having(
                  (exception) => exception.error,
                  'error',
                  isA<Exception>(),
                ),
          ),
        );
      });

      test(
        'should include deviceInfo into request body when provided',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: buildSessionJson()));

          const DeviceInfo deviceInfo = DeviceInfo(
            ipAddress: '127.0.0.1',
            macAddress: '00:11:22:33:44:55',
            deviceName: 'Pixel',
            deviceType: 'phone',
            operatingSystem: 'android',
          );

          await authRepo.logIn(
            username: 'john',
            password: '123',
            deviceInfo: deviceInfo,
          );

          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.logIn,
              data: <String, dynamic>{
                'username': 'john',
                'password': '123',
                'deviceInfo': <String, dynamic>{
                  'IPAddress': '127.0.0.1',
                  'macAddress': '00:11:22:33:44:55',
                  'deviceName': 'Pixel',
                  'deviceType': 'phone',
                  'OS': 'android',
                },
              },
            ),
          ).called(1);

          verifyNoMoreInteractions(mockHttpClient);
        },
      );
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
            throwsA(
              isA<AppUnknownException>().having(
                (exception) => exception.message,
                'message',
                contains('Invalid API response format'),
              ),
            ),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (ApiValidationException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiValidationException(message: 'validation'));

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<ApiValidationException>()),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (ApiUnauthorizedException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          await expectLater(
            () => authRepo.register(
              username: 'john',
              firstName: 'John',
              lastName: 'Doe',
              password: '123',
            ),
            throwsA(isA<ApiUnauthorizedException>()),
          );
        },
      );

      test('should wrap unknown exception into AppUnknownException', () async {
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
          throwsA(
            isA<AppUnknownException>()
                .having(
                  (exception) => exception.message,
                  'message',
                  'Failed to register',
                )
                .having(
                  (exception) => exception.error,
                  'error',
                  isA<Exception>(),
                ),
          ),
        );
      });

      test(
        'should include deviceInfo into request body when provided',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: buildSessionJson()));

          const DeviceInfo deviceInfo = DeviceInfo(
            ipAddress: '127.0.0.1',
            macAddress: '00:11:22:33:44:55',
            deviceName: 'Pixel',
            deviceType: 'phone',
            operatingSystem: 'android',
          );

          await authRepo.register(
            username: 'john',
            firstName: 'John',
            lastName: 'Doe',
            password: '123',
            deviceInfo: deviceInfo,
          );

          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.register,
              data: <String, dynamic>{
                'username': 'john',
                'firstName': 'John',
                'lastName': 'Doe',
                'patronymic': null,
                'description': null,
                'password': '123',
                'deviceInfo': <String, dynamic>{
                  'IPAddress': '127.0.0.1',
                  'macAddress': '00:11:22:33:44:55',
                  'deviceName': 'Pixel',
                  'deviceType': 'phone',
                  'OS': 'android',
                },
              },
            ),
          ).called(1);

          verifyNoMoreInteractions(mockHttpClient);
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
            throwsA(
              isA<AppUnknownException>().having(
                (exception) => exception.message,
                'message',
                contains('Invalid API response format'),
              ),
            ),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (ApiUnauthorizedException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<ApiUnauthorizedException>()),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (ApiForbiddenException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiForbiddenException(message: 'forbidden'));

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<ApiForbiddenException>()),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (ApiValidationException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiValidationException(message: 'validation'));

          await expectLater(
            () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
            throwsA(isA<ApiValidationException>()),
          );
        },
      );

      test('should wrap unknown exception into AppUnknownException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.refresh,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('boom'));

        await expectLater(
          () => authRepo.refresh(refreshToken: 'rt', sessionId: 'sid'),
          throwsA(
            isA<AppUnknownException>()
                .having(
                  (exception) => exception.message,
                  'message',
                  'Failed to refresh session',
                )
                .having(
                  (exception) => exception.error,
                  'error',
                  isA<Exception>(),
                ),
          ),
        );
      });

      test(
        'should include deviceInfo into request body when provided',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => FakeResponse(data: buildSessionJson()));

          const DeviceInfo deviceInfo = DeviceInfo(
            ipAddress: '127.0.0.1',
            macAddress: '00:11:22:33:44:55',
            deviceName: 'Pixel',
            deviceType: 'phone',
            operatingSystem: 'android',
          );

          await authRepo.refresh(
            refreshToken: 'refresh-token',
            sessionId: 'session-id',
            deviceInfo: deviceInfo,
          );

          verify(
            () => mockHttpClient.post(
              path: ApiEndpoints.refresh,
              data: <String, dynamic>{
                'refreshToken': 'refresh-token',
                'sessionId': 'session-id',
                'deviceInfo': <String, dynamic>{
                  'IPAddress': '127.0.0.1',
                  'macAddress': '00:11:22:33:44:55',
                  'deviceName': 'Pixel',
                  'deviceType': 'phone',
                  'OS': 'android',
                },
              },
            ),
          ).called(1);

          verifyNoMoreInteractions(mockHttpClient);
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
        'should rethrow AppException unchanged (ApiUnauthorizedException)',
        () async {
          when(
            () => mockHttpClient.post(
              path: ApiEndpoints.logOut,
              data: any(named: 'data'),
            ),
          ).thenThrow(ApiUnauthorizedException(message: 'unauthorized'));

          await expectLater(
            () => authRepo.logOut(sessionId: 'session-id'),
            throwsA(isA<ApiUnauthorizedException>()),
          );
        },
      );

      test(
        'should rethrow AppException unchanged (AppUnknownException)',
        () async {
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
        },
      );

      test('should wrap unknown exception into AppUnknownException', () async {
        when(
          () => mockHttpClient.post(
            path: ApiEndpoints.logOut,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('boom'));

        await expectLater(
          () => authRepo.logOut(sessionId: 'session-id'),
          throwsA(
            isA<AppUnknownException>()
                .having(
                  (exception) => exception.message,
                  'message',
                  'Failed to logout',
                )
                .having(
                  (exception) => exception.error,
                  'error',
                  isA<Exception>(),
                ),
          ),
        );
      });
    });
  });
}
