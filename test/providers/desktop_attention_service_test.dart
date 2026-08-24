import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/providers/desktop_attention_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelDesktopAttentionService', () {
    late List<MethodCall> calls;

    setUp(() {
      calls = [];
      // Reset in setUp, never at the end of a test: end-of-test cleanup is
      // skipped when an earlier expectation throws (docs/TESTING.md).
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannelDesktopAttentionService.channel,
            null,
          );
    });

    /// Installs [reply] as the platform side of the attention channel and
    /// records every call, the way the macOS runner's handler would answer.
    void mockPlatform(Future<Object?> Function(MethodCall call) reply) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannelDesktopAttentionService.channel,
            (call) {
              calls.add(call);
              return reply(call);
            },
          );
    }

    test('requesting critical attention returns the id the platform issued', () async {
      mockPlatform((_) async => 7);
      final service = MethodChannelDesktopAttentionService();

      final requestId = await service.requestCriticalAttention();

      expect(requestId, 7);
      expect(calls.single.method, 'requestCriticalAttention');
    });

    test(
      'a null reply means the app was already active and no request was issued',
      () async {
        mockPlatform((_) async => null);
        final service = MethodChannelDesktopAttentionService();

        expect(await service.requestCriticalAttention(), isNull);
      },
    );

    test('cancelling passes the attention request id to the platform', () async {
      mockPlatform((_) async => null);
      final service = MethodChannelDesktopAttentionService();

      await service.cancelAttention(7);

      expect(calls.single.method, 'cancelAttention');
      expect(calls.single.arguments, 7);
    });

    test('the pending count is handed to the platform as it stands', () async {
      mockPlatform((_) async => null);
      final service = MethodChannelDesktopAttentionService();

      await service.setPendingBadge(2);

      expect(calls.single.method, 'setPendingBadge');
      expect(calls.single.arguments, 2);
    });

    test(
      'zero is handed over like any other count, for the platform to render as '
      'no badge at all',
      () async {
        mockPlatform((_) async => null);
        final service = MethodChannelDesktopAttentionService();

        await service.setPendingBadge(0);

        expect(calls.single.method, 'setPendingBadge');
        expect(calls.single.arguments, 0);
      },
    );

    test(
      'one call carries back both facts the app cannot measure from Dart',
      () async {
        mockPlatform((_) async => {'isOnActiveSpace': true, 'isHidden': false});
        final service = MethodChannelDesktopAttentionService();

        final placement = await service.readWindowPlacement();

        expect(placement?.isOnActiveSpace, isTrue);
        expect(placement?.isHidden, isFalse);
        expect(calls.single.method, 'readWindowPlacement');
      },
    );

    test('the facts are carried back as the platform reported them', () async {
      mockPlatform((_) async => {'isOnActiveSpace': false, 'isHidden': true});
      final service = MethodChannelDesktopAttentionService();

      final placement = await service.readWindowPlacement();

      expect(placement?.isOnActiveSpace, isFalse);
      expect(placement?.isHidden, isTrue);
    });

    test('a null placement reply is unreadable rather than a placement', () async {
      mockPlatform((_) async => null);
      final service = MethodChannelDesktopAttentionService();

      expect(await service.readWindowPlacement(), isNull);
    });

    test('a placement reply that is not a map at all is unreadable', () async {
      mockPlatform((_) async => 'not a placement');
      final service = MethodChannelDesktopAttentionService();

      expect(await service.readWindowPlacement(), isNull);
    });

    test('a placement map whose facts are not booleans is unreadable', () async {
      mockPlatform((_) async => {'isOnActiveSpace': 1, 'isHidden': 0});
      final service = MethodChannelDesktopAttentionService();

      expect(await service.readWindowPlacement(), isNull);
    });

    test('a placement map missing one of the two facts is unreadable', () async {
      mockPlatform((_) async => {'isOnActiveSpace': true});
      final service = MethodChannelDesktopAttentionService();

      expect(await service.readWindowPlacement(), isNull);
    });

    test('a platform that refuses the placement query throws to the caller', () async {
      mockPlatform((_) => Future.error(PlatformException(code: 'no_window')));
      final service = MethodChannelDesktopAttentionService();

      await expectLater(
        service.readWindowPlacement(),
        throwsA(isA<PlatformException>()),
      );
    });

    test(
      'a build with no handler for the channel throws the placement query back '
      'to the caller',
      () async {
        // setUp left the channel without a handler, the way a runner that never
        // registered it would.
        final service = MethodChannelDesktopAttentionService();

        await expectLater(
          service.readWindowPlacement(),
          throwsA(isA<MissingPluginException>()),
        );
      },
    );
  });
}
