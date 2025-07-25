import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Scaffold(
          backgroundColor: notifier.isDark
              ? BackGroundColor.fourthColor
              : BackGroundColor.primaryColor,
          appBar: AppBar(
            leading: Semantics(
              label: "backtopage".tr(),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: IconColor.primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            title: Text("select_theme".tr(), style: context.h1),
            centerTitle: true,
            backgroundColor: notifier.isDark
                ? AppBarColor.thirdColor
                : AppBarColor.secondaryColor,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 30),
            child: ListView(
              children: ThemeModeOption.values.map((option) {
                IconData icon;
                String label;

                switch (option) {
                  case ThemeModeOption.light:
                    icon = Icons.light_mode;
                    label = "light_theme".tr();
                    break;
                  case ThemeModeOption.dark:
                    icon = Icons.dark_mode;
                    label = "dark_theme".tr();
                    break;
                  case ThemeModeOption.system:
                    icon = Icons.settings;
                    label = "system_theme".tr();
                    break;
                }

                return RadioListTile<ThemeModeOption>(
                  title: Text(label, style: context.bodyMediumFont),
                  secondary: Icon(
                    icon,
                    color: IconColor.primaryColor,
                    semanticLabel: "radio_icon".tr(),
                  ),
                  activeColor: notifier.isDark
                      ? IconColor.primaryColor
                      : IconColor.fourthColor,
                  value: option,
                  groupValue: notifier.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.changeTheme(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
