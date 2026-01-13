import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/error/error_screen.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/splash/splash_screen.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';
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
            return const SplashScreen();
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
                  final router = AppRouter.createRouter(
                    includePrefixMatches: true,
                    navigatorObservers: [appScope.routeObserver],
                    authListenable: AuthRouterListenable(
                      authCubit: context.read<AuthCubit>(),
                    ),
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

class _App extends StatelessWidget {
  const _App({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SettingsCubit,
      SettingsState,
      (Locale, ThemeMode, AppTheme)
    >(
      selector: (state) {
        switch (state) {
          case SettingsLoadedState():
            return (state.locale, state.themeMode, state.appTheme);
          default:
            return (
              const Locale(AppLanguages.ru),
              ThemeMode.system,
              AppTheme.basic(),
            );
        }
      },
      builder: (context, tuple) {
        final (locale, themeMode, appTheme) = tuple;
        final appThemeData = AppThemeData(
          lightScheme: appTheme.lightPalette.toColorScheme(
            const AppColorScheme.light(),
          ),
          darkScheme: appTheme.darkPalette.toColorScheme(
            const AppColorScheme.dark(),
          ),
        );

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
          theme: appThemeData.getLightTheme(),
          darkTheme: appThemeData.getDarkTheme(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
