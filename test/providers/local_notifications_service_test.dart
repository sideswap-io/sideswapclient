import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_notifications_platform_interface/sideswap_notifications_platform_interface.dart';
import 'package:window_manager/window_manager.dart';

import '../helpers/test_utils.dart';

final _logOutput = CapturingLogOutput();

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockIOSFlutterLocalNotificationsPlugin extends Mock
    implements IOSFlutterLocalNotificationsPlugin {}

class MockWindowManager extends Mock implements WindowManager {}

void main() {
  // `CustomLogger` is a process singleton that keeps the output of whichever
  // construction came first, so this has to win the race against the lazy
  // top-level `logger`. A file-level setUpAll runs before any group's, and
  // assigning never reads the top-level, so its initializer never runs.
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _logOutput);
  });

  group('getNotificationDetails', () {
    group('returns NotificationDetails with', () {
      test(
        'default NotificationVisibility.public and main channel when no args',
        () {
          final details = getNotificationDetails();

          expect(details, isA<NotificationDetails>());
          expect(details.android!.channelId, 'sideswap_channel_id');
          expect(details.android!.channelName, 'Main');
          expect(details.android!.importance, Importance.max);
          expect(details.android!.priority, Priority.high);
          expect(details.android!.visibility, NotificationVisibility.public);
          expect(details.iOS, isA<DarwinNotificationDetails>());
        },
      );

      test('main channel details for NotificationChannelType.main', () {
        final details = getNotificationDetails(
          type: NotificationChannelType.main,
        );

        expect(details.android!.channelId, 'sideswap_channel_id');
        expect(details.android!.channelName, 'Main');
      });

      test('sign channel details for NotificationChannelType.sign', () {
        final details = getNotificationDetails(
          type: NotificationChannelType.sign,
        );

        expect(details.android!.channelId, 'sideswap_channel_id_sign');
        expect(details.android!.channelName, 'Sign');
      });

      test('custom StyleInformation when provided', () {
        final customStyle = BigTextStyleInformation('Big text');
        final details = getNotificationDetails(styleInformation: customStyle);

        expect(details.android!.styleInformation, customStyle);
      });

      test('all Android notification properties configured correctly', () {
        final details = getNotificationDetails();
        final android = details.android!;

        expect(android.importance, Importance.max);
        expect(android.priority, Priority.high);
        expect(android.groupKey, 'com.android.sideswap.GENERAL_NOTIFICATION');
        expect(android.enableLights, true);
        expect(android.color, const Color.fromARGB(255, 87, 193, 251));
        expect(android.ledColor, const Color.fromARGB(255, 0, 197, 255));
        expect(android.ledOnMs, 1000);
        expect(android.ledOffMs, 500);
      });
    });

    group('respects all argument combinations', () {
      final cases = [
        (
          visibility: NotificationVisibility.public,
          type: NotificationChannelType.main,
          expectedChannelId: 'sideswap_channel_id',
        ),
        (
          visibility: NotificationVisibility.private,
          type: NotificationChannelType.main,
          expectedChannelId: 'sideswap_channel_id',
        ),
        (
          visibility: NotificationVisibility.secret,
          type: NotificationChannelType.sign,
          expectedChannelId: 'sideswap_channel_id_sign',
        ),
        (
          visibility: NotificationVisibility.public,
          type: NotificationChannelType.sign,
          expectedChannelId: 'sideswap_channel_id_sign',
        ),
      ];

      for (final c in cases) {
        test(
          '${c.visibility} + ${c.type} → channel ${c.expectedChannelId}',
          () {
            final details = getNotificationDetails(
              visibility: c.visibility,
              type: c.type,
            );

            expect(details.android!.visibility, c.visibility);
            expect(details.android!.channelId, c.expectedChannelId);
          },
        );
      }
    });

    test(
      'iOS details are always DarwinNotificationDetails regardless of arguments',
      () {
        final details1 = getNotificationDetails(
          type: NotificationChannelType.main,
        );
        final details2 = getNotificationDetails(
          visibility: NotificationVisibility.secret,
          type: NotificationChannelType.sign,
        );

        expect(details1.iOS, isA<DarwinNotificationDetails>());
        expect(details2.iOS, isA<DarwinNotificationDetails>());
      },
    );

    test('each call produces independent NotificationDetails instance', () {
      final details1 = getNotificationDetails();
      final details2 = getNotificationDetails();

      expect(identical(details1, details2), false);
      expect(identical(details1.android, details2.android), false);
    });
  });

  group('NotificationChannelType enum', () {
    test('has main and sign values', () {
      expect(
        NotificationChannelType.values,
        contains(NotificationChannelType.main),
      );
      expect(
        NotificationChannelType.values,
        contains(NotificationChannelType.sign),
      );
    });
  });

  group('localNotificationsProvider', () {
    test('creates LocalNotificationService with ref from container', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final service = container.read(localNotificationsProvider);

      expect(service, isA<LocalNotificationService>());
      expect(service.ref, isNotNull);
    });
  });

  group('LocalNotificationService', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late MockWindowManager mockWindowManager;
    late Ref realRef;
    late ProviderContainer container;
    late LocalNotificationService service;
    late Future<void> Function(NotificationResponse) capturedCallback;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      registerFallbackValue(const InitializationSettings());
      registerFallbackValue(const NotificationDetails());
      registerFallbackValue(mainChannel);
      registerFallbackValue(
        NotificationResponse(
          id: 0,
          notificationResponseType:
              NotificationResponseType.selectedNotification,
        ),
      );
    });

    setUp(() {
      // The logger is a global; clear what it captured before each test rather
      // than after, so an earlier failed expectation cannot leave it dirty.
      _logOutput.lines.clear();
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      mockWindowManager = MockWindowManager();
      when(
        () => mockWindowManager.waitUntilReadyToShow(any(), any()),
      ).thenAnswer((inv) async {
        final callback = inv.positionalArguments[1] as VoidCallback?;
        callback?.call();
      });
      when(() => mockWindowManager.show()).thenAnswer((_) async {});
      when(() => mockWindowManager.restore()).thenAnswer((_) async {});
      when(() => mockWindowManager.focus()).thenAnswer((_) async {});
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      final dummyProvider = Provider<Ref>((ref) => ref);
      realRef = container.read(dummyProvider);

      when(
        () => mockPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >(),
      ).thenReturn(null);
      when(
        () => mockPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >(),
      ).thenReturn(null);

      when(
        () => mockPlugin.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse: any(
            named: 'onDidReceiveNotificationResponse',
          ),
        ),
      ).thenAnswer((invocation) async {
        capturedCallback =
            invocation.namedArguments[#onDidReceiveNotificationResponse]
                as Future<void> Function(NotificationResponse);
        return true;
      });

      when(
        () => mockPlugin.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      service = LocalNotificationService(
        realRef,
        flutterLocalNotificationsPlugin: mockPlugin,
        initSettingsFactory: () => const InitializationSettings(),
        windowManager: mockWindowManager,
      );
    });

    test('has empty selectedNotificationPayload on construction', () {
      expect(service.selectedNotificationPayload, '');
    });

    test('has didReceiveLocalNotificationSubject initialized', () {
      expect(
        service.didReceiveLocalNotificationSubject,
        isA<BehaviorSubject<ReceivedNotification>>(),
      );
    });

    test('has selectNotificationSubject initialized', () {
      expect(
        service.selectNotificationSubject,
        isA<BehaviorSubject<FCMPayload>>(),
      );
    });

    group('init', () {
      test('calls initialize on plugin', () async {
        await service.init();

        verify(
          () => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(
              named: 'onDidReceiveNotificationResponse',
            ),
          ),
        ).called(1);
      });

      test('logs the plugin initialize result', () async {
        await service.init();

        expect(
          _logOutput.lines.join('\n'),
          allOf(contains('initialize result'), contains('true')),
        );
      });

      test('logs a refused plugin initialize result', () async {
        when(
          () => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(
              named: 'onDidReceiveNotificationResponse',
            ),
          ),
        ).thenAnswer((_) async => false);

        await service.init();

        expect(
          _logOutput.lines.join('\n'),
          allOf(contains('initialize result'), contains('false')),
        );
      });

      test('calls resolvePlatformSpecificImplementation for Android', () async {
        await service.init();

        verify(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).called(1);
      });

      test('uses injected initSettingsFactory', () async {
        const customSettings = InitializationSettings();
        final capturedSettings = <InitializationSettings>[];

        when(
          () => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(
              named: 'onDidReceiveNotificationResponse',
            ),
          ),
        ).thenAnswer((inv) async {
          capturedSettings.add(
            inv.namedArguments[#settings] as InitializationSettings,
          );
          capturedCallback =
              inv.namedArguments[#onDidReceiveNotificationResponse]
                  as Future<void> Function(NotificationResponse);
          return true;
        });

        final svc = LocalNotificationService(
          realRef,
          flutterLocalNotificationsPlugin: mockPlugin,
          initSettingsFactory: () => customSettings,
          windowManager: mockWindowManager,
        );

        await svc.init();

        expect(capturedSettings.length, 1);
        expect(identical(capturedSettings.first, customSettings), isTrue);
      });

      test('rethrows when initialize throws', () {
        when(
          () => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(
              named: 'onDidReceiveNotificationResponse',
            ),
          ),
        ).thenThrow(Exception('init failed'));

        expect(() => service.init(), throwsA(isA<Exception>()));
      });

      test('requests iOS permissions when isIOS is true', () async {
        final mockIOS = MockIOSFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockIOS);
        when(
          () => mockIOS.requestPermissions(
            sound: any(named: 'sound'),
            alert: any(named: 'alert'),
            badge: any(named: 'badge'),
          ),
        ).thenAnswer((_) async => true);

        final svc = LocalNotificationService(
          realRef,
          flutterLocalNotificationsPlugin: mockPlugin,
          initSettingsFactory: () => const InitializationSettings(),
          windowManager: mockWindowManager,
          isIOS: true,
        );

        await svc.init();

        verify(
          () =>
              mockIOS.requestPermissions(sound: true, alert: true, badge: true),
        ).called(1);
      });

      test('logs an absent iOS notification permission result', () async {
        // resolvePlatformSpecificImplementation returns null off iOS/macOS;
        // the `?.` short-circuits and there is no result to report.
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(null);

        final svc = LocalNotificationService(
          realRef,
          flutterLocalNotificationsPlugin: mockPlugin,
          initSettingsFactory: () => const InitializationSettings(),
          windowManager: mockWindowManager,
          isIOS: true,
        );

        await svc.init();

        expect(
          _logOutput.lines.join('\n'),
          contains('notification permission result: null'),
        );
      });

      test('logs a denied iOS notification permission result', () async {
        final mockIOS = MockIOSFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockIOS);
        when(
          () => mockIOS.requestPermissions(
            sound: any(named: 'sound'),
            alert: any(named: 'alert'),
            badge: any(named: 'badge'),
          ),
        ).thenAnswer((_) async => false);

        final svc = LocalNotificationService(
          realRef,
          flutterLocalNotificationsPlugin: mockPlugin,
          initSettingsFactory: () => const InitializationSettings(),
          windowManager: mockWindowManager,
          isIOS: true,
        );

        await svc.init();

        expect(
          _logOutput.lines.join('\n'),
          allOf(contains('notification permission result'), contains('false')),
        );
      });

      test('calls Android channel operations when platform resolves', () async {
        final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();

        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockAndroid);

        when(
          () => mockAndroid.deleteNotificationChannel(
            channelId: any(named: 'channelId'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockAndroid.createNotificationChannel(any()),
        ).thenAnswer((_) async {});

        await service.init();

        verify(
          () => mockAndroid.deleteNotificationChannel(
            channelId: 'sideswap_channel_id',
          ),
        ).called(1);
        verify(
          () => mockAndroid.createNotificationChannel(mainChannel),
        ).called(1);
        verify(
          () => mockAndroid.createNotificationChannel(signChannel),
        ).called(1);
      });
    });

    test(
      'default initSettingsFactory produces real InitializationSettings',
      () async {
        FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues(
            enableNetworkSettings: false,
            enableJade: false,
            enableLocalEndpoint: false,
          ),
        );

        final capturedSettings = <InitializationSettings>[];
        when(
          () => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(
              named: 'onDidReceiveNotificationResponse',
            ),
          ),
        ).thenAnswer((inv) async {
          capturedSettings.add(
            inv.namedArguments[#settings] as InitializationSettings,
          );
          capturedCallback =
              inv.namedArguments[#onDidReceiveNotificationResponse]
                  as Future<void> Function(NotificationResponse);
          return true;
        });

        final svc = LocalNotificationService(
          realRef,
          flutterLocalNotificationsPlugin: mockPlugin,
          windowManager: mockWindowManager,
          // no initSettingsFactory → uses _defaultInitSettingsFactory
        );

        await svc.init();

        expect(capturedSettings, hasLength(1));
        expect(capturedSettings.first.android, isNotNull);
      },
    );

    group('init callback — non-desktop', () {
      setUp(() {
        FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues(
            enableNetworkSettings: false,
            enableJade: false,
            enableLocalEndpoint: false,
            isDesktop: false,
          ),
        );
      });

      test('null payload does not emit on selectNotificationSubject', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: null,
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(emitted, isEmpty);
      });

      test(
        'valid JSON payload sets selectedNotificationPayload and emits FCMPayload',
        () async {
          await service.init();

          final emitted = <FCMPayload>[];
          final sub = service.selectNotificationSubject.listen(emitted.add);
          addTearDown(sub.cancel);

          const payload = '{"type":"Unknown","txid":"abc123"}';
          await capturedCallback(
            NotificationResponse(
              id: 0,
              payload: payload,
              notificationResponseType:
                  NotificationResponseType.selectedNotification,
            ),
          );

          await Future<void>.delayed(Duration.zero);
          expect(service.selectedNotificationPayload, payload);
          expect(emitted.length, 1);
          expect(emitted.first.txid, 'abc123');
        },
      );

      test('invalid JSON payload does not crash and does not emit', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: 'not json',
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(emitted, isEmpty);
      });
    });

    group('init callback — desktop', () {
      setUp(() {
        FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues(
            enableNetworkSettings: false,
            enableJade: false,
            enableLocalEndpoint: false,
            isDesktop: true,
          ),
        );
      });

      // ADR-0004 decision 6: the banner-click path keeps its own sequence and
      // never establishes ownership of the window — an explicit user click is
      // not an unsolicited event, so it must not earn the app the right to put
      // the window back later. Pinned in order, so a later unification of the
      // two raise paths cannot pass silently.
      test('calls windowManager show/restore/focus on notification', () async {
        await service.init();

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: null,
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        verifyInOrder([
          () => mockWindowManager.waitUntilReadyToShow(any(), any()),
          () => mockWindowManager.show(),
          () => mockWindowManager.restore(),
          () => mockWindowManager.focus(),
        ]);
        // No episode is opened, so nothing here will ever put the window back.
        verifyNever(() => mockWindowManager.minimize());
      });

      test('null payload returns early without emitting', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: null,
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(emitted, isEmpty);
      });

      test('payload with colon extracts txid', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: 'type:txid123',
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        final txids = emitted.map((p) => p.txid).toList();
        expect(txids, contains('txid123'));
      });

      test('payload without colon does not emit txid event', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: 'nocolon',
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(emitted.where((p) => p.txid == 'nocolon'), isEmpty);
      });

      test('valid JSON payload emits FCMPayload', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: '{"type":"Unknown","txid":"tx999"}',
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(emitted.any((p) => p.txid == 'tx999'), isTrue);
      });

      test('malformed payload triggers error logging without crash', () async {
        await service.init();

        final emitted = <FCMPayload>[];
        final sub = service.selectNotificationSubject.listen(emitted.add);
        addTearDown(sub.cancel);

        // payload with colon triggers txid branch, then jsonDecode fails
        await capturedCallback(
          NotificationResponse(
            id: 0,
            payload: 'type:txid123:extra',
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(emitted, isEmpty);
        // no crash — both catch blocks handle gracefully
      });

      test(
        'payload with single segment has empty txid and invalid json',
        () async {
          await service.init();

          final emitted = <FCMPayload>[];
          final sub = service.selectNotificationSubject.listen(emitted.add);
          addTearDown(sub.cancel);

          // no colon → txid empty, jsonDecode fails → both catches triggered
          await capturedCallback(
            NotificationResponse(
              id: 0,
              payload: 'not-json-not-colon',
              notificationResponseType:
                  NotificationResponseType.selectedNotification,
            ),
          );

          await Future<void>.delayed(Duration.zero);
          expect(emitted, isEmpty);
          // both try blocks fail gracefully, no crash
        },
      );
    });

    group('showNotification', () {
      test('calls plugin.show with correct args', () async {
        await service.showNotification('title', 'body', payload: 'p');

        verify(
          () => mockPlugin.show(
            id: 0,
            title: 'title',
            body: 'body',
            notificationDetails: any(named: 'notificationDetails'),
            payload: 'p',
          ),
        ).called(1);
      });

      test('increments notification ID on second call', () async {
        await service.showNotification('t1', 'b1');
        await service.showNotification('t2', 'b2');

        verify(
          () => mockPlugin.show(
            id: 0,
            title: 't1',
            body: 'b1',
            notificationDetails: any(named: 'notificationDetails'),
            payload: any(named: 'payload'),
          ),
        ).called(1);

        verify(
          () => mockPlugin.show(
            id: 1,
            title: 't2',
            body: 'b2',
            notificationDetails: any(named: 'notificationDetails'),
            payload: any(named: 'payload'),
          ),
        ).called(1);
      });

      test('uses default notificationDetails when none provided', () async {
        await service.showNotification('t', 'b');

        verify(
          () => mockPlugin.show(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationDetails: any(named: 'notificationDetails'),
            payload: any(named: 'payload'),
          ),
        ).called(1);
      });

      test('uses custom notificationDetails when provided', () async {
        final customDetails = getNotificationDetails(
          type: NotificationChannelType.sign,
        );
        final captured = <NotificationDetails>[];

        when(
          () => mockPlugin.show(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationDetails: any(named: 'notificationDetails'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((inv) async {
          captured.add(
            inv.namedArguments[#notificationDetails] as NotificationDetails,
          );
        });

        await service.showNotification(
          't',
          'b',
          notificationDetails: customDetails,
        );

        expect(captured.length, 1);
        expect(identical(captured.first, customDetails), isTrue);
      });

      group('body handling', () {
        ({List<String> bodies, List<NotificationDetails> details})
        stubShowCapture() {
          final bodies = <String>[];
          final details = <NotificationDetails>[];
          when(
            () => mockPlugin.show(
              id: any(named: 'id'),
              title: any(named: 'title'),
              body: any(named: 'body'),
              notificationDetails: any(named: 'notificationDetails'),
              payload: any(named: 'payload'),
            ),
          ).thenAnswer((inv) async {
            bodies.add(inv.namedArguments[#body] as String);
            details.add(
              inv.namedArguments[#notificationDetails] as NotificationDetails,
            );
          });
          return (bodies: bodies, details: details);
        }

        group('non-Windows', () {
          final cases = [
            (desc: 'single-line body is passed unchanged', input: 'Simple body'),
            (
              desc: 'multiline body is passed unchanged on non-Windows',
              input: 'Line 1\nLine 2\nLine 3',
            ),
          ];

          for (final c in cases) {
            test(c.desc, () async {
              final captured = stubShowCapture();

              await service.showNotification('title', c.input);

              expect(captured.bodies, [c.input]);
            }, testOn: '!windows');
          }
        });

        group('Windows', () {
          test(
            'splits multiline body — first line becomes body, rest becomes subtitle',
            () async {
              final captured = stubShowCapture();

              await service.showNotification(
                'title',
                'Line 1\nLine 2\nLine 3',
              );

              expect(captured.bodies, ['Line 1']);
              expect(
                captured.details.single.windows?.subtitle,
                'Line 2\nLine 3',
              );
            },
            testOn: 'windows',
          );
        });
      });
    });
  });
}
