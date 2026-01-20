import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/utils/enum_routes.dart';
import 'package:cltvspj/views/components/navigation/nav_config.dart';
import 'package:cltvspj/views/components/navigation/nav_destination.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppPage extends StatelessWidget {
  final Widget child;
  const AppPage({super.key, required this.child});

  int _indexFromLocation(String location, List<NavDestination> items) {
    final idx = items.indexWhere(
      (d) =>
          location == d.route.path || location.startsWith('${d.route.path}/'),
    );
    return idx >= 0 ? idx : 0;
  }

  String _label(BuildContext context, AppRoute route) {
    switch (route) {
      case AppRoute.home:
        return 'home'.tr();
      case AppRoute.clt:
        return 'clt'.tr();
      case AppRoute.pj:
        return 'pj'.tr();
      case AppRoute.user:
        return 'user'.tr();
      case AppRoute.settings:
        return 'settings'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Consumer2<UiProvider, LocaleController>(
      builder: (context, notifier, languageProvider, _) {
        final items = NavConfig.mobile;
        final location = GoRouterState.of(context).uri.toString();
        final currentIndex = _indexFromLocation(location, items);

        return Scaffold(
          body: child,
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                indicatorColor: notifier.isDark
                    ? TabBarColor.fifthColor
                    : TabBarColor.thirdColor,
                backgroundColor: notifier.isDark
                    ? TabBarColor.fourthColor
                    : TabBarColor.primaryColor,
                labelTextStyle: WidgetStateProperty.all(
                  context.footerMediumFont.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            child: NavigationBar(
              height: 70,
              key: ValueKey(currentLocale.languageCode),
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                context.go(items[index].route.path);
              },
              destinations: [
                for (final d in items)
                  NavigationDestination(
                    icon: Icon(
                      d.icon,
                      color: IconColor.primaryColor,
                      semanticLabel: d.route == AppRoute.settings
                          ? "settings_icon".tr()
                          : "money_icon".tr(),
                    ),
                    label: _label(context, d.route),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
