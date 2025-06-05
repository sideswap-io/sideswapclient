import 'package:sideswap_permissions/src/permission_handler.dart';
import 'package:sideswap_permissions/src/sideswap_permissions_platform_interface.dart';

class SideswapPermissionMobilePlugin
    extends SideswapPermissionPlatformInterface {
  @override
  Future<bool> hasContactPermission() {
    return PermissionHandler.hasContactPermission();
  }

  @override
  Future<bool> requestContactPermission() {
    return PermissionHandler.requestContactPermission();
  }

  @override
  Future<bool> hasCameraPermission() {
    return PermissionHandler.hasCameraPermission();
  }

  @override
  Future<bool> requestCameraPermission() {
    return PermissionHandler.requestCameraPermission();
  }

  @override
  Future<bool> hasBluetoothScanPermission() {
    return PermissionHandler.hasBluetoothScanPermission();
  }

  @override
  Future<bool> requestBluetoothScanPermission() {
    return PermissionHandler.requestBluetoothScanPermission();
  }

  @override
  Future<bool> hasBluetoothConnectPermission() {
    return PermissionHandler.hasBluetoothConnectPermission();
  }

  @override
  Future<bool> requestBluetoothConnectPermission() {
    return PermissionHandler.requestBluetoothConnectPermission();
  }
}
