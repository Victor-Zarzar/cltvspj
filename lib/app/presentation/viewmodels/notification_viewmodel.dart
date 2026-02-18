import 'package:app_settings/app_settings.dart';
import 'package:cltvspj/shared/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationViewModel extends ChangeNotifier {
  bool _notificationsEnabled = false;
  bool _ratingNotificationScheduled = false;

  bool get notificationsEnabled => _notificationsEnabled;

  NotificationViewModel() {
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();

    _notificationsEnabled = await NotificationService.areNotificationsEnabled();

    _ratingNotificationScheduled =
        prefs.getBool('rating_notification_scheduled') ?? false;

    if (_notificationsEnabled && !_ratingNotificationScheduled) {
      await NotificationService.scheduleRatingNotification(
        title: 'title_notification'.tr(),
        body: 'body_notification'.tr(),
        payload: 'rate_app',
      );

      await prefs.setBool('rating_notification_scheduled', true);
      _ratingNotificationScheduled = true;
    }

    notifyListeners();
  }

  Future<void> openSystemNotificationSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.notification);

    _notificationsEnabled = await NotificationService.areNotificationsEnabled();
    notifyListeners();
  }
}
