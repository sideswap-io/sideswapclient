import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:sideswap_notifications/src/firebase_options.dart';
import 'package:sideswap_notifications/src/notification_logger.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';

TNotificationBackgroundHandler? _notificationBackgroundHandler;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmRemoteMessage = FCMRemoteMessage(
    details: message.data['details'],
    body: message.notification?.body,
    title: message.notification?.title,
    data: message.data,
  );
  await _notificationBackgroundHandler?.call(fcmRemoteMessage);
}

class NotificationService {
  Future<void> init({
    required TNotificationBackgroundHandler notificationBackgroundHandler,
    THandleIncomingNotification? handleIncomingNotification,
  }) async {
    _notificationBackgroundHandler = notificationBackgroundHandler;
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // resume?
    await FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message == null) {
        return;
      }

      logger.d('onResume: $message');

      final fcmRemoteMessage = FCMRemoteMessage(
        details: message.data['details'],
        body: message.notification?.body,
        title: message.notification?.title,
        data: message.data,
      );

      if (handleIncomingNotification != null) {
        handleIncomingNotification(
          IncomingNotificationType.resume,
          fcmRemoteMessage,
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('onMessage: $message');

      final fcmRemoteMessage = FCMRemoteMessage(
        details: message.data['details'],
        body: message.notification?.body,
        title: message.notification?.title,
        data: message.data,
      );

      if (handleIncomingNotification != null) {
        handleIncomingNotification(
          IncomingNotificationType.message,
          fcmRemoteMessage,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('onLaunch: $message');

      final fcmRemoteMessage = FCMRemoteMessage(
        details: message.data['details'],
        body: message.notification?.body,
        title: message.notification?.title,
        data: message.data,
      );

      if (handleIncomingNotification != null) {
        handleIncomingNotification(
          IncomingNotificationType.launch,
          fcmRemoteMessage,
        );
      }
    });
  }

  Future<void> refreshToken({
    TRefreshTokenCallback? refreshTokenCallback,
  }) async {
    if (refreshTokenCallback == null) {
      return;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      logger.d('Firebase token $token');
      refreshTokenCallback(token);

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        logger.d('Firebase token: $newToken');
        refreshTokenCallback(newToken);
      });
    } on PlatformException catch (err) {
      logger.e('PlatformException: $err');
    } catch (err) {
      logger.e('Generic error: $err');
    }
  }
}
