
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/desktop_window_minimum_listener.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';

import 'helpers/test_utils.dart';

class MockDesktopWindowMetrics extends Mock implements DesktopWindowMetrics {}

/// The guarded chrome measurement of ADR-0014 decision 5, and the work-area
/// cap of decision 6 that it feeds.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDesktopWindowMetrics metrics;
  final logOutput = CapturingLogOutput();

  setUpAll(() => registerFallbackValue(Size.zero));

  setUp(() {
    logOutput.lines.clear();
    logger = CustomLogger('SideSwap', output: logOutput);
    metrics = MockDesktopWindowMetrics();
    when(() => metrics.isMaximized()).thenAnswer((_) async => false);
    when(() => metrics.isMinimized()).thenAnswer((_) async => false);
    when(() => metrics.isFullScreen()).thenAnswer((_) async => false);
    when(() => metrics.getSize()).thenAnswer((_) async => const Size(1088, 880));
    when(() => metrics.setMinimumSize(any())).thenAnswer((_) async {});
  });

  Future<Size?> run({
    Size? workArea = const Size(1920, 1032),
    Size client = const Size(1072, 840),
    int attempts = 4,
  }) => applyDesktopWindowMinimum(
    metrics: metrics,
    workArea: workArea,
    readClientSize: () => client,
    isCancelled: () => false,
    attempts: attempts,
    interval: Duration.zero,
  );

  test('applies the floor plus the measured chrome, once', () async {
    expect(await run(), const Size(16, 40));
    verify(() => metrics.setMinimumSize(const Size(1088, 660))).called(1);
  });

  test('caps the applied minimum to the work area', () async {
    expect(await run(workArea: const Size(1366, 648)), const Size(16, 40));
    verify(() => metrics.setMinimumSize(const Size(1088, 648))).called(1);
    expect(
      logOutput.lines.join(' '),
      contains('below the supported floor'),
    );
  });

  test('defers while the window is maximized', () async {
    when(() => metrics.isMaximized()).thenAnswer((_) async => true);
    expect(await run(), isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  test('defers while the window is minimized', () async {
    when(() => metrics.isMinimized()).thenAnswer((_) async => true);
    expect(await run(), isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  test('defers while the window is full-screen', () async {
    when(() => metrics.isFullScreen()).thenAnswer((_) async => true);
    expect(await run(), isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  test('never applies an out-of-band measurement', () async {
    // The client area of a window whose frame no desktop reports.
    expect(await run(client: const Size(1072, 300)), isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  test('needs two equal samples before it applies anything', () async {
    var call = 0;
    when(() => metrics.getSize()).thenAnswer((_) async {
      call++;
      // The first outer size disagrees with every later one.
      return call == 1 ? const Size(1088, 868) : const Size(1088, 880);
    });
    expect(await run(attempts: 2), isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
    expect(await run(attempts: 3), const Size(16, 40));
  });

  test('stops when the attempt budget is spent', () async {
    when(() => metrics.isMaximized()).thenAnswer((_) async => true);
    await run(attempts: 3);
    verify(() => metrics.isMaximized()).called(3);
  });

  test('stops when the listener is disposed', () async {
    var cancelled = false;
    final accepted = await applyDesktopWindowMinimum(
      metrics: metrics,
      workArea: const Size(1920, 1032),
      readClientSize: () {
        cancelled = true;
        return const Size(1072, 840);
      },
      isCancelled: () => cancelled,
      attempts: 4,
      interval: Duration.zero,
    );
    expect(accepted, isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  test('applies nothing when the dispose lands on the accepted sample', () async {
    // The second sample is the one that accepts. Cancelling as it is read
    // leaves an accepted chrome that must not reach the window.
    var samples = 0;
    var cancelled = false;
    final accepted = await applyDesktopWindowMinimum(
      metrics: metrics,
      workArea: const Size(1920, 1032),
      readClientSize: () {
        samples++;
        if (samples == 2) {
          cancelled = true;
        }
        return const Size(1072, 840);
      },
      isCancelled: () => cancelled,
      attempts: 4,
      interval: Duration.zero,
    );
    expect(samples, 2);
    expect(accepted, isNull);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  group('WindowManagerDesktopWindowMetrics', () {
    const channel = MethodChannel('window_manager');
    const metrics = WindowManagerDesktopWindowMetrics();
    late List<MethodCall> calls;

    setUp(() {
      calls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return switch (call.method) {
              'getBounds' => {
                'x': 10.0,
                'y': 20.0,
                'width': 1088.0,
                'height': 880.0,
              },
              'isMaximized' => true,
              'isMinimized' => false,
              'isFullScreen' => true,
              _ => null,
            };
          });
    });

    test('forwards every query and command to window_manager', () async {
      expect(await metrics.getSize(), const Size(1088, 880));
      expect(await metrics.isMaximized(), isTrue);
      expect(await metrics.isMinimized(), isFalse);
      expect(await metrics.isFullScreen(), isTrue);
      await metrics.setMinimumSize(const Size(1088, 660));

      expect(calls.map((c) => c.method), [
        'getBounds',
        'isMaximized',
        'isMinimized',
        'isFullScreen',
        'setMinimumSize',
      ]);
      expect(
        calls.last.arguments,
        containsPair('width', 1088.0),
      );
      expect(calls.last.arguments, containsPair('height', 660.0));
    });
  });

  test('the default launch window stands the measurement down', () {
    // A widget test that does not override this provider has no window to
    // measure, so the default takes the "already answered" branch.
    final container = ProviderContainer.test();
    expect(
      container.read(desktopLaunchWindowProvider),
      (workArea: null, chrome: Size.zero),
    );
  });
}
