import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:window_manager/window_manager.dart';

import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_notifications/sideswap_notifications.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';

enum NotificationChannelType { main, sign }

final localNotificationsProvider = Provider<LocalNotificationService>(
  (ref) => LocalNotificationService(ref),
);

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
  description: _notificationChannelDescription,
  importance: Importance.high,
);

const AndroidNotificationChannel signChannel = AndroidNotificationChannel(
  _notificationSignChannelId,
  _notificationSignChannelName,
  description: _notificationSignChannelDescription,
  importance: Importance.high,
);

NotificationDetails getNotificationDetails({
  NotificationVisibility visibility = NotificationVisibility.public,
  StyleInformation styleInformation = const DefaultStyleInformation(true, true),
  NotificationChannelType type = NotificationChannelType.main,
  String? desktopSubtitle,
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
    channelDescription: channelDescription,
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
    iOS: const DarwinNotificationDetails(),
    windows: WindowsNotificationDetails(subtitle: desktopSubtitle),
    macOS: DarwinNotificationDetails(subtitle: desktopSubtitle),
  );

  return platformChannelSpecifics;
}

class LocalNotificationService {
  final Ref ref;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final InitializationSettings Function() _initSettingsFactory;
  final WindowManager _windowManager;
  final bool _isIOS;

  int _notificationId = 0;

  String _selectedNotificationPayload = '';
  String get selectedNotificationPayload => _selectedNotificationPayload;

  final didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final selectNotificationSubject = BehaviorSubject<FCMPayload>();

  LocalNotificationService(
    this.ref, {
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
    InitializationSettings Function()? initSettingsFactory,
    WindowManager? windowManager,
    bool? isIOS,
  }) : _flutterLocalNotificationsPlugin =
           flutterLocalNotificationsPlugin ?? FlutterLocalNotificationsPlugin(),
       _initSettingsFactory =
           initSettingsFactory ?? _defaultInitSettingsFactory,
       _windowManager = windowManager ?? WindowManager.instance,
       _isIOS = isIOS ?? Platform.isIOS;

  static InitializationSettings _defaultInitSettingsFactory() {
    final plugin = SideswapNotificationsPlugin(
      androidPlatform: FlavorConfig.isFdroid
          ? AndroidPlatformEnum.fdroid
          : AndroidPlatformEnum.android,
    );
    return plugin.getLocalNotificationsInitializationSettings();
  }

  Future<void> init() async {
    if (_isIOS) {
      // Logged unconditionally: a denied or absent grant is the difference
      // between "no banner was submitted" and "a banner was submitted and the
      // OS declined to show it", and only this result distinguishes them.
      final granted = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(sound: true, alert: true, badge: true);
      logger.i(
        '[LocalNotificationService][init]: notification permission result: '
        '$granted',
      );
    }

    // remove old notification channel
    // TODO: This could be removed later
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.deleteNotificationChannel(
      channelId: _notificationChannelId,
    );

    // create new notification channel
    await androidPlugin?.createNotificationChannel(mainChannel);
    await androidPlugin?.createNotificationChannel(signChannel);

    final initializationSettings = _initSettingsFactory();

    // initialise the plugin.
    try {
      final initialized = await _flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          if (FlavorConfig.isDesktop) {
            logger.d(
              '[LocalNotificationService][init]: Desktop notification received',
            );
            await _windowManager.waitUntilReadyToShow(null, () async {
              await _windowManager.show();
              await _windowManager.restore();
              await _windowManager.focus();
            });

            if (response.payload == null) {
              return;
            }

            // try JSON first (swaption payload)
            try {
              final json =
                  jsonDecode(response.payload!) as Map<String, dynamic>;
              final fcmPayload = FCMPayload.fromJson(json);
              selectNotificationSubject.add(fcmPayload);
              return;
            } catch (_) {}

            // fallback: colon-split txid
            final txid = switch (response.payload!.split(':')) {
              [_, var txid] => txid.trim(),
              _ => '',
            };
            if (txid.isNotEmpty) {
              selectNotificationSubject.add(
                FCMPayload(type: FCMPayloadType.unknown, txid: txid),
              );
            }
            return;
          }

          if (response.payload == null) {
            logger.w(
              '[LocalNotificationService][init]: Empty notification payload',
            );
            return;
          }

          try {
            _selectedNotificationPayload = response.payload!;
            final json = jsonDecode(response.payload!) as Map<String, dynamic>;
            final fcmPayload = FCMPayload.fromJson(json);
            selectNotificationSubject.add(fcmPayload);
          } catch (e) {
            logger.e(
              '[LocalNotificationService][init]: Cannot parse payload: $e',
            );
          }
        },
      );
      // On macOS the `_isIOS` gate above skips the permission log, so this is
      // the only permission-adjacent signal. It reflects the authorization
      // status the OS returned at initialisation, not the per-app delivery
      // settings a user can change later in System Settings — a `true` here
      // does not promise a banner. AC6's manual pass records those settings.
      logger.i(
        '[LocalNotificationService][init]: plugin initialize result: '
        '$initialized',
      );
    } catch (e) {
      logger.e(
        '[LocalNotificationService][init]: Flutter local notification plugin isn\'t initialized: $e',
      );
      rethrow;
    }
  }

  Future<void> showNotification(
    String title,
    String body, {
    String payload = '',
    NotificationVisibility visibility = NotificationVisibility.public,
    NotificationDetails? notificationDetails,
    NotificationChannelType type = NotificationChannelType.main,
    StyleInformation styleInformation = const DefaultStyleInformation(
      true,
      true,
    ),
  }) async {
    String effectiveBody = body;
    String? desktopSubtitle;

    if (Platform.isWindows && body.contains('\n')) {
      final parts = body.split('\n');
      effectiveBody = parts.first;
      desktopSubtitle = parts.skip(1).join('\n');
    }

    notificationDetails ??= getNotificationDetails(
      visibility: visibility,
      type: type,
      styleInformation: styleInformation,
      desktopSubtitle: desktopSubtitle,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: _notificationId,
      title: title,
      body: effectiveBody,
      notificationDetails: notificationDetails,
      payload: payload,
    );

    _notificationId = _notificationId + 1;
  }
}
