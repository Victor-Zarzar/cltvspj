import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ThemeSettings extends StatelessWidget {
  final ThemeModeOption option;
  final bool isSelected;
  final bool isDark;

  const ThemeSettings({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    List<Color> colors;

    switch (option) {
      case ThemeModeOption.system:
        icon = Icons.devices_other_rounded;
        colors = isSelected
            ? [ThemeColorIcon.primaryColor, ThemeColorIcon.secondaryColor]
            : [ThemeColorIcon.thirdColor, ThemeColorIcon.fourthColor];
        break;

      case ThemeModeOption.light:
        icon = Icons.wb_sunny_rounded;
        colors = isSelected
            ? [ThemeColorIcon.fifthColor, ThemeColorIcon.sixthColor]
            : [ThemeColorIcon.seventhColor, ThemeColorIcon.eighthColor];
        break;

      case ThemeModeOption.dark:
        icon = Icons.nightlight_round_rounded;
        colors = isSelected
            ? [ThemeColorIcon.ninthColor, ThemeColorIcon.tenthColor]
            : [ThemeColorIcon.eleventhColor, ThemeColorIcon.twelfthColor];
        break;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  offset: const Offset(0, 6),
                  blurRadius: 16,
                  color: BoxShadowColor.secondaryColor.withValues(alpha: 0.35),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 30,
          color: IconColor.primaryColor,
          semanticLabel: "radio_icon".tr(),
        ),
      ),
    );
  }
}
