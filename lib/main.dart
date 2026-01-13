import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/runners/app_runner.dart';

// flutter run --dart-define=APP_ENV=stage

// flutter run --web-port=63192 --dart-define=APP_ENV=stage
void main() {
  const envString = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  final AppEnvType env = switch (envString) {
    'dev' => AppEnvType.dev,
    'stage' => AppEnvType.stage,
    'prod' => AppEnvType.prod,
    _ => throw Exception('Unknown APP_ENV: $envString'),
  };

  AppRunner(env).run();
}
