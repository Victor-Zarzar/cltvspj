import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/features/app_assets.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  String _currentLanguageKey(Locale currentLocale) {
    if (currentLocale.languageCode == 'pt') return 'portuguese';
    if (currentLocale.languageCode == 'es') return 'spanish';
    return 'english';
  }

  TextStyle _popupItemTextStyle() {
    return GoogleFonts.roboto(
      textStyle: TextStyle(color: TextColor.primaryColor, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Locale currentLocale = context.locale;

    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        final String currentLanguageKey = _currentLanguageKey(currentLocale);

        return ListTile(
          leading: Icon(
            Icons.translate,
            color: IconColor.primaryColor,
            semanticLabel: "translate_icon".tr(),
          ),
          title: Text('language'.tr(), style: context.bodyMediumFont),
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
                Text(currentLanguageKey.tr(), style: context.bodyMediumFont),
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
                    Text('english'.tr(), style: _popupItemTextStyle()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('pt', 'BR'),
                child: Row(
                  children: [
                    PTBR.asset(),
                    const SizedBox(width: 8),
                    Text('portuguese'.tr(), style: _popupItemTextStyle()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('es'),
                child: Row(
                  children: [
                    ES.asset(),
                    const SizedBox(width: 8),
                    Text('spanish'.tr(), style: _popupItemTextStyle()),
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
