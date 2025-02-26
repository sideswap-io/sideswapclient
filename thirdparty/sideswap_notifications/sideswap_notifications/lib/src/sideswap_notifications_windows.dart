import 'dart:io';

import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SideswapNotificationsWindowsPlugin
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
    final iconPath =
        '${File(Platform.resolvedExecutable).parent.path}\\data\\flutter_assets\\assets\\icon\\icon.ico';
    final initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'Sideswap',
      appUserModelId: 'io.sideswap',
      guid: '1bcb19c7-94f7-4b16-a81d-1e753135bc46', // random generated guid
      iconPath: iconPath,
    );

    return InitializationSettings(windows: initializationSettingsWindows);
  }
}
