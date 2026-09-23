import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/desktop_window_size.dart';
import 'package:window_manager/window_manager.dart';

/// The window commands the chrome measurement needs.
///
/// A seam so the measurement can be driven without a live window. It is
/// injected into the unit that uses it, which is the one case
/// `docs/TESTING.md` allows a platform plugin to be mocked.
abstract interface class DesktopWindowMetrics {
  Future<Size> getSize();
  Future<void> setMinimumSize(Size size);
  Future<bool> isMaximized();
  Future<bool> isMinimized();
  Future<bool> isFullScreen();
}

/// The seam over the real `window_manager`.
class WindowManagerDesktopWindowMetrics implements DesktopWindowMetrics {
  const WindowManagerDesktopWindowMetrics();

  @override
  Future<Size> getSize() => windowManager.getSize();

  @override
  Future<void> setMinimumSize(Size size) => windowManager.setMinimumSize(size);

  @override
  Future<bool> isMaximized() => windowManager.isMaximized();

  @override
  Future<bool> isMinimized() => windowManager.isMinimized();

  @override
  Future<bool> isFullScreen() => windowManager.isFullScreen();
}

/// What `startApp` decided at launch, for the applier to finish.
typedef DesktopLaunchWindow = ({
  /// The work area of the display the window was sized and centred on, or
  /// null when the platform reported none that could be used.
  Size? workArea,

  /// The chrome, where the platform gave it before the window was shown.
  /// Linux only: the toolkit answers there, and the minimum applied at launch
  /// is already final. Null everywhere else, which is what asks the applier
  /// to measure.
  Size? chrome,
});

/// Overridden in `startApp` on the desktop path. The default is what a widget
/// test gets when it does not care, so it stands the measurement down: a
/// non-null chrome is the "already answered" branch, and a test that does not
/// override this provider has no window to measure.
final desktopLaunchWindowProvider = Provider<DesktopLaunchWindow>(
  (ref) => (workArea: null, chrome: Size.zero),
);

/// How long the measurement waits between two samples.
const kDesktopChromeSampleInterval = Duration(milliseconds: 250);

/// How many samples the measurement takes before it gives up.
///
/// Bounded on purpose: a session that stays maximized would otherwise leave a
/// timer running for the life of the app, which is the resize observer
/// ADR-0014 decision 7 refuses by another name.
const kDesktopChromeSampleAttempts = 40;

/// Measures the window chrome and applies the outer minimum size, once.
///
/// Returns the chrome it accepted, or null when it was cancelled or the
/// attempt budget ran out with nothing accepted. In that case the minimum
/// applied at launch stands. ADR-0014 decision 5.
Future<Size?> applyDesktopWindowMinimum({
  required DesktopWindowMetrics metrics,
  required Size? workArea,
  required Size Function() readClientSize,
  required bool Function() isCancelled,
  Duration interval = kDesktopChromeSampleInterval,
  int attempts = kDesktopChromeSampleAttempts,
}) async {
  Size? pending;

  for (var attempt = 0; attempt < attempts; attempt++) {
    if (attempt > 0) {
      await Future<void>.delayed(interval);
    }
    if (isCancelled()) {
      return null;
    }

    if (await metrics.isMinimized() ||
        await metrics.isMaximized() ||
        await metrics.isFullScreen()) {
      // The client area of a window in any of those states says nothing about
      // its frame. The pending sample was taken before the state changed, so
      // it goes too.
      pending = null;
      continue;
    }

    final sample = desktopChromeSample(
      outer: await metrics.getSize(),
      client: readClientSize(),
      pending: pending,
    );
    pending = sample.pending;
    final chrome = sample.chrome;
    if (chrome == null) {
      continue;
    }

    if (isCancelled()) {
      return null;
    }

    final minimum = desktopMinimumSizeFor(chrome: chrome, workArea: workArea);
    await metrics.setMinimumSize(minimum.size);
    if (minimum.capped) {
      logger.w(
        'Work area $workArea is below the supported floor: the window minimum '
        'is ${minimum.size} rather than $desktopFloorClientSize plus $chrome',
      );
    } else {
      logger.i('Window chrome $chrome, minimum ${minimum.size}');
    }
    return chrome;
  }

  logger.w(
    'Window chrome not measured in $attempts attempts; the launch minimum '
    'stands',
  );
  return null;
}

/// Finishes the window policy `startApp` began: measures the chrome the
/// platform would not give before the first frame, and applies the outer
/// minimum size built from it.
///
/// It runs once and latches. Nothing here observes resizes or moves the
/// window — ADR-0014 decision 7.
class DesktopWindowMinimumListener extends HookConsumerWidget {
  const DesktopWindowMinimumListener({
    super.key,
    this.metrics = const WindowManagerDesktopWindowMetrics(),
  });

  /// The window seam. Defaults to the real `window_manager`.
  final DesktopWindowMetrics metrics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launch = ref.watch(desktopLaunchWindowProvider);
    // Read in build, so the measurement sees the current client area rather
    // than the one the first frame had. This does not re-run the effect: the
    // rebuild a resize causes is the point at which the newer size becomes
    // readable, not a trigger.
    final clientSize = MediaQuery.sizeOf(context);
    final latestClientSize = useRef(clientSize);
    latestClientSize.value = clientSize;

    useEffect(() {
      if (launch.chrome != null) {
        // Linux: the toolkit already answered, so the minimum applied at
        // launch is final and there is nothing left to measure.
        return null;
      }

      var cancelled = false;
      unawaited(
        applyDesktopWindowMinimum(
          metrics: metrics,
          workArea: launch.workArea,
          readClientSize: () => latestClientSize.value,
          isCancelled: () => cancelled,
        ),
      );
      return () => cancelled = true;
    }, const []);

    return const SizedBox();
  }
}
