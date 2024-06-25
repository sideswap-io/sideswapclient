import 'package:sideswap_permissions/src/sideswap_permissions_platform_interface.dart';

class SideswapPermissionDesktopPlugin
    extends SideswapPermissionPlatformInterface {
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
  Future<bool> hasBluetoothScanPermission() async {
    return true;
  }

  @override
  Future<bool> requestBluetoothScanPermission() async {
    return true;
  }

  @override
  Future<bool> hasBluetoothConnectPermission() async {
    return true;
  }

  @override
  Future<bool> requestBluetoothConnectPermission() async {
    return true;
  }
}
