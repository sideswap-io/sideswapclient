import 'dart:async';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/desktop_attention_service.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:window_manager/window_manager.dart';

/// Desktop window behaviour that differs per platform.
///
/// Read from the injected instance only — ADR-0004 forbids a runtime
/// `Platform.is*` check inside provider logic, because the coverage gate runs
/// on a single OS and such a branch is uncoverable there.
class DesktopWindowCapabilities {
  const DesktopWindowCapabilities({
    required this.togglesAlwaysOnTopOnRaise,
    required this.requestsUserAttentionOnRaise,
    required this.raisesOnlyFromMinimizedWindow,
    required this.readsNativeWindowPlacement,
    required this.showsPendingBadge,
  });

  /// Whether a raise ends with a `setAlwaysOnTop(true)`/`(false)` toggle.
  ///
  /// Shipped behaviour on Windows and Linux, plausibly a z-order workaround
  /// under focus-stealing prevention. Dropped on macOS, where a probe showed
  /// `restore` → `show` → `focus` is sufficient on its own.
  final bool togglesAlwaysOnTopOnRaise;

  /// Whether a delivered request asks the OS to draw attention to the app.
  ///
  /// macOS only: a Dock icon that bounces until the app is activated, which is
  /// how a request stays noticeable when the app deliberately leaves the window
  /// where it is, or when the system declines to bring it forward — another
  /// Space, a full-screen app, a Focus mode. Windows and Linux have no
  /// equivalent and issue no attention call.
  final bool requestsUserAttentionOnRaise;

  /// Whether a raise episode may open only from a minimized window.
  ///
  /// macOS only. Raising is the one signal the app must afterwards undo, and
  /// the only undo it has is `minimize()` — the exact inverse of `restore()`,
  /// and of nothing else. A window merely sitting behind a browser was raised
  /// and then never put back, leaving the user in an app they never came to.
  /// So on macOS the app raises from the one disposition it can undo exactly
  /// and leaves the window alone in every other.
  ///
  /// Off on Windows and Linux, which keep the shipped behaviour: they raise
  /// from any disposition where the window is not already in front of the
  /// user, because they have no quieter signal to reach for. See ADR-0005
  /// decision 1.
  final bool raisesOnlyFromMinimizedWindow;

  /// Whether the app asks the platform where its window is before deciding.
  ///
  /// macOS only, and it exists because two of the five dispositions cannot be
  /// measured from Dart at all — see [WindowPlacement] for why neither fact is
  /// reachable without the platform.
  ///
  /// Off on Windows and Linux, which have no such query to make and no
  /// disposition it would change: they raise from anything the user is not
  /// already looking at. Off, the app assumes [WindowPlacement.fallback] and
  /// behaves exactly as it shipped. See ADR-0005 decision 1.
  final bool readsNativeWindowPlacement;

  /// Whether the app icon carries a count of the requests still waiting.
  ///
  /// macOS only, and not for want of trying elsewhere: Windows has no text
  /// badge at all — `ITaskbarList3::SetOverlayIcon` takes a rendered icon, and
  /// the runner has no method channel to carry one — while the Linux launcher
  /// signal addresses a `.desktop` entry id, and this repo's build ships a raw
  /// bundle with none. The seam is written for all three so neither is a
  /// rewrite when they are answered; off, nothing is asked of the platform.
  /// See ADR-0005 decision 4.
  final bool showsPendingBadge;
}

/// Where the window stood relative to the user when a request arrived.
///
/// A value rather than a boolean on purpose: reading the disposition as "was it
/// minimized" is what let the app take the foreground and never return it
/// (CONTEXT.md, ADR-0005 decision 1).
enum WindowDisposition {
  /// The window belongs to a Space the user is not looking at. Deminiaturizing
  /// it would pull them off whatever they are in, including a full-screen app.
  offActiveSpace,

  /// The whole application is hidden, as by Cmd-H, minimized or not.
  hidden,

  /// Minimized, on the active Space, of an app that is not hidden — the one
  /// disposition `minimize()` puts back exactly.
  minimized,

