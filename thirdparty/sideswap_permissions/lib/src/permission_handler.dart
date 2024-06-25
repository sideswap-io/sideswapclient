import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sideswap_permissions/src/permission_logger.dart';

class PermissionHandler {
  static Future<bool> _hasPermission(Permission permission) async {
    return permission.isGranted;
  }

  static Future<bool> _requestPermission({
    List<Permission> permissions = const [],
  }) async {
    final statuses = await permissions.request();

    for (final key in statuses.keys) {
      if (statuses[key] != PermissionStatus.granted) {
        logger.w('${key.toString()}: ${statuses[key]}');
        return false;
      }
    }

    return true;
  }

  static Future<bool> hasContactPermission() async {
    return _hasPermission(Permission.contacts);
  }

  static Future<bool> requestContactPermission(
      {Function? onPermissionDenied}) async {
    final granted =
        await _requestPermission(permissions: [Permission.contacts]);
    if (!granted && onPermissionDenied != null) {
      onPermissionDenied();
    }

    return granted;
  }

  static Future<bool> hasCameraPermission() async {
    return _hasPermission(Permission.camera);
  }

  static Future<bool> requestCameraPermission(
      {Function? onPermissionDenied}) async {
    final granted = await _requestPermission(permissions: [Permission.camera]);
    if (!granted && onPermissionDenied != null) {
      onPermissionDenied();
    }

    return granted;
  }

  static Future<bool> hasBluetoothScanPermission() async {
    return _hasBluetoothPermissions(permissions: [Permission.bluetoothScan]);
  }

  static Future<bool> requestBluetoothScanPermission() async {
    return _requestBluetoothPermission(permissions: [Permission.bluetoothScan]);
  }

  static Future<bool> hasBluetoothConnectPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt <= 30) {
        return _hasBluetoothPermissions(permissions: [
          Permission.bluetooth,
          Permission.location,
          Permission.locationWhenInUse,
          // Permission.locationAlways
        ]);
      }
    }

    return _hasBluetoothPermissions(permissions: [Permission.bluetoothConnect]);
  }

  static Future<bool> requestBluetoothConnectPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt <= 30) {
        return _requestBluetoothPermission(permissions: [
          Permission.bluetooth,
          Permission.location,
          Permission.locationWhenInUse,
          // Permission.locationAlways
        ]);
      }
    }

    return _requestBluetoothPermission(
        permissions: [Permission.bluetoothConnect]);
  }

  static Future<bool> _hasBluetoothPermissions({
    List<Permission> permissions = const [],
  }) async {
    if (Platform.isAndroid) {
      for (final permission in permissions) {
        if (!await _hasPermission(permission)) {
          return false;
        }
      }
      return true;
    }

    return _hasPermission(Permission.bluetooth);
  }

  static Future<bool> _requestBluetoothPermission({
    List<Permission> permissions = const [],
  }) async {
    if (Platform.isAndroid) {
      return _requestPermission(permissions: permissions);
    }

    return _requestPermission(permissions: [Permission.bluetooth]);
  }
}
