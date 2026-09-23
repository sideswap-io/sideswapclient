import 'package:flutter/services.dart';

/// The two launch questions only the native side can answer together.
///
/// Neither is reachable from Dart in usable units. `screen_retriever` divides
/// each display's work area by *that* display's DPI scale, divides the cursor
/// point by the *current Flutter view's* device pixel ratio, and
/// `window_manager` multiplies a `setBounds` position back by that same
/// current ratio. On a desktop whose monitors run at different scales the
/// three answers are in incompatible units, so a display picked by cursor
/// position and a window placed at a computed position land on different
/// monitors. See ADR-0014 decision 3 and its #261 amendment.
///
/// The fix is not a Dart-side correction: the units are lost before Dart sees
/// them. Selecting the monitor and centring the window happen in one native
/// operation in physical pixels, and only a [Size] ever crosses this seam.
abstract interface class DesktopLaunchPlacementService {
  /// The work area of the display under the cursor, in that display's own
  /// logical units, with the primary display as the platform's fallback.
  ///
  /// Returns null when the platform answered with something this app cannot
  /// read. Throws whatever the channel throws — a build without the handler,
  /// or a platform that refuses. The caller decides what an unanswerable
  /// query means.
  Future<Size?> readLaunchWorkArea();

  /// Centres a window of logical size [size] in the work area of the display
  /// under the cursor, in physical pixels, and moves it there in the same
  /// native call.
  ///
  /// Returns whether the platform placed the window. Throws whatever the
  /// channel throws.
  Future<bool> placeLaunchWindow(Size size);
}

/// The platform-channel implementation, handled by the Windows and macOS
/// runners.
class MethodChannelDesktopLaunchPlacementService
    implements DesktopLaunchPlacementService {
  static const channel = MethodChannel('app.sideswap.io/launch_placement');

  @override
  Future<Size?> readLaunchWorkArea() async {
    final reply = await channel.invokeMethod<Object?>('readLaunchWorkArea');
    // Read defensively rather than cast: a reply of the wrong shape is one of
    // the failure modes the caller's fallback exists for, not a crash.
    if (reply is! Map) {
      return null;
    }

    final width = reply['width'];
    final height = reply['height'];
    if (width is! num || height is! num) {
      return null;
    }

    final workArea = Size(width.toDouble(), height.toDouble());
    // A work area no window fits in is not a work area. Returning null here
    // rather than the value lets the caller take its documented fallback,
    // which reads the layout again through `screen_retriever`, instead of
    // sizing the window at the floor from a report that is plainly junk.
    if (!workArea.isFinite || workArea.width <= 0 || workArea.height <= 0) {
      return null;
    }
    return workArea;
  }

  @override
  Future<bool> placeLaunchWindow(Size size) async {
    final reply = await channel.invokeMethod<Object?>('placeLaunchWindow', {
      'width': size.width,
      'height': size.height,
    });
    return reply == true;
  }
}
