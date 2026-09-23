import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/desktop_window_service.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_notifications_platform_interface/models/notification_model.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'notifications_provider.g.dart';
part 'notifications_provider.freezed.dart';

@freezed
sealed class NotificationItemState with _$NotificationItemState {
  const factory NotificationItemState.empty() = NotificationItemStateEmpty;
  const factory NotificationItemState.canceled() =
      NotificationItemStateCanceled;
}

@freezed
sealed class NotificationType with _$NotificationType {
  const factory NotificationType.connect(
    String reqId,
    String origin,
    NotificationItemState notificationItemState,
    DateTime createdAt,
    Option<int> ttlMilliseconds,
  ) = NotificationTypeConnect;
  const factory NotificationType.signRequest(
    From_SignerRequest_Sign sign,
    String reqId,
    String origin,
    NotificationItemState notificationItemState,
    DateTime createdAt,
    Option<int> ttlMilliseconds,
  ) = NotificationTypeSignRequest;
}

@freezed
sealed class NotificationData with _$NotificationData {
  const factory NotificationData(int id, NotificationType type) =
      _NotificationData;
}

@Riverpod(keepAlive: true)
class Notifications extends _$Notifications {
  /// The arrival counter every entry's local id is minted from.
  ///
  /// Monotonic for as long as the notifier instance lives, which is longer than
  /// any one generation of the list: [clearAll] ends in `ref.invalidateSelf()`,
  /// and riverpod rebuilds the element without replacing the notifier it caches
  /// against it, so this field survives the call and goes on counting. There is
  /// deliberately no reset — a counter that only ever goes up is the weaker of
  /// the two assumptions and needs no mechanism to hold (#211).
  ///
  /// It is still not an identity, and nothing that has to tell two requests
  /// apart may key on it alone — the counter moves once per *delivery*, not
  /// once per entry, so a request carrying both a connect and a sign payload
  /// files two entries under one id. The request id is what tells requests
  /// apart.
  int _id = 0;

  /// Where the pending badge is written, captured once while the notifier is
  /// built, or `null` off desktop.
  ///
  /// Held rather than read at each use because the badge outlives the reads:
  /// clearing it is the last thing this notifier does, and `ref.read` is not
  /// available from a disposal callback.
  DesktopWindowService? _badgeTarget;

  /// The one timer that runs the expiry sweep, armed for the earliest deadline
  /// the sweep would act on, or `null` while there is nothing to act on.
  ///
  /// The only lifecycle state this notifier holds. It is a field on the
  /// notifier rather than a subscription on the element, and the notifier
  /// instance survives `clearAll()`'s invalidation — riverpod caches it per
  /// element — so forgetting to cancel it does not raise anything: a stray
  /// timer sweeps the *next* generation's entries in silence. ADR-0010
  /// decision 3.
  Timer? _expiryTimer;

  /// Suppresses rearming while one operation is making several removals.
  ///
  /// Every [removeNotification] assigns `state`, so a rearm hung off each of
  /// them fires once per removal over a half-emptied list. The rule is per
  /// operation: [_asOneOperation] holds this up for the duration and rearms
  /// once at the end. ADR-0010 decision 3.
  bool _batchingRemovals = false;

  @override
  List<NotificationData> build() {
    final notifications = <NotificationData>[];

    // Registered outside the desktop branch: the sweep runs on both flavours,
    // and this is what makes `clearAll()` — which disposes this generation
    // before rebuilding — give the timer up with the list it was armed over.
    ref.onDispose(_cancelExpiryTimer);

    if (FlavorConfig.isDesktop) {
      _badgeTarget = ref.read(desktopWindowServiceProvider);
      // The badge lives on the process's app icon, not in this notifier's
      // state: a notifier rebuilt after an invalidation inherits whatever count
      // its predecessor left there, so the count is reconciled from the list
      // being built rather than assumed to start at nothing. Cleared again when
      // this notifier goes, because a count nothing is left to resolve is worse
      // than none. See ADR-0005 decision 3.
      ref.onDispose(() => _writeBadge(0));
      _writeBadge(pendingBadgeCount(notifications));
    }

    return notifications;
  }

