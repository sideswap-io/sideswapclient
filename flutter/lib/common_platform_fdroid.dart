import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/permission_handler.dart';
import 'package:sideswap/common_platform.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/screens/qr_scanner/address_qr_scanner.dart';

class CommonPlatformFdroid extends CommonPlatform {
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
}
