import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/mock/mock_backend_storage.dart';
import 'package:provider/provider.dart';

class AppProvidersWrapper extends StatelessWidget {
  const AppProvidersWrapper({
    required this.appScope,
    required this.child,
    super.key,
  });

  final AppScope appScope;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final backendStorage = MockBackendStorage();

    return MultiProvider(
      providers: [
        Provider<AppScope>(create: (context) => appScope),
        Provider<ILogger>(create: (context) => appScope.logger),
        Provider<IHttpClient>(
          create: (context) =>
              DioHttpClient(dio: appScope.dio, apiConfig: appScope.apiConfig),
        ),
        Provider<IWebSocketClient>(create: (context) => MockWebSocketClient()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IUserRepo>(
            create: (context) =>
                MockMemoryUserRepo(backendStorage: backendStorage),
          ),
          RepositoryProvider<IAuthRepo>(
            create: (context) => const MockAuthRepo(),
          ),
          RepositoryProvider<IConversationRepo>(
            create: (context) => MockWebSocketConversationRepo(
              backendStorage: backendStorage,
              // webSocketClient: context.read<IWebSocketClient>(),
              logger: appScope.logger,
            ),
          ),
          RepositoryProvider<IConversationsListRepo>(
            create: (context) => MockWebSocketConversationsListRepo(
              // webSocketClient: context.read<IWebSocketClient>(),
              backendStorage: backendStorage,
              logger: appScope.logger,
            ),
          ),

          RepositoryProvider<ISettingsRepo>(
            create: (context) => SettingsRepo(
              storage: appScope.storageAggregator.sharedPrefsStorage,
            ),
          ),
          RepositoryProvider<IUserCacheRepo>(
            create: (context) => UserCacheRepo(
              storage: appScope.storageAggregator.secureStorage,
            ),
          ),
          RepositoryProvider<ISessionCacheRepo>(
            create: (context) {
              final cacheRepo = SessionCacheRepo(
                storage: appScope.storageAggregator.secureStorage,
              );
              appScope.dio.interceptors.add(
                JWTInterceptor(
                  sessionCacheRepo: cacheRepo,
                  logger: appScope.logger,
                ),
              );
              return cacheRepo;
            },
          ),
        ],
        child: _InteractorProviders(child: _BlocProviders(child: child)),
      ),
    );
  }
}

class _InteractorProviders extends StatelessWidget {
  const _InteractorProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsInteractor>(
          create: (context) =>
              SettingsInteractor(settingsRepo: context.read<ISettingsRepo>()),
        ),
        RepositoryProvider<UserInteractor>(
          create: (context) => UserInteractor(
            userRepo: context.read<IUserRepo>(),
            logger: context.read<ILogger>(),
          ),
        ),
        RepositoryProvider<AuthInteractor>(
          lazy: false,
          create: (context) => AuthInteractor(
            authRepo: context.read<IAuthRepo>(),
            userRepo: context.read<IUserRepo>(),
            sessionCacheRepo: context.read<ISessionCacheRepo>(),
            userCacheRepo: context.read<IUserCacheRepo>(),
            logger: context.read<ILogger>(),
          ),
        ),
      ],
      child: child,
    );
  }
}

class _BlocProviders extends StatelessWidget {
  const _BlocProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appScope = context.read<AppScope>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
            authInteractor: context.read<AuthInteractor>(),
            logger: appScope.logger,
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SettingsCubit(
            settingsInteractor: context.read<SettingsInteractor>(),
            authInteractor: context.read<AuthInteractor>(),
            logger: appScope.logger,
          ),
        ),
      ],
      child: child,
    );
  }
}