  /// The user could see the window, but the app does not have the keyboard.
  visibleInactive,

  /// In front of the user with the keyboard in it.
  active;

  /// Reads the facts in ADR-0005 decision 1's fixed precedence.
  ///
  /// The order is part of the decision, not an implementation detail: the
  /// dispositions overlap as measured, so the first match wins and off-Space
  /// outranks hidden, which outranks minimized.
  static WindowDisposition of({
    required bool isOnActiveSpace,
    required bool isHidden,
    required bool isMinimized,
    required bool isVisible,
    required bool isFocused,
  }) {
    if (!isOnActiveSpace) {
      return WindowDisposition.offActiveSpace;
    }

    if (isHidden) {
      return WindowDisposition.hidden;
    }

    if (isMinimized) {
      return WindowDisposition.minimized;
    }

    // Last, so anything the app cannot see itself in front of the user falls
    // short of active rather than defaulting to it.
    if (isVisible && isFocused) {
      return WindowDisposition.active;
    }

    return WindowDisposition.visibleInactive;
  }
}

/// How long the app may still attribute an incoming window transition to a
/// command it issued itself.
const kWindowTransitionGrace = Duration(seconds: 2);

/// How long ownership of a raised window waits for the raise's postconditions
/// to settle before giving up. A window manager may refuse activation, and the
/// episode must not hang waiting for it.
const kOwnershipSettleTimeout = Duration(seconds: 2);

/// How long the native placement query may take before the app stops waiting
/// for it and falls back.
///
/// Every episode mutation is serialized behind one chain, so an unanswered
/// platform hop would strand not merely this delivery but every later command.
/// [kOwnershipSettleTimeout] does not cover this: it guards the post-raise
/// transition wait only. See ADR-0005 decision 1.
const kWindowPlacementQueryTimeout = Duration(seconds: 2);

final desktopWindowServiceProvider = Provider<DesktopWindowService>((ref) {
  final service = DesktopWindowService();
  ref.onDispose(service.dispose);
  return service;
});

/// Owns the desktop window commands, so window policy can be driven from the
/// request delivery boundary rather than from the widget tree — a minimized
/// macOS window produces no frames, so a widget effect never runs while
/// minimized. See ADR-0004.
class DesktopWindowService with WindowListener {
  DesktopWindowService({
    WindowManager? windowManager,
    DesktopAttentionService? attentionService,
    DesktopWindowCapabilities? capabilities,
  }) : _windowManager = windowManager ?? WindowManager.instance,
       _attentionService =
           attentionService ?? MethodChannelDesktopAttentionService(),
       _capabilities = capabilities ?? _defaultCapabilities();

  final WindowManager _windowManager;
  final DesktopAttentionService _attentionService;
  final DesktopWindowCapabilities _capabilities;

  /// The ids the current raise episode is still waiting on. Non-empty exactly
  /// while an episode is open.
  final Set<int> _unresolvedRequestIds = {};

  bool _episodeOpen = false;
  bool _expectingTransition = false;
  bool _ownsWindow = false;
  bool _disposed = false;

  /// The pre-raise disposition, reduced to the only part the app can undo:
  /// whether the window was minimized when the episode opened.
  bool _tookWindowOffScreen = false;

  /// The outstanding attention request, or `null` when there is none to
  /// withdraw — either none was issued or it has already been cancelled.
  int? _attentionRequestId;

  /// Whether a bounce is meant to be outstanding right now.
  ///
  /// Distinct from holding an id, and true from before the request is issued:
  /// the id only arrives a platform hop later, and everything that would stop
  /// the bounce — a focus event, the end of the episode — can happen in
  /// between. Without this, such an id lands on a service that has already
  /// stopped listening and can never be cancelled.
  bool _attentionWanted = false;

  /// Mirrors whether [_windowManager] currently holds this listener, so it is
  /// never added or removed twice. See [_syncListener] for the invariant it
  /// tracks.
  bool _listenerRegistered = false;
  Timer? _expectationTimer;
  Completer<void>? _settled;
  Future<void> _chain = Future<void>.value();

