import 'dart:ui';

/// A display reduced to the two fields the restore decision reads.
typedef DesktopDisplayGeometry = ({
  /// The work area in logical pixels, positioned in the virtual desktop:
  /// the display minus the taskbar, the dock or a panel.
  Rect workArea,

  /// The scale factor the platform reports for this display.
  double scaleFactor,
});

/// What the launch applies when the stored geometry is usable.
typedef DesktopWindowPlacement = ({
  /// The stored normal bounds, to give to `setBounds`.
  Rect bounds,

  /// Whether the launch maximizes the window after it applies [bounds].
  bool maximized,

  /// The work area of the display that accepted [bounds]. The caller sizes
  /// the window minimum against this display, so the display the geometry is
  /// checked against and the display the minimum is computed for are the
  /// same one.
  Rect workArea,
});

/// The placement to restore on launch, or null to fall back to today's
/// launch (`desktopWindowSizeFor` and `center: true`).
///
/// A stored geometry is a hint, never a command. A user who unplugs a
/// monitor or changes the layout must still get a visible window, so this
/// checks the hint against the displays actually present before trusting it.
///
/// Visible means the whole rectangle lies inside one work area of one
/// present display. A window that straddles two monitors is not visible,
/// even where the two work areas together cover it.
///
/// The uniform-scale rule is a guard, not a policy. `setBounds` multiplies
/// the position by the current view's device pixel ratio, so a position
/// saved on a display with another scale factor lands wrong. A later change
/// delivers a native placement channel and lifts the guard.
///
/// The maximized flag rides beside the normal bounds. The visibility check
/// runs on [storedBounds], the normal bounds; when it passes, the caller
/// restores those bounds and then maximizes.
DesktopWindowPlacement? desktopRestorePlacement({
  required Rect? storedBounds,
  required bool storedMaximized,
  required List<DesktopDisplayGeometry> displays,
}) {
  final bounds = storedBounds;
  if (bounds == null || !_isUsable(bounds)) {
    return null;
  }
  if (displays.isEmpty) {
    return null;
  }

  final referenceScale = displays.first.scaleFactor;
  for (final display in displays) {
    if (!_isSameScale(display.scaleFactor, referenceScale)) {
      return null;
    }
  }

  for (final display in displays) {
    if (_isUsable(display.workArea) && _contains(display.workArea, bounds)) {
      return (
        bounds: bounds,
        maximized: storedMaximized,
        workArea: display.workArea,
      );
    }
  }
  return null;
}

/// Whether [bounds] is a rectangle `setBounds` can be given: every edge
/// finite, and both axes strictly positive.
bool _isUsable(Rect bounds) =>
    bounds.left.isFinite &&
    bounds.top.isFinite &&
    bounds.width.isFinite &&
    bounds.height.isFinite &&
    bounds.width > 0 &&
    bounds.height > 0;

/// Whether [scaleFactor] agrees with [reference]: finite, greater than
/// zero, and equal to it.
bool _isSameScale(double scaleFactor, double reference) =>
    scaleFactor.isFinite && scaleFactor > 0 && scaleFactor == reference;

/// Whether [workArea] fully contains [bounds], inclusive on every edge.
bool _contains(Rect workArea, Rect bounds) =>
    workArea.left <= bounds.left &&
    workArea.top <= bounds.top &&
    workArea.right >= bounds.right &&
    workArea.bottom >= bounds.bottom;
