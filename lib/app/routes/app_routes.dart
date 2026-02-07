import 'package:cltvspj/app/layout/desktop_layout.dart';
import 'package:cltvspj/app/layout/mobile_layout.dart';
import 'package:cltvspj/features/clt/presentantion/pages/clt_salary_page.dart';
import 'package:cltvspj/features/home/presentation/pages/home_page.dart';
import 'package:cltvspj/features/pj/presentation/pages/pj_salary_page.dart';
import 'package:cltvspj/features/settings/presentation/pages/settings_page_desktop.dart';
import 'package:cltvspj/features/settings/presentation/pages/settings_page_mobile.dart';
import 'package:cltvspj/features/user/presentation/pages/user_profile.dart';
import 'package:cltvspj/shared/widgets/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
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
            mobile: MobileLayout(child: child),
            tablet: MobileLayout(child: child),
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
