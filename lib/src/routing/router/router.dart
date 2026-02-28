import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mangabackupconverter/src/routing/presentation/routes/books_route.dart';
import 'package:mangabackupconverter/src/routing/presentation/routes/setting_details_route.dart';
import 'package:mangabackupconverter/src/routing/presentation/routes/settings_route.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

enum RouteName { home(), settings(), settingDetails() }

final Provider<GoRouter> routerProvider = Provider<GoRouter>(
  (Ref ref) => createRouter(),
);

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouteName.home.name,
        builder: (BuildContext context, GoRouterState state) =>
            const BooksRoute(),
        routes: <RouteBase>[
          GoRoute(
            path: 'settings',
            name: RouteName.settings.name,
            builder: (BuildContext context, GoRouterState state) =>
                const SettingsRoute(),
            routes: <RouteBase>[
              GoRoute(
                path: 'settings/:id',
                name: RouteName.settingDetails.name,
                builder: (BuildContext context, GoRouterState state) =>
                    SettingDetailsRoute(id: state.pathParameters['id']),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
