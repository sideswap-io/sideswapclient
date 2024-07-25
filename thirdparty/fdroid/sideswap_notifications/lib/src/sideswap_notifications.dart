import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sideswap_notifications/src/sideswap_notifications_fdroid.dart';
import 'package:sideswap_notifications/src/sideswap_notifications_ios.dart';
import 'package:sideswap_notifications/src/sideswap_notifications_linux.dart';
import 'package:sideswap_notifications/src/sideswap_notifications_macos.dart';
import 'package:sideswap_notifications/src/sideswap_notifications_windows.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';

enum AndroidPlatformEnum {
  android,
  fdroid,
  none,
}

class SideswapNotificationsPlugin {
  SideswapNotificationsPlugin._internal() {
    if (kIsWeb) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android &&
            _androidPlatformEnum == AndroidPlatformEnum.android ||
        _androidPlatformEnum == AndroidPlatformEnum.fdroid) {
      SideswapNotificationsPlatformInterface.instance =
          SideswapNotificationsFdroidPlugin();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      SideswapNotificationsPlatformInterface.instance =
          SideswapNotificationsiOSPlugin();
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      SideswapNotificationsPlatformInterface.instance =
          SideswapNotificationsMacOSPlugin();
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      SideswapNotificationsPlatformInterface.instance =
          SideswapNotificationsLinuxPlugin();
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      SideswapNotificationsPlatformInterface.instance =
          SideswapNotificationsWindowsPlugin();
    } else {
      return;
    }
  }

  static final SideswapNotificationsPlugin _instance =
      SideswapNotificationsPlugin._internal();

  factory SideswapNotificationsPlugin({
    AndroidPlatformEnum androidPlatform = AndroidPlatformEnum.none,
  }) {
    _androidPlatformEnum = androidPlatform;
    return _instance;
  }

  static AndroidPlatformEnum _androidPlatformEnum = AndroidPlatformEnum.none;

  Future<void> firebaseInitializeApp() async {
    SideswapNotificationsPlatformInterface.instance.firebaseInitializeApp();
  }

  Future<void> notificationsInitialize({
    required TNotificationBackgroundHandler notificationBackgroundHandler,
    THandleIncomingNotification? handleIncomingNotification,
  }) async {
    SideswapNotificationsPlatformInterface.instance.notificationsInitialize(
      notificationBackgroundHandler: notificationBackgroundHandler,
      handleIncomingNotification: handleIncomingNotification,
    );
  }

  Future<void> firebaseRefreshToken({
    TRefreshTokenCallback? refreshTokenCallback,
  }) async {
    SideswapNotificationsPlatformInterface.instance.firebaseRefreshToken(
      refreshTokenCallback: refreshTokenCallback,
    );
  }

  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) {
    return SideswapNotificationsPlatformInterface.instance
        .getLocalNotificationsInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  }
}
