import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_notifications/sideswap_notifications.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  FCMRemoteMessage message,
) async {
  logger.d('onBackground: $message');
  dynamic details = message.details;
  if (details is String) {
    Lib.lib.sideswap_process_background(details.toNativeUtf8().cast());
  }
}

final sideswapNotificationProvider = AutoDisposeProvider((ref) {
  final plugin = SideswapNotificationsPlugin(
    androidPlatform: FlavorConfig.isFdroid
        ? AndroidPlatformEnum.fdroid
        : AndroidPlatformEnum.android,
  );
  return SideswapNotificationProvider(ref, plugin);
});

class SideswapNotificationProvider {
  final Ref ref;
  final SideswapNotificationsPlugin plugin;

  SideswapNotificationProvider(this.ref, this.plugin) {
    logger.d('Initialize notifications');
    plugin.notificationsInitialize(
      notificationBackgroundHandler: _firebaseMessagingBackgroundHandler,
      handleIncomingNotification: _handleIncomingNotification,
    );

    ref
        .read(localNotificationsProvider)
        .selectNotificationSubject
        .stream
        .listen(_onNotificationData);
    ref
        .read(localNotificationsProvider)
        .didReceiveLocalNotificationSubject
        .stream
        .listen(_oniOSNotification);
    ref.read(walletProvider).newTransItemSubject.stream.listen(_onNewTransItem);
  }

  final _delayedNotifications = <FCMPayload>[];

  void _handleIncomingNotification(
    IncomingNotificationType type,
    FCMRemoteMessage message,
  ) {
    dynamic details = message.details;
    if (details is String) {
      ref.read(walletProvider).gotPushMessage(details);
    }

    final messageJson = {
      'notification': {'body': message.body, 'title': message.title},
      'data': message.data,
    };

    final fcmMessage = FCMMessage.fromJson(messageJson);

    if (fcmMessage.data?.details == null) {
      return;
    }

    final fcmTx = fcmMessage.data?.details?.tx;

    switch (type) {
      case IncomingNotificationType.message:
        _onForegroundNotification(fcmMessage);
        break;
      case IncomingNotificationType.resume:
        if (fcmTx != null) {
          _onResumeNotification(fcmTx);
        }
        break;
      case IncomingNotificationType.launch:
        logger.d('Adding delayed: $fcmMessage');
        final payload = _createPayload(fcmMessage);
        if (payload != null) {
          _delayedNotifications.add(payload);
          // check if we already have txid on list
          final allTxs = ref.read(allTxsNotifierProvider);
          for (var txs in allTxs.values) {
            _onNewTransItem(txs);
          }
          final allPegs = ref.read(allPegsNotifierProvider);
          for (var pegs in allPegs.values) {
            for (var item in pegs) {
              _onNewTransItem(item);
            }
          }
        } else {
          logger.w('Empty payload: $fcmMessage');
        }
        break;
    }
  }

  bool _onNewTransItem(TransItem transItem) {
    if (_delayedNotifications.isEmpty) {
      return true;
    }

    if (transItem.tx.hasTxid()) {
      try {
        final txid = transItem.tx.txid;
        final fcmPayload = _delayedNotifications.firstWhere(
          (e) => e.txid == txid,
        );

        logger.d('Delayed found: ${transItem.toDebugString()}');
        _onNotificationData(fcmPayload);
        _delayedNotifications.removeWhere((e) => e.txid == txid);
        return true;
      } on StateError {
        return false;
      }
    }

    if (transItem.peg.isPegIn) {
      try {
        final txid = transItem.peg.txidSend;
        final fcmPayload = _delayedNotifications.firstWhere(
          (e) => e.txid == txid,
        );

        logger.d('Delayed found: ${transItem.toDebugString()}');
        _onNotificationData(fcmPayload);
        _delayedNotifications.removeWhere((e) => e.txid == txid);
        return true;
      } on StateError {
        return false;
      }
    }

    logger.d('Delayed not found!');
    return false;
  }

  FCMPayload? _createPayload(FCMMessage fcmMessage) {
    final fcmTx = fcmMessage.data?.details?.tx;
    final fcmTxType = fcmTx?.txType;

    if (fcmTx != null && fcmTxType != null) {
      final payloadType = _getPayloadType(fcmTxType);
      final payload = FCMPayload(type: payloadType, txid: fcmTx.txId);
      return payload;
    }

    final pegDetected = fcmMessage.data?.details?.pegDetected;

    if (pegDetected != null) {
      const payloadType = FCMPayloadType.pegin;
      final payload = FCMPayload(type: payloadType, txid: pegDetected.txHash);
      return payload;
    }

    return null;
  }

  Future<void> _onResumeNotification(FCMTx fcmTx) async {
    final fcmTxType = fcmTx.txType;
    if (fcmTxType == null) {
      return;
    }

    final payloadType = _getPayloadType(fcmTxType);
    final payload = FCMPayload(type: payloadType, txid: fcmTx.txId);
    _onNotificationData(payload);
  }

