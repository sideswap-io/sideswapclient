import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/desktop_window_minimum_listener.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/test_utils.dart';

class MockDesktopWindowMetrics extends Mock implements DesktopWindowMetrics {}

/// [DesktopWindowMinimumListener] has two branches: it measures where the
/// launch left the chrome unknown, and it stands down where the platform
/// already answered. ADR-0014 decision 5.
void main() {
  late MockDesktopWindowMetrics metrics;

  setUpAll(() => registerFallbackValue(Size.zero));

  setUp(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
    metrics = MockDesktopWindowMetrics();
    when(() => metrics.isMaximized()).thenAnswer((_) async => false);
    when(() => metrics.isMinimized()).thenAnswer((_) async => false);
    when(() => metrics.isFullScreen()).thenAnswer((_) async => false);
    when(() => metrics.getSize()).thenAnswer((_) async => const Size(1088, 880));
    when(() => metrics.setMinimumSize(any())).thenAnswer((_) async {});
  });

  Future<void> pumpListener(
    WidgetTester tester, {
    required DesktopLaunchWindow launch,
    // The client area of a 1088x880 outer window on Windows.
    Size client = const Size(1072, 840),
  }) => tester.pumpWidget(
    ProviderScope(
      overrides: [desktopLaunchWindowProvider.overrideWithValue(launch)],
      child: MediaQuery(
        data: MediaQueryData(size: client),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DesktopWindowMinimumListener(metrics: metrics),
        ),
      ),
    ),
  );

  testWidgets('applies the measured minimum once, then latches', (
    tester,
  ) async {
    await pumpListener(
      tester,
      launch: (workArea: const Size(1920, 1032), chrome: null),
    );
    // The second sample lands one interval after the first.
    await tester.pump(kDesktopChromeSampleInterval);
    await tester.pump();

    verify(() => metrics.setMinimumSize(const Size(1088, 660))).called(1);

    // A resize rebuilds the widget with a new client area. Nothing measures
    // again: the effect keeps its empty dependency list. ADR-0014 decision 7.
    await pumpListener(
      tester,
      launch: (workArea: const Size(1920, 1032), chrome: null),
      client: const Size(1072, 700),
    );
    await tester.pump(kDesktopChromeSampleInterval * 4);
    verifyNever(() => metrics.setMinimumSize(any()));
  });

  testWidgets('measures nothing when the launch already knew the chrome', (
    tester,
  ) async {
    await pumpListener(
      tester,
      launch: (workArea: const Size(1366, 720), chrome: const Size(0, 46)),
    );
    await tester.pump(kDesktopChromeSampleInterval * 4);

    verifyNever(() => metrics.getSize());
    verifyNever(() => metrics.setMinimumSize(any()));
  });
}
