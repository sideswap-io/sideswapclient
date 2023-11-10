// import 'package:flutter_test/flutter_test.dart';
// import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
// import 'package:sideswap_notifications_platform_interface/method_channel_sideswap_notifications.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSideswapNotificationsPlatformInterfacePlatform
//     with MockPlatformInterfaceMixin
//     implements SideswapNotificationsPlatformInterface {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SideswapNotificationsPlatformInterface initialPlatform =
//       SideswapNotificationsPlatformInterface.instance;

//   test(
//       '$MethodChannelSideswapNotificationsPlatformInterface is the default instance',
//       () {
//     expect(initialPlatform,
//         isInstanceOf<MethodChannelSideswapNotificationsPlatformInterface>());
//   });

//   test('getPlatformVersion', () async {
//     SideswapNotificationsPlatformInterface
//         sideswapNotificationsPlatformInterfacePlugin =
//         SideswapNotificationsPlatformInterface();
//     MockSideswapNotificationsPlatformInterfacePlatform fakePlatform =
//         MockSideswapNotificationsPlatformInterfacePlatform();
//     SideswapNotificationsPlatformInterface.instance = fakePlatform;

//     expect(
//         await sideswapNotificationsPlatformInterfacePlugin.getPlatformVersion(),
//         '42');
//   });
// }
