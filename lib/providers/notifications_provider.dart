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
  int _id = 0;

  /// Where the pending badge is written, captured once while the notifier is
  /// built, or `null` off desktop.
  ///
  /// Held rather than read at each use because the badge outlives the reads:
  /// clearing it is the last thing this notifier does, and `ref.read` is not
  /// available from a disposal callback.
  DesktopWindowService? _badgeTarget;

  @override
  List<NotificationData> build() {
    final notifications = <NotificationData>[];

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
            DateTime.now(),
            signRequest.hasTtlMilliseconds()
                ? Option.of(signRequest.ttlMilliseconds.toInt())
                : none(),
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
            DateTime.now(),
            signRequest.hasTtlMilliseconds()
                ? Option.of(signRequest.ttlMilliseconds.toInt())
                : none(),
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
    // is two entries the user sees, and the badge states the total once.
    _updateBadge();
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

    Future.microtask(() {
      // Don't leave cancelled notifications on the screen, just remove them.
      state
          .where(
            (notification) => notification.type.map(
              connect: (connect) =>
                  connect.notificationItemState ==
                  NotificationItemState.canceled(),
              signRequest: (signRequest) =>
                  signRequest.notificationItemState ==
                  NotificationItemState.canceled(),
            ),
          )
          .forEach((notification) {
            removeNotification(
              notification.id,
              reason: NotificationRemovalReason.remoteCancel,
            );
          });
    });
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

    if (notification.type.map(
      connect: (connect) =>
          connect.notificationItemState == NotificationItemState.canceled(),
      signRequest: (signRequest) =>
          signRequest.notificationItemState == NotificationItemState.canceled(),
    )) {
      return none();
    }

    final ttlMilliseconds = notification.type.map(
      connect: (connect) => connect.ttlMilliseconds,
      signRequest: (signRequest) => signRequest.ttlMilliseconds,
    );

    if (ttlMilliseconds.isNone()) {
      return none();
    }

    final timer = Timer.periodic(Duration(seconds: 1), _onTick);
    ref.onDispose(() => timer.cancel());

    return updateState(notification);
  }

  Option<int> updateState(NotificationData notification) {
    final ttlMilliseconds = notification.type.map(
      connect: (connect) => connect.ttlMilliseconds,
      signRequest: (signRequest) => signRequest.ttlMilliseconds,
    );

    return ttlMilliseconds.match(() => none(), (ttlMilliseconds) {
      final createdAt = notification.type.map(
        connect: (connect) => connect.createdAt,
        signRequest: (signRequest) => signRequest.createdAt,
      );

      final endTimestamp = createdAt.add(
        Duration(milliseconds: ttlMilliseconds),
      );
      state = switch (endTimestamp.difference(DateTime.now()).inSeconds <= 0) {
        true => Option.of(0),
        false => Option.of(endTimestamp.difference(DateTime.now()).inSeconds),
      };

      return state;
    });
  }
}
