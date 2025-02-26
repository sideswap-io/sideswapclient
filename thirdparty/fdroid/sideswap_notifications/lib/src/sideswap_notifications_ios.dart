import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SideswapNotificationsiOSPlugin
    extends SideswapNotificationsPlatformInterface {
  @override
  Future<void> firebaseInitializeApp() async {}

  @override
  Future<void> notificationsInitialize({
    required TNotificationBackgroundHandler notificationBackgroundHandler,
    THandleIncomingNotification? handleIncomingNotification,
  }) async {}

  @override
  Future<void> firebaseRefreshToken({
    TRefreshTokenCallback? refreshTokenCallback,
  }) async {}

  @override
  InitializationSettings getLocalNotificationsInitializationSettings() {
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    return InitializationSettings(iOS: initializationSettingsIOS);
  }
}