  static DesktopWindowCapabilities _defaultCapabilities() =>
      DesktopWindowCapabilities(
        togglesAlwaysOnTopOnRaise: !Platform.isMacOS,
        requestsUserAttentionOnRaise: Platform.isMacOS,
        raisesOnlyFromMinimizedWindow: Platform.isMacOS,
        readsNativeWindowPlacement: Platform.isMacOS,
        showsPendingBadge: Platform.isMacOS,
      );

  /// Brings the window forward.
  ///
  /// The sequence is exactly `restore` → `show` → `focus`, issued
  /// unconditionally: the app never samples `isMinimized()` to decide, because
  /// that sample is stale right after a transition.
  ///
  /// Throws whatever the window manager throws — the caller decides how a
  /// refused raise is reported.
  Future<void> raise() async {
    await _windowManager.restore();
    await _windowManager.show();
    await _windowManager.focus();

    if (_capabilities.togglesAlwaysOnTopOnRaise) {
      try {
        await _windowManager.setAlwaysOnTop(true);
      } finally {
        // Always paired: a window left pinned above every other window has no
        // user-facing way back.
        await _windowManager.setAlwaysOnTop(false);
      }
    }
  }

  /// A Liquid Connect request has been delivered to the user.
  ///
  /// Opens a raise episode when the window is not already in front of the
  /// user, raises the window, and claims ownership of it once the raise's
  /// postconditions settle.
  Future<void> onRequestDelivered(int requestId) =>
      _serialized(() => _deliver(requestId));

  /// A Liquid Connect request has left the pending list, for [reason].
  ///
  /// Puts the window back only when this removal empties the episode and the
  /// user is the one who resolved it. See ADR-0004 decision 3.
  Future<void> onRequestResolved(
    int requestId,
    NotificationRemovalReason reason,
  ) => _serialized(() => _resolve(requestId, reason));

  /// Episode mutations and window commands run one at a time: two requests can
  /// arrive while the first raise is still in flight, and every native command
  /// and callback is asynchronous.
  Future<void> _serialized(Future<void> Function() action) {
    // Work queued before disposal must not run after it and register a
    // listener or a timer on a service nobody will close again.
    final next = _chain.then((_) => _disposed ? null : action());
    // A failed action must not poison the queue for every later one.
    _chain = next.catchError((Object _) {});
    return next;
  }

