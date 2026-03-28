final class ApiConfig {
  ApiConfig({required this.baseUrl});

  final String baseUrl;
}

abstract class ApiEndpoints {
  // Users
  static const String users = "/users";
  static String userById(String userId) => "/users/$userId";

  // Auth
  static const String register = "/auth/register";
  static const String logIn = "/auth/login";
  static const String refresh = "/auth/refresh";
  static const String logOut = "/auth/logout";

  // Private conversations
  static const String privateConversations = "/private-chats/conversations";
  static String privateConversation(String conversationId) =>
      "/private-chats/conversations/$conversationId";

  static String privateConversationMessages(String conversationId) =>
      "/private-chats/$conversationId/messages";

  static String privateConversationMessage(
    String conversationId,
    String messageId,
  ) => "/private-chats/messages/$messageId";
}
