import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> _hasPermission(Permission permission) async {
    return permission.isGranted;
  }

  static Future<bool> hasContactPermission() async {
    return _hasPermission(Permission.contacts);
  }

  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      return true;
    }

    return false;
  }

  static Future<bool> requestContactPermission(
      {Function onPermissionDenied}) async {
    final granted = await _requestPermission(Permission.contacts);
    if (!granted && onPermissionDenied != null) {
      onPermissionDenied();
    }

    return granted;
  }
}
