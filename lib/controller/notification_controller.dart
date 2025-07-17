import 'package:cltvspj/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  NotificationController() {
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    if (_notificationsEnabled) {
      NotificationService.showWeeklyNotification(
        title: 'title_notification'.tr(),
        body: 'body_notification'.tr(),
        payload: 'rate_app',
      );
    }
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    if (value) {
      NotificationService.showWeeklyNotification(
        title: 'title_notification'.tr(),
        body: 'body_notification'.tr(),
        payload: 'rate_app',
      );
    } else {
      NotificationService.cancelWeeklyNotification();
    }
    notifyListeners();
  }
}
