import 'package:flutter/widgets.dart';
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
}
