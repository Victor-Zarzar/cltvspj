class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String payload;
  final NotificationType type;
  final bool enabled;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.type,
    this.enabled = true,
  });
}

enum NotificationType { weekly, daily, reminder, update }
