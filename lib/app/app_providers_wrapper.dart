import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/interactors/media_interactor.dart';
import 'package:locnet_app/features/passcode/data/data.dart';
import 'package:locnet_app/features/passcode/domain/domain.dart';
import 'package:locnet_app/features/passcode/presentation/presentation.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/data/repositories/settings_cache_database_repo/drift_settings_cache_database_repo.dart';
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
        Provider<UnauthorizedEventBus>(
          create: (context) => UnauthorizedEventBus(),
        ),
        Provider<IHttpClient>(
          create: (context) =>
              DioHttpClient(dio: appScope.dio, apiConfig: appScope.apiConfig),
        ),

        Provider<IAppEnvPreset>(create: (context) => envPreset),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IUserRepo>(
            create: (context) => envPreset.createUserRepo(),
          ),
          RepositoryProvider<IAuthRepo>(
            create: (context) => envPreset.createAuthRepo(),
          ),
          RepositoryProvider<IConversationsListRepo>(
            create: (context) => envPreset.createConversationsListRepo(),
          ),
          RepositoryProvider<IDeviceInfoRepo>(
            create: (context) => envPreset.createDeviceInfoRepo(),
          ),
          RepositoryProvider<ISettingsRepo>(
            create: (context) => envPreset.createSettingsRepo(),
          ),
          RepositoryProvider<IThemeRepository>(
            create: (context) => envPreset.createThemeRepo(),
          ),
          RepositoryProvider<IThemeEditorRepo>(
            create: (context) => envPreset.createThemeEditorRepo(),
          ),
          RepositoryProvider<IUnifiedSearchRepo>(
            create: (context) => envPreset.createUnifiedSearchRepo(),
          ),
          RepositoryProvider<IPrivateMessageRepo>(
            create: (context) => envPreset.createPrivateMessageRepo(),
          ),
          RepositoryProvider<IGroupMessageRepo>(
            create: (context) => envPreset.createGroupMessageRepo(),
          ),
          RepositoryProvider<IChannelPublicationRepo>(
            create: (context) => envPreset.createChannelPublicationRepo(),
          ),
          RepositoryProvider<IUserCacheRepo>(
            create: (context) {
              final bool useMacOsFallbackStorage =
                  !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
              final IKeyValueStorage storageForUser = useMacOsFallbackStorage
                  ? appScope.storageAggregator.localKeyValueStorage
                  : appScope.storageAggregator.secureStorage;
              return LocalUserCacheRepo(storage: storageForUser);
            },
          ),
          RepositoryProvider<IAuthTokenRefreshRepo>(
            create: (context) => HttpAuthTokenRefreshRepo(
              httpClient: context.read<IHttpClient>(),
              deviceInfoRepo: context.read<IDeviceInfoRepo>(),
            ),
          ),
          RepositoryProvider<IPasscodeRepo>(
            create: (context) {
              final bool useMacOsFallbackStorage =
                  !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
              final IKeyValueStorage secureStorage = useMacOsFallbackStorage
                  ? appScope.storageAggregator.localKeyValueStorage
                  : appScope.storageAggregator.secureStorage;
              return LocalPasscodeRepo(
                secureStorage: secureStorage,
                localStorage: appScope.storageAggregator.localKeyValueStorage,
              );
            },
          ),
          RepositoryProvider<PasscodeInteractor>(
            create: (context) =>
                PasscodeInteractor(passcodeRepo: context.read<IPasscodeRepo>()),
          ),
          RepositoryProvider<ISessionCacheRepo>(
            create: (context) {
              final bool useMacOsFallbackStorage =
                  !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
              final IKeyValueStorage storageForSession = useMacOsFallbackStorage
                  ? appScope.storageAggregator.localKeyValueStorage
                  : appScope.storageAggregator.secureStorage;
              final cacheRepo = LocalSessionCacheRepo(
                storage: storageForSession,
              );
              appScope.dio.interceptors.add(
                JWTInterceptor(
                  httpClient: context.read<IHttpClient>(),
                  sessionCacheRepo: cacheRepo,
                  authTokenRefreshRepo: context.read<IAuthTokenRefreshRepo>(),
                  unauthorizedEventBus: context.read<UnauthorizedEventBus>(),
                  logger: appScope.logger,
                ),
              );
              return cacheRepo;
            },
          ),
          RepositoryProvider<SettingsInteractor>(
            create: (context) => SettingsInteractor(
              settingsRepo: context.read<ISettingsRepo>(),
              themeRepository: context.read<IThemeRepository>(),
              userRepo: context.read<IUserRepo>(),
              userCacheRepo: context.read<IUserCacheRepo>(),
            ),
          ),
          RepositoryProvider<ThemeEditorInteractor>(
            create: (context) => ThemeEditorInteractor(
              themeEditorRepo: context.read<IThemeEditorRepo>(),
            ),
          ),
          RepositoryProvider<UserInteractor>(
            create: (context) => UserInteractor(
              userRepo: context.read<IUserRepo>(),
              userCacheRepo: context.read<IUserCacheRepo>(),
              logger: context.read<ILogger>(),
            ),
          ),
          RepositoryProvider<MediaInteractor>(
            create: (context) => MediaInteractor(
              mediaRepo: envPreset.createMediaRepo(),
              downloadCache: envPreset.createMediaDownloadCacheRepo(),
            ),
          ),
          RepositoryProvider<UnifiedSearchInteractor>(
            create: (context) => UnifiedSearchInteractor(
              searchRepo: context.read<IUnifiedSearchRepo>(),
            ),
          ),
          RepositoryProvider<SettingsCacheDatabaseInteractor>(
            create: (context) => SettingsCacheDatabaseInteractor(
              settingsCacheDatabaseRepo: DriftSettingsCacheDatabaseRepo(
                db: appScope.db,
              ),
            ),
          ),
          RepositoryProvider<AuthInteractor>(
            lazy: false,
            create: (context) => AuthInteractor(
              authRepo: context.read<IAuthRepo>(),
              userRepo: context.read<IUserRepo>(),
              sessionCacheRepo: context.read<ISessionCacheRepo>(),
              userCacheRepo: context.read<IUserCacheRepo>(),
              deviceInfoRepo: context.read<IDeviceInfoRepo>(),
              logger: context.read<ILogger>(),
              db: appScope.db,
            ),
          ),
        ],
        child: _BlocProviders(child: child),
      ),
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
          )..tryRestoreSession(),
          lazy: false,
        ),
        BlocProvider(
          lazy: false,
          create: (context) => PasscodeLockCubit(
            passcodeInteractor: context.read<PasscodeInteractor>(),
            authCubit: context.read<AuthCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(
            settingsInteractor: context.read<SettingsInteractor>(),
            themeConstructorInteractor: context.read<ThemeEditorInteractor>(),
            logger: appScope.logger,
          )..restoreSettings(),
        ),
      ],
      child: child,
    );
  }
}
