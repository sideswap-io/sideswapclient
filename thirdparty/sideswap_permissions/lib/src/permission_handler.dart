import 'package:permission_handler/permission_handler.dart';
import 'package:sideswap_permissions/src/permission_logger.dart';

class PermissionHandler {
  static Future<bool> _hasPermission(Permission permission) async {
    return permission.isGranted;
  }

  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();

    if (status == PermissionStatus.granted) {
      return true;
    }

    logger.w('${permission.toString()}: ${status.toString()}');
    return false;
  }

  static Future<bool> hasContactPermission() async {
    return _hasPermission(Permission.contacts);
  }

  static Future<bool> requestContactPermission(
      {Function? onPermissionDenied}) async {
    final granted = await _requestPermission(Permission.contacts);
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
    final granted = await _requestPermission(Permission.camera);
    if (!granted && onPermissionDenied != null) {
      onPermissionDenied();
    }

    return granted;
  }
}
