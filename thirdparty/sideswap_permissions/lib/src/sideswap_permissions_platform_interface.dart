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

  Future<bool> hasContactPermission() {
    throw UnimplementedError('hasContactPermission() has not been implemented');
  }

  Future<bool> requestContactPermission() {
    throw UnimplementedError(
      'requestContactPermission() has not been implemented',
    );
  }

  Future<bool> hasCameraPermission() {
    throw UnimplementedError('hasCameraPermission() has not been implemented');
  }

  Future<bool> requestCameraPermission() {
    throw UnimplementedError(
      'requestCameraPermission() has not been implemented',
    );
  }

  Future<bool> hasBluetoothScanPermission() {
    throw UnimplementedError(
      'hasBluetoothScanPermission() has not been implemented',
    );
  }

  Future<bool> requestBluetoothScanPermission() {
    throw UnimplementedError(
      'requestBluetoothScanPermission() has not been implemented',
    );
  }

  Future<bool> hasBluetoothConnectPermission() {
    throw UnimplementedError(
      'hasBluetoothConnectPermission() has not been implemented',
    );
  }

  Future<bool> requestBluetoothConnectPermission() {
    throw UnimplementedError(
      'requestBluetoothConnectPermission() has not been implemented',
    );
  }
}