  /// Puts [count] on the app icon, if there is one to write to.
  ///
  /// Fire-and-forget: nothing in a delivery, a removal or a disposal waits on
  /// the badge, and [DesktopWindowService.setPendingBadge] already swallows a
  /// platform that refuses it.
  void _writeBadge(int count) {
    final badgeTarget = _badgeTarget;
    if (badgeTarget == null) {
      return;
    }

    unawaited(badgeTarget.setPendingBadge(count));
  }

  /// Re-states what is still waiting, from the list as it stands now.
  ///
  /// Called at every boundary that changes the list, including the one that
  /// only marks entries cancelled — see [pendingBadgeCount] for why that
  /// counts as a change.
  void _updateBadge() => _writeBadge(pendingBadgeCount(state));

  void addNotification(From_SignerRequest signRequest) {
    // One receipt instant for the whole delivery. The drop below and the
    // `createdAt` stamps have to agree about when this request arrived, and two
    // `DateTime.now()` calls do not. ADR-0010 decision 2.
    final receivedAt = DateTime.now();

    // Read once, and carried into whichever entries this delivery appends: the
    // drop below and the entries have to agree about the deadline they are
    // being judged against.
    final ttlMilliseconds = signRequest.hasTtlMilliseconds()
        ? signRequest.ttlMilliseconds.toInt()
        : null;

    // Decided once, at the top: before the id counter moves, before the window
    // raise below, and before either payload branch. The raise sits between
    // here and the branches, so a per-branch check would be one made after the
    // window was already up.
    //
    // Nothing is sent to the origin and no resolution is recorded — the request
    // never entered the pending set, so it never left it. Logged because this
    // is the one path where the app discards a request without the user ever
    // having had a chance at it. ADR-0010 decision 4.
    if (ttlMilliseconds != null &&
        requestDeadlinePassedAt(
          createdAt: receivedAt,
          ttlMilliseconds: ttlMilliseconds,
          now: receivedAt,
        )) {
      final elapsed = receivedAt.difference(
        requestDeadline(receivedAt, ttlMilliseconds),
      );
      logger.w(
        '[Notifications] Dropped at delivery: reqId=${signRequest.reqId} '
        'origin=${signRequest.origin} was already '
        '${elapsed.inMilliseconds}ms past its deadline on arrival',
      );
      return;
    }

    _id = _id + 1;
    // Captured now: the window command must carry the id of *this* request,
    // not whatever the counter has reached by the time it runs.
    final deliveredId = _id;

    // Raised here, at the delivery boundary, rather than from the notifications
    // toolbar widget: a minimized desktop window produces no frames, so a
    // widget effect only runs once the user has already reopened the window.
    // Fires once per delivered request, not per "any notifications active"
    // transition, so a request arriving while another is pending raises too.
    // See ADR-0004.
    if (FlavorConfig.isDesktop) {
      unawaited(
        _onDesktopWindow(
          'raise the desktop window',
          (service) => service.onRequestDelivered(deliveredId),
        ),
      );
    }

    if (signRequest.hasConnect()) {
      state = [
        NotificationData(
          _id,
          NotificationType.connect(
            signRequest.reqId,
            signRequest.origin,
            NotificationItemState.empty(),
            receivedAt,
            Option.fromNullable(ttlMilliseconds),
          ),
        ),
        ...state,
      ];

      _announceRequest(
        title: 'Liquid Connect: Connection Requested'.tr(),
        payloadType: FCMPayloadType.swaptionConnect,
        signRequest: signRequest,
        notificationId: _id,
      );
    }

    if (signRequest.hasSign()) {
      state = [
        NotificationData(
          _id,
          NotificationType.signRequest(
            signRequest.sign,
            signRequest.reqId,
            signRequest.origin,
            NotificationItemState.empty(),
            receivedAt,
            Option.fromNullable(ttlMilliseconds),
          ),
        ),
        ...state,
      ];

      _announceRequest(
        title: 'Liquid Connect: Signature Required'.tr(),
        payloadType: FCMPayloadType.swaptionSign,
        signRequest: signRequest,
        notificationId: _id,
      );
    }

    // After both appends, not inside either: a request carrying both payloads
    // is two entries the user sees, and the badge states the total once. The
    // arming is stated once for the same reason.
    _updateBadge();
    _rearmExpiryTimer();
  }

