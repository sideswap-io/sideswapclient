import 'package:sideswap_permissions/src/permission_handler.dart';
import 'package:sideswap_permissions/src/sideswap_permissions_platform_interface.dart';

class SideswapPermissionMobilePlugin
    extends SideswapPermissionPlatformInterface {
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
}
