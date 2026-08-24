import Cocoa
import FlutterMacOS

/// The app's one macOS platform channel: the Dock bounce while a Liquid Connect
/// request is waiting, and where the window stands when one arrives.
///
/// The decisions live here rather than in Dart because Dart cannot make them.
/// AppKit's contract is that attention is requested only while the app is
/// inactive, "active" is *application* activity rather than window key-ness,
/// and the answer can change between a Dart-side query and the request that
/// follows it; checking and requesting in the same hop is what makes the answer
/// usable (ADR-0004 decision 4). `isOnActiveSpace` is not exposed to Dart at
/// all, and a minimized window already reports itself invisible, so visibility
/// cannot separate "minimized" from "minimized and hidden" (ADR-0005
/// decision 1).
enum DockAttentionChannel {
  static let channelName = "app.sideswap.io/attention"

  /// [window] is the app's main window — the one `window_manager` drives. Held
  /// weakly, and read through rather than `NSApp.mainWindow`, which is nil in
  /// precisely the two states the placement query exists to report.
  static func register(messenger: FlutterBinaryMessenger, window: NSWindow) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)

    channel.setMethodCallHandler { [weak window] (call: FlutterMethodCall, result: FlutterResult) in
      switch call.method {
      case "requestCriticalAttention":
        if NSApplication.shared.isActive {
          // Nothing was issued, so there is no id and nothing to cancel later.
          result(nil)
          return
        }

        // Critical: the icon bounces until the app is activated, rather than
        // once.
        result(NSApplication.shared.requestUserAttention(.criticalRequest))

      case "cancelAttention":
        guard let requestId = (call.arguments as? NSNumber)?.intValue else {
          result(
            FlutterError(
              code: "bad_argument",
              message: "cancelAttention needs an attention request id",
              details: nil))
          return
        }

        NSApplication.shared.cancelUserAttentionRequest(requestId)
        result(nil)

      case "setPendingBadge":
        guard let count = (call.arguments as? NSNumber)?.intValue else {
          result(
            FlutterError(
              code: "bad_argument",
              message: "setPendingBadge needs a pending request count",
              details: nil))
          return
        }

        // Read off the Dock tile rather than the window: the badge has to
        // outlive every window state, including the two the placement query
        // exists to report. Nothing is drawn at zero — what "nothing waiting"
        // looks like is the platform's decision, and AppKit's is a nil label.
        NSApplication.shared.dockTile.badgeLabel = count > 0 ? String(count) : nil
        result(nil)

      case "readWindowPlacement":
        guard let window else {
          // The window is gone, so there is nothing to place. The Dart side
          // falls back rather than treating this as an answer.
          result(
            FlutterError(
              code: "no_window",
              message: "The main window is gone",
              details: nil))
          return
        }

        // Both facts in one reply, so they describe the same instant: the user
        // can switch Space between two separate hops.
        result([
          "isOnActiveSpace": window.isOnActiveSpace,
          "isHidden": NSApplication.shared.isHidden,
        ])

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
