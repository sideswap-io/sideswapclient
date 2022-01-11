import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ffi/ffi.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
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

const String _groupKey = 'com.android.sideswap.GENERAL_NOTIFICATION';

const String _notificationChannelId = 'sideswap_channel_id';
const String _notificationChannelName = 'Main';
const String _notificationChannelDescription = 'All notifications';

const String _notificationSignChannelId = 'sideswap_channel_id_sign';
const String _notificationSignChannelName = 'Sign';
const String _notificationSignChannelDescription = 'Sign notifications';

const AndroidNotificationChannel mainChannel = AndroidNotificationChannel(
  _notificationChannelId, // id
  _notificationChannelName, // title
  _notificationChannelDescription, // description
  importance: Importance.high,
);

const AndroidNotificationChannel signChannel = AndroidNotificationChannel(
  _notificationSignChannelId,
  _notificationSignChannelName,
  _notificationSignChannelDescription,
  importance: Importance.high,
);

NotificationService notificationService = NotificationService();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d('onBackground: $message');
  dynamic details = message.data['details'];
  if (details is String) {
    Lib.lib.sideswap_process_background(details.toNativeUtf8().cast());
  }
}

class NotificationService {
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService.internal();

  static final NotificationService _notificationService =
      NotificationService.internal();

  final didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  final selectNotificationSubject = BehaviorSubject<FCMPayload>();

  String _selectedNotificationPayload = '';
  String get selectedNotificationPayload => _selectedNotificationPayload;

  int _notificationId = 0;

  String dynamicLinkAddress = '';

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  BuildContext? _context;

  final _delayedNotifications = <FCMPayload>[];