  /// Surfaces a request the caller has *already* appended to [state]: an OS
  /// banner on desktop, the in-app notification menu everywhere else.
  ///
  /// Called after the append, never before, so a refused OS submission cannot
  /// cost the user the request. Synchronous on purpose — only the desktop
  /// banner is deferred, so the non-desktop arm still runs before this returns.
  void _announceRequest({
    required String title,
    required FCMPayloadType payloadType,
    required From_SignerRequest signRequest,
    required int notificationId,
  }) {
    if (FlavorConfig.isDesktop) {
      unawaited(
        _showOsNotification(
          title: title,
          payloadType: payloadType,
          signRequest: signRequest,
          notificationId: notificationId,
        ),
      );
    } else {
      ref.read(desktopDialogProvider).closePopups();
      ref.read(showNotificationMenuProvider.notifier).setState(notificationId);
    }
  }

  /// Runs a window command, swallowing and logging any refusal.
  ///
  /// A window manager may legitimately refuse activation. Log it rather than
  /// letting the discarded future reject into the root zone, where a failed
  /// command is indistinguishable from none having been attempted at all — and
  /// a failure must not take the notification's delivery or removal down with
  /// it.
  Future<void> _onDesktopWindow(
    String what,
    Future<void> Function(DesktopWindowService service) command,
  ) async {
    try {
      await command(ref.read(desktopWindowServiceProvider));
    } catch (e) {
      logger.e('[Notifications] Cannot $what: $e');
    }
  }

  /// Submits the OS notification for a delivered request.
  ///
  /// Awaited here rather than at the call site so a plugin failure is caught
  /// and logged against the request that provoked it, instead of rejecting
  /// into the root zone where a refused submission is indistinguishable from
  /// none having been attempted. A successful submission means Notification
  /// Center accepted it — not that a banner was displayed; Focus modes,
  /// per-app notification settings and grouping all sit downstream.
  Future<void> _showOsNotification({
    required String title,
    required FCMPayloadType payloadType,
    required From_SignerRequest signRequest,
    required int notificationId,
  }) async {
    final reqId = signRequest.reqId;
    final origin = signRequest.origin;
    try {
      await ref
          .read(localNotificationsProvider)
          .showNotification(
            title,
            '',
            payload: FCMPayload(
              type: payloadType,
              data: jsonEncode({'notificationId': notificationId}),
            ).toJsonString(),
          );
      logger.d(
        '[Notifications] OS notification submitted for reqId=$reqId '
        'origin=$origin id=$notificationId type=${payloadType.name}; '
        'Notification Center accepted the submission, which does not prove a '
        'banner was displayed',
      );
    } catch (e) {
      logger.e(
        '[Notifications] Cannot post the OS notification for reqId=$reqId '
        'origin=$origin id=$notificationId type=${payloadType.name}: $e',
      );
    }
  }

  /// [reason] is required so every removal states why it happened: the window
  /// goes back only for a resolution the user performed. See ADR-0004.
  void removeNotification(int id, {required NotificationRemovalReason reason}) {
    state = state.where((notification) => notification.id != id).toList();

    // Whatever the reason: the badge says what is left waiting, not how the
    // last one went (ADR-0005 decision 3).
    _updateBadge();
    _rearmExpiryTimer();

    if (FlavorConfig.isDesktop) {
      unawaited(
        _onDesktopWindow(
          'put the desktop window back',
          (service) => service.onRequestResolved(id, reason),
        ),
      );
    }
  }

