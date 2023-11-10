import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:sideswap_notifications/src/notification_logger.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';

class NotificationService {
  Future<void> init({
    required TNotificationBackgroundHandler notificationBackgroundHandler,
    THandleIncomingNotification? handleIncomingNotification,
  }) async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(notificationBackgroundHandler);

    // resume?
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message == null) {
        return;
      }

      logger.d('onResume: $message');
      if (handleIncomingNotification != null) {
        handleIncomingNotification(IncomingNotificationType.resume, message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('onMessage: $message');
      if (handleIncomingNotification != null) {
        handleIncomingNotification(IncomingNotificationType.message, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('onLaunch: $message');
      if (handleIncomingNotification != null) {
        handleIncomingNotification(IncomingNotificationType.launch, message);
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
