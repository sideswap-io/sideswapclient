import 'dart:math' as math;
import 'dart:ui';

/// The outer window the desktop screens are laid out for, in logical pixels.
///
/// `window_manager` sizes the outer window, so this is an outer figure: the
/// client area is 16 px narrower and 40 px shorter once Windows takes its
/// frame. ADR-0014 decision 2.
const Size desktopDesignWindowSize = Size(1088, 880);

/// The supported floor as a **client** area, in logical pixels.
///
/// The smallest client area every desktop surface must stay usable in.
/// ADR-0014 decision 1 and CONTEXT.md, "Supported floor".
const Size desktopFloorClientSize = Size(1072, 620);

/// The supported floor as an **outer** window, using the Windows frame of
/// 16 x 40 px that `lib/start_app.dart`'s original `min app width is 1072`
/// comment records against its 1088 outer width.
///
/// It serves two purposes on purpose, and they are the same number rather
/// than two that happen to agree: it is the minimum applied before a chrome
/// measurement is accepted (ADR-0014 decision 5), and it is what the launch
/// clamp falls back to when the work area is unknown (decision 4).
const Size desktopFloorWindowSize = Size(1088, 660);

/// A display reduced to the three fields the window policy reads.
///
/// A record rather than `screen_retriever`'s `Display`, so every function
/// below stays a plain value transform that a unit test can drive.
typedef DisplayReport = ({
  /// Where the display's work area starts. `calcWindowPosition` uses this
  /// with [size] to decide which display the cursor is on.
  Offset? visiblePosition,

  /// The display size, as the plugin reports it.
  Size size,

  /// The work area: the display minus the taskbar, the dock or a panel.
  Size? visibleSize,
});

/// The outer window size to open on a display whose work area is [workArea]
/// logical pixels: [desktopDesignWindowSize], shrunk on each axis that would
/// not fit.
///
/// The return is what `setSize` is asked for. [decoration] is the part of the
/// outer window `setSize` does not cover: `Size.zero` everywhere but Linux,
/// where `gtk_window_resize` targets the size excluding the client-side header
/// bar. It is subtracted from the target rather than from the work area, so
/// the outer window matches the target on every platform and not only where
/// the work area binds. ADR-0014 decision 2.
///
/// An unknown (null) or unusable work area falls back to
/// [desktopFloorWindowSize], because a window smaller than it needs to be is
/// one the user can enlarge, while a window larger than its screen is the
/// defect this exists to remove. ADR-0014 decision 4.
///
/// A decoration that leaves nothing of the target falls back to
/// [desktopFloorWindowSize] with no allowance at all: no request both fits the
/// work area and carries the decoration.
Size desktopWindowSizeFor(Size? workArea, {Size decoration = Size.zero}) {
  final target = workArea == null || !_isUsable(workArea)
      ? desktopFloorWindowSize
      : Size(
          math.min(desktopDesignWindowSize.width, workArea.width),
          math.min(desktopDesignWindowSize.height, workArea.height),
        );

  final request = Size(
    target.width - decoration.width,
    target.height - decoration.height,
  );
  if (!_isUsable(request)) {
    return desktopFloorWindowSize;
  }
  return request;
}

bool _isUsable(Size size) =>
    size.width.isFinite &&
    size.height.isFinite &&
    size.width > 0 &&
    size.height > 0;

/// The display `calcWindowPosition` will centre the window on: the one whose
/// bounds contain [point], falling back to [primary].
///
/// The predicate mirrors `calc_window_position.dart:12-20` field for field —
/// containment of the cursor against `visiblePosition` and `size`, not
/// `visibleSize` — so the display this sizes for and the display
/// `center: true` places on are the same display by construction rather than
/// by coincidence. ADR-0014 decision 3.
///
/// One divergence: the plugin force-unwraps `visiblePosition`, so a display
/// that reports none makes it throw. Here such a display is skipped. That is
/// a robustness property of this function alone; `center: true` still routes
/// through the plugin's own version, which is unchanged.
DisplayReport desktopDisplayFor({
  required List<DisplayReport> displays,
  required DisplayReport primary,
  required Offset point,
}) {
  for (final display in displays) {
    final position = display.visiblePosition;
    if (position == null) {
      continue;
    }
    final bounds = Rect.fromLTWH(
      position.dx,
      position.dy,
      display.size.width,
      display.size.height,
    );
    if (bounds.contains(point)) {
      return display;
    }
  }
  return primary;
}

