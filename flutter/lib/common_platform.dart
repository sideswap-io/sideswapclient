import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late final CommonPlatform commonPlatform;

abstract class CommonPlatform {
  Future<void> firebaseInitializeApp();
  Future<void> initNotifications();
  Future<void> notificationServiceProviderInit(WidgetRef ref);
  Future<void> firebaseRefreshToken(Ref ref);

  Future<bool> hasContactPermission();
  Future<bool> requestContactPermission();
  Future<bool> hasCameraPermission();
  Future<bool> requestCameraPermission();

  Widget getAddressQrScanner({required bool bitcoinAddress});

  // Different versions of flutter_local_notifications is used on mobile and desktop
  // until this PR is merged: https://github.com/MaikuB/flutter_local_notifications/pull/1473
  // (version from the PR crashes on iOS trying open local notification).
  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  });
}
