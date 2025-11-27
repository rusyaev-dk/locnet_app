abstract class AppRoutes {
  static const String login = "/login";
  static const String registration = "/registration";
  static const String home = '/home';
  static const String conversations = '/home/conversations';
  static const String storage = '/home/storage';
  static const String settings = '/home/settings';
  static const String profile = '/home/profile';

  static String somePageWithArg(String arg) => "/home/somepage/$arg";
  static String conversation(String conversationId) =>
      "/home/conversations/$conversationId";
}
