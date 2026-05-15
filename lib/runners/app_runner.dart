import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/data/storage/db/encryption/encryption.dart';
import 'package:locnet_app/core/presentation/navigation/router.dart';
import 'package:locnet_app/core/utils/utils.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/error/error_screen.dart';
import 'package:locnet_app/features/server_config/data/data.dart';
import 'package:locnet_app/features/server_config/domain/domain.dart';
import 'package:locnet_app/runners/runners.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'errors_handlers.dart';

const _initTimeout = Duration(seconds: 7);

class AppRunner {
  AppRunner(this.env);

  final AppEnvType env;
  late final GoRouter router;
  late final TimerRunner _timerRunner;

  Future<void> run() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      if (kIsWeb) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await BrowserContextMenu.disableContextMenu();
        });
      }

      final talker = TalkerFlutter.init();
      final ILogger logger = AppLogger(talker: talker);
      _timerRunner = TimerRunner(logger: logger);

      await dotenv.load(fileName: 'env/${env.toString()}');
      logger.log('Environment file loaded. Env type: ${env.name}');

      await _initApp();
      _initErrorHandlers(logger, env);

      runApp(
        LocnetApp(
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
    required AppEnvType env,
    required TimerRunner timerRunner,
  }) async {
    logger.log('Build type: ${env.name}');

    final dio = Dio();

    if (env == AppEnvType.dev || env == AppEnvType.stage) {
      Bloc.observer = TalkerBlocObserver(
        talker: talker,
        settings: const TalkerBlocLoggerSettings(
          printEventFullData: false,
          printStateFullData: false,
        ),
      );
      dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printRequestData: false,
          ),
        ),
      );
    }

    final sharedPrefs = await SharedPreferences.getInstance();
    const flutterSecureStorage = FlutterSecureStorage();

    final secureStorage =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS
        ? LocalKeyValueStorage(sharedPreferences: sharedPrefs)
        : SecureStorage(flutterSecureStorage: flutterSecureStorage);
    final localKeyValueStorage = LocalKeyValueStorage(
      sharedPreferences: sharedPrefs,
    );

    final keyProvider = DbEncryptionKeyProvider(secureStorage: secureStorage);
    final encryptionKey = await keyProvider.getOrCreateKey();

    final QueryExecutor executor = kIsWeb
        ? AppDatabase.openWeb()
        : await AppDatabase.openEncrypted(encryptionKey);

    final db = AppDatabase(executor);
    unawaited(
      db.evictStale().catchError((Object e, StackTrace st) {
        logger.warning('DB stale eviction failed: $e');
      }),
    );
    final storageAggregator = StorageAggregator(
      secureStorage: secureStorage,
      localKeyValueStorage: localKeyValueStorage,
      db: db,
    );

    final defaultConfig = ServerConfig(
      baseUrl: dotenv.env['BASE_URL']!,
      socketBaseUrl: dotenv.env['BASE_SOCKET_URL']!,
    );
    final serverConfigRepo = LocalServerConfigRepo(
      storage: localKeyValueStorage,
      defaults: defaultConfig,
    );
    final serverConfig = await serverConfigRepo.getConfig();

    final apiConfig = ApiConfig(
      baseUrl: serverConfig.baseUrl,
      baseSocketUrl: serverConfig.socketBaseUrl,
    );
    final appConfig = AppConfig();

    return AppScope(
      env: env,
      appConfig: appConfig,
      apiConfig: apiConfig,
      serverConfigRepo: serverConfigRepo,
      initialServerConfig: serverConfig,
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
