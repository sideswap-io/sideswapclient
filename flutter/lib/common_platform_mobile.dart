import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/permission_handler.dart';
import 'package:sideswap/common_platform.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sideswap/providers/notifications_service_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';

import 'screens/qr_scanner/address_qr_scanner.dart';

class CommonPlatformMobile extends CommonPlatform {
  @override
  Future<void> firebaseInitializeApp() async {
    await Firebase.initializeApp();
  }

  @override
  Future<void> initNotifications() async {}

  @override
  Future<void> notificationServiceProviderInit(WidgetRef ref) async {
    await ref.read(notificationServiceProvider).init();
  }

  @override
  Future<void> firebaseRefreshToken(Ref ref) async {
    await ref.read(notificationServiceProvider).refreshToken();
  }

  @override
  Future<bool> hasContactPermission() async {
    return await PermissionHandler.hasContactPermission();
  }

  @override
  Future<bool> requestContactPermission() async {
    return await PermissionHandler.requestCameraPermission();
  }

  @override
  Future<bool> hasCameraPermission() async {
    return await PermissionHandler.hasCameraPermission();
  }

  @override
  Future<bool> requestCameraPermission() async {
    return await PermissionHandler.requestCameraPermission();
  }

  @override
  Widget getAddressQrScanner({required bool bitcoinAddress}) {
    return AddressQrScanner(
        expectedAddress: bitcoinAddress ? QrCodeAddressType.bitcoin : null);
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

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      linux: initializationSettingsLinux,
      macOS: initializationSettingsMacos,
    );

    return initializationSettings;
  }
}
