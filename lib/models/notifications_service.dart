import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/notification_model.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  logger.e('onBackgroundNotification: $message');

  await Firebase.initializeApp();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .initialize(notificationService._getInitializationSettings());

  if (message.containsKey('data')) {
    // Handle data message
    //final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    //final dynamic notification = message['notification'];
  }

  // Or do other work.
}

enum IncomingNotificationType {
  message,
  launch,
  resume,
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

const String _groupKey = 'com.android.sideswap.GENERAL_NOTIFICATION';
const String _groupChannelId = 'sideswap_channel_id';
const String _groupChannelName = 'SideSwapChannel';
const String _groupChannelDescription = 'SideSwapChannelDescription';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  _groupChannelId, // id
  _groupChannelName, // title
  _groupChannelDescription, // description
  importance: Importance.high,
);

NotificationService notificationService = NotificationService();

class NotificationService {
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService.internal();

  static final NotificationService _notificationService =
      NotificationService.internal();

  final didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  final selectNotificationSubject = BehaviorSubject<String>();

  String _selectedNotificationPayload;
  String get selectedNotificationPayload => _selectedNotificationPayload;

  int _notificationId = 0;

  String _dynamicLinkAddress = '';
  String get dynamicLinkAddress => _dynamicLinkAddress;

  set dynamicLinkAddress(String dynamicLinkAddress) {
    _dynamicLinkAddress = dynamicLinkAddress;
  }

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  BuildContext _context;

  final _delayedNotifications = <FCMMessage>[];

