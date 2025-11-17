abstract class AppRoutes {
  static const String login = "/login";
  static const String registration = "/registration";
  static const String panel = "/panel";
  static const String settings = "/panel/settings";
  static const String welcome = "/panel/welcome";

  static String somePageWithArg(String arg) => "/home/somepage/$arg";
}
