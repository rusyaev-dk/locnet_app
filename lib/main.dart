import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/runners/app_runner.dart';

// flutter run --dart-define=APP_ENV=stage

// flutter build web --dart-define=APP_ENV=stage
// python3 -m http.server 63192 --directory build/web
// flutter run --web-port=63192 --dart-define=APP_ENV=stage

// flutter run -d macos --debug

void main() {
  const envString = String.fromEnvironment('APP_ENV', defaultValue: 'stage');

  final AppEnvType env = switch (envString) {
    'dev' => AppEnvType.dev,
    'stage' => AppEnvType.stage,
    'prod' => AppEnvType.prod,
    _ => throw Exception('Unknown APP_ENV: $envString'),
  };

  AppRunner(env).run();
}
