final class ApiConfig {
  ApiConfig({required this.baseUrl, required this.baseSocketUrl});

  String baseUrl;
  String baseSocketUrl;

  void applyUrls({
    required String baseUrl,
    required String baseSocketUrl,
  }) {
    this.baseUrl = baseUrl;
    this.baseSocketUrl = baseSocketUrl;
  }
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

  // Media
  static const String mediaInit = "/media/init";
  static String media(String mediaId) => "/media/$mediaId";
  static String mediaComplete(String mediaId) => "/media/$mediaId/complete";
  static String mediaMetadata(String mediaId) => "/media/$mediaId/metadata";
  static String mediaDownload(String mediaId) => "/media/$mediaId/download";

  static String privateConversationMessage(
    String conversationId,
    String messageId,
  ) => "/private-chats/conversations/$conversationId/messages/$messageId";

  static String privateConversationMessageRead(
    String conversationId,
    String messageId,
  ) => "/private-chats/conversations/$conversationId/messages/$messageId/read";
}
