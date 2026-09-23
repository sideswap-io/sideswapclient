import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/providers/desktop_launch_placement_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelDesktopLaunchPlacementService', () {
    late List<MethodCall> calls;

    setUp(() {
      calls = [];
      // Reset in setUp, never at the end of a test: end-of-test cleanup is
      // skipped when an earlier expectation throws (docs/TESTING.md).
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannelDesktopLaunchPlacementService.channel,
            null,
          );
    });

    /// Installs [reply] as the platform side of the placement channel and
    /// records every call, the way the runner's handler would answer.
    void mockPlatform(Future<Object?> Function(MethodCall call) reply) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannelDesktopLaunchPlacementService.channel,
            (call) {
              calls.add(call);
              return reply(call);
            },
          );
    }

    test('the launch work area is the size the platform reported', () async {
      mockPlatform((_) async => {'width': 1920.0, 'height': 1040.0});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), const Size(1920, 1040));
      expect(calls.single.method, 'readLaunchWorkArea');
      expect(calls.single.arguments, isNull);
    });

    test('a reply that is not a map is unreadable', () async {
      mockPlatform((_) async => null);
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a reply of the wrong type is unreadable', () async {
      mockPlatform((_) async => 'no work area here');
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a reply missing a dimension is unreadable', () async {
      mockPlatform((_) async => {'width': 1920.0});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a dimension that is not a number is unreadable', () async {
      mockPlatform((_) async => {'width': 1920.0, 'height': 'tall'});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a width that is not a number is unreadable', () async {
      mockPlatform((_) async => {'width': 'wide', 'height': 1040.0});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a width that is not positive is unreadable', () async {
      mockPlatform((_) async => {'width': -1.0, 'height': 1040.0});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a dimension that is not finite is unreadable', () async {
      mockPlatform((_) async => {'width': double.infinity, 'height': 1040.0});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('a dimension that is not positive is unreadable', () async {
      mockPlatform((_) async => {'width': 1920.0, 'height': 0.0});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), isNull);
    });

    test('an integer reply is read as a size', () async {
      mockPlatform((_) async => {'width': 1920, 'height': 1040});
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.readLaunchWorkArea(), const Size(1920, 1040));
    });

    test('a refused query throws to the caller', () {
      mockPlatform((_) async => throw PlatformException(code: 'no_monitor'));
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(service.readLaunchWorkArea(), throwsA(isA<PlatformException>()));
    });

    test('a build without the handler throws to the caller', () {
      // `setUp` left the channel unhandled, which is what a platform with no
      // placement channel gives.
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(
        service.readLaunchWorkArea(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('placing hands the logical window size to the platform', () async {
      mockPlatform((_) async => true);
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.placeLaunchWindow(const Size(1088, 880)), isTrue);
      expect(calls.single.method, 'placeLaunchWindow');
      expect(calls.single.arguments, {'width': 1088.0, 'height': 880.0});
    });

    test('a platform that did not place the window answers false', () async {
      mockPlatform((_) async => false);
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.placeLaunchWindow(const Size(1088, 880)), isFalse);
    });

    test('a reply that is not a boolean means not placed', () async {
      mockPlatform((_) async => null);
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(await service.placeLaunchWindow(const Size(1088, 880)), isFalse);
    });

    test('a refused placement throws to the caller', () {
      mockPlatform((_) async => throw PlatformException(code: 'no_window'));
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(
        service.placeLaunchWindow(const Size(1088, 880)),
        throwsA(isA<PlatformException>()),
      );
    });

    test('a build without the handler refuses the placement too', () {
      final service = MethodChannelDesktopLaunchPlacementService();

      expect(
        service.placeLaunchWindow(const Size(1088, 880)),
        throwsA(isA<MissingPluginException>()),
      );
    });
  });
}
