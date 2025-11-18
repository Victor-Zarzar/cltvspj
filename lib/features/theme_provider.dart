import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption { system, light, dark }

class UiProvider extends ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.system;
  ThemeModeOption get themeMode => _themeMode;

  late SharedPreferences storage;

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      waitDuration: const Duration(milliseconds: 400),
      showDuration: const Duration(seconds: 3),
    ),
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.green[600],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    ),
  );

  bool get isDark {
    if (_themeMode == ThemeModeOption.dark) return true;
    if (_themeMode == ThemeModeOption.light) return false;
    final brightness = PlatformDispatcher.instance.platformBrightness;
    return brightness == Brightness.dark;
  }

  void changeTheme(ThemeModeOption mode) {
    _themeMode = mode;
    storage.setString("themeMode", mode.name);
    notifyListeners();
  }

  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
    final saved = storage.getString("themeMode");
    _themeMode = ThemeModeOption.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => ThemeModeOption.system,
    );
    notifyListeners();
  }
}