  void cancelNotification(String reqId) {
    state = state
        .map(
          (notificationData) => notificationData.type.reqId == reqId
              ? notificationData.copyWith(
                  type: notificationData.type.copyWith(
                    notificationItemState:
                        const NotificationItemState.canceled(),
                  ),
                )
              : notificationData,
        )
        .toList();

    // Recorded here, not deferred to the microtask below — see
    // [pendingBadgeCount] (ADR-0005 decision 3).
    _updateBadge();

    // Rearmed on the marks alone, before anything has left the list: the sweep
    // refuses a cancelled entry, so marking one changes what the timer is due
    // for even though the list is the same length.
    _rearmExpiryTimer();

    Future.microtask(() {
      // Don't leave cancelled notifications on the screen, just remove them.
      final cancelled = state
          .where(
            (notification) =>
                notification.type.notificationItemState ==
                const NotificationItemState.canceled(),
          )
          .toList();

      _asOneOperation(() {
        for (final notification in cancelled) {
          removeNotification(
            notification.id,
            reason: NotificationRemovalReason.remoteCancel,
          );
        }
      });
    });
  }

  /// Removes every entry whose deadline has gone by, and rearms.
  ///
  /// [_expiryTimer] is this method's only production caller. ADR-0010 rejected
  /// a sweep driven by `AppLifecycleState.resumed`: a suspended process does
  /// not run its timers, but the state is derived from timestamps rather than
  /// decremented, so a fire that comes late is a late notice and not a wrong
  /// answer — and the rearm at the end of every fire is what lets a late or
  /// misaimed one recover on its own. A second trigger would be adding
  /// something the design deliberately does not have.
  void sweepExpired() {
    // The fire that brought us here is spent; whatever comes next is armed at
    // the end of this method. Cleared up front so the field never holds a timer
    // that has already gone off.
    _cancelExpiryTimer();

    final now = DateTime.now();

    // Snapshotted, as ids, before anything is removed: [removeNotification]
    // rewrites `state`, and it removes by id rather than by entry — so two
    // entries sharing one id go together and the id is asked for once.
    final expired = {
      for (final candidate in _expiryCandidates(state))
        if (_deadlineReached(candidate.deadline, now: now))
          candidate.notification.id,
    };

    // Rearmed at the end whether or not anything was removed. A fire that finds
    // nothing produces no state change, and a design that rearmed only on state
    // changes would strand the timer for the rest of the session — which a
    // backwards wall-clock correction is enough to produce. ADR-0010
    // decision 3.
    _asOneOperation(() {
      for (final id in expired) {
        removeNotification(id, reason: NotificationRemovalReason.expired);
      }
    });
  }

  /// Runs [removals] as one change to the list: the expiry timer is rearmed
  /// once at the end rather than once per [removeNotification] inside it.
  void _asOneOperation(void Function() removals) {
    _batchingRemovals = true;
    try {
      removals();
    } finally {
      // Both halves in the `finally`: `sweepExpired` gives the timer up before
      // it starts, so a removal that threw part way would leave the notifier
      // with the flag cleared and nothing armed — stranded for the rest of the
      // session, which is the failure ADR-0010 decision 3 exists to prevent.
      _batchingRemovals = false;
      _rearmExpiryTimer();
    }
  }

  /// Points [_expiryTimer] at the earliest deadline the list still owes a
  /// sweep, replacing whatever it was pointing at before.
  ///
  /// Called at the end of every operation that changes the list, and suppressed
  /// while [_asOneOperation] is holding one open. `build` does not call it: the
  /// list it returns is empty, and the disposal that precedes a rebuild has
  /// already given the previous generation's timer up.
  void _rearmExpiryTimer() {
    if (_batchingRemovals) {
      return;
    }

    _cancelExpiryTimer();

    final deadline = nextExpiryDeadline(state).toNullable();
    if (deadline == null) {
      return;
    }

    // Through the same boundary every other caller asks: a deadline already
    // reached sweeps at the first opportunity rather than arming for a negative
    // delay. `now` is sampled once, so the question and the delay agree.
    final now = DateTime.now();
    _expiryTimer = Timer(
      _deadlineReached(deadline, now: now)
          ? Duration.zero
          : deadline.difference(now),
      sweepExpired,
    );
  }

