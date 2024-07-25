import 'package:sideswap_notifications_platform_interface/models/notification_model.dart';

enum IncomingNotificationType {
  message,
  launch,
  resume,
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

typedef TNotificationBackgroundHandler = Future<void> Function(
    FCMRemoteMessage message);

typedef THandleIncomingNotification = void Function(
    IncomingNotificationType type, FCMRemoteMessage message);

typedef TRefreshTokenCallback = void Function(String? token);