  Future<void> init(BuildContext context) async {
    _context = context;
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            sound: true,
            alert: true,
            badge: true,
          );
    }

    // remove old notification channel
    // TODO: This could be removed later
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(_notificationChannelId);

    // create new notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(mainChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(signChannel);

    // resume?
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message == null) {
        return;
      }

      logger.d('onResume: $message');
      _handleIncomingNotification(
        context,
        IncomingNotificationType.resume,
        message,
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('onMessage: $message');
      _handleIncomingNotification(
        context,
        IncomingNotificationType.message,
        message,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('onLaunch: $message');
      _handleIncomingNotification(
        context,
        IncomingNotificationType.launch,
        message,
      );
    });

    final initializationSettings = _getInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
    );

    // initialise the plugin.
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload == null) {
          logger.w('Empty notification payload');
          return;
        }

        try {
          _selectedNotificationPayload = payload;
          final json = jsonDecode(payload) as Map<String, dynamic>;
          final fcmPayload = FCMPayload.fromJson(json);
          selectNotificationSubject.add(fcmPayload);
        } catch (e) {
          logger.e('Cannot parse payload: $e');
        }
      },
    );

    selectNotificationSubject.stream.listen(_onNotificationData);
    didReceiveLocalNotificationSubject.stream.listen(_oniOSNotification);
    context
        .read(walletProvider)
        .newTransItemSubject
        .stream
        .listen(_onNewTransItem);
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

  NotificationDetails _getNotificationDetails({
    NotificationVisibility visibility = NotificationVisibility.public,
    StyleInformation styleInformation =
        const DefaultStyleInformation(true, true),
    NotificationChannelType type = NotificationChannelType.main,
  }) {
    String channelId, channelName, channelDescription;

    switch (type) {
      case NotificationChannelType.main:
        channelId = _notificationChannelId;
        channelName = _notificationChannelName;
        channelDescription = _notificationChannelDescription;
        break;
      case NotificationChannelType.sign:
        channelId = _notificationSignChannelId;
        channelName = _notificationSignChannelName;
        channelDescription = _notificationSignChannelDescription;
        break;
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      enableLights: true,
      color: const Color.fromARGB(255, 87, 193, 251),
      ledColor: const Color.fromARGB(255, 0, 197, 255),
      ledOnMs: 1000,
      ledOffMs: 500,
      visibility: visibility,
      styleInformation: styleInformation,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const IOSNotificationDetails(),
    );

    return platformChannelSpecifics;
  }

  InitializationSettings _getInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notification_icon');

    final initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    return initializationSettings;
  }

  void _handleIncomingNotification(BuildContext context,
      IncomingNotificationType type, RemoteMessage message) {
    dynamic details = message.data['details'];
    if (details is String) {
      context.read(walletProvider).gotPushMessage(details);
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
        if (fcmTx != null) {
          _onForegroundNotification(fcmMessage, fcmTx);
        }
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
          context.read(walletProvider).allTxs.values.forEach(_onNewTransItem);
          context.read(walletProvider).allPegs.values.forEach((pegs) {
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

  Future<void> _onForegroundNotification(
      FCMMessage fcmMessage, FCMTx fcmTx) async {
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

    return await _onTxNotification(fcmMessage, fcmTx);
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
    if (_context == null) {
      return;
    }

    logger.d(fcmTx.txType.toString());

    final fcmTxType = fcmTx.txType;
    if (fcmTxType == null) {
      return;
    }

    final payloadType = _getPayloadType(fcmTxType);
    final payload = FCMPayload(type: payloadType, txid: fcmTx.txId);

    // display only recv notification when app is opened
    final allTxs = _context!.read(walletProvider).allTxs;
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

    if (_context == null) {
      return;
    }

    final txid = fcmPayload.txid;

    final fcmTxType = fcmPayload.type;
    if (fcmTxType == null) {
      return;
    }

    for (final tx in _context!.read(walletProvider).allTxs.values) {
      if (tx.tx.txid == txid) {
        if (fcmTxType == FCMPayloadType.swap) {
          _context!.read(walletProvider).showSwapTxDetails(tx);
        } else {
          _context!.read(walletProvider).showTxDetails(tx);
        }
        return;
      }
    }

    for (final list in _context!.read(walletProvider).allPegs.values) {
      for (final peg in list) {
        if (peg.peg.txidSend == txid) {
          _context!.read(walletProvider).showTxDetails(peg);
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

    if (_context == null) {
      return;
    }

    await showDialog<void>(
      context: _context!,
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

  Future<void> showNotification(
    String title,
    String body, {
    String payload = '',
    NotificationVisibility visibility = NotificationVisibility.public,
    NotificationDetails? notificationDetails,
    NotificationChannelType type = NotificationChannelType.main,
  }) async {
    final activeNotifications = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    if (activeNotifications == null || activeNotifications.isEmpty) {
      _notificationId = 0;
    }

    notificationDetails ??= _getNotificationDetails(
      visibility: visibility,
      type: type,
    );

    await _flutterLocalNotificationsPlugin.show(
      _notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    _notificationId = _notificationId + 1;
  }

  Future<void> _onDefaultNotification({
    String? title,
    String? body,
    FCMPayload? payload,
    NotificationChannelType type = NotificationChannelType.main,
  }) async {
    final notificationDetails = _getNotificationDetails(type: type);

    await showNotification(
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

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      logger.e('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    final deepLink = data?.link;
    if (deepLink != null) {
      logger.d('_handleDeepLink | deeplink: $deepLink');

      if (deepLink.queryParameters.containsKey('address') && _context != null) {
        _context!.read(paymentProvider).selectPaymentAmountPage(
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
      androidParameters: AndroidParameters(
        packageName: 'io.sideswap',
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Sideswap',
        description: 'Shared address',
      ),
    );

    final shortDynamicLink = await parameters.buildShortLink();

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
      if (_context != null) {
        _context!.read(walletProvider).updatePushToken(token);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        logger.d('Firebase token: $token');
        if (_context != null) {
          _context!.read(walletProvider).updatePushToken(newToken);
        }
      });
    } on PlatformException catch (err) {
      logger.e('PlatformException: $err');
    } catch (err) {
      logger.e('Generic error: $err');
    }
  }
}
