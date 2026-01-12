import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
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
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';
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
    final IAppEnvPreset envPreset = AppEnvPresetsFactory.create(
      appScope: appScope,
    );

    return MultiProvider(
      providers: [
        Provider<AppScope>(create: (context) => appScope),
        Provider<ILogger>(create: (context) => appScope.logger),
        Provider<IHttpClient>(
          create: (context) =>
              DioHttpClient(dio: appScope.dio, apiConfig: appScope.apiConfig),
        ),
        Provider<IWebSocketClient>(create: (context) => MockWebSocketClient()),
        Provider<IAppEnvPreset>(create: (context) => envPreset,)
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IUserRepo>(
            create: (context) => envPreset.createUserRepo(),
          ),
          RepositoryProvider<IAuthRepo>(
            create: (context) => envPreset.createAuthRepo(),
          ),
          RepositoryProvider<IConversationRepo>(
            create: (context) => envPreset.createConversationRepo(),
          ),
          RepositoryProvider<IConversationsListRepo>(
            create: (context) => envPreset.createConversationsListRepo(),
          ),

          RepositoryProvider<ISettingsRepo>(
            create: (context) => envPreset.createSettingsRepo(),
          ),
          RepositoryProvider<IThemeEditorRepo>(
            create: (context) => envPreset.createThemeEditorRepo(),
          ),
          RepositoryProvider<IUserCacheRepo>(
            create: (context) => LocalUserCacheRepo(
              storage: appScope.storageAggregator.secureStorage,
            ),
          ),
          RepositoryProvider<ISessionCacheRepo>(
            create: (context) {
              final cacheRepo = LocalSessionCacheRepo(
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
        RepositoryProvider<ThemeEditorInteractor>(
          create: (context) =>
              ThemeEditorInteractor(themeEditorRepo: context.read<IThemeEditorRepo>()),
        ),
        RepositoryProvider<UserInteractor>(
          create: (context) => UserInteractor(
            userRepo: context.read<IUserRepo>(),
            userCacheRepo: context.read<IUserCacheRepo>(),
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
            userInteractor: context.read<UserInteractor>(),
            logger: appScope.logger,
          )..restoreOrFetch(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SettingsCubit(
            settingsInteractor: context.read<SettingsInteractor>(),
            authInteractor: context.read<AuthInteractor>(),
            themeConstructorInteractor: context.read<ThemeEditorInteractor>(),
            logger: appScope.logger,
          )..restoreSettings(),
        ),
      ],
      child: child,
    );
  }
}
