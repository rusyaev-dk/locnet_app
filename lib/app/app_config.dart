import 'package:flutter/widgets.dart';
import 'package:locnet_app/core/core.dart';

final class AppConfig {
  static const String defaultLanguageCode = AppLanguages.ru;
  static const String defaultThemeMode = "system";
  static const String defaultTextScale = "m";
}

abstract class AppLanguages {
  static const String ru = "ru";
  static const String uz = "uz";
  static const String en = "en";

  static List<String> toList() => [ru, uz, en];

  static List<Locale> toLocalesList() => [
    const Locale(ru),
    const Locale(uz),
    const Locale(en),
  ];
}

abstract class AppRoles {
  static const Role admin = Role.admin;
  static const Role user = Role.user;

  static List<Role> toList() => [admin, user];
}
