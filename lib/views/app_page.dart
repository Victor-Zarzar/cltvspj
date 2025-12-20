import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/views/clt_salary_page.dart';
import 'package:cltvspj/views/home_page.dart';
import 'package:cltvspj/views/pj_salary_page.dart';
import 'package:cltvspj/views/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Consumer2<UiProvider, LocaleController>(
      builder: (context, notifier, languageProvider, child) {
        return Scaffold(
          body: TabBarView(
            controller: tabController,
            children: const [HomePage(), Cltpage(), Pjpage(), SettingsPage()],
          ),
          bottomNavigationBar: Material(
            color: notifier.isDark
                ? TabBarColor.fourthColor
                : TabBarColor.primaryColor,
            child: TabBar(
              key: ValueKey(currentLocale.languageCode),
              controller: tabController,
              labelColor: TextColor.primaryColor,
              indicatorColor: TextColor.primaryColor,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.calculate,
                    semanticLabel: "money_icon".tr(),
                    color: IconColor.primaryColor,
                  ),
                  child: Text(
                    'home'.tr(),
                    style: context.footerMediumFont,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.work,
                    semanticLabel: "money_icon".tr(),
                    color: IconColor.primaryColor,
                  ),
                  child: Text(
                    'Clt',
                    style: context.footerMediumFont,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.business,
                    semanticLabel: "money_icon".tr(),
                    color: IconColor.primaryColor,
                  ),
                  child: Text(
                    'Pj',
                    style: context.footerMediumFont,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                    semanticLabel: "settings_icon".tr(),
                    color: IconColor.primaryColor,
                  ),
                  child: Text(
                    'settings'.tr(),
                    style: context.footerMediumFont,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
