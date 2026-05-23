import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/error/error_screen.dart';
import 'package:locnet_app/features/passcode/presentation/presentation.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/splash/splash_screen.dart';
import 'package:locnet_app/gen/gen.dart';
import 'package:locnet_app/uikit/uikit.dart';

class LocnetApp extends StatefulWidget {
  const LocnetApp({required this.initDependencies, super.key});

  final Future<AppScope> Function() initDependencies;

  @override
  State<LocnetApp> createState() => _LocnetAppState();
}

class _LocnetAppState extends State<LocnetApp> {
  late Future<AppScope> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = widget.initDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppScope>(
      future: _initFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const _InitSplashShell(child: SplashScreen());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return ErrorScreen(
                error: snapshot.error,
                stackTrace: snapshot.stackTrace,
                onRetry: _retryInit,
              );
            }

            final appScope = snapshot.data;
            if (appScope == null) {
              return ErrorScreen(
                error: 'Error initializing dependencies: diContainer = null',
                stackTrace: null,
                onRetry: _retryInit,
              );
            }
            return AppProvidersWrapper(
              appScope: appScope,
              child: Builder(
                builder: (context) {
                  final AuthFlowController authFlowController =
                      AuthFlowController(
                        authCubit: context.read<AuthCubit>(),
                        unauthorizedEventBus: context
                            .read<UnauthorizedEventBus>(),
                      );
                  final PasscodeFlowController passcodeFlowController =
                      PasscodeFlowController(
                        cubit: context.read<PasscodeLockCubit>(),
                      );
                  final router = AppRouter.createRouter(
                    includePrefixMatches: true,
                    navigatorObservers: [appScope.routeObserver],
                    authFlowController: authFlowController,
                    passcodeFlowController: passcodeFlowController,
                  );
                  return _App(router: router);
                },
              ),
            );
        }
      },
    );
  }

  void _retryInit() {
    setState(() {
      _initFuture = widget.initDependencies();
    });
  }
}

class _App extends StatefulWidget {
  const _App({required this.router});

  final GoRouter router;

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final PasscodeLockCubit cubit = context.read<PasscodeLockCubit>();
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        cubit.onAppPaused();
      case AppLifecycleState.resumed:
        cubit.onAppResumed();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, SettingsLoadedState?>(
      selector: (state) => state is SettingsLoadedState ? state : null,
      builder: (context, loaded) {
        final locale = loaded?.locale ?? const Locale(AppLanguages.ru);
        final themeType = loaded?.themeType ?? AppThemeType.light;
        final textScaleFactor = loaded?.textScaleFactor ?? 1.0;
        final elementScaleFactor = loaded?.elementScaleFactor ?? 1.0;
        final appTheme = AppThemeData(accentIndex: themeType.accentIndex);
        final density = ((elementScaleFactor - 1.0) * 8).clamp(-1.2, 1.2);
        final theme = appTheme.getLightTheme().copyWith(
          visualDensity: VisualDensity(horizontal: density, vertical: density),
        );
        final darkTheme = appTheme.getDarkTheme().copyWith(
          visualDensity: VisualDensity(horizontal: density, vertical: density),
        );
        final themeMode = themeType.isLight ? ThemeMode.light : ThemeMode.dark;

        return MaterialApp.router(
          scrollBehavior: const NoGlowClampingBehavior(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: locale,
          supportedLocales: AppLanguages.toLocalesList(),
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: widget.router,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return ConnectivityBanner(
              child: MediaQuery(
                data: mediaQuery.copyWith(
                  textScaler: TextScaler.linear(textScaleFactor),
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}

class _InitSplashShell extends StatelessWidget {
  const _InitSplashShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeData().getLightTheme();
    return MaterialApp(
      scrollBehavior: const NoGlowClampingBehavior(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale(AppLanguages.ru),
      supportedLocales: AppLanguages.toLocalesList(),
      theme: theme,
      home: child,
    );
  }
}
