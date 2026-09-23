import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/desktop_window_geometry_listener.dart';
import 'package:sideswap/models/desktop_window_geometry.dart';

class MockDesktopWindowGeometrySource extends Mock
    implements DesktopWindowGeometrySource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDesktopWindowGeometrySource source;
  late List<DesktopWindowGeometry> saves;
  late DesktopWindowGeometry? stored;

  const normalBounds = Rect.fromLTWH(10, 20, 800, 600);
  const normalGeometry = DesktopWindowGeometry(
    left: 10,
    top: 20,
    width: 800,
    height: 600,
  );

  setUp(() {
    source = MockDesktopWindowGeometrySource();
    saves = [];
    stored = null;
    when(() => source.isMinimized()).thenAnswer((_) async => false);
    when(() => source.isFullScreen()).thenAnswer((_) async => false);
    when(() => source.isMaximized()).thenAnswer((_) async => false);
    when(() => source.getBounds()).thenAnswer((_) async => normalBounds);
  });

  DesktopWindowGeometryRecorder buildRecorder({
    Duration debounce = Duration.zero,
    Duration maxWait = kDesktopWindowGeometryMaxWait,
  }) => DesktopWindowGeometryRecorder(
    source: source,
    readStored: () => stored,
    save: saves.add,
    debounce: debounce,
    maxWait: maxWait,
  );

  group('DesktopWindowGeometryRecorder', () {
    test('capture() on a normal window stores the bounds with maximized '
        'false', () async {
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, [normalGeometry]);
    });

    test('capture() on a minimized window stores nothing, and does not call '
        'getBounds', () async {
      when(() => source.isMinimized()).thenAnswer((_) async => true);
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
      verifyNever(() => source.getBounds());
    });

    test('capture() on a full-screen window stores nothing, and does not '
        'call getBounds', () async {
      when(() => source.isFullScreen()).thenAnswer((_) async => true);
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
      verifyNever(() => source.getBounds());
    });

    test('capture() on a maximized window with a stored geometry stores the '
        'same bounds with maximized true, and does not call getBounds', () async {
      // capture() is called directly, so schedule() never ran and
      // _normalBounds is null: the fallback to the stored bounds is what
      // this test proves.
      when(() => source.isMaximized()).thenAnswer((_) async => true);
      stored = normalGeometry;
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, [normalGeometry.copyWith(maximized: true)]);
      verifyNever(() => source.getBounds());
    });

    test('capture() on a maximized window with no stored geometry stores '
        'nothing', () async {
      when(() => source.isMaximized()).thenAnswer((_) async => true);
      stored = null;
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('capture() on a maximized window whose stored geometry is already '
        'maximized true stores nothing', () async {
      when(() => source.isMaximized()).thenAnswer((_) async => true);
      stored = normalGeometry.copyWith(maximized: true);
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('capture() on a normal window whose bounds equal the stored '
        'geometry stores nothing', () async {
      stored = normalGeometry;
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('capture() on a normal window whose bounds carry a non-finite edge '
        'stores nothing', () async {
      when(
        () => source.getBounds(),
      ).thenAnswer((_) async => const Rect.fromLTWH(double.infinity, 20, 800, 600));
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('capture() on a normal window whose bounds have zero width stores '
        'nothing', () async {
      when(
        () => source.getBounds(),
      ).thenAnswer((_) async => const Rect.fromLTWH(10, 20, 0, 600));
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('capture() on a normal window whose bounds have zero height stores '
        'nothing', () async {
      when(
        () => source.getBounds(),
      ).thenAnswer((_) async => const Rect.fromLTWH(10, 20, 800, 0));
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('capture() after dispose() stores nothing and reads no window '
        'state', () async {
      final recorder = buildRecorder();
      recorder.dispose();
      await recorder.capture();
      expect(saves, isEmpty);
      verifyNever(() => source.isMinimized());
      verifyNever(() => source.isFullScreen());
      verifyNever(() => source.isMaximized());
      verifyNever(() => source.getBounds());
    });

    test('schedule() with a zero debounce eventually stores the geometry', () async {
      final recorder = buildRecorder();
      recorder.schedule();
      await Future<void>.delayed(Duration.zero);
      expect(saves, [normalGeometry]);
    });

    test('schedule() twice in a row runs one write only', () async {
      final recorder = buildRecorder();
      recorder.schedule();
      recorder.schedule();
      await Future<void>.delayed(Duration.zero);
      // The second call restarts the debounce, so one capture runs and one
      // geometry reaches the store. The number of seam queries is an
      // implementation detail and is not asserted.
      expect(saves, [normalGeometry]);
    });

    test('schedule() after dispose() starts no timer and stores nothing', () async {
      final recorder = buildRecorder();
      recorder.dispose();
      recorder.schedule();
      await Future<void>.delayed(Duration.zero);
      expect(saves, isEmpty);
      verifyNever(() => source.isMinimized());
    });

    test('dispose() cancels a pending timer', () async {
      final recorder = buildRecorder(debounce: const Duration(milliseconds: 50));
      recorder.schedule();
      recorder.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(saves, isEmpty);
      verifyNever(() => source.isMinimized());
    });

    test(
      'a maximize inside the debounce stores the sampled bounds, not the '
      'stale stored ones',
      () async {
        // The move: the window reports it is now on the secondary monitor.
        const movedBounds = Rect.fromLTWH(2000, 100, 900, 700);
        when(() => source.getBounds()).thenAnswer((_) async => movedBounds);
        // The store still holds a different, older geometry.
        stored = const DesktopWindowGeometry(
          left: 0,
          top: 0,
          width: 900,
          height: 700,
        );
        final recorder = buildRecorder(
          debounce: const Duration(milliseconds: 50),
        );
        recorder.schedule(); // The move.
        await Future<void>.delayed(const Duration(milliseconds: 10));
        // The maximize, before the debounce from the move elapses.
        when(() => source.isMaximized()).thenAnswer((_) async => true);
        recorder.schedule();
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(saves, [
          const DesktopWindowGeometry(
            left: 2000,
            top: 100,
            width: 900,
            height: 700,
            maximized: true,
          ),
        ]);
      },
    );

    test('the maximum wait writes during a continuous burst', () {
      fakeAsync((async) {
        final recorder = buildRecorder(
          debounce: const Duration(milliseconds: 500),
          maxWait: const Duration(seconds: 2),
        );
        for (var i = 0; i < 9; i++) {
          recorder.schedule();
          async.elapse(const Duration(milliseconds: 300));
          if (i == 6) {
            // 2100ms elapsed: past maxWait, while the burst (interval 300ms,
            // shorter than the 500ms debounce) is still running. The
            // debounce alone would never fire during a burst like this.
            expect(saves, isNotEmpty);
          }
        }
        recorder.dispose();
      });
    });

    test('the maximum wait does not restart', () {
      fakeAsync((async) {
        final recorder = buildRecorder(
          debounce: const Duration(milliseconds: 20),
          maxWait: const Duration(milliseconds: 60),
        );
        for (var i = 0; i < 10; i++) {
          recorder.schedule();
          async.elapse(const Duration(milliseconds: 10));
          if (i == 6) {
            // 70ms elapsed: the maxWait timer, set by the first schedule()
            // call and never restarted by the later ones, has already fired.
            expect(saves, isNotEmpty);
          }
        }
        recorder.dispose();
      });
    });

    test('a window that turns full-screen after the first check stores '
        'nothing', () async {
      var fullScreenCalls = 0;
      when(() => source.isFullScreen()).thenAnswer((_) async {
        fullScreenCalls++;
        return fullScreenCalls > 1;
      });
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('a window that turns maximized after the first check stores '
        'nothing', () async {
      var maximizedCalls = 0;
      when(() => source.isMaximized()).thenAnswer((_) async {
        maximizedCalls++;
        return maximizedCalls > 1;
      });
      final recorder = buildRecorder();
      await recorder.capture();
      expect(saves, isEmpty);
    });

    test('flush() cancels a pending timer and stores immediately, leaving '
        'no timer pending', () {
      fakeAsync((async) {
        final recorder = buildRecorder(debounce: const Duration(seconds: 10));
        recorder.schedule();
        unawaited(recorder.flush());
        async.flushMicrotasks();

        expect(saves, [normalGeometry]);
        expect(async.pendingTimers, isEmpty);
      });
    });

    test('the sample drops unusable bounds and keeps the last good ones',
        () async {
      final recorder = buildRecorder();
      // A first burst samples and writes a good rectangle.
      recorder.schedule();
      await Future<void>.delayed(Duration.zero);
      stored = saves.last;

      // The window now reports an unusable rectangle. The sample drops it, so
      // the maximized capture still rides the last good bounds.
      when(() => source.getBounds()).thenAnswer(
        (_) async => const Rect.fromLTWH(10, 20, 0, 600),
      );
      recorder.schedule();
      await Future<void>.delayed(Duration.zero);
      when(() => source.isMaximized()).thenAnswer((_) async => true);
      await recorder.capture();

      expect(saves.last, normalGeometry.copyWith(maximized: true));
      recorder.dispose();
    });

    test('a capture that is disposed while it reads the window stores nothing',
        () async {
      final recorder = buildRecorder();
      // The recorder is disposed after the state queries answer and before the
      // save runs. The half-finished capture must not write.
      when(() => source.getBounds()).thenAnswer((_) async {
        recorder.dispose();
        return normalBounds;
      });

      await recorder.capture();

      expect(saves, isEmpty);
    });

    test('flush() after dispose() stores nothing', () async {
      final recorder = buildRecorder();
      recorder.dispose();
      await recorder.flush();
      expect(saves, isEmpty);
    });
  });

  group('WindowManagerDesktopWindowGeometrySource', () {
    const channel = MethodChannel('window_manager');
    const geometrySource = WindowManagerDesktopWindowGeometrySource();
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
                'width': 800.0,
                'height': 600.0,
              },
              'isMaximized' => true,
              'isMinimized' => false,
              'isFullScreen' => true,
              _ => null,
            };
          });
    });

    test('forwards every query to window_manager', () async {
      expect(await geometrySource.getBounds(), normalBounds);
      expect(await geometrySource.isMaximized(), isTrue);
      expect(await geometrySource.isMinimized(), isFalse);
      expect(await geometrySource.isFullScreen(), isTrue);

      expect(calls.map((c) => c.method), [
        'getBounds',
        'isMaximized',
        'isMinimized',
        'isFullScreen',
      ]);
    });
  });
}
