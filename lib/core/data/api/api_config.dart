final class ApiConfig {
  ApiConfig({required this.baseUrl});

  final String baseUrl;
}

abstract class ApiEndpoints {
  static const String users = "/users";
  static String userProfileById(String id) => "/users/$id/profile";
}