  Future<void> _deliver(int requestId) async {
    // Tracked from delivery, whatever the window was doing: a request that
    // arrived while the window was open is still unresolved, and an episode
    // opened later must wait for it too.
    _unresolvedRequestIds.add(requestId);

    // The delivery boundary, before the disposition is even sampled: the bounce
    // is the primary arrival signal and does not depend on a raise following.
    // Whether one is issued at all is the platform's answer, not the app's —
    // the activity check lives natively (ADR-0005 decision 2).
    await _requestAttention();

    if (_disposed) {
      // The round trip above is a platform hop of unbounded duration, and
      // _serialized only keeps work that has not started yet from running after
      // disposal. Anything below would open an episode, or raise a window, that
      // nobody is left to take back down.
      return;
    }

    if (_episodeOpen) {
      // A second request joins the episode already in flight; ownership is
      // whatever the first raise established.
      await _raiseExpectingTransition();
      return;
    }

    // Before any window command is issued, and after the episode check: a
    // request joining an open episode is post-raise behaviour and samples
    // nothing (ADR-0005 decision 1).
    final placement = await _readWindowPlacement();

    if (_disposed) {
      // Same hazard as above, at a hop of its own: the query is bounded, but a
      // whole timeout's worth of disposal can land inside it.
      return;
    }

    // Sampled before anything is issued, so it is not the stale read right
    // after a transition that ADR-0004 warns against; _serialized guarantees
    // no window command of ours is in flight.
    final wasMinimized = await _windowManager.isMinimized();
    // The visibility predicates only ever settle a window the rungs above them
    // did not, so they are sampled only then. Every platform hop that cannot
    // change the answer is one more way a delivery can fail before the raise it
    // exists to fall back to — and on the arm that raises solely from a
    // minimized window, that is the raise the whole query is protecting.
    final visibilityDecides =
        placement.isOnActiveSpace && !placement.isHidden && !wasMinimized;
    final isVisible = visibilityDecides && await _windowManager.isVisible();
    // Chained off the answer above rather than off [visibilityDecides]: a
    // window the user cannot see is not the one they are typing into, whatever
    // the platform would say about focus, so that hop cannot change the answer
    // either.
    final isFocused = isVisible && await _windowManager.isFocused();
    final disposition = WindowDisposition.of(
      isOnActiveSpace: placement.isOnActiveSpace,
      isHidden: placement.isHidden,
      isMinimized: wasMinimized,
      isVisible: isVisible,
      isFocused: isFocused,
    );
    // Where the app raises only from a minimized window it raises from exactly
    // that one row of the table. Elsewhere it raises from anything the user is
    // not already looking at, which is the behaviour Windows and Linux ship.
    final leaveWindowAlone = _capabilities.raisesOnlyFromMinimizedWindow
        ? disposition != WindowDisposition.minimized
        : disposition == WindowDisposition.active;

    if (leaveWindowAlone) {
      return;
    }

    if (_disposed) {
      // Same hazard as above, at the next await boundary: sampling the
      // disposition is a platform hop of its own, and disposal can land inside
      // it too.
      return;
    }

    _episodeOpen = true;
    _tookWindowOffScreen = wasMinimized;
    _syncListener();

    final settled = Completer<void>();
    _settled = settled;

    try {
      await _raiseExpectingTransition();
      await settled.future.timeout(kOwnershipSettleTimeout);
      // A raise abandoned while it was settling must not claim the window it
      // no longer has an episode for.
      _ownsWindow = _episodeOpen;
    } on TimeoutException {
      // A window manager may legitimately refuse activation. Without a
      // settled raise the app has not earned the right to put the window
      // back, so the episode stays open but unowned rather than pending.
    } catch (_) {
      // A refused raise leaves no episode behind: the window never came up,
      // so nothing about it is the app's to undo.
      _closeEpisode();
      rethrow;
    } finally {
      _settled = null;
    }
  }

  /// The two placement facts, as a bounded predicate.
  ///
  /// A refused channel, a build without the handler, an unreadable reply and a
  /// reply that never arrives all resolve to [WindowPlacement.fallback], under
  /// which the app raises — the behaviour it shipped with. A missing raise next
  /// to a missing badge would leave the user with no signal at all.
  ///
  /// Nothing thrown here reaches the caller: an escaping failure would abort
  /// the delivery before the raise it is supposed to fall back to.
  /// See ADR-0005 decision 1.
  Future<WindowPlacement> _readWindowPlacement() async {
    if (!_capabilities.readsNativeWindowPlacement) {
      return WindowPlacement.fallback;
    }

    try {
      final placement = await _attentionService.readWindowPlacement().timeout(
        kWindowPlacementQueryTimeout,
      );
      return placement ?? WindowPlacement.fallback;
    } catch (e) {
      logger.e('[DesktopWindowService] Cannot read the window placement: $e');
      return WindowPlacement.fallback;
    }
  }

  /// Puts [count] on the app icon, or asks nothing of a platform that has no
  /// badge to put it on.
  ///
  /// A pass-through, deliberately: the count belongs to the notifications
  /// notifier, which is the single authority for it, and the episode's
  /// [_unresolvedRequestIds] legitimately differ from it in cardinality — one
  /// id backs both a connect and a sign entry, and `clearAll()` empties the
  /// notifier before the abandonment it queues ever runs. Reconciling the two
  /// here would be a second source of truth for a number that has one
  /// (ADR-0005 decision 3).
  ///
  /// Off the serialized chain, because it mutates no window state and no
  /// episode: queued behind a raise, a badge would wait out the settle timeout,
  /// and behind an unanswered placement query it would never be written at all.
  /// Unguarded by [_disposed] for the same reason the notifier clears the badge
  /// as it goes: the provider that could correct a stale count is exactly what
  /// is going away.
  ///
  /// Nothing thrown here reaches the caller: a refused badge must not cost the
  /// user the delivery or the removal that was writing it.
  Future<void> setPendingBadge(int count) async {
    if (!_capabilities.showsPendingBadge) {
      return;
    }

    try {
      await _attentionService.setPendingBadge(count);
    } catch (e) {
      logger.e('[DesktopWindowService] Cannot set the pending badge: $e');
    }
  }

