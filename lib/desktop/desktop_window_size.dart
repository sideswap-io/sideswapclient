import 'dart:math' as math;
import 'dart:ui';

import 'package:window_size/window_size.dart' show Screen;

/// The outer window the desktop screens are laid out for, in logical pixels
/// (window_manager sizes the outer window). The client area is 16 px
/// narrower and 40 px shorter once Windows takes its frame.
const desktopWindowSize = Size(1088, 880);

/// The screen's work area (the screen minus taskbar, dock or menu bar) in
/// logical pixels, or null when it cannot be determined.
///
/// window_size reports the Windows work area in physical pixels with the
/// DPI scale alongside, while window_manager wants logical pixels; the other
/// desktops already report logical units. Pass [workAreaIsPhysical] for the
/// platforms that need the conversion. An unusable scale factor makes the
/// answer unknown rather than passing a physical size off as logical, which
/// would open a window larger than the screen on a scaled display.
Size? logicalWorkArea(Screen screen, {required bool workAreaIsPhysical}) {
  final frame = screen.frame.size;
  final visible = screen.visibleFrame.size;
  if (!_isUsable(frame) || !_isUsable(visible)) {
    return null;
  }

  // The work area is part of the screen; never trust a report beyond it.
  final area = Size(
    math.min(visible.width, frame.width),
    math.min(visible.height, frame.height),
  );

  if (!workAreaIsPhysical) {
    return area;
  }

  final scale = screen.scaleFactor;
  if (!scale.isFinite || scale <= 0) {
    return null;
  }
  return area / scale;
}

/// The outer window size to open on a screen whose work area is [workArea]
/// logical pixels: [desktopWindowSize], shrunk on each axis that would not
/// fit. An unknown (null) work area keeps the default.
Size desktopWindowSizeFor(Size? workArea) {
  if (workArea == null || !_isUsable(workArea)) {
    return desktopWindowSize;
  }
  return Size(
    math.min(desktopWindowSize.width, workArea.width),
    math.min(desktopWindowSize.height, workArea.height),
  );
}

bool _isUsable(Size size) =>
    size.width.isFinite &&
    size.height.isFinite &&
    size.width > 0 &&
    size.height > 0;
