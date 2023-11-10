import 'package:firebase_core/firebase_core.dart';
import 'package:sideswap_notifications/src/notification_logger.dart';
import 'package:sideswap_notifications/src/notification_service.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SideswapNotificationsiOSPlugin
    extends SideswapNotificationsPlatformInterface {
  NotificationService? notificationService;
  @override
  Future<void> firebaseInitializeApp() async {
    logger.d('Initialize firebase app');
    await Firebase.initializeApp();
  }

  @override
  Future<void> notificationsInitialize({
    required TNotificationBackgroundHandler notificationBackgroundHandler,
    THandleIncomingNotification? handleIncomingNotification,
  }) async {
    notificationService ??= NotificationService();
    notificationService!.init(
      notificationBackgroundHandler: notificationBackgroundHandler,
      handleIncomingNotification: handleIncomingNotification,
    );
  }

  @override
  Future<void> firebaseRefreshToken({
    TRefreshTokenCallback? refreshTokenCallback,
  }) async {
    if (notificationService == null) {
      return;
    }

    notificationService!
        .refreshToken(refreshTokenCallback: refreshTokenCallback);
  }

  @override
  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) {
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    return InitializationSettings(
      iOS: initializationSettingsIOS,
    );
  }
}