  Future<void> _onForegroundNotification(FCMMessage fcmMessage) async {
    final pegDetected = fcmMessage.data?.details?.pegDetected;
    if (pegDetected != null) {
      const payloadType = FCMPayloadType.pegin;
      final payload = FCMPayload(type: payloadType, txid: pegDetected.txHash);
      final title = fcmMessage.notification?.title ?? '';
      final body = fcmMessage.notification?.body ?? '';
      await _onDefaultNotification(title: title, body: body, payload: payload);
      return;
    }

    final orderCancelled = fcmMessage.data?.details?.orderCancelled;
    if (orderCancelled != null) {
      final title = fcmMessage.notification?.title ?? '';
      final body = fcmMessage.notification?.body ?? '';
      await _onDefaultNotification(title: title, body: body);
      return;
    }

    final fcmTx = fcmMessage.data?.details?.tx;
    if (fcmTx != null) {
      await _onTxNotification(fcmMessage, fcmTx);
      return;
    }
  }

  FCMPayloadType _getPayloadType(FCMTxType txType) {
    var payloadType = FCMPayloadType.unknown;

    switch (txType) {
      case FCMTxType.send:
        payloadType = FCMPayloadType.send;
        break;
      case FCMTxType.recv:
        payloadType = FCMPayloadType.recv;
        break;
      case FCMTxType.swap:
        payloadType = FCMPayloadType.swap;
        break;
      case FCMTxType.redeposit:
        payloadType = FCMPayloadType.redeposit;
        break;
      case FCMTxType.unknown:
        payloadType = FCMPayloadType.unknown;
        break;
    }

    return payloadType;
  }

  Future<void> _onTxNotification(FCMMessage fcmMessage, FCMTx fcmTx) async {
    logger.d(fcmTx.txType.toString());

    final fcmTxType = fcmTx.txType;
    if (fcmTxType == null) {
      return;
    }

    final payloadType = _getPayloadType(fcmTxType);
    final payload = FCMPayload(type: payloadType, txid: fcmTx.txId);

    // display only recv notification when app is opened
    final allTxs = ref.read(allTxsNotifierProvider);
    final knownTx = allTxs.containsKey(fcmTx.txId);

    if (!knownTx && fcmTx.txType == FCMTxType.recv) {
      // no tx item in internal list or unhandled type - let's display that what we're received
      await _onDefaultNotification(
        title: fcmMessage.notification?.title ?? '',
        body: fcmMessage.notification?.body ?? '',
        payload: payload,
      );

      return;
    }

    if (fcmTx.txType == FCMTxType.recv) {
      await _onDefaultNotification(
        title: fcmMessage.notification?.title ?? '',
        body: fcmMessage.notification?.body ?? '',
        payload: payload,
      );

      return;
    }
  }

  void _onNotificationData(FCMPayload fcmPayload) {
    logger.d('Notification data: $fcmPayload');

    final txid = fcmPayload.txid;

    final fcmTxType = fcmPayload.type;
    if (fcmTxType == null) {
      return;
    }

    final allTxs = ref.read(allTxsNotifierProvider);

    for (final tx in allTxs.values) {
      if (tx.tx.txid == txid) {
        if (fcmTxType == FCMPayloadType.swap) {
          ref.read(walletProvider).showSwapTxDetails(tx);
        } else {
          ref.read(walletProvider).showTxDetails(tx);
        }
        return;
      }
    }

    final allPegs = ref.read(allPegsNotifierProvider);

    for (final list in allPegs.values) {
      for (final peg in list) {
        if (peg.peg.txidSend == txid) {
          ref.read(walletProvider).showTxDetails(peg);
          return;
        }
      }
    }

    logger.d('onNotificationData payload not found: $fcmPayload');
    // can't display now, push as delayed notification
    // and wait for data from server
    _delayedNotifications.add(fcmPayload);
  }

  void _oniOSNotification(ReceivedNotification receivedNotification) async {
    logger.d(
      'Notification iOS data: ${receivedNotification.id} ${receivedNotification.title} ${receivedNotification.body} ${receivedNotification.payload}',
    );

    await showDialog<void>(
      context: ref.read(navigatorKeyProvider).currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null
            ? Text(receivedNotification.title ?? '')
            : null,
        content: receivedNotification.body != null
            ? Text(receivedNotification.body ?? '')
            : null,
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              logger.d('Ok pressed');
              logger.d('Payload: ${receivedNotification.payload}');
              // handle iOS notification here

              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Ok'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              logger.d('Cancel pressed');
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _onDefaultNotification({
    String? title,
    String? body,
    FCMPayload? payload,
    NotificationChannelType type = NotificationChannelType.main,
  }) async {
    final notificationDetails = getNotificationDetails(type: type);

    await ref
        .read(localNotificationsProvider)
        .showNotification(
          title ?? '',
          body ?? '',
          notificationDetails: notificationDetails,
          payload: payload?.toJsonString() ?? '',
          type: type,
        );
  }
}

class SideswapNotificationListener extends ConsumerWidget {
  const SideswapNotificationListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sideswapNotificationProvider, (_, _) {});
    return const SizedBox();
  }
}
