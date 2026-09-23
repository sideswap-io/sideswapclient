import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/desktop_window_geometry_listener.dart';
import 'package:sideswap/models/desktop_window_geometry.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/fake_shared_preferences.dart';
import '../helpers/settings_container.dart';
import '../helpers/test_utils.dart';

class MockDesktopWindowGeometrySource extends Mock
    implements DesktopWindowGeometrySource {}

/// [DesktopWindowGeometryListener] renders nothing. Its behaviour lives in
/// its lifecycle and its [WindowListener] overrides, which schedule or run
/// [DesktopWindowGeometryRecorder.capture] and land in [configurationProvider].
void main() {
  late MockDesktopWindowGeometrySource source;
  late FakeSharedPreferences prefs;
  late ProviderContainer container;

  const launchBounds = Rect.fromLTWH(100, 200, 1088, 880);
  const launchGeometry = DesktopWindowGeometry(
    left: 100,
    top: 200,
    width: 1088,
    height: 880,
  );

  setUp(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
    source = MockDesktopWindowGeometrySource();
    when(() => source.isMinimized()).thenAnswer((_) async => false);
    when(() => source.isFullScreen()).thenAnswer((_) async => false);
    when(() => source.isMaximized()).thenAnswer((_) async => false);
    when(() => source.getBounds()).thenAnswer((_) async => launchBounds);
    prefs = FakeSharedPreferences();
    container = settingsContainer(prefs);
  });

  /// Mounts the listener over [container], so the state it writes is the
  /// state this test reads back.
  Future<void> pumpListener(
    WidgetTester tester, {
    Duration debounce = Duration.zero,
  }) => tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DesktopWindowGeometryListener(
          source: source,
          debounce: debounce,
        ),
      ),
    ),
  );

  /// Advances past [debounce] and drains the recorder's async capture chain.
  Future<void> settleDebounce(WidgetTester tester, Duration debounce) async {
    await tester.pump(debounce);
    await tester.pump();
    await tester.pump();
  }

  DesktopWindowGeometryListenerState stateOf(WidgetTester tester) =>
      tester.state<DesktopWindowGeometryListenerState>(
        find.byType(DesktopWindowGeometryListener),
      );

  DesktopWindowGeometry? storedGeometry() =>
      container.read(configurationProvider).desktopWindowGeometry;

  group('DesktopWindowGeometryListener', () {
    testWidgets('renders nothing visible', (tester) async {
      await pumpListener(tester);

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('mounting stores the launch geometry', (tester) async {
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), launchGeometry);
    });

    testWidgets('a move event stores the new bounds', (tester) async {
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      const movedBounds = Rect.fromLTWH(300, 400, 900, 700);
      const movedGeometry = DesktopWindowGeometry(
        left: 300,
        top: 400,
        width: 900,
        height: 700,
      );
      when(() => source.getBounds()).thenAnswer((_) async => movedBounds);
      stateOf(tester).onWindowMoved();
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), movedGeometry);
    });

    testWidgets('a resize event stores the new bounds', (tester) async {
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      const resizedBounds = Rect.fromLTWH(300, 400, 900, 700);
      const resizedGeometry = DesktopWindowGeometry(
        left: 300,
        top: 400,
        width: 900,
        height: 700,
      );
      when(() => source.getBounds()).thenAnswer((_) async => resizedBounds);
      stateOf(tester).onWindowResized();
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), resizedGeometry);
    });

    testWidgets('the continuous move event stores the new bounds', (
      tester,
    ) async {
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      const movedBounds = Rect.fromLTWH(300, 400, 900, 700);
      const movedGeometry = DesktopWindowGeometry(
        left: 300,
        top: 400,
        width: 900,
        height: 700,
      );
      when(() => source.getBounds()).thenAnswer((_) async => movedBounds);
      stateOf(tester).onWindowMove();
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), movedGeometry);
    });

    testWidgets('the continuous resize event stores the new bounds', (
      tester,
    ) async {
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      const resizedBounds = Rect.fromLTWH(300, 400, 900, 700);
      const resizedGeometry = DesktopWindowGeometry(
        left: 300,
        top: 400,
        width: 900,
        height: 700,
      );
      when(() => source.getBounds()).thenAnswer((_) async => resizedBounds);
      stateOf(tester).onWindowResize();
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), resizedGeometry);
    });

    testWidgets('maximizing sets the flag and keeps the normal bounds', (
      tester,
    ) async {
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      when(() => source.isMaximized()).thenAnswer((_) async => true);
      stateOf(tester).onWindowMaximize();
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), launchGeometry.copyWith(maximized: true));
    });

    testWidgets(
      'unmaximizing clears the flag and stores the normal bounds again',
      (tester) async {
        await pumpListener(tester);
        await settleDebounce(tester, Duration.zero);

        when(() => source.isMaximized()).thenAnswer((_) async => true);
        stateOf(tester).onWindowMaximize();
        await settleDebounce(tester, Duration.zero);

        when(() => source.isMaximized()).thenAnswer((_) async => false);
        when(() => source.getBounds()).thenAnswer((_) async => launchBounds);
        stateOf(tester).onWindowUnmaximize();
        await settleDebounce(tester, Duration.zero);

        expect(storedGeometry(), launchGeometry.copyWith(maximized: false));
      },
    );

    testWidgets('closing stores without waiting for the debounce', (
      tester,
    ) async {
      await pumpListener(tester, debounce: const Duration(seconds: 10));
      await tester.pump();

      const closedBounds = Rect.fromLTWH(500, 600, 640, 480);
      const closedGeometry = DesktopWindowGeometry(
        left: 500,
        top: 600,
        width: 640,
        height: 480,
      );
      when(() => source.getBounds()).thenAnswer((_) async => closedBounds);
      stateOf(tester).onWindowClose();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(storedGeometry(), closedGeometry);

      // Cancels the pending 10-second timer, so the test leaves none behind.
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('a full-screen window stores nothing', (tester) async {
      when(() => source.isFullScreen()).thenAnswer((_) async => true);
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), isNull);
    });

    testWidgets('a minimized window stores nothing', (tester) async {
      when(() => source.isMinimized()).thenAnswer((_) async => true);
      await pumpListener(tester);
      await settleDebounce(tester, Duration.zero);

      expect(storedGeometry(), isNull);
    });

    testWidgets('disposing stops the recorder', (tester) async {
      await pumpListener(tester, debounce: const Duration(seconds: 10));
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 11));

      expect(storedGeometry(), isNull);
    });
  });
}
