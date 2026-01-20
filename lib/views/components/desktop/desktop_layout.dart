import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/views/components/desktop/app_footer.dart';
import 'package:cltvspj/views/components/desktop/app_sidebar.dart';
import 'package:cltvspj/views/components/navigation/nav_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DesktopLayout extends StatelessWidget {
  final Widget child;

  const DesktopLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final items = NavConfig.desktop;
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = items.indexWhere(
      (d) =>
          location == d.route.path || location.startsWith('${d.route.path}/'),
    );
    if (currentIndex < 0) currentIndex = 0;

    return Consumer<LocaleController>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          backgroundColor: AppThemeColor.primaryColor,
          body: Row(
            children: [
              AppSidebar(
                currentIndex: currentIndex,
                onNavigate: (index) {
                  context.go(items[index].route.path);
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: child),
                    const AppFooter(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
