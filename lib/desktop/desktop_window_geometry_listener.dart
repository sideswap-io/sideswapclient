import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/desktop_window_geometry.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:window_manager/window_manager.dart';

/// The window state the geometry recorder reads.
///
/// A seam so the recorder can run without a live window. It is injected into
/// the unit that uses it, which is the one case `docs/TESTING.md` allows a
/// platform plugin to be mocked.
abstract interface class DesktopWindowGeometrySource {
  Future<Rect> getBounds();
  Future<bool> isMaximized();
  Future<bool> isMinimized();
  Future<bool> isFullScreen();
}

/// The seam over the real `window_manager`.
class WindowManagerDesktopWindowGeometrySource
    implements DesktopWindowGeometrySource {
  const WindowManagerDesktopWindowGeometrySource();

  @override
  Future<Rect> getBounds() => windowManager.getBounds();

  @override
  Future<bool> isMaximized() => windowManager.isMaximized();

  @override
  Future<bool> isMinimized() => windowManager.isMinimized();

  @override
  Future<bool> isFullScreen() => windowManager.isFullScreen();
}

/// How long the recorder waits after the last move or resize event before it
/// stores the geometry.
///
/// A crash or a killed process loses at most this much. The close path
/// captures without waiting.
const kDesktopWindowGeometryDebounce = Duration(milliseconds: 500);

/// The longest a burst of events runs before the recorder writes anyway.
///
/// A trailing debounce on its own loses the whole burst when the process dies
/// during it: a ten-second drag would write nothing. This bounds the loss at
/// one debounce interval past this wait.
const kDesktopWindowGeometryMaxWait = Duration(seconds: 2);

/// Debounces window move and resize events and stores the settled geometry.
///
/// A maximized window keeps the normal bounds it already had and only gains
/// the flag: the maximized rectangle itself is never stored. Full-screen and
/// minimized states never reach the store, because neither describes normal
/// bounds. The debounce is what keeps the full settings write cheap: an
/// event burst writes once, after it settles, instead of on every event.
class DesktopWindowGeometryRecorder {
  DesktopWindowGeometryRecorder({
    required this.source,
    required this.readStored,
    required this.save,
    this.debounce = kDesktopWindowGeometryDebounce,
    this.maxWait = kDesktopWindowGeometryMaxWait,
  });

  final DesktopWindowGeometrySource source;
  final DesktopWindowGeometry? Function() readStored;
  final void Function(DesktopWindowGeometry geometry) save;
  final Duration debounce;
  final Duration maxWait;

  Timer? _timer;
  Timer? _maxTimer;
  bool _disposed = false;

  /// The last bounds the window reported while it was neither maximized,
  /// minimized nor full-screen.
  ///
  /// A maximized window cannot report its normal bounds, so the recorder
  /// remembers them itself. Without this the maximized flag rides whatever
  /// the store happened to hold, which is the wrong rectangle when the move
  /// that preceded the maximize has not been written yet.
  Rect? _normalBounds;

  /// Serializes the sampling and the capture, so two of them never interleave
  /// their awaits on the seam.
  Future<void> _pending = Future<void>.value();

  /// Samples the bounds now and schedules the store write.
  ///
  /// The sample runs on every event, because a maximize event that lands
  /// inside the debounce would otherwise cancel the write and leave the flag
  /// riding the bounds from before the move.
  ///
  /// The write runs when the burst settles, or after [maxWait], whichever
  /// comes first. Repeated calls restart the debounce but never restart the
  /// maximum wait.
  void schedule() {
    if (_disposed) {
      return;
    }
    _enqueue(_sampleNormalBounds);
    _timer?.cancel();
    _timer = Timer(debounce, _fire);
    _maxTimer ??= Timer(maxWait, _fire);
  }

  void _fire() {
    _timer?.cancel();
    _timer = null;
    _maxTimer?.cancel();
    _maxTimer = null;
    _enqueue(capture);
  }

  void _enqueue(Future<void> Function() action) {
    _pending = _pending.then((_) => action());
  }

  /// Captures now, without waiting for the debounce.
  ///
  /// The close path uses this. It cancels the pending timers first, so the
  /// close capture and a timer capture never both run.
  Future<void> flush() {
    _timer?.cancel();
    _timer = null;
    _maxTimer?.cancel();
    _maxTimer = null;
    _enqueue(capture);
    return _pending;
  }

  /// Remembers the window's normal bounds, or leaves the last ones alone.
  ///
  /// A minimized, full-screen or maximized window reports a rectangle that is
  /// not its normal bounds, so none of them is sampled.
  Future<void> _sampleNormalBounds() async {
    if (_disposed) {
      return;
    }
    if (await source.isMinimized()) {
      return;
    }
    if (await source.isFullScreen()) {
      return;
    }
    if (await source.isMaximized()) {
      return;
    }
    final bounds = await source.getBounds();
    if (!_isUsable(bounds)) {
      return;
    }
    _normalBounds = bounds;
  }

