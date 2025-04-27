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

final routerProvider = Provider<GoRouter>((ref) => createRouter());

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.home.name,
        builder: (context, state) => const BooksRoute(),
        routes: [
          GoRoute(
            path: 'settings',
            name: RouteName.settings.name,
            builder: (context, state) => const SettingsRoute(),
            routes: [
              GoRoute(
                path: 'settings/:id',
                name: RouteName.settingDetails.name,
                builder:
                    (context, state) =>
                        SettingDetailsRoute(id: state.pathParameters['id']),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
