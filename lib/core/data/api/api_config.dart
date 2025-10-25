import 'package:locnet_app/app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class ApiConfig {
  factory ApiConfig(AppEnv env) {
    final path = switch (env) {
      AppEnv.dev => 'env/dev.env',
      AppEnv.stage => 'env/stage.env',
      AppEnv.prod => 'env/prod.env',
    };

    dotenv.load(fileName: path);

    return ApiConfig._internal(
      env,
      dotenv.env['BASE_URL'] ?? 'MISSING_BASE_URL',
    );
  }

  ApiConfig._internal(this.env, this.baseUrl);

  final String baseUrl;
  final AppEnv env;
}

abstract class ApiEndpoints {
  static const String users = "/users";
  static String userProfileById(String id) => "/users/$id/profile";
}
