import 'package:cltvspj/controller/locale_controller.dart';
import 'package:cltvspj/controller/notification_controller.dart';
import 'package:cltvspj/features/app_assets.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/views/about_page.dart';
import 'package:cltvspj/views/theme_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final double myHeight = MediaQuery.of(context).size.height;
    final double myWidth = MediaQuery.of(context).size.width;
    final Locale currentLocale = context.locale;

    String currentLanguageKey;
    if (currentLocale.languageCode == 'pt') {
      currentLanguageKey = 'portuguese';
    } else if (currentLocale.languageCode == 'es') {
      currentLanguageKey = 'spanish';
    } else {
      currentLanguageKey = 'english';
    }

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
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ListTile(
                      leading: Icon(
                        Icons.translate,
                        color: IconColor.primaryColor,
                        semanticLabel: "translate_icon".tr(),
                      ),
                      title: Text(
                        'language'.tr(),
                        style: context.bodyMediumFont,
                      ),
                      trailing: PopupMenuButton<Locale>(
                        initialValue: currentLocale,
                        color: notifier.isDark
                            ? PopupMenuColor.fourthColor
                            : PopupMenuColor.thirdColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language,
                              color: IconColor.primaryColor,
                              semanticLabel: "language_icon".tr(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              currentLanguageKey.tr(),
                              style: context.bodyMediumFont,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: IconColor.primaryColor,
                              semanticLabel: "arrow_drop_icon".tr(),
                            ),
                          ],
                        ),
                        onSelected: (Locale locale) {
                          Provider.of<LocaleController>(
                            context,
                            listen: false,
                          ).changeLanguage(context, locale);
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: const Locale('en', 'US'),
                            child: Row(
                              children: [
                                EN.asset(),
                                const SizedBox(width: 8),
                                Text(
                                  'english'.tr(),
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: TextColor.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: const Locale('pt', 'BR'),
                            child: Row(
                              children: [
                                PTBR.asset(),
                                const SizedBox(width: 8),
                                Text(
                                  'portuguese'.tr(),
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: TextColor.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: const Locale('es'),
                            child: Row(
                              children: [
                                ES.asset(),
                                const SizedBox(width: 8),
                                Text(
                                  'spanish'.tr(),
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: TextColor.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (!kIsWeb)
                    ListTile(
                      leading: Icon(
                        color: IconColor.primaryColor,
                        Icons.notification_important,
                        semanticLabel: 'about_icon'.tr(),
                        size: 20,
                      ),
                      title: Text(
                        'notifications'.tr(),
                        style: context.bodyMediumFont,
                      ),
                      trailing: CupertinoSwitch(
                        value: notificationController.notificationsEnabled,
                        onChanged: notificationController.toggleNotifications,
                        activeTrackColor: notifier.isDark
                            ? SwitchColor.darkInactiveTrack
                            : SwitchColor.activeThumb.withValues(alpha: 0.5),
                        inactiveThumbColor: notifier.isDark
                            ? SwitchColor.fiveColor
                            : SwitchColor.fourthColor,
                        inactiveTrackColor: notifier.isDark
                            ? SwitchColor.inactiveThumb
                            : SwitchColor.activeThumb,
                      ),
                    ),
                  const SizedBox(height: 5),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: IconColor.primaryColor,
                      semanticLabel: "color_icon".tr(),
                    ),
                    title: Text('theme'.tr(), style: context.bodyMediumFont),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: IconColor.primaryColor,
                      semanticLabel: "arrow_forward_icon".tr(),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ThemePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    leading: Icon(
                      Icons.info,
                      color: IconColor.primaryColor,
                      semanticLabel: "info_icon".tr(),
                    ),
                    title: Text('about'.tr(), style: context.bodyMediumFont),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: IconColor.primaryColor,
                      semanticLabel: "arrow_forward_icon".tr(),
                    ),
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
