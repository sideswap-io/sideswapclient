import 'dart:async';
import 'package:ffi/ffi.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/local_notifications_service.dart';
import 'package:sideswap/models/notification_model.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/common/utils/build_config.dart';

enum IncomingNotificationType {
  message,
  launch,
  resume,
}

enum NotificationChannelType {
  main,
  sign,
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService(ref));

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d('onBackground: $message');
  dynamic details = message.data['details'];
  if (details is String) {
    Lib.lib.sideswap_process_background(details.toNativeUtf8().cast());
  }
}

class NotificationService {
  final Ref ref;

  NotificationService(this.ref);

  String dynamicLinkAddress = '';

  final _delayedNotifications = <FCMPayload>[];

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // resume?
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message == null) {
        return;
      }

      logger.d('onResume: $message');
      _handleIncomingNotification(
        IncomingNotificationType.resume,
        message,
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('onMessage: $message');
      _handleIncomingNotification(
        IncomingNotificationType.message,
        message,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('onLaunch: $message');
      _handleIncomingNotification(
        IncomingNotificationType.launch,
        message,
      );
    });

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

  bool _onNewTransItem(TransItem transItem) {
    if (_delayedNotifications.isEmpty) {
      return true;
    }

    if (transItem.tx.hasTxid()) {
      try {
        final txid = transItem.tx.txid;
        final fcmPayload =
            _delayedNotifications.firstWhere((e) => e.txid == txid);

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
        final fcmPayload =
            _delayedNotifications.firstWhere((e) => e.txid == txid);

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

  void _handleIncomingNotification(
      IncomingNotificationType type, RemoteMessage message) {
    dynamic details = message.data['details'];
    if (details is String) {
      ref.read(walletProvider).gotPushMessage(details);
    }

    final messageJson = {
      'notification': {
        'body': message.notification?.body,
        'title': message.notification?.title,
      },
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
          ref.read(walletProvider).allTxs.values.forEach(_onNewTransItem);
          ref.read(walletProvider).allPegs.values.forEach((pegs) {
            pegs.forEach(_onNewTransItem);
          });
        } else {
          logger.w('Empty payload: $fcmMessage');
        }
        break;
    }
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
      await _onDefaultNotification(
        title: title,
        body: body,
        payload: payload,
      );
      return;
    }

    final orderCancelled = fcmMessage.data?.details?.orderCancelled;
    if (orderCancelled != null) {
      final title = fcmMessage.notification?.title ?? '';
      final body = fcmMessage.notification?.body ?? '';
      await _onDefaultNotification(
        title: title,
        body: body,
      );
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
    final allTxs = ref.read(walletProvider).allTxs;
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

  void _onNotificationData(FCMPayload fcmPayload) async {
    logger.d('Notification data: $fcmPayload');

    final txid = fcmPayload.txid;

    final fcmTxType = fcmPayload.type;
    if (fcmTxType == null) {
      return;
    }

    final allTxs = ref.read(walletProvider).allTxs;

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

    final allPegs = ref.read(walletProvider).allPegs;

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
      context: ref.read(walletProvider).navigatorKey.currentContext!,
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
            onPressed: () async {
              logger.d('Ok pressed');
              logger.d('Payload: ${receivedNotification.payload}');
              // handle iOS notification here

              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Ok'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
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

    await ref.read(localNotificationsProvider).showNotification(
          title ?? '',
          body ?? '',
          notificationDetails: notificationDetails,
          payload: payload?.toJsonString() ?? '',
          type: type,
        );
  }

  Future handleDynamicLinks() async {
    if (!notificationServiceAvailable()) {
      return;
    }

    final data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      _handleDeepLink(dynamicLink);
    }, onError: (dynamic error) {
      logger.e('Link Failed: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    final deepLink = data?.link;
    if (deepLink != null) {
      logger.d('_handleDeepLink | deeplink: $deepLink');

      if (deepLink.queryParameters.containsKey('address')) {
        ref.read(paymentProvider).selectPaymentAmountPage(
              PaymentAmountPageArguments(
                result:
                    QrCodeResult(address: deepLink.queryParameters['address']),
              ),
            );
      }
    }
  }

  Future<Uri> createShortDynamicLink({String address = ''}) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://sideswap.page.link',
      link: Uri.parse('https://sideswap.io/share?address=$address'),
      androidParameters: const AndroidParameters(
        packageName: 'io.sideswap',
      ),
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Sideswap',
        description: 'Shared address',
      ),
    );

    final shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    if (shortDynamicLink.warnings != null &&
        shortDynamicLink.warnings!.isNotEmpty) {
      logger.w(shortDynamicLink.warnings);
    }

    logger.d('Created short uri ${shortDynamicLink.shortUrl}');

    return shortDynamicLink.shortUrl;
  }

  Future<void> refreshToken() async {
    if (!notificationServiceAvailable()) {
      return;
    }
    try {
      final token = await FirebaseMessaging.instance.getToken();
      logger.d('Firebase token $token');
      ref.read(walletProvider).updatePushToken(token);

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        logger.d('Firebase token: $token');
        ref.read(walletProvider).updatePushToken(newToken);
      });
    } on PlatformException catch (err) {
      logger.e('PlatformException: $err');
    } catch (err) {
      logger.e('Generic error: $err');
    }
  }
}
