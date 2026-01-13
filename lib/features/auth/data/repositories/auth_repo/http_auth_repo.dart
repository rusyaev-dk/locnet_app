import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class HttpAuthRepo implements IAuthRepo {
  HttpAuthRepo({required IHttpClient httpClient}) : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Future<Session> logIn({
    required String username,
    required String password,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.logIn,
        data: <String, dynamic>{'username': username, 'password': password},
      );

      final dynamic responseData = httpResponse.data;

      if (responseData is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid login response format',
          error: responseData,
          stackTrace: StackTrace.current,
        );
      }

      return Session.fromJson(responseData);
    } on ApiUnauthorizedException catch (e, st) {
      throw AuthInvalidCredentialsException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiValidationException catch (e, st) {
      final String? usernameError = _getFieldError(e.errors, 'username');
      final String? passwordError = _getFieldError(e.errors, 'password');

      if (usernameError != null || passwordError != null) {
        throw AuthInvalidCredentialsException(
          message: usernameError ?? passwordError ?? e.message,
          error: e,
          stackTrace: st,
        );
      }

      throw LogInFailedException(message: e.message, error: e, stackTrace: st);
    } on AppApiException catch (e, st) {
      throw LogInFailedException(
        message: 'Auth API error',
        error: e,
        stackTrace: st,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw LogInFailedException(
        message: 'Failed to login',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Session> register({
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    String? patronymic,
    String? description,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.register,
        data: <String, dynamic>{
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'description': description,
          'password': password,
        },
      );

      final dynamic responseData = httpResponse.data;

      if (responseData is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid registration response format',
          error: responseData,
          stackTrace: StackTrace.current,
        );
      }

      return Session.fromJson(responseData);
    } on ApiValidationException catch (e, st) {
      final String? usernameError = _getFieldError(e.errors, 'username');
      if (usernameError != null) {
        throw UsernameAlreadyTakenException(
          message: usernameError,
          error: e,
          stackTrace: st,
        );
      }

      final String? passwordError = _getFieldError(e.errors, 'password');
      if (passwordError != null) {
        throw RegistrationFailedException(
          message: passwordError,
          error: e,
          stackTrace: st,
        );
      }

      throw RegistrationFailedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiUnauthorizedException catch (e, st) {
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on AppApiException catch (e, st) {
      throw RegistrationFailedException(
        message: 'Auth API error',
        error: e,
        stackTrace: st,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw RegistrationFailedException(
        message: 'Failed to register',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Session> refresh({
    required String refreshToken,
    required String sessionId,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.refresh,
        data: <String, dynamic>{
          'refreshToken': refreshToken,
          'sessionId': sessionId,
        },
      );

      final dynamic responseData = httpResponse.data;

      if (responseData is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid refresh response format',
          error: responseData,
          stackTrace: StackTrace.current,
        );
      }

      return Session.fromJson(responseData);
    } on ApiUnauthorizedException catch (e, st) {
      throw AuthExpiredSessionException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiForbiddenException catch (e, st) {
      throw AuthExpiredSessionException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on ApiValidationException catch (e, st) {
      throw AuthExpiredSessionException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on AppApiException catch (e, st) {
      throw AuthExpiredSessionException(
        message: 'Auth API error',
        error: e,
        stackTrace: st,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AuthExpiredSessionException(
        message: 'Failed to refresh session',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> logOut({required String sessionId}) async {
    try {
      await _httpClient.post(
        path: ApiEndpoints.logOut,
        data: <String, dynamic>{'sessionId': sessionId},
      );
    } on ApiUnauthorizedException catch (e, st) {
      throw AuthUnauthorizedException(
        message: e.message,
        error: e,
        stackTrace: st,
      );
    } on AppApiException catch (e, st) {
      throw AppUnknownException(
        message: 'Auth API error',
        error: e,
        stackTrace: st,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to logout',
        error: e,
        stackTrace: st,
      );
    }
  }

  String? _getFieldError(Map<String, dynamic>? errors, String fieldName) {
    if (errors == null) {
      return null;
    }

    final dynamic fieldValue = errors[fieldName];

    if (fieldValue is String && fieldValue.isNotEmpty) {
      return fieldValue;
    }

    if (fieldValue is List && fieldValue.isNotEmpty) {
      final dynamic firstValue = fieldValue.first;
      if (firstValue is String && firstValue.isNotEmpty) {
        return firstValue;
      }
    }

    return null;
  }
}
