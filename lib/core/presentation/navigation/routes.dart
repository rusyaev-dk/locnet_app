abstract class AppRoutes {
  static const String login = "/login";
  static const String registration = "/registration";
  static const String home = '/home';
  static const String conversations = '/conversations';
  static const String storage = '/storage';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String passcodeLock = '/passcode-lock';

  static String conversation(String conversationId) =>
      "/conversations/$conversationId";

  static String conversationDraft(String companionId) =>
      "/conversations/draft/$companionId";
}