  Future<void> init(BuildContext context) async {
    _context = context;
    _firebaseMessaging.requestNotificationPermissions();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        logger.e('onMessage: ${jsonEncode(message)}');
        _handleIncomingNotification(
          context,
          IncomingNotificationType.message,
          message,
        );
      },
      // Set the background handler only when fcm notification is sent without notification in json!
      onBackgroundMessage: null,
      onLaunch: (Map<String, dynamic> message) async {
        logger.e('onLaunch: $message');
        _handleIncomingNotification(
          context,
          IncomingNotificationType.launch,
          message,
        );
      },
      onResume: (Map<String, dynamic> message) async {
        logger.e('onResume: $message');
        _handleIncomingNotification(
          context,
          IncomingNotificationType.resume,
          message,
        );
      },
    );

    final initializationSettings = _getInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
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
      onSelectNotification: (String payload) async {
        _selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
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

  void _onNewTransItem(TransItem transItem) {
    if (_delayedNotifications.isEmpty) {
      return;
    }

    if (transItem.tx != null) {
      final txid = transItem.tx.txid;
      final fcmMessage = _delayedNotifications.firstWhere(
          (e) => e.data?.details?.tx?.txId == txid,
          orElse: () => null);

      if (fcmMessage != null) {
        logger.d('Delayed found: ${transItem.toDebugString()}');
        final payloadType = _getPayloadType(fcmMessage.data.details.tx.txType);
        final payload = FCMPayload(type: payloadType, txid: txid);
        _onNotificationData(payload.toJsonString());
        _delayedNotifications
            .removeWhere((e) => e.data.details.tx.txId == txid);
        return;
      }
    }

    if (transItem.peg != null && transItem.peg.isPegIn) {
      final txid = transItem.peg.txidRecv;
      final fcmMessage = _delayedNotifications.firstWhere(
          (e) => e.data.details.pegDetected.txHash == txid,
          orElse: () => null);

      if (fcmMessage != null) {
        logger.d('Delayed found: ${transItem.toDebugString()}');
        final payloadType = FCMPayloadType.pegin;
        final payload = FCMPayload(type: payloadType, txid: txid);
        _onNotificationData(payload.toJsonString());
        _delayedNotifications
            .removeWhere((e) => e.data.details.tx.txId == txid);
        return;
      }
    }

    logger.d('Delayed not found found!');
  }

  NotificationDetails _getNotificationDetails({
    NotificationVisibility visibility = NotificationVisibility.public,
    StyleInformation styleInformation,
  }) {
    styleInformation ??= DefaultStyleInformation(true, true);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      enableLights: true,
      color: Color.fromARGB(255, 87, 193, 251),
      ledColor: Color.fromARGB(255, 0, 197, 255),
      ledOnMs: 1000,
      ledOffMs: 500,
      visibility: visibility,
      styleInformation: styleInformation,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );

    return platformChannelSpecifics;
  }

  InitializationSettings _getInitializationSettings({
    Future<dynamic> Function(int, String, String, String)
        onDidReceiveLocalNotification,
  }) {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notification_icon');

    final initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    return initializationSettings;
  }

  void _handleIncomingNotification(BuildContext context,
      IncomingNotificationType type, Map<String, Object> message) {
    final fcmMessage = FCMMessage.fromJson(message);

    if (fcmMessage?.data?.details == null) {
      return;
    }

    switch (type) {
      case IncomingNotificationType.message:
        _onForegroundNotification(fcmMessage);
        break;
      case IncomingNotificationType.resume:
        _onResumeNotification(fcmMessage);
        break;
      case IncomingNotificationType.launch:
        logger.d('Adding delayed: $fcmMessage');
        _delayedNotifications.add(fcmMessage);
        break;
    }
  }

  Future<void> _onResumeNotification(FCMMessage fcmMessage) async {
    final fcmTx = fcmMessage?.data?.details?.tx;
    if (fcmTx == null) {
      return;
    }

    final payloadType = _getPayloadType(fcmTx.txType);
    final payload = FCMPayload(type: payloadType, txid: fcmTx.txId);
    _onNotificationData(payload.toJsonString());
  }

  Future<void> _onForegroundNotification(FCMMessage fcmMessage) async {
    final fcmTx = fcmMessage?.data?.details?.tx;

    if (fcmTx != null) {
      return await _onTxNotification(fcmMessage);
    }

    final peg = fcmMessage.data.details.pegDetected ??
        fcmMessage.data.details.pegPayout;
    if (peg != null) {
      final payloadType = FCMPayloadType.pegin;
      final payload = FCMPayload(type: payloadType, txid: peg.txHash);
      await _onDefaultNotification(
        title: fcmMessage.notification.title,
        body: fcmMessage.notification.body,
        payload: payload,
      );
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

  Future<void> _onTxNotification(FCMMessage fcmMessage) async {
    final allTxs = _context.read(walletProvider).allTxs;
    final fcmTx = fcmMessage.data.details.tx;

    logger.d(fcmTx.txType.toString());

    final payloadType = _getPayloadType(fcmTx.txType);
    final payload = FCMPayload(type: payloadType, txid: fcmTx.txId);

    // display only recv notification when app is opened
    if (!allTxs.containsKey(fcmTx.txId) && fcmTx.txType == FCMTxType.recv) {
      // no tx item in internal list or unhandled type - let's display that what we're received
      await _onDefaultNotification(
        title: fcmMessage.notification.title,
        body: fcmMessage.notification.body,
        payload: payload,
      );

      return;
    }

    if (fcmTx.txType == FCMTxType.recv) {
      await _onDefaultNotification(
        title: fcmMessage.notification.title,
        body: fcmMessage.notification.body,
        payload: payload,
      );

      return;
    }
  }

  void _onNotificationData(String payload) async {
    logger.d('Notification data: $payload');

    // handle Android notification here
    final json = jsonDecode(payload) as Map<String, Object>;
    final fcmPayload = FCMPayload.fromJson(json);
    final txid = fcmPayload.txid;

    final allTxs = _context.read(walletProvider).allTxs;

    switch (fcmPayload.type) {
      case FCMPayloadType.pegin:
      case FCMPayloadType.pegout:
      case FCMPayloadType.send:
      case FCMPayloadType.recv:
      case FCMPayloadType.redeposit:
        if (allTxs.containsKey(txid)) {
          final tx = allTxs[txid];
          _context.read(walletProvider).showTxDetails(tx);
        }
        break;
      case FCMPayloadType.swap:
        if (allTxs.containsKey(txid)) {
          final tx = allTxs[txid];
          _context.read(walletProvider).showSwapTxDetails(tx);
        }
        break;
      case FCMPayloadType.unknown:
        break;
    }

    logger.d('onNotificationData payload not found: $payload');
  }

  void _oniOSNotification(ReceivedNotification receivedNotification) async {
    logger.d(
      'Notification iOS data: ${receivedNotification.id} ${receivedNotification.title} ${receivedNotification.body} ${receivedNotification.payload}',
    );

    await showDialog<void>(
      context: _context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null
            ? Text(receivedNotification.title)
            : null,
        content: receivedNotification.body != null
            ? Text(receivedNotification.body)
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
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> showNotification(
    String title,
    String body, {
    String payload,
    NotificationVisibility visibility = NotificationVisibility.public,
    NotificationDetails notificationDetails,
  }) async {
    final activeNotifications = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    if (activeNotifications == null || activeNotifications.isEmpty) {
      _notificationId = 0;
    }

    notificationDetails ??= _getNotificationDetails(visibility: visibility);

    await _flutterLocalNotificationsPlugin.show(
      _notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    _notificationId = _notificationId + 1;
  }

  Future<void> _onDefaultNotification(
      {String title, String body, FCMPayload payload}) async {
    final notificationDetails = _getNotificationDetails();

    await showNotification(
      title,
      body,
      notificationDetails: notificationDetails,
      payload: payload.toJsonString(),
    );
  }

  Future handleDynamicLinks() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      logger.e('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final deepLink = data?.link;
    if (deepLink != null) {
      logger.d('_handleDeepLink | deeplink: $deepLink');

      if (deepLink.queryParameters.containsKey('address')) {
        _context.read(paymentProvider).selectPaymentAmountPage(
              PaymentAmountPageArguments(
                result:
                    QrCodeResult(address: deepLink.queryParameters['address']),
              ),
            );
      }
    }
  }

  Future<Uri> createShortDynamicLink({String address}) async {
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

    if (shortDynamicLink.warnings.isNotEmpty) {
      logger.w(shortDynamicLink.warnings);
    }

    logger.d('Created short uri ${shortDynamicLink.shortUrl}');

    return shortDynamicLink.shortUrl;
  }

  void refreshToken() async {
    // TODO: Catch platform exceptions
    final token = await _firebaseMessaging.getToken();
    _context.read(walletProvider).updatePushToken(token);

    FirebaseMessaging().onTokenRefresh.listen((newToken) {
      logger.d('Firebase token: $token');
      _context.read(walletProvider).updatePushToken(newToken);
    });
  }
}
