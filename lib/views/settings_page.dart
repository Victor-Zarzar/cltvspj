import 'package:cltvspj/controller/controllers/notification_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/views/about_page.dart';
import 'package:cltvspj/views/components/language_selector.dart';
import 'package:cltvspj/views/theme_page.dart';
import 'package:cltvspj/views/user_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget _buildTrailingArrow() {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Icon(
          Icons.chevron_right,
          size: 28,
          color: IconColor.primaryColor,
          semanticLabel: "arrow_forward_icon".tr(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double myHeight = MediaQuery.of(context).size.height;
    final double myWidth = MediaQuery.of(context).size.width;

    return Consumer2<UiProvider, NotificationController>(
      builder: (context, notifier, notificationController, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: notifier.isDark
                ? AppBarColor.thirdColor
                : AppBarColor.secondaryColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('settings'.tr(), style: context.h1),
          ),
          body: Container(
            color: notifier.isDark
                ? BackGroundColor.fourthColor
                : BackGroundColor.primaryColor,
            child: SizedBox(
              height: myHeight,
              width: myWidth,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: LanguageSelector(),
                  ),
                  const SizedBox(height: 5),
                  if (!kIsWeb)
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: IconColor.primaryColor,
                        semanticLabel: 'information_icon'.tr(),
                      ),
                      title: Text(
                        'enable_notifications'.tr(),
                        style: context.bodyMediumFont,
                      ),
                      trailing: _buildTrailingArrow(),
                      onTap:
                          notificationController.openSystemNotificationSettings,
                    ),
                  if (!kIsWeb)
                    ListTile(
                      leading: Icon(
                        Icons.person_2,
                        color: IconColor.primaryColor,
                        semanticLabel: 'person_icon'.tr(),
                      ),
                      title: Text(
                        'profile'.tr(),
                        style: context.bodyMediumFont,
                      ),
                      trailing: _buildTrailingArrow(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserProfilePage(),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 5),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: IconColor.primaryColor,
                      semanticLabel: "color_icon".tr(),
                    ),
                    title: Text('theme'.tr(), style: context.bodyMediumFont),
                    trailing: _buildTrailingArrow(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ThemePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  if (!kIsWeb)
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        color: IconColor.primaryColor,
                        semanticLabel: "info_icon".tr(),
                      ),
                      title: Text('about'.tr(), style: context.bodyMediumFont),
                      trailing: _buildTrailingArrow(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutPage()),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
