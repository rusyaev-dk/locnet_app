import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/core/presentation/navigation/router.dart';
import 'package:locnet_app/core/utils/utils.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/error/error_screen.dart';
import 'package:locnet_app/runners/runners.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'errors_handlers.dart';

/// Timeout for initializing dependencies.
/// If exceeded, an error screen will be shown.
/// Should be moved to env later.
const _initTimeout = Duration(seconds: 7);

/// Runner class that configures the app on startup.
///
/// Initialization order:
/// 1. _initApp — initialize app configuration
/// 2. initialize app repositories (to be added)
/// 3. runApp — launch the application
/// 4. _onAppLoaded — after the app is launched
class AppRunner {
  AppRunner(this.env);

  final AppEnv env;
  late final GoRouter router;
  late final TimerRunner _timerRunner;

  Future<void> run() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      final talker = TalkerFlutter.init();
      final ILogger logger = AppLogger(talker: talker);
      _timerRunner = TimerRunner(logger: logger);

      await dotenv.load(fileName: 'env/${env.fileName}');
      logger.log('Environment file loaded. Env type: ${env.name}');

      await _initApp();
      _initErrorHandlers(logger, env);

      runApp(
        TemplateApp(
          initDependencies: () {
            return _initDependencies(
              logger: logger,
              talker: talker,
              env: env,
              timerRunner: _timerRunner,
            ).timeout(
              _initTimeout,
              onTimeout: () {
                return Future.error(
                  TimeoutException(
                    'Dependency initialization timeout exceeded',
                  ),
                );
              },
            );
          },
        ),
      );
      await _onAppLoaded();
    } on Object catch (e, stackTrace) {
      await _onAppLoaded();

      /// If an error occurs during app initialization,
      /// start the error screen.
      runApp(
        ErrorScreen(error: e, stackTrace: stackTrace, onRetry: run, env: env),
      );
    }
  }

  /// App initialization method executed before the app starts.
  Future<void> _initApp() async {
    // Lock device orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Defer the first frame (splash)
    WidgetsBinding.instance.deferFirstFrame();
  }

  /// Method invoked after the app has started.
  Future<void> _onAppLoaded() async {
    _timerRunner.stop();

    // Allow the first frame (splash)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.allowFirstFrame();
    });
  }

  Future<AppScope> _initDependencies({
    required ILogger logger,
    required Talker talker,
    required AppEnv env,
    required TimerRunner timerRunner,
  }) async {
    // TODO: remove the delay
    await Future.delayed(const Duration(milliseconds: 1500));
    logger.log('Build type: ${env.name}');

    final dio = Dio();

    if (env == AppEnv.dev || env == AppEnv.stage) {
      Bloc.observer = TalkerBlocObserver(talker: talker);
      dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
          ),
        ),
      );
    }

    final sharedPrefs = await SharedPreferences.getInstance();
    const flutterSecureStorage = FlutterSecureStorage();

    final secureStorage = SecureStorage(secureStorage: flutterSecureStorage);
    final sharedPrefsStorage = SharedPrefsStorage(
      sharedPreferences: sharedPrefs,
    );
    final storageAggregator = StorageAggregator(
      secureStorage: secureStorage,
      sharedPrefsStorage: sharedPrefsStorage,
    );

    final apiConfig = ApiConfig(env);
    final httpClient = DioHttpClient(dio: dio, apiConfig: apiConfig);
    final authTokenProvider = AuthTokenProvider(
      httpClient: httpClient,
      tokenStorage: storageAggregator.secureStorage,
    );

    dio.interceptors.add(
      JwtRefreshInterceptor(authTokenProvider: authTokenProvider),
    );

    return AppScope(
      env: env,
      appConfig: AppConfig(),
      apiConfig: apiConfig,
      sharedPreferences: sharedPrefs,
      flutterSecureStorage: flutterSecureStorage,
      storageAggregator: storageAggregator,
      talker: talker,
      routeObserver: TalkerRouteObserver(talker),
      dio: dio,
      logger: logger,
    );
  }
}
