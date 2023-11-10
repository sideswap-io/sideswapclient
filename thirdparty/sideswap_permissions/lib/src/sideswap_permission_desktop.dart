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
}
