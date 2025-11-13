import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/conversations/presentation/presentation.dart';
import 'package:locnet_app/features/panel/presentation/presentation.dart';
import 'package:locnet_app/features/root/root_screen.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/splash/splash_screen.dart';
import 'package:locnet_app/features/storage/presentation/presentation.dart';

class AppRouter {
  AppRouter();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

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
      redirect: (BuildContext context, GoRouterState state) {
        final AuthFlowStatus status = authListenable.status;
        final String location = state.uri.path;

        if (status == AuthFlowStatus.loading) {
          return location == '/' ? null : '/';
        }

        switch (status) {
          case AuthFlowStatus.authenticated:
            if (location == '/' || location == '/registration') {
              return '/panel/welcome';
            }

            final bool isPanelRoute = location.startsWith('/panel');

            if (!isPanelRoute) {
              return '/panel/welcome';
            }

            return null;

          case AuthFlowStatus.unauthenticated:
            if (location == '/' || location == '/registration') {
              return null;
            }

            return '/registration';

          case AuthFlowStatus.unknown:
          case AuthFlowStatus.loading:
            return null;
        }
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (BuildContext context, GoRouterState _) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: '/registration',
          name: 'registration',
          pageBuilder: buildPageTransition((
            BuildContext context,
            GoRouterState state,
          ) {
            return const RegistrationScreenWrapper(child: RegistrationScreen());
          }),
        ),
        ShellRoute(
          pageBuilder: buildShellPageTransition((
            BuildContext context,
            GoRouterState state,
            Widget child,
          ) {
            return RootScreen(child: PanelScreen(child: child));
          }),
          routes: <RouteBase>[
            GoRoute(
              path: '/panel/welcome',
              name: 'panelWelcome',
              pageBuilder: buildPageTransition((
                BuildContext context,
                GoRouterState state,
              ) {
                return const PanelWelcomeScreen();
              }),
            ),
            GoRoute(
              path: '/panel/conversations',
              name: 'conversations',
              pageBuilder: buildPageTransition((
                BuildContext context,
                GoRouterState state,
              ) {
                return const ConversationsScreenWrapper(
                  child: ConversationsScreen(selectedConversationId: null),
                );
              }),
            ),
            GoRoute(
              path: '/panel/conversations/:conversationId',
              name: 'conversationDetails',
              pageBuilder: buildPageTransition((
                BuildContext context,
                GoRouterState state,
              ) {
                final String conversationId =
                    state.pathParameters['conversationId']!;
                return ConversationsScreenWrapper(
                  child: ConversationsScreen(
                    selectedConversationId: conversationId,
                  ),
                );
              }),
            ),
            GoRoute(
              path: '/panel/storage',
              name: 'storage',
              pageBuilder: buildPageTransition((
                BuildContext context,
                GoRouterState state,
              ) {
                return const StorageScreen();
              }),
            ),
            GoRoute(
              path: '/panel/settings',
              name: 'settings',
              pageBuilder: buildPageTransition((
                BuildContext context,
                GoRouterState state,
              ) {
                return const SettingsScreen();
              }),
            ),
          ],
        ),
      ],
    );
  }
}

Page<dynamic> Function(BuildContext, GoRouterState) buildPageTransition(
  Widget Function(BuildContext, GoRouterState) childBuilder,
) {
  return (BuildContext context, GoRouterState state) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: childBuilder(context, state),
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
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

Page<dynamic> Function(BuildContext, GoRouterState, Widget)
buildShellPageTransition(
  Widget Function(BuildContext, GoRouterState, Widget child) childBuilder,
) {
  return (BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: childBuilder(context, state, child),
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
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
