import 'package:crud/screens/free/free.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/screens/profile/join_screen.dart';
import 'package:crud/screens/profile/join_screen2.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:crud/screens/profile/profile_main.dart';
import 'package:crud/screens/qna/qna.dart';
import 'package:crud/screens/scaffold_withnav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

List<RouteBase> _homeRoutes = [
  GoRoute(
    path: Home.routePath,
    name: Home.routeName,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: Home(),
    ),
  ),
];

List<RouteBase> _freeRoutes = [
  GoRoute(
    path: FreeBoard.routePath,
    name: FreeBoard.routeName,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: FreeBoard(),
    ),
  ),
];

List<RouteBase> _qnaRoutes = [
  GoRoute(
    path: QnaBoard.routePath,
    name: QnaBoard.routeName,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: QnaBoard(),
    ),
  ),
];

List<RouteBase> _profileRoutes = [
  GoRoute(
    path: Profile.routePath,
    name: Profile.routeName,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: Profile(),
    ),
    routes: const [],
  ),
];

final routesProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavKey,
    routes: [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavKey,
        builder: (context, state, navigationShell) =>
            ScaffoldWithNav(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(routes: _homeRoutes),
          StatefulShellBranch(routes: _freeRoutes),
          StatefulShellBranch(routes: _qnaRoutes),
          StatefulShellBranch(routes: _profileRoutes),
        ],
      ),
      GoRoute(
        path: JoinScreenWidget.routePath,
        name: JoinScreenWidget.routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: JoinScreenWidget(),
        ),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: LoginScreen(),
          );
        },
      ),
    ],
  );
});
