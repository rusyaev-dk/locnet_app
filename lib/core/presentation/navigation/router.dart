import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/presentation/presentation.dart';
import 'package:locnet_app/features/side_panel/presentation/presentation.dart';
import 'package:locnet_app/features/root/root_screen.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';
import 'package:locnet_app/features/splash/splash_screen.dart';

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
          final bool isAuthRoute =
              location == AppRoutes.login || location == AppRoutes.registration;

          if (isAuthRoute) {
            return null;
          }

          return location == '/' ? null : '/';
        }

        if (status == AuthFlowStatus.unauthenticated) {
          final bool isAuthRoute =
              location == AppRoutes.login || location == AppRoutes.registration;
          if (isAuthRoute) {
            return null;
          }
          return AppRoutes.login;
        }

        if (status == AuthFlowStatus.authenticated) {
          if (location == '/' ||
              location == AppRoutes.login ||
              location == AppRoutes.registration) {
            return AppRoutes.conversations;
          }

          final bool isAppRoute =
              location == AppRoutes.home ||
              location.startsWith('${AppRoutes.conversations}/') ||
              location == AppRoutes.conversations ||
              location == AppRoutes.storage ||
              location == AppRoutes.settings ||
              location.startsWith('${AppRoutes.storage}/') ||
              location.startsWith('${AppRoutes.settings}/');

          if (isAppRoute) {
            return null;
          }

          return AppRoutes.conversations;
        }

        return null;
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
          pageBuilder: buildFadePage((
            BuildContext context,
            GoRouterState state,
          ) {
            return const RegistrationScreenWrapper(child: RegistrationScreen());
          }),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: buildFadePage((
            BuildContext context,
            GoRouterState state,
          ) {
            return const LogInScreenWrapper(child: LogInScreen());
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
            // Conversations branch (now top-level under the shell)
            ShellRoute(
              builder:
                  (BuildContext context, GoRouterState state, Widget child) {
                    return ConversationsPanelWrapper(child: child);
                  },
              routes: <RouteBase>[
                GoRoute(
                  path: '/conversations',
                  name: 'conversations',
                  pageBuilder: buildNoTransitionPage((context, state) {
                    final String? selectedConversationId =
                        state.pathParameters['conversationId'];

                    return ConversationsPanel(
                      selectedConversationId: selectedConversationId,
                    );
                  }),
                  routes: <RouteBase>[
                    GoRoute(
                      path: ':conversationId',
                      name: 'conversationDetails',
                      pageBuilder: buildNoTransitionPage((context, state) {
                        final String? selectedConversationId =
                            state.pathParameters['conversationId'];

                        return ConversationsPanel(
                          selectedConversationId: selectedConversationId,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),

            GoRoute(
              path: '/settings',
              name: 'settings',
              pageBuilder: buildNoTransitionPage((context, state) {
                return const SettingsScreen();
              }),
            ),
          ],
        ),
      ],
    );
  }
}

Page<dynamic> Function(BuildContext, GoRouterState) buildFadePage(
  Widget Function(BuildContext, GoRouterState) childBuilder,
) {
  return (BuildContext context, GoRouterState state) {
    final bool disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      transitionDuration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 180),
      reverseTransitionDuration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 150),
      child: childBuilder(context, state),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            if (disableAnimations) return child;

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
    // No animation for Shell: keeps panel navigation snappy on desktop.
    return NoTransitionPage<dynamic>(
      key: state.pageKey,
      child: childBuilder(context, state, child),
    );
  };
}

Page<dynamic> Function(BuildContext, GoRouterState) buildNoTransitionPage(
  Widget Function(BuildContext, GoRouterState) childBuilder,
) {
  return (BuildContext context, GoRouterState state) {
    return NoTransitionPage<dynamic>(
      key: state.pageKey,
      child: childBuilder(context, state),
    );
  };
}
