import 'package:flutter/material.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/home/presentation/presentation.dart';
import 'package:locnet_app/features/root/root_screen.dart';
import 'package:locnet_app/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter({
    required bool includePrefixMatches,
    required List<NavigatorObserver> navigatorObservers,
    required AuthRouterListenable authListenable,
  }) {
    return GoRouter(
      initialLocation: '/',
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      refreshListenable: authListenable,
      observers: navigatorObservers,
      redirect: (context, state) {
        // All comments in English.
        final AuthFlowStatus status = authListenable.status;
        final String location = state.uri.path;

        // Keep Splash while loading.
        if (status == AuthFlowStatus.loading) {
          return location == '/' ? null : '/';
        }

        // Route decisions after loading is done.
        switch (status) {
          case AuthFlowStatus.authenticated:
            // Send any non-home location to home, except nested home children.
            if (!location.startsWith('/home')) {
              return '/home';
            }
            return null;

          case AuthFlowStatus.unauthenticated:
            // Force to registration unless already there.
            if (location != '/registration') {
              return '/registration';
            }
            return null;

          case AuthFlowStatus.unknown:
          case AuthFlowStatus.loading:
            // handled above
            return null;
        }
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, _) => const SplashScreen(),
        ),
        ShellRoute(
          pageBuilder: buildShellPageTransition((
            BuildContext context,
            GoRouterState state,
            Widget child,
          ) {
            return RootScreen(child: child);
          }),
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, _) => const HomeScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

Page<dynamic> Function(BuildContext, GoRouterState) buildPageTransition(
  Widget Function(BuildContext, GoRouterState) childBuilder,
) => (BuildContext context, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: childBuilder(context, state),
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondary, child) {
      final Animation<double> opacity = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(opacity: opacity, child: child);
    },
  );
};

Page<dynamic> Function(BuildContext, GoRouterState, Widget)
buildShellPageTransition(
  Widget Function(BuildContext, GoRouterState, Widget child) childBuilder,
) {
  return (BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: childBuilder(context, state, child),
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      transitionsBuilder: (context, animation, secondary, child) {
        final Animation<double> opacity = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(opacity: opacity, child: child);
      },
    );
  };
}