  Future<void> _resolve(
    int requestId,
    NotificationRemovalReason reason,
  ) async {
    if (!_unresolvedRequestIds.remove(requestId)) {
      // An id never delivered, or one already resolved: the same notification
      // id can back both a connect and a sign entry.
      return;
    }

    if (_unresolvedRequestIds.isNotEmpty) {
      return;
    }

    if (!_episodeOpen) {
      // Nothing is waiting on the user, and a bounce can now outlive every
      // window command: in the dispositions the app leaves alone it is the only
      // thing this request ever started, so this is the only place that ends it.
      _cancelAttention();
      return;
    }

    // Only a window the app took off the screen is put back. One the user
    // could already see — merely unfocused, occluded, or on another Space —
    // is left where it was: minimizing it would take away something they
    // never asked the app to touch.
    final putWindowBack =
        _ownsWindow && _tookWindowOffScreen && _resolvedByUser(reason);
    _closeEpisode();

    if (putWindowBack) {
      await _windowManager.minimize();
    }
  }

  /// Gives up the current episode without touching the window.
  ///
  /// The pending requests are gone but the user never resolved them, so the
  /// app has nothing to put back — and leaving the episode open would strand
  /// its ids and its listener for the rest of the session.
  Future<void> abandonEpisode() =>
      _serialized(() async => _closeEpisode(forgetRequests: true));

  static bool _resolvedByUser(NotificationRemovalReason reason) =>
      switch (reason) {
        NotificationRemovalReason.acceptedByUser ||
        NotificationRemovalReason.rejectedByUser => true,
        NotificationRemovalReason.expired ||
        NotificationRemovalReason.remoteCancel => false,
      };

  /// Ends the episode. [forgetRequests] additionally drops the unresolved ids,
  /// for the case where the requests themselves are gone; a refused raise
  /// leaves them tracked, because they are still pending for the user.
  void _closeEpisode({bool forgetRequests = false}) {
    // The bounce goes with the episode: the app is done asking for the user, so
    // an id left outstanding would keep asking on behalf of a raise that is
    // over. The listener no longer depends on this — it now outlives the episode
    // whenever a bounce does — but the bounce itself still ends here.
    _cancelAttention();
    _episodeOpen = false;
    _ownsWindow = false;
    _tookWindowOffScreen = false;
    _expectingTransition = false;
    if (forgetRequests) {
      _unresolvedRequestIds.clear();
    }
    _expectationTimer?.cancel();
    _expectationTimer = null;
    // Releases a raise still waiting to settle, so its timeout timer cannot
    // outlive the episode.
    if (_settled?.isCompleted == false) {
      _settled!.complete();
    }
    // Last, so it reads the flags this method just cleared.
    _syncListener();
  }

  /// Registers or removes the window listener to match the one invariant that
  /// justifies having it: it is registered exactly while an attention request is
  /// outstanding **or** an episode is open, and removed when neither holds.
  ///
  /// Idempotent, because both halves of that condition are set and cleared
  /// independently and either may already have registered it.
  void _syncListener() {
    final needed = _attentionWanted || _episodeOpen;
    if (needed == _listenerRegistered) {
      return;
    }

    _listenerRegistered = needed;
    if (needed) {
      _windowManager.addListener(this);
    } else {
      _windowManager.removeListener(this);
    }
  }

  Future<void> _raiseExpectingTransition() async {
    // Armed immediately before the raise, never around the round trip: the
    // expectation attributes the transitions the raise itself produces, and a
    // window the user restored while the platform was still answering is one
    // they moved themselves.
    _expect();
    await raise();
  }

