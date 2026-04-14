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
  static const String validateRegisterLogin = "/auth/register/validate-login";
  static const String logIn = "/auth/login";
  static const String refresh = "/auth/refresh";
  static const String logOut = "/auth/logout";

  // Search
  static const String unifiedSearch = "/search/unified";

  // Private conversations
  static const String privateConversations = "/private-chats/conversations";
  static String privateConversation(String conversationId) =>
      "/private-chats/conversations/$conversationId";

  static String privateConversationMessages(String conversationId) =>
      "/private-chats/conversations/$conversationId/messages";

  static const String conversationsList = "/private-chats/conversations/tiles";

  /// Send a private message (POST). The conversationId is in the body.
  static const String privateMessages = "/private-chats/messages";

  static String privateConversationMessage(
    String conversationId,
    String messageId,
  ) => "/private-chats/conversations/$conversationId/messages/$messageId";
}
