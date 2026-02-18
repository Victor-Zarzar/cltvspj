import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocaleViewModel extends ChangeNotifier {
  void changeLanguage(BuildContext context, Locale locale) {
    context.setLocale(locale);
    notifyListeners();
  }
}
