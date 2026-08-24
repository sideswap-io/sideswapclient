import 'package:flutter/services.dart';

/// The two facts about the window that AppKit alone can answer.
///
/// Neither is measurable from Dart: `window_manager` does not expose
/// `isOnActiveSpace` at all, and a minimized window already reports
/// `isVisible() == false`, so visibility cannot separate "minimized" from
/// "minimized and hidden". See ADR-0005 decision 1.
class WindowPlacement {
  const WindowPlacement({required this.isOnActiveSpace, required this.isHidden});

  /// What the app assumes when the query cannot answer: the window is where a
  /// raise would be harmless. The app then falls back to the behaviour it
  /// shipped with, because a missing raise next to a missing badge would leave
  /// the user with no signal at all (ADR-0005 decision 1).
  static const fallback = WindowPlacement(isOnActiveSpace: true, isHidden: false);

  /// Whether the app's main window belongs to the Space the user is looking at.
  final bool isOnActiveSpace;

  /// Whether the whole application is hidden, as by Cmd-H.
  final bool isHidden;
}

/// The app's one injected macOS platform seam.
///
/// A separate seam from the window commands because the decisions it carries
/// are not the app's to make: whether an attention request may be issued at all
/// depends on whether the *application* is active, which only the platform can
/// answer atomically with issuing it (ADR-0004 decision 4), and the placement
/// facts are not reachable from Dart at all (ADR-0005 decision 1).
///
/// One seam rather than one per feature, so a test mocks a single boundary and
/// the runner registers a single channel. Each operation is separately gated by
/// its own capability flag; reaching one says nothing about the others.
abstract interface class DesktopAttentionService {
  /// Asks the OS for critical attention — on macOS, a Dock icon that bounces
  /// until the app is activated.
  ///
  /// Returns the request id, or `null` when no request was issued because the
  /// app was already active.
  Future<int?> requestCriticalAttention();

  /// Withdraws the attention request [requestId].
  Future<void> cancelAttention(int requestId);

  /// Both placement facts together, or `null` when the platform answered with
  /// something this app cannot read.
  ///
  /// One method rather than two, so the two facts describe the same instant:
  /// the user can switch Space between two separate hops.
  ///
  /// Throws whatever the channel throws — a build without the handler, or a
  /// platform that refuses. The caller decides what an unanswerable query
  /// means.
  Future<WindowPlacement?> readWindowPlacement();

  /// Puts [count] on the app icon — on macOS, the Dock tile's badge.
  ///
  /// A count rather than a label, and zero rather than a separate clear: what
  /// "nothing waiting" looks like is the platform's decision, and macOS already
  /// has one — an empty badge label draws nothing. Keeping the rule native
  /// leaves one meaning of the argument for every desktop to honour.
  ///
  /// Unlike the bounce, this is not an attention marker: it survives the user
  /// activating the app and goes only when nothing is left pending, whatever
  /// resolved it (ADR-0005 decision 3).
  ///
  /// Throws whatever the channel throws — a build without the handler, or a
  /// platform that refuses. The caller decides what an unwritten badge means.
  Future<void> setPendingBadge(int count);
}

/// The platform-channel implementation, handled by the macOS runner.
class MethodChannelDesktopAttentionService implements DesktopAttentionService {
  static const channel = MethodChannel('app.sideswap.io/attention');

  @override
  Future<int?> requestCriticalAttention() =>
      channel.invokeMethod<int>('requestCriticalAttention');

  @override
  Future<void> cancelAttention(int requestId) =>
      channel.invokeMethod<void>('cancelAttention', requestId);

  @override
  Future<void> setPendingBadge(int count) =>
      channel.invokeMethod<void>('setPendingBadge', count);

  @override
  Future<WindowPlacement?> readWindowPlacement() async {
    final reply = await channel.invokeMethod<Object?>('readWindowPlacement');
    // Read defensively rather than cast: a reply of the wrong shape is one of
    // the failure modes the caller's fallback exists for, not a crash.
    if (reply is! Map) {
      return null;
    }

    final isOnActiveSpace = reply['isOnActiveSpace'];
    final isHidden = reply['isHidden'];
    if (isOnActiveSpace is! bool || isHidden is! bool) {
      return null;
    }

    return WindowPlacement(
      isOnActiveSpace: isOnActiveSpace,
      isHidden: isHidden,
    );
  }
}
