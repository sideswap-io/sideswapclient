import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class SideswapPermissionPlatformInterface extends PlatformInterface {
  SideswapPermissionPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static late SideswapPermissionPlatformInterface _instance;

  /// The default instance of [SideswapPermissionPlatformInterface] to use.
  static SideswapPermissionPlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SideswapPermissionPlatformInterface] when
  /// they register themselves.
  static set instance(SideswapPermissionPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> hasContactPermission() async {
    throw UnimplementedError('hasContactPermission() has not been implemented');
  }

  Future<bool> requestContactPermission() async {
    throw UnimplementedError(
        'requestContactPermission() has not been implemented');
  }

  Future<bool> hasCameraPermission() async {
    throw UnimplementedError('hasCameraPermission() has not been implemented');
  }

  Future<bool> requestCameraPermission() async {
    throw UnimplementedError(
        'requestCameraPermission() has not been implemented');
  }
}