  void _cancelExpiryTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }

  void clearAll() {
    // The pending requests go without any of them being resolved, so the
    // episode has to be given up explicitly: nothing else will ever empty its
    // unresolved set, and a stranded episode never puts the window back again.
    if (FlavorConfig.isDesktop) {
      unawaited(
        _onDesktopWindow(
          'abandon the raise episode',
          (service) => service.abandonEpisode(),
        ),
      );
    }

    // Written explicitly, and before the invalidation: clearing does not assign
    // state, so nothing else would ever push the new zero — and after
    // invalidateSelf this notifier no longer has a ref to write through.
    _writeBadge(0);

    ref.invalidateSelf();
  }

  Option<NotificationData> getNotification(int id) {
    final notifications = [...state];
    return Option.fromNullable(
      notifications.firstWhereOrNull((e) => e.id == id),
    );
  }
}

/// How many entries of [notifications] are still awaiting a user decision.
///
/// The badge's unit, and not the raw list length: a cancelled entry stays in
/// the list until a later microtask removes it, and counting it would make the
/// icon claim a decision is awaited on a request the origin has already
/// withdrawn (ADR-0005 decision 3).
///
/// Deliberately not folded together with [activeNotifications], whose predicate
/// happens to select the same entries today only because the item state has
/// exactly two cases: that one asks which entries to *show*, this one asks what
/// is still *waiting*, and the two would part company the moment a third state
/// appears.
int pendingBadgeCount(List<NotificationData> notifications) {
  return notifications
      .where(
        (notification) =>
            notification.type.notificationItemState !=
            const NotificationItemState.canceled(),
      )
      .length;
}

/// When a request received at [createdAt] with [ttlMilliseconds] to live stops
/// being actionable.
///
/// The local deadline lands at or after the server's, because the countdown
/// starts at receipt and the server's at issue: [Notifications.addNotification]
/// stamps [createdAt] on arrival and transport latency is not subtracted. So
/// this is an approximation of a withdrawal the server owns, not a retraction
/// the app decides — ADR-0006 decision 7, unchanged.
DateTime requestDeadline(DateTime createdAt, int ttlMilliseconds) =>
    createdAt.add(Duration(milliseconds: ttlMilliseconds));

/// The one boundary comparison, to the millisecond.
///
/// Every question about whether a request is past its deadline goes through
/// here — the presentation guard, the expiry sweep, the arming that schedules
/// it, the drop at delivery and the countdown's own zero — so none of them can
/// disagree about where the boundary sits. It used to truncate to whole
/// seconds, which answered "passed" from 999 ms before the deadline and left
/// the arming instant with no writable expression. ADR-0010 decision 2.
bool _deadlineReached(DateTime deadline, {required DateTime now}) =>
    !now.isBefore(deadline);

/// Whether a request received at [createdAt] with [ttlMilliseconds] to live has
/// reached its deadline by [now].
///
/// The shape for a caller holding a receipt instant rather than an entry:
/// [Notifications.addNotification] decides its drop before any entry exists,
/// and passes the same instant it is about to stamp as `createdAt` rather than
/// sampling the clock a second time. ADR-0010 decision 2.
bool requestDeadlinePassedAt({
  required DateTime createdAt,
  required int ttlMilliseconds,
  required DateTime now,
}) => _deadlineReached(requestDeadline(createdAt, ttlMilliseconds), now: now);

/// Whether [notification]'s deadline has already gone by at [now].
///
/// Asked of a request that is about to be presented, before its dialog is
/// built. [SignRequestNotificationTtl] cannot answer it: it is autoDispose and
/// starts a timer the moment it is watched, and its `none()` says both "this
/// request carries no deadline" and "there is no such entry" — so watching it
/// to decide whether to present would both start a countdown for a request
/// nothing is showing yet and conflate the two answers.
///
/// A request carrying no deadline is never past one: none is invented for it
/// (ADR-0006 decision 7). The entry-shaped wrapper over
/// [requestDeadlinePassedAt]: it unpacks the pair and delegates, so it cannot
/// drift from the boundary every other caller uses.
bool requestDeadlinePassed(
  NotificationData notification, {
  required DateTime now,
}) {
  return notification.type.ttlMilliseconds.match(
    () => false,
    (ttlMilliseconds) => requestDeadlinePassedAt(
      createdAt: notification.type.createdAt,
      ttlMilliseconds: ttlMilliseconds,
      now: now,
    ),
  );
}

