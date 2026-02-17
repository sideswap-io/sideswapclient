import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
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

  @override
  List<NotificationData> build() {
    return [];
  }

  void addNotification(From_SignerRequest signRequest) {
    _id = _id + 1;

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

      if (FlavorConfig.isDesktop) {
        ref
            .read(localNotificationsProvider)
            .showNotification(
              'New connection request',
              '',
              payload: FCMPayload(
                type: FCMPayloadType.swaptionConnect,
                data: jsonEncode({'notificationId': _id}),
              ).toJsonString(),
            );
      } else {
        ref.read(desktopDialogProvider).closePopups();
        ref.read(showNotificationMenuProvider.notifier).setState(_id);
      }
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

      if (FlavorConfig.isDesktop) {
        ref
            .read(localNotificationsProvider)
            .showNotification(
              'New sign request',
              '',
              payload: FCMPayload(
                type: FCMPayloadType.swaptionSign,
                data: jsonEncode({'notificationId': _id}),
              ).toJsonString(),
            );
      } else {
        ref.read(desktopDialogProvider).closePopups();
        ref.read(showNotificationMenuProvider.notifier).setState(_id);
      }
    }
  }

  void removeNotification(int id) {
    state = state.where((notification) => notification.id != id).toList();
  }

  void cancelNotification(String reqId) {
    state = state.map((notificationData) {
      final updatedType = switch (notificationData.type) {
        NotificationTypeConnect(:final reqId) when reqId == reqId =>
          notificationData.type.copyWith(
            notificationItemState: const NotificationItemState.canceled(),
          ),
        NotificationTypeSignRequest(:final reqId) when reqId == reqId =>
          notificationData.type.copyWith(
            notificationItemState: const NotificationItemState.canceled(),
          ),
        _ => null,
      };

      return updatedType != null
          ? notificationData.copyWith(type: updatedType)
          : notificationData;
    }).toList();
  }

  void clearAll() {
    ref.invalidateSelf();
  }

  Option<NotificationData> getNotification(int id) {
    final notifications = [...state];
    return Option.fromNullable(
      notifications.firstWhereOrNull((e) => e.id == id),
    );
  }
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

    final timer = Timer.periodic(
      Duration(seconds: 1),
      (_) => updateState(notification),
    );
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
