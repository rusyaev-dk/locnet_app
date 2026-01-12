final class ApiConfig {
  ApiConfig({required this.baseUrl});

  final String baseUrl;
}

abstract class ApiEndpoints {
  static const String users = "/users";
  static const String register = "/auth/register";
  static const String logIn = "/auth/login";
  static const String refresh = "/auth/refresh";
  static const String logOut = "/auth/logout";
}
