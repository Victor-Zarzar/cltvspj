import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/features/app_assets.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPageDesktop extends StatelessWidget {
  const SettingsPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Scaffold(
          backgroundColor: notifier.isDark
              ? BackGroundColor.fourthColor
              : BackGroundColor.primaryColor,
          appBar: AppBar(
            title: Text("settings".tr(), style: context.h1),
            centerTitle: true,
            backgroundColor: notifier.isDark
                ? AppBarColor.thirdColor
                : AppBarColor.secondaryColor,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: notifier.isDark
                            ? CardColor.primaryColor
                            : CardColor.secondaryColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: notifier.isDark
                                ? BoxShadowColor.fifthColor.withValues(
                                    alpha: 0.2,
                                  )
                                : BoxShadowColor.fourthColor.withValues(
                                    alpha: 0.3,
                                  ),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        "preferences".tr(),
                        style: context.h1Home,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 0.3),
                    _buildSettingsCard(context, notifier),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard(BuildContext context, UiProvider notifier) {
    return Container(
      decoration: BoxDecoration(
        color: notifier.isDark
            ? CardColor.primaryColor
            : CardColor.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: notifier.isDark
                ? BoxShadowColor.fifthColor.withValues(alpha: 0.2)
                : BoxShadowColor.fourthColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildLanguageRow(context, notifier),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                color: notifier.isDark
                    ? DividerColor.thirdColor
                    : DividerColor.secondaryColor,
              ),
            ),
            _buildThemeRow(context, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageRow(BuildContext context, UiProvider notifier) {
    final Locale currentLocale = context.locale;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSettingInfo(
          context: context,
          icon: Icons.translate,
          title: 'language'.tr(),
          description: 'language_description'.tr(),
          notifier: notifier,
          iconSemanticKey: 'settings.language_icon',
        ),
        _buildLanguageDropdown(context, notifier, currentLocale),
      ],
    );
  }

  Widget _buildThemeRow(BuildContext context, UiProvider notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSettingInfo(
          context: context,
          icon: Icons.palette,
          title: 'theme'.tr(),
          description: 'theme_description'.tr(),
          notifier: notifier,
          iconSemanticKey: 'settings.theme_icon',
        ),
        _buildThemeSegmentedButton(context, notifier),
      ],
    );
  }

  Widget _buildSettingInfo({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required UiProvider notifier,
    required String iconSemanticKey,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notifier.isDark
                ? IconColor.primaryColor.withValues(alpha: 0.1)
                : IconColor.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: IconColor.primaryColor,
            size: 24,
            semanticLabel: iconSemanticKey.tr(),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.h3),
            const SizedBox(height: 4),
            Text(description, style: context.h3),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown(
    BuildContext context,
    UiProvider notifier,
    Locale currentLocale,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: notifier.isDark
            ? BackGroundColor.secondaryColor.withValues(alpha: 0.05)
            : BackGroundColor.fourthColor.withValues(alpha: 0.03),
        border: Border.all(
          color: notifier.isDark
              ? IconColor.primaryColor.withValues(alpha: 0.2)
              : IconColor.primaryColor.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<Locale>(
        value: currentLocale,
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: IconColor.primaryColor,
          size: 20,
          semanticLabel: 'settings.language_dropdown_icon'.tr(),
        ),
        dropdownColor: notifier.isDark
            ? PopupMenuColor.fourthColor
            : PopupMenuColor.thirdColor,
        borderRadius: BorderRadius.circular(12),
        style: context.h3,
        items: [
          _buildLanguageDropdownItem(
            locale: const Locale('en', 'US'),
            flag: EN.asset(),
            label: 'english'.tr(),
          ),
          _buildLanguageDropdownItem(
            locale: const Locale('pt', 'BR'),
            flag: PTBR.asset(),
            label: 'portuguese'.tr(),
          ),
          _buildLanguageDropdownItem(
            locale: const Locale('es'),
            flag: ES.asset(),
            label: 'spanish'.tr(),
          ),
        ],
        onChanged: (Locale? locale) {
          if (locale != null) {
            Provider.of<LocaleController>(
              context,
              listen: false,
            ).changeLanguage(context, locale);
          }
        },
      ),
    );
  }

  DropdownMenuItem<Locale> _buildLanguageDropdownItem({
    required Locale locale,
    required Widget flag,
    required String label,
  }) {
    return DropdownMenuItem(
      value: locale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 24, height: 24, child: flag),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildThemeSegmentedButton(BuildContext context, UiProvider notifier) {
    return SegmentedButton<ThemeModeOption>(
      segments: [
        ButtonSegment(
          value: ThemeModeOption.light,
          icon: Icon(
            Icons.light_mode,
            size: 18,
            semanticLabel: 'settings.theme_light_icon'.tr(),
            color: IconColor.primaryColor,
          ),
          label: Text('light'.tr(), style: context.h3),
        ),
        ButtonSegment(
          value: ThemeModeOption.system,
          icon: Icon(
            Icons.brightness_auto,
            color: IconColor.primaryColor,
            size: 18,
            semanticLabel: 'settings.theme_system_icon'.tr(),
          ),
          label: Text('auto'.tr(), style: context.h3),
        ),
        ButtonSegment(
          value: ThemeModeOption.dark,
          icon: Icon(
            Icons.dark_mode,
            size: 18,
            semanticLabel: 'settings.theme_dark_icon'.tr(),
            color: IconColor.primaryColor,
          ),
          label: Text('dark'.tr(), style: context.h3),
        ),
      ],
      selected: {notifier.themeMode},
      onSelectionChanged: (Set<ThemeModeOption> selection) {
        notifier.changeTheme(selection.first);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return notifier.isDark
                ? RadioColor.primaryColor.withValues(alpha: 0.3)
                : RadioColor.thirdColor.withValues(alpha: 0.3);
          }
          return AppThemeColor.fifthColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return notifier.isDark
                ? TextColor.primaryColor
                : TextColor.secondaryColor;
          }
          return notifier.isDark
              ? TextColor.primaryColor.withValues(alpha: 0.6)
              : TextColor.secondaryColor.withValues(alpha: 0.6);
        }),
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(
            color: notifier.isDark
                ? IconColor.primaryColor.withValues(alpha: 0.2)
                : IconColor.primaryColor.withValues(alpha: 0.15),
            width: 1,
          );
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
