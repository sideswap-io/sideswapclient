import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';

class SideswapNotificationsFdroidPlugin
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
  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) {
    return const InitializationSettings();
  }
}
