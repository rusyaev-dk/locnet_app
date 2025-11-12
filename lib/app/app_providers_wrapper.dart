import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
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
    return MultiProvider(
      providers: [
        Provider<AppScope>(create: (context) => appScope),
        Provider<ILogger>(create: (context) => appScope.logger),
        Provider<IHttpClient>(
          create: (context) =>
              DioHttpClient(dio: appScope.dio, apiConfig: appScope.apiConfig),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ISettingsRepo>(
            create: (context) => SettingsRepo(
              storage: appScope.storageAggregator.sharedPrefsStorage,
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
        RepositoryProvider<AuthInteractor>(
          lazy: false,
          create: (context) => AuthInteractor(),
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
            settingsRepository: context.read<ISettingsRepo>(),
            logger: appScope.logger,
          ),
        ),
      ],
      child: child,
    );
  }
}