/// Every entry the expiry sweep acts on, paired with the deadline it acts at.
///
/// A cancelled entry is skipped: it is leaving as *remote cancel*, under a
/// resolution the server performed, and recording it as *expired* would replace
/// a known cause with a guessed one. An entry carrying no TTL is skipped
/// because none is invented for it (ADR-0006 decision 7).
///
/// [nextExpiryDeadline] and the sweep both read the list through here, so the
/// two cannot filter differently. They must not: an arming computed over an
/// entry the sweep refuses schedules a fire that can only be a no-op, and —
/// because every fire rearms — a hot loop. ADR-0010 decision 3.
Iterable<({NotificationData notification, DateTime deadline})>
_expiryCandidates(List<NotificationData> notifications) sync* {
  for (final notification in notifications) {
    if (notification.type.notificationItemState ==
        const NotificationItemState.canceled()) {
      continue;
    }

    final ttlMilliseconds = notification.type.ttlMilliseconds.toNullable();
    if (ttlMilliseconds == null) {
      continue;
    }

    yield (
      notification: notification,
      deadline: requestDeadline(notification.type.createdAt, ttlMilliseconds),
    );
  }
}

/// When the expiry sweep next has work to do, and nothing when it never will.
///
/// The earliest deadline among the entries the sweep would act on — the instant
/// [Notifications]'s single timer is armed for. An empty answer arms nothing;
/// an answer already in the past arms the sweep for the first opportunity
/// rather than for a negative delay. ADR-0010 decision 3.
Option<DateTime> nextExpiryDeadline(List<NotificationData> notifications) {
  return Option.fromNullable(
    _expiryCandidates(notifications)
        .map((candidate) => candidate.deadline)
        .minOrNull,
  );
}

@riverpod
bool activeNotifications(Ref ref) {
  final notifications = ref.watch(notificationsProvider);

  return notifications.any((notification) {
    return notification.type.map(
      connect: (connect) =>
          connect.notificationItemState == NotificationItemState.empty(),
      signRequest: (signRequest) =>
          signRequest.notificationItemState == NotificationItemState.empty(),
    );
  });
}

/// The entry [notificationId] addresses while its request is still pending, and
/// nothing once it is gone, cancelled, or addresses a different request.
///
/// [reqId] is what separates requests rather than entries: the local id is an
/// arrival counter whose uniqueness is a property of one notifier instance and
/// not of the protocol. It is not even one entry per id — a request carrying
/// both payloads files two under the same one, as the next paragraph says — so
/// matching the integer alone establishes nothing about *which request* the
/// entry belongs to, and comparing the request id is what does. That argument
/// holds whatever the counter happens to do, which is why the counter not
/// starting over at [Notifications.clearAll] (#211) costs it nothing.
/// ADR-0006 decision 3.
///
/// It does not separate the two entries of a request carrying both a connect
/// and a sign payload — [Notifications.addNotification] gives those one id and
/// one request id between them, so this answers with whichever the list holds
/// first. That is the same entry the lookup this replaced would have found, and
/// narrowing it needs an identity the protocol does not currently carry.
@riverpod
Option<NotificationData> pendingRequest(
  Ref ref,
  int notificationId,
  String reqId,
) {
  final notifications = ref.watch(notificationsProvider);

  final notification = notifications.firstWhereOrNull(
    (notification) => notification.id == notificationId,
  );

  if (notification == null) {
    return none();
  }

  if (notification.type.reqId != reqId) {
    return none();
  }

  if (notification.type.notificationItemState ==
      const NotificationItemState.canceled()) {
    return none();
  }

  return Option.of(notification);
}

