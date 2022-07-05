import 'package:flutter/widgets.dart';
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
}
