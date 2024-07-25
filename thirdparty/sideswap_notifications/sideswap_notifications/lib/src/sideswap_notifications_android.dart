import 'package:firebase_core/firebase_core.dart';
import 'package:sideswap_notifications/src/firebase_options.dart';
import 'package:sideswap_notifications/src/notification_logger.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_service.dart';

class SideswapNotificationsAndroidPlugin
    extends SideswapNotificationsPlatformInterface {
  NotificationService? notificationService;
  FirebaseApp? firebaseApp;

  @override
  Future<void> firebaseInitializeApp() async {
    logger.d('Initialize firebase app');
    firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    logger.d('FirebaseApp: $firebaseApp');
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
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notification_icon');

    return const InitializationSettings(
      android: initializationSettingsAndroid,
    );
  }
}
