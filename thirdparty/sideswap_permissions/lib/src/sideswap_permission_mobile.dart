import 'package:sideswap_permissions/src/permission_handler.dart';
import 'package:sideswap_permissions/src/sideswap_permissions_platform_interface.dart';

class SideswapPermissionMobilePlugin
    extends SideswapPermissionPlatformInterface {
  @override
  Future<bool> hasContactPermission() async {
    return PermissionHandler.hasContactPermission();
  }

  @override
  Future<bool> requestContactPermission() async {
    return PermissionHandler.requestCameraPermission();
  }

  @override
  Future<bool> hasCameraPermission() async {
    return PermissionHandler.hasCameraPermission();
  }

  @override
  Future<bool> requestCameraPermission() async {
    return PermissionHandler.requestCameraPermission();
  }

  @override
  Future<bool> hasBluetoothScanPermission() async {
    return PermissionHandler.hasBluetoothScanPermission();
  }

  @override
  Future<bool> requestBluetoothScanPermission() async {
    return PermissionHandler.requestBluetoothScanPermission();
  }

  @override
  Future<bool> hasBluetoothConnectPermission() async {
    return PermissionHandler.hasBluetoothConnectPermission();
  }

  @override
  Future<bool> requestBluetoothConnectPermission() async {
    return PermissionHandler.requestBluetoothConnectPermission();
  }
}
