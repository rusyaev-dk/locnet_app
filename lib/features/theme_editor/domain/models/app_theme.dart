// ignore_for_file: sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';
import 'package:locnet_app/uikit/uikit.dart';

class AppTheme extends Equatable {
  const AppTheme({required this.lightPalette, required this.darkPalette});

  final AppColorPalette lightPalette;
  final AppColorPalette darkPalette;

  AppTheme copyWith({
    AppColorPalette? lightPalette,
    AppColorPalette? darkPalette,
  }) {
    return AppTheme(
      lightPalette: lightPalette ?? this.lightPalette,
      darkPalette: darkPalette ?? this.darkPalette,
    );
  }

  factory AppTheme.basic() {
    return AppTheme(
      lightPalette: AppColorPalette.fromColorScheme(
        const AppColorScheme.light(),
      ),
      darkPalette: AppColorPalette.fromColorScheme(const AppColorScheme.dark()),
    );
  }

  @override
  List<Object?> get props => <Object?>[lightPalette, darkPalette];
}

extension AppThemeSerialization on AppTheme {
  String toJsonString() {
    final Map<String, dynamic> json = <String, dynamic>{
      'lightPalette': lightPalette.toJson(),
      'darkPalette': darkPalette.toJson(),
    };

    return jsonEncode(json);
  }

  static AppTheme fromJsonString(String source) {
    final Map<String, dynamic> json =
        jsonDecode(source) as Map<String, dynamic>;

    return AppTheme(
      lightPalette: AppColorPaletteSerialization.fromJson(
        json['lightPalette'] as Map<String, dynamic>,
      ),
      darkPalette: AppColorPaletteSerialization.fromJson(
        json['darkPalette'] as Map<String, dynamic>,
      ),
    );
  }
}
