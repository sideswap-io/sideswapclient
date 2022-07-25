import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common_platform.dart';

class CommonPlatformDesktop extends CommonPlatform {
  @override
  Future<void> firebaseInitializeApp() async {}

  @override
  Future<void> initNotifications() async {}

  @override
  Future<void> notificationServiceProviderInit(WidgetRef ref) async {}

  @override
  Future<void> firebaseRefreshToken(Ref ref) async {}

  @override
  Future<bool> hasContactPermission() async {
    return false;
  }

  @override
  Future<bool> requestContactPermission() async {
    return false;
  }

  @override
  Future<bool> hasCameraPermission() async {
    return false;
  }

  @override
  Future<bool> requestCameraPermission() async {
    return false;
  }

  @override
  Widget getAddressQrScanner({required bool bitcoinAddress}) {
    return Container();
  }

  @override
  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notification_icon');

    final initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettingsLinux = LinuxInitializationSettings(
        defaultActionName: '',
        defaultIcon: AssetsLinuxIcon('assets/icon/icon_linux.png'));

    const initializationSettingsMacos = MacOSInitializationSettings();

    final iconPath =
        '${File(Platform.resolvedExecutable).parent.path}data\\flutter_assets\\assets\\icon\\icon.ico';
    final initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'SideSwap',
      appUserModelId: 'io.sideswap',
      iconPath: iconPath,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      linux: initializationSettingsLinux,
      macOS: initializationSettingsMacos,
      windows: initializationSettingsWindows,
    );

    return initializationSettings;
  }
}
