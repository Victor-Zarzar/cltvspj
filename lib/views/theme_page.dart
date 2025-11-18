import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/views/components/theme_ilustration.dart';
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              const double maxContentWidth = 420;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth < maxContentWidth
                        ? constraints.maxWidth
                        : maxContentWidth,
                  ),
                  child: RadioGroup<ThemeModeOption>(
                    groupValue: notifier.themeMode,
                    onChanged: (ThemeModeOption? value) {
                      if (value != null) {
                        notifier.changeTheme(value);
                      }
                    },
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      children: ThemeModeOption.values.map((option) {
                        String label;
                        switch (option) {
                          case ThemeModeOption.light:
                            label = "light_theme".tr();
                            break;
                          case ThemeModeOption.dark:
                            label = "dark_theme".tr();
                            break;
                          case ThemeModeOption.system:
                            label = "system_theme".tr();
                            break;
                        }

                        final bool isSelected = notifier.themeMode == option;

                        return Card(
                          color: notifier.isDark
                              ? CardColor.primaryColor
                              : CardColor.secondaryColor,
                          elevation: isSelected ? 4 : 1,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected
                                  ? IconColor.fourthColor
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: RadioListTile<ThemeModeOption>(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(label, style: context.bodyMediumFont),
                            subtitle: Text(
                              _subtitleFor(option),
                              style: context.h2,
                            ),
                            secondary: ThemeIllustration(
                              option: option,
                              isSelected: isSelected,
                              isDark: notifier.isDark,
                            ),
                            fillColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return notifier.isDark
                                    ? RadioColor.primaryColor
                                    : RadioColor.thirdColor;
                              }
                              return notifier.isDark
                                  ? RadioColor.secondaryColor
                                  : RadioColor.thirdColor;
                            }),
                            value: option,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _subtitleFor(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.system:
        return "system_theme_description".tr();
      case ThemeModeOption.light:
        return "light_theme_description".tr();
      case ThemeModeOption.dark:
        return "dark_theme_description".tr();
    }
  }
}
