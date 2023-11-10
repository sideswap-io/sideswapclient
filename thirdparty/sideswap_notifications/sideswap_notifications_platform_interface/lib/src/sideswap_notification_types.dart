import 'package:firebase_messaging/firebase_messaging.dart';

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
    RemoteMessage message);

typedef THandleIncomingNotification = void Function(
    IncomingNotificationType type, RemoteMessage message);

typedef TRefreshTokenCallback = void Function(String? token);
