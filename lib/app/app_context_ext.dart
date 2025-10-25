import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/gen/gen.dart';
import 'package:locnet_app/uikit/uikit.dart';
import 'package:provider/provider.dart';

extension AppContextExt on BuildContext {
  AppConfig get appConfig => Provider.of<AppConfig>(this);

  AppThemeData get theme => Provider.of<AppThemeData>(this);

  AppColorScheme get colorScheme => AppColorScheme.of(this);
  AppTextScheme get textScheme => AppTextScheme.of(this);

  S get l10n => S.of(this);
}