/// The request to present next on mobile: the oldest one still waiting, and
/// nothing while none is.
///
/// Mobile presents one request at a time, so this is the queue — derived from
/// the pending set rather than held beside it. A request that has to wait its
/// turn therefore stays in [notificationsProvider] the whole time, and keeps
/// counting towards everything read off that list, instead of being moved into
/// a holding pen where it would silently stop being pending. ADR-0006
/// decision 5.
///
/// Oldest first, because a queue served newest-first starves the request with
/// the least time left on it. Order is by id — the arrival counter — rather
/// than by `createdAt`, which [Notifications.addNotification] stamps from a
/// separate `DateTime.now()` call per payload branch.
///
/// The answer is folded out of the list rather than read off one end of it, so
/// it does not depend on the order the list happens to be held in. Ties are
/// settled in favour of the entry the list holds first, which is the entry
/// [pendingRequest] answers with for that id — the two have to agree about
/// which entry an id addresses. A tie needs two entries under one id, which
/// `addNotification` would produce for a request carrying both a connect and a
/// sign payload; the wire makes that impossible today, because the two are a
/// protobuf `oneof`. Both the tie-break and the append-order independence are
/// therefore defensive, and stated here so neither is mistaken for a property
/// the list guarantees.
@riverpod
Option<NotificationData> nextPendingRequest(Ref ref) {
  final notifications = ref.watch(notificationsProvider);

  NotificationData? oldest;

  for (final notification in notifications) {
    if (notification.type.notificationItemState ==
        const NotificationItemState.canceled()) {
      continue;
    }

    // Strictly less than, so the first entry of a tie is the one kept.
    if (oldest == null || notification.id < oldest.id) {
      oldest = notification;
    }
  }

  return Option.fromNullable(oldest);
}

@riverpod
class ShowNotificationMenu extends _$ShowNotificationMenu {
  @override
  Option<int> build() {
    return none();
  }

  void setState(int notificationId) {
    state = Option.of(notificationId);
  }
}

@riverpod
class SignRequestNotificationTtl extends _$SignRequestNotificationTtl {
  void _onTick(Timer _) {
    final notifications = ref.read(notificationsProvider);
    final notification = notifications.firstWhereOrNull(
      (n) => n.id == notificationId,
    );
    if (notification != null) updateState(notification);
  }

  @override
  Option<int> build(int notificationId) {
    final notifications = ref.watch(notificationsProvider);
    if (notifications.isEmpty) {
      return none();
    }

    final notification = notifications.firstWhereOrNull(
      (notification) => notification.id == notificationId,
    );

    if (notification == null) {
      return none();
    }

    if (notification.type.notificationItemState ==
        const NotificationItemState.canceled()) {
      return none();
    }

    // Returned before the timer below is created: a request carrying no
    // deadline has no countdown to render, because there is no deadline and
    // none is invented for it (ADR-0006 decision 7). Nothing follows from the
    // absent countdown any more — the expiry is the notifier's, recorded
    // whether or not anything is watching (ADR-0010 decision 5).
    if (notification.type.ttlMilliseconds.isNone()) {
      return none();
    }

    final timer = Timer.periodic(Duration(seconds: 1), _onTick);
    ref.onDispose(() => timer.cancel());

    return updateState(notification);
  }

  Option<int> updateState(NotificationData notification) {
    return notification.type.ttlMilliseconds.match(() => none(), (
      ttlMilliseconds,
    ) {
      // Sampled once: two calls can straddle the boundary and render a
      // negative count from the arm that was chosen for a positive one.
      final now = DateTime.now();
      final endTimestamp = requestDeadline(
        notification.type.createdAt,
        ttlMilliseconds,
      );

      // Whole seconds, as before — this provider is the number on the screen
      // and nothing else now. What changed is that it no longer decides
      // anything by the truncation: the boundary it floors at is the
      // millisecond-precise one every other caller uses, so the count reaches
      // zero before the entry goes rather than up to a second after.
      // ADR-0010 decisions 2 and 5.
      state = Option.of(
        _deadlineReached(endTimestamp, now: now)
            ? 0
            : endTimestamp.difference(now).inSeconds,
      );

      return state;
    });
  }
}
