import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
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
        .listen((payload) {
          _onNotificationData(payload);
        });
    ref
        .read(localNotificationsProvider)
        .didReceiveLocalNotificationSubject
        .stream
        .listen(_oniOSNotification);
    ref.listen(updatedTxsNotifierProvider, (_, updatedTxs) {
      for (final tx in updatedTxs) {
        _onNewTransItem(tx);
      }
    });
    ref.listen(showTransactionNotifierProvider, (_, showTransaction) {
      showTransaction.match(() {}, (tx) {
        if (_onNewTransItem(tx)) {
          // stop receiving tx data
          _delayedNotifications.removeWhere(
            (e) => e.txid == (tx.hasTx() ? tx.tx.txid : tx.peg.txidSend),
          );
          final msg = To();
          msg.showTransaction = To_ShowTransaction();
          ref.read(walletProvider).sendMsg(msg);

          // cleanup
          ref.invalidate(showTransactionNotifierProvider);
        }
      });
    });
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
          var isHandled = false;
          for (var tx in allTxs.values) {
            final ret = _onNewTransItem(tx);
            if (ret) {
              _delayedNotifications.removeWhere((e) => e.txid == tx.tx.txid);
              isHandled = true;
            }
          }
          final allPegs = ref.read(allPegsNotifierProvider);
          for (var pegs in allPegs.values) {
            for (var tx in pegs) {
              final ret = _onNewTransItem(tx);
              if (ret) {
                _delayedNotifications.removeWhere(
                  (e) => e.txid == tx.peg.txidSend,
                );
                isHandled = true;
              }
            }
          }

          final serverConnected = ref.read(serverConnectionNotifierProvider);
          if (!isHandled && serverConnected && payload.txid != null) {
            _requestTxFromBackend(payload.txid!);
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
        return _onNotificationData(fcmPayload);
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
        return _onNotificationData(fcmPayload);
      } on StateError {
        return false;
      }
    }

    // maybe we don't have this txid, ask server about it
    final txid = transItem.tx.hasTxid()
        ? transItem.tx.txid
        : transItem.peg.txidSend;
    _requestTxFromBackend(txid);

    logger.d('Delayed not found! Asking BE for tx');
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

  bool _onNotificationData(FCMPayload fcmPayload) {
    logger.d('Notification data: $fcmPayload');

    final txid = fcmPayload.txid;

    final fcmTxType = fcmPayload.type;
    if (fcmTxType == null) {
      return false;
    }

    final allTxs = ref.read(allTxsNotifierProvider);

    for (final transItem in allTxs.values) {
      if (transItem.tx.txid == txid) {
        if (FlavorConfig.isDesktop) {
          final walletMainArguments = ref.read(uiStateArgsNotifierProvider);
          final newWalletMainArguments = walletMainArguments.fromIndexDesktop(
            3,
          ); // transactions page
          ref
              .read(uiStateArgsNotifierProvider.notifier)
              .setWalletMainArguments(
                newWalletMainArguments,
              ); // open transactions page

          final allPegsById = ref.read(allPegsByIdProvider);
          ref
              .read(desktopDialogProvider)
              .showTx(
                transItem,
                isPeg: transItem.hasPeg()
                    ? allPegsById.containsKey(
                        transItem.peg.isPegIn
                            ? transItem.peg.txidRecv
                            : transItem.peg.txidSend,
                      )
                    : false,
              ); // show tx popup
          return true;
        }

        if (fcmTxType == FCMPayloadType.swap) {
          ref.read(walletProvider).showSwapTxDetails(transItem);
          return true;
        }

        ref.read(walletProvider).showTxDetails(transItem);
        return true;
      }
    }

    final allPegs = ref.read(allPegsNotifierProvider);

    for (final list in allPegs.values) {
      for (final peg in list) {
        if (peg.peg.txidSend == txid) {
          if (FlavorConfig.isDesktop) {
            final walletMainArguments = ref.read(uiStateArgsNotifierProvider);
            final newWalletMainArguments = walletMainArguments.fromIndexDesktop(
              3,
            ); // transactions page
            ref
                .read(uiStateArgsNotifierProvider.notifier)
                .setWalletMainArguments(
                  newWalletMainArguments,
                ); // open transactions page

            final allPegsById = ref.read(allPegsByIdProvider);
            ref
                .read(desktopDialogProvider)
                .showTx(peg, isPeg: allPegsById.containsKey(peg.id));
            return true;
          }

          ref.read(walletProvider).showTxDetails(peg);
          return true;
        }
      }
    }

    logger.d('onNotificationData payload not found: $fcmPayload');
    // can't display now, push as delayed notification
    // and wait for data from server
    if (!_delayedNotifications.contains(fcmPayload)) {
      _delayedNotifications.add(fcmPayload);
    }

    return false;
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

  void requestTxFromBackend() {
    if (_delayedNotifications.isEmpty) {
      return;
    }
    final txid = _delayedNotifications.first.txid;

    if (txid != null) {
      _requestTxFromBackend(txid);
    }
  }

  void _requestTxFromBackend(String txid) {
    final msg = To();
    msg.showTransaction = To_ShowTransaction(txid: txid);
    ref.read(walletProvider).sendMsg(msg);
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
