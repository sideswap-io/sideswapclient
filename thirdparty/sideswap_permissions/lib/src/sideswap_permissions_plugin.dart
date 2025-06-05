import 'package:flutter/foundation.dart';
import 'package:sideswap_permissions/src/sideswap_permission_desktop.dart';
import 'package:sideswap_permissions/src/sideswap_permission_mobile.dart';
import 'package:sideswap_permissions/src/sideswap_permissions_platform_interface.dart';

class SideswapPermissionsPlugin {
  SideswapPermissionsPlugin._() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      SideswapPermissionPlatformInterface.instance =
          SideswapPermissionMobilePlugin();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      SideswapPermissionPlatformInterface.instance =
          SideswapPermissionMobilePlugin();
    } else {
      SideswapPermissionPlatformInterface.instance =
          SideswapPermissionDesktopPlugin();
    }
  }

  static final SideswapPermissionsPlugin _instance =
      SideswapPermissionsPlugin._();

  factory SideswapPermissionsPlugin() {
    return _instance;
  }

  Future<bool> hasContactPermission() {
    return SideswapPermissionPlatformInterface.instance.hasContactPermission();
  }

  Future<bool> requestContactPermission() {
    return SideswapPermissionPlatformInterface.instance
        .requestContactPermission();
  }

  Future<bool> hasCameraPermission() {
    return SideswapPermissionPlatformInterface.instance.hasCameraPermission();
  }

  Future<bool> requestCameraPermission() {
    return SideswapPermissionPlatformInterface.instance
        .requestCameraPermission();
  }

  Future<bool> hasBluetoothScanPermission() {
    return SideswapPermissionPlatformInterface.instance
        .hasBluetoothScanPermission();
  }

  Future<bool> requestBluetoothScanPermission() {
    return SideswapPermissionPlatformInterface.instance
        .requestBluetoothScanPermission();
  }

  Future<bool> hasBluetoothConnectPermission() {
    return SideswapPermissionPlatformInterface.instance
        .hasBluetoothConnectPermission();
  }

  Future<bool> requestBluetoothConnectPermission() {
    return SideswapPermissionPlatformInterface.instance
        .requestBluetoothConnectPermission();
  }
}