  /// Asks the OS to draw attention to the app, at the delivery boundary and
  /// before any raise that follows.
  ///
  /// Issued whatever the app then decides to do with the window: activation is
  /// exactly the event macOS uses to stop a bounce, so one issued from inside a
  /// raise is never seen, and the disposition the app leaves alone is the one
  /// with no other signal at all. See ADR-0005 decision 2.
  ///
  /// The ordering is load-bearing, not stylistic: the raise can bring the
  /// window forward and deliver its focus callback before it returns, and a
  /// focus event arriving with no id stored can never stop the bounce.
  Future<void> _requestAttention() async {
    if (!_capabilities.requestsUserAttentionOnRaise) {
      return;
    }

    if (_attentionWanted) {
      // Only one id can be held, and cancelling withdraws exactly that one:
      // overwriting it would leave the request it replaced bouncing with
      // nothing left that could stop it. Set from before the request is issued,
      // so a second one cannot start while the first is still in flight.
      return;
    }

    _attentionWanted = true;
    // Before the round trip, not after: the platform can report focus while it
    // is still answering, and a listener registered only once the id is in hand
    // would never hear the event that stops the bounce.
    _syncListener();
    try {
      _attentionRequestId = await _attentionService.requestCriticalAttention();
    } catch (e) {
      // A bounce is decoration; the raise is what the user needs. Letting a
      // refused channel escape here would abort the delivery and leave the
      // window down.
      logger.e('[DesktopWindowService] Cannot request user attention: $e');
    }

    if (_attentionRequestId == null) {
      // Nothing is bouncing: the app was already active, or the channel
      // refused. The next request is free to ask again — and the listener this
      // request registered comes back down, since nothing is outstanding for it
      // to hear about.
      _cancelAttention();
      return;
    }

    if (!_attentionWanted) {
      // A focus event or the end of the episode came and went while the
      // request was still in flight, so the id arrived after the only things
      // that would have cancelled it had already run.
      _cancelAttention();
    }
  }

  /// Marks that a command the app just issued may produce window transitions.
  ///
  /// Best-effort by construction: the platform reports transitions without
  /// their cause (ADR-0004), so this is an attribution heuristic, never a
  /// guarantee. The expectation stays armed for [kWindowTransitionGrace] and is
  /// not consumed on first match — a command may produce a transition more
  /// than once, and restore and focus arrive in either order.
  void _expect() {
    _expectingTransition = true;
    _expectationTimer?.cancel();
    _expectationTimer = Timer(kWindowTransitionGrace, () {
      _expectingTransition = false;
    });
  }

  /// A window transition the platform reported. The callbacks carry no
  /// arguments and no cause, so restore and focus are treated alike.
  ///
  /// Only the transitions a raise produces are tracked: the app closes the
  /// episode before it minimizes, so it is no longer listening by then.
  void _onTransition() {
    if (!_expectingTransition) {
      // Nothing the app issued can account for this, so the user moved the
      // window themselves and the app no longer has the right to put it back.
      _ownsWindow = false;
      return;
    }

    _settled?.complete();
    _settled = null;
  }

  @override
  void onWindowRestore() => _onTransition();

  @override
  void onWindowFocus() {
    _cancelAttention();
    _onTransition();
  }

  /// Withdraws an outstanding attention request.
  ///
  /// Cancelling is explicit — the OS keeps bouncing until it is told to stop —
  /// and it is addressed by id, so a focus event with no id stored has nothing
  /// to cancel.
  void _cancelAttention() {
    _attentionWanted = false;
    final requestId = _attentionRequestId;
    _attentionRequestId = null;
    // Before the early return below: the listener goes whether or not there was
    // an id to withdraw, as long as no episode still needs it.
    _syncListener();
    if (requestId == null) {
      return;
    }

    // Fire-and-forget from a synchronous platform callback: nobody is waiting
    // on this, so a rejection would surface as an unhandled error.
    unawaited(
      _attentionService.cancelAttention(requestId).catchError((Object e) {
        logger.e('[DesktopWindowService] Cannot cancel user attention: $e');
      }),
    );
  }

  /// Drops any open episode, so a listener never outlives the provider.
  void dispose() {
    _disposed = true;
    _closeEpisode(forgetRequests: true);
  }
}