/// The work area of [display] in logical pixels, or null when the plugin
/// reports none that can be used.
///
/// Only `visibleSize` is read. `Display.size` is not a fallback: the Windows
/// plugin computes it as `rcMonitor.right/scale - rcWork.left/scale`, which
/// is not the monitor size on a display other than the primary.
/// ADR-0014 decision 4.
Size? desktopWorkAreaOf(DisplayReport display) {
  final visibleSize = display.visibleSize;
  if (visibleSize == null || !_isUsable(visibleSize)) {
    return null;
  }
  return visibleSize;
}

/// The widest window frame this code will believe, in logical pixels.
///
/// A band rather than an assertion: the measurement runs against a live
/// window, and a sample taken while the window is in a state the guard did
/// not catch produces a difference no desktop frame ever has.
const double _maxPlausibleChromeWidth = 64;

/// The tallest window frame this code will believe, in logical pixels. The
/// tallest real one measured for ADR-0014 is a 46 px GTK header bar.
const double _maxPlausibleChromeHeight = 128;

/// Whether [chrome] is a window frame any of the three desktops could report.
///
/// Zero is plausible and not a failure: on a GTK desktop with server-side
/// decoration the frame lies outside the window the toolkit reports, and no
/// allowance is wanted there. ADR-0014 decision 5.
bool isPlausibleChrome(Size chrome) =>
    chrome.width.isFinite &&
    chrome.height.isFinite &&
    chrome.width >= 0 &&
    chrome.height >= 0 &&
    chrome.width <= _maxPlausibleChromeWidth &&
    chrome.height <= _maxPlausibleChromeHeight;

/// The outer minimum size to apply on a display whose work area is
/// [workArea]: [desktopFloorClientSize] plus [chrome], never larger than the
/// work area on either axis.
///
/// `capped` is true when the work area bound the result. That machine is
/// below the supported floor, and the caller logs it: the window is then
/// smaller than any surface was built for, which is accepted, because a
/// window that cannot be shrunk to fit its own screen is the trap ADR-0014
/// exists to remove. Decision 6.
///
/// A null or implausible [chrome] means no measurement has been accepted yet
/// and yields [desktopFloorWindowSize], still capped. Decision 5.
({Size size, bool capped}) desktopMinimumSizeFor({
  required Size? chrome,
  required Size? workArea,
}) {
  final desired = _desiredMinimumSize(chrome);

  if (workArea == null || !_isUsable(workArea)) {
    return (size: desired, capped: false);
  }

  final size = Size(
    math.min(desired.width, workArea.width),
    math.min(desired.height, workArea.height),
  );
  return (size: size, capped: size != desired);
}

/// The outer minimum the floor asks for before the work area gets a say:
/// [desktopFloorClientSize] plus [chrome].
///
/// A null or implausible [chrome] means no measurement has been accepted yet,
/// and yields the bootstrap constant [desktopFloorWindowSize].
Size _desiredMinimumSize(Size? chrome) {
  if (chrome == null || !isPlausibleChrome(chrome)) {
    return desktopFloorWindowSize;
  }
  return Size(
    desktopFloorClientSize.width + chrome.width,
    desktopFloorClientSize.height + chrome.height,
  );
}

/// One step of the guarded chrome measurement: the difference between the
/// outer window and the client area Flutter lays out in.
///
/// [pending] carries the previous step's sample. Two consecutive equal
/// in-band samples are required, because the window can be resized between
/// the two platform calls a single sample is made of. An out-of-band sample
/// discards the pending one as well as itself: whatever produced it applies
/// to both. ADR-0014 decision 5.
({Size? chrome, Size? pending}) desktopChromeSample({
  required Size outer,
  required Size client,
  required Size? pending,
}) {
  final chrome = Size(outer.width - client.width, outer.height - client.height);
  if (!isPlausibleChrome(chrome)) {
    return (chrome: null, pending: null);
  }
  if (chrome != pending) {
    return (chrome: null, pending: chrome);
  }
  return (chrome: chrome, pending: chrome);
}
