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
  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
    onDidReceiveLocalNotification,
  }) {
    final iconPath =
        '${File(Platform.resolvedExecutable).parent.path}\\data\\flutter_assets\\assets\\icon\\icon.ico';
    final initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'SideSwap',
      appUserModelId: 'io.sideswap',
      iconPath: iconPath,
      guid: '1c2144ac-44b6-4f04-8f47-c08f1e2d6ecf',
    );

    return InitializationSettings(windows: initializationSettingsWindows);
  }
}