  /// Reads the window state now and stores it, unless the state says nothing
  /// about the normal bounds.
  Future<void> capture() async {
    if (_disposed) {
      return;
    }
    if (await source.isMinimized()) {
      return;
    }
    if (await source.isFullScreen()) {
      return;
    }
    if (await source.isMaximized()) {
      // A maximized window keeps the normal bounds it came from. The sampled
      // bounds win over the stored ones, because a move inside the debounce
      // is sampled but not yet written.
      final bounds = _normalBounds ?? _storedBounds();
      if (bounds == null) {
        return;
      }
      _save(bounds, maximized: true);
      return;
    }
    final bounds = await source.getBounds();
    if (!_isUsable(bounds)) {
      return;
    }
    // The state can change between the checks above and this read. Read it
    // again rather than store a full-screen or a maximized rectangle as the
    // normal bounds.
    if (await source.isFullScreen()) {
      return;
    }
    if (await source.isMaximized()) {
      return;
    }
    _normalBounds = bounds;
    _save(bounds, maximized: false);
  }

  /// The stored normal bounds, or null when nothing is stored.
  Rect? _storedBounds() {
    final stored = readStored();
    if (stored == null) {
      return null;
    }
    return Rect.fromLTWH(stored.left, stored.top, stored.width, stored.height);
  }

  /// Stores [bounds] unless the recorder is disposed or nothing changed.
  void _save(Rect bounds, {required bool maximized}) {
    if (_disposed) {
      return;
    }
    final next = DesktopWindowGeometry(
      left: bounds.left,
      top: bounds.top,
      width: bounds.width,
      height: bounds.height,
      maximized: maximized,
    );
    // An event burst that ends where it started writes nothing.
    if (next == readStored()) {
      return;
    }
    save(next);
  }

  bool _isUsable(Rect bounds) {
    if (!bounds.left.isFinite ||
        !bounds.top.isFinite ||
        !bounds.width.isFinite ||
        !bounds.height.isFinite) {
      return false;
    }
    if (bounds.width <= 0 || bounds.height <= 0) return false;
    return true;
  }

  /// Stops the recorder. No further capture runs after this.
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    _maxTimer?.cancel();
    _maxTimer = null;
  }
}

/// Records the window's normal bounds so the next launch can restore them.
///
/// Listens to move and resize events and stores the settled geometry through
/// [DesktopWindowGeometryRecorder]. Renders nothing.
class DesktopWindowGeometryListener extends ConsumerStatefulWidget {
  const DesktopWindowGeometryListener({
    super.key,
    this.source = const WindowManagerDesktopWindowGeometrySource(),
    this.debounce = kDesktopWindowGeometryDebounce,
  });

  /// The window seam. Defaults to the real `window_manager`.
  final DesktopWindowGeometrySource source;

  /// How long the recorder waits after the last event before it stores.
  final Duration debounce;

  @override
  DesktopWindowGeometryListenerState createState() =>
      DesktopWindowGeometryListenerState();
}

class DesktopWindowGeometryListenerState
    extends ConsumerState<DesktopWindowGeometryListener>
    with WindowListener {
  late final DesktopWindowGeometryRecorder recorder;

  @override
  void initState() {
    super.initState();
    recorder = DesktopWindowGeometryRecorder(
      source: widget.source,
      readStored: () => ref.read(configurationProvider).desktopWindowGeometry,
      save: (geometry) =>
          ref.read(configurationProvider.notifier).setDesktopWindowGeometry(
            geometry,
          ),
      debounce: widget.debounce,
    );
    windowManager.addListener(this);
    // Store the launch geometry once, so a window the user only maximizes
    // still has normal bounds for the flag to ride beside. Without this a
    // first run that never moves the window stores nothing, and the maximized
    // state is lost. ADR-0016 decision 5.
    recorder.schedule();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    recorder.dispose();
    super.dispose();
  }

  // `onWindowMoved` and `onWindowResized` fire only on Windows and macOS, so
  // the continuous `onWindowMove` and `onWindowResize` are listened to as
  // well and the debounce absorbs the duplicates.
  @override
  void onWindowMove() {
    recorder.schedule();
  }

  @override
  void onWindowMoved() {
    recorder.schedule();
  }

  @override
  void onWindowResize() {
    recorder.schedule();
  }

  @override
  void onWindowResized() {
    recorder.schedule();
  }

  @override
  void onWindowMaximize() {
    recorder.schedule();
  }

  @override
  void onWindowUnmaximize() {
    recorder.schedule();
  }

  // The close path captures without the debounce and is not turned into a
  // prevent-close flow, so the write is best effort. It cancels the pending
  // timers first, so the close capture and a timer capture never both run.
  @override
  void onWindowClose() {
    unawaited(recorder.flush());
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
