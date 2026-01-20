import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UiProvider, LocaleController>(
      builder: (context, notifier, languageProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: notifier.isDark
                ? TabBarColor.fourthColor
                : TabBarColor.thirdColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, -4),
                color: IconColor.fiveColor.withValues(
                  alpha: notifier.isDark ? 0.3 : 0.1,
                ),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: notifier.isDark
                            ? IconColor.sixColor
                            : IconColor.secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calculate_rounded,
                        color: IconColor.primaryColor,
                        semanticLabel: 'footer_app_icon'.tr(),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'app_title'.tr(),
                        style: context.footerMediumFont,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copyright_rounded,
                        size: 14,
                        color: IconColor.primaryColor,
                        semanticLabel: 'footer_version_icon'.tr(),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'copyright'.tr(
                            namedArgs: {'year': DateTime.now().year.toString()},
                          ),
                          style: context.footerMediumFont,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: notifier.isDark
                            ? IconColor.primaryColor.withValues(alpha: 0.1)
                            : IconColor.fiveColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: notifier.isDark
                              ? IconColor.primaryColor.withValues(alpha: 0.2)
                              : IconColor.fiveColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: IconColor.primaryColor,
                            semanticLabel: 'footer_version_icon'.tr(),
                          ),
                          const SizedBox(width: 6),
                          Text('v1.0.0', style: context.footerFont),
                        ],
                      ),
                    ),
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
