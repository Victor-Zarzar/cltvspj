import 'package:cltvspj/features/responsive.dart';
import 'package:cltvspj/views/app_page.dart';
import 'package:cltvspj/views/clt_salary_page.dart';
import 'package:cltvspj/views/components/desktop/desktop_layout.dart';
import 'package:cltvspj/views/components/desktop/settings_page_desktop.dart';
import 'package:cltvspj/views/home_page.dart';
import 'package:cltvspj/views/pj_salary_page.dart';
import 'package:cltvspj/views/settings_page.dart';
import 'package:cltvspj/views/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String clt = '/clt';
  static const String pj = '/pj';
  static const String user = '/user';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Responsive(
            mobile: AppPage(child: child),
            tablet: AppPage(child: child),
            desktop: DesktopLayout(child: child),
          );
        },
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const HomePage()),
          ),
          GoRoute(
            path: clt,
            name: 'clt',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const Cltpage()),
          ),
          GoRoute(
            path: pj,
            name: 'pj',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const Pjpage()),
          ),
          GoRoute(
            path: user,
            name: 'user',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const UserProfilePage(),
            ),
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: kIsWeb
                  ? const SettingsPageDesktop()
                  : const SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
