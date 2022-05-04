import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/notification_model.dart';
import 'package:sideswap/models/notifications_service.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:window_manager/window_manager.dart';

final localNotificationsProvider =
    Provider<LocalNotificationService>((ref) => LocalNotificationService(ref));

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
    iOS: const IOSNotificationDetails(),
  );

  return platformChannelSpecifics;
}

class LocalNotificationService {
  final Ref ref;

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  int _notificationId = 0;

  String _selectedNotificationPayload = '';
  String get selectedNotificationPayload => _selectedNotificationPayload;

  final didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final selectNotificationSubject = BehaviorSubject<FCMPayload>();

  LocalNotificationService(this.ref);

  Future<void> init() async {
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
        if (FlavorConfig.isDesktop) {
          logger.d('Desktop notification received');
          WindowManager.instance.show();
          return;
        }

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
  }

  Future<void> showNotification(
    String title,
    String body, {
    String payload = '',
    NotificationVisibility visibility = NotificationVisibility.public,
    NotificationDetails? notificationDetails,
    NotificationChannelType type = NotificationChannelType.main,
  }) async {
    // Do not reset _notificationId because activeNotifications is null on Linux
    // and there is only one notification shown as the result.

    // final activeNotifications = await _flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.getActiveNotifications();

    // if (activeNotifications != null && activeNotifications.isEmpty) {
    //   _notificationId = 0;
    // }

    notificationDetails ??= getNotificationDetails(
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

    final initializationSettingsLinux = LinuxInitializationSettings(
        defaultActionName: '',
        defaultIcon: AssetsLinuxIcon('assets/icon/icon_linux.png'));

    const initializationSettingsMacos = MacOSInitializationSettings();

    final iconPath = File(Platform.resolvedExecutable).parent.path +
        'data\\flutter_assets\\assets\\icon\\icon.ico';
    final initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'SideSwap',
      appUserModelId: 'io.sideswap',
      iconPath: iconPath,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      linux: initializationSettingsLinux,
      macOS: initializationSettingsMacos,
      windows: initializationSettingsWindows,
    );

    return initializationSettings;
  }
}