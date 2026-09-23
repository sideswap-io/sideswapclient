import Cocoa
import FlutterMacOS

/// The app's macOS placement channel: the work area of the screen under the
/// cursor, and a window centred on that screen.
///
/// A second channel beside `DockAttentionChannel` rather than two more cases
/// in it: this one answers at launch, before the app is running, and it is
/// registered on both desktops that have a runner of their own. The attention
/// channel is macOS-only by nature.
///
/// The decisions live here rather than in Dart because Dart cannot make them.
/// `screen_retriever` flips a display's position with the first screen's
/// height while it flips the cursor with the minimum `maxY` across all
/// screens, so with a taller monitor below the primary the two conversions
/// disagree. Selecting the screen and centring the window in one AppKit call
/// removes the conversion entirely — only a size ever crosses this channel,
/// and every rectangle below stays in AppKit's own bottom-left point space.
/// See ADR-0014 decision 3, as amended by #261.
enum LaunchPlacementChannel {
  static let channelName = "app.sideswap.io/launch_placement"

  /// [window] is the app's main window — the one `window_manager` drives.
  /// Held weakly, and read through rather than `NSApp.mainWindow`, which is
  /// nil at launch, which is exactly when this channel answers.
  static func register(messenger: FlutterBinaryMessenger, window: NSWindow) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)

    // The screen `readLaunchWorkArea` answered for, latched so that
    // `placeLaunchWindow` centres on the display the size was computed from.
    // The two methods are separate hops with the window's own setup between
    // them, and the user can move the cursor across a screen boundary in that
    // time; without the latch the window would be sized for one screen and
    // placed on another. Nil until the first query, which is the mobile-mode
    // path: it asks for no work area, so it places under the cursor.
    var latchedScreen: NSScreen?

    channel.setMethodCallHandler { [weak window] (call: FlutterMethodCall, result: FlutterResult) in
      let isWorkArea = call.method == "readLaunchWorkArea"
      let isPlace = call.method == "placeLaunchWindow"
      guard isWorkArea || isPlace else {
        result(FlutterMethodNotImplemented)
        return
      }

      // A latched screen goes stale when the display layout changes, and
      // `NSScreen.screens` is what says so. Falling back to the cursor then is
      // the same answer this channel gives with nothing latched at all.
      var screen: NSScreen?
      if isPlace, let latched = latchedScreen, NSScreen.screens.contains(latched) {
        screen = latched
      }
      guard let screen = screen ?? screenUnderCursor() else {
        result(
          FlutterError(
            code: "no_screen",
            message: "AppKit reported no screen",
            details: nil))
        return
      }

      if isWorkArea {
        latchedScreen = screen
        let visible = screen.visibleFrame
        result(["width": visible.width, "height": visible.height])
        return
      }

      guard let size = logicalSize(from: call.arguments) else {
        result(
          FlutterError(
            code: "bad_argument",
            message: "placeLaunchWindow needs a logical window size",
            details: nil))
        return
      }

      guard let window else {
        result(
          FlutterError(
            code: "no_window",
            message: "The app has no main window",
            details: nil))
        return
      }

      // Whether the window ended up in the rectangle asked for. False is a
      // real answer the caller acts on: `setFrame` constrains the rectangle
      // it is given, so a frame AppKit refuses must reach Dart rather than be
      // reported as placed.
      let wanted = centred(size, in: screen.visibleFrame)
      window.setFrame(wanted, display: false)
      result(matches(window.frame, wanted))
    }
  }

  private static func screenUnderCursor() -> NSScreen? {
    let cursor = NSEvent.mouseLocation
    return NSScreen.screens.first { $0.frame.contains(cursor) }
      ?? NSScreen.screens.first
  }

  private static func logicalSize(from arguments: Any?) -> NSSize? {
    guard let map = arguments as? [String: Any],
      let width = (map["width"] as? NSNumber)?.doubleValue,
      let height = (map["height"] as? NSNumber)?.doubleValue,
      width.isFinite, height.isFinite, width > 0, height > 0
    else {
      return nil
    }
    return NSSize(width: width, height: height)
  }

  /// Whether [placed] is the rectangle [wanted], within a point.
  ///
  /// A tolerance rather than equality: AppKit rounds a frame to the backing
  /// store, so an exact comparison would report a window placed exactly where
  /// it was asked as misplaced, and send the launch down the fallback path on
  /// every Retina display.
  private static func matches(_ placed: NSRect, _ wanted: NSRect) -> Bool {
    let tolerance = 1.0
    return abs(placed.minX - wanted.minX) < tolerance
      && abs(placed.minY - wanted.minY) < tolerance
      && abs(placed.width - wanted.width) < tolerance
      && abs(placed.height - wanted.height) < tolerance
  }

  /// [size] centred in [workArea], and clamped so that a window larger than
  /// the screen it opens on still starts inside the work area rather than
  /// half off the corner of it.
  ///
  /// The two axes clamp to opposite edges because AppKit measures from the
  /// bottom left: a too-wide window keeps its left edge on screen, and a
  /// too-tall one keeps its *top* edge — the one carrying the title bar the
  /// user drags — which is `maxY`, not `minY`.
  private static func centred(_ size: NSSize, in workArea: NSRect) -> NSRect {
    let x = max(workArea.minX, workArea.midX - size.width / 2)
    let y = min(workArea.maxY - size.height, workArea.midY - size.height / 2)
    return NSRect(x: x, y: y, width: size.width, height: size.height)
  }
}
