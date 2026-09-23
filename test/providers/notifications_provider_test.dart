import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/desktop_window_service.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';
import '../utils.dart';

final _logOutput = CapturingLogOutput();

// Mocks
class MockLocalNotificationService extends Mock
    implements LocalNotificationService {
  @override
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
    String? desktopSubtitle,
  }) async {
    // Default behavior: return completed future
  }
}

// Stands in for a Notification Center that refuses the submission.
class _ThrowingLocalNotificationService extends MockLocalNotificationService {
  @override
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
    String? desktopSubtitle,
  }) => Future<void>.error(
    Exception('notification center refused the submission'),
  );
}

/// Records the OS notifications the notifier submitted.
///
/// [MockLocalNotificationService] gives `showNotification` a concrete body, so
/// mocktail does not track it and `verifyNever` cannot be asked about it.
class _RecordingLocalNotificationService extends MockLocalNotificationService {
  final submitted = <String>[];

  @override
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
    String? desktopSubtitle,
  }) async {
    submitted.add(title);
  }
}

class MockDesktopDialog extends Mock implements DesktopDialog {}

class MockDesktopWindowService extends Mock implements DesktopWindowService {}

// Helper to create a mock SignerRequest with connect
From_SignerRequest _createConnectRequest({
  required String reqId,
  required String origin,
  int? ttlMilliseconds,
}) {
  final mock = MockSignerRequest();
  when(() => mock.reqId).thenReturn(reqId);
  when(() => mock.origin).thenReturn(origin);
  when(() => mock.hasConnect()).thenReturn(true);
  when(() => mock.hasSign()).thenReturn(false);
  when(() => mock.hasTtlMilliseconds()).thenReturn(ttlMilliseconds != null);
  if (ttlMilliseconds != null) {
    when(() => mock.ttlMilliseconds).thenReturn(Int64(ttlMilliseconds));
  }
  return mock;
}

// Helper to create a mock SignerRequest with sign
From_SignerRequest _createSignRequest({
  required String reqId,
  required String origin,
  int? ttlMilliseconds,
}) {
  final mock = MockSignerRequest();
  when(() => mock.reqId).thenReturn(reqId);
  when(() => mock.origin).thenReturn(origin);
  when(() => mock.hasConnect()).thenReturn(false);
  when(() => mock.hasSign()).thenReturn(true);
  when(() => mock.sign).thenReturn(From_SignerRequest_Sign());
  when(() => mock.hasTtlMilliseconds()).thenReturn(ttlMilliseconds != null);
  if (ttlMilliseconds != null) {
    when(() => mock.ttlMilliseconds).thenReturn(Int64(ttlMilliseconds));
  }
  return mock;
}

// Helper to create a mock SignerRequest with both connect and sign
From_SignerRequest _createBothRequest({
  required String reqId,
  required String origin,
  int? ttlMilliseconds,
}) {
  final mock = MockSignerRequest();
  when(() => mock.reqId).thenReturn(reqId);
  when(() => mock.origin).thenReturn(origin);
  when(() => mock.hasConnect()).thenReturn(true);
  when(() => mock.hasSign()).thenReturn(true);
  when(() => mock.sign).thenReturn(From_SignerRequest_Sign());
  when(() => mock.hasTtlMilliseconds()).thenReturn(ttlMilliseconds != null);
  if (ttlMilliseconds != null) {
    when(() => mock.ttlMilliseconds).thenReturn(Int64(ttlMilliseconds));
  }
  return mock;
}

class MockSignerRequest extends Mock implements From_SignerRequest {}

/// Seeds the real notifier with a known list and lets a test replace it.
///
/// Overriding [build] rather than driving `addNotification` keeps the entries'
/// ids and request ids under the test's control, which is what makes the
/// identity case — an id handed to the lookup alongside a request id it does
/// not belong to — expressible at all: `addNotification` mints one id per
/// delivery from a counter that only ever goes up (#211), so it never files two
/// *different* requests under one id, and the pairing has to be seeded. Same
/// shape as the desktop widget suite's seed
/// (`test/widgets/d_notifications_test.dart`).
class _SeededNotifications extends Notifications {
  _SeededNotifications(this._seed);

  final List<NotificationData> _seed;

  @override
  List<NotificationData> build() => _seed;

  void setEntries(List<NotificationData> entries) => state = entries;
}

/// Records the reason every removal was made under, over the real notifier.
///
/// Only [Notifications.removeNotification] is overridden — `build` is the real
/// one — so the entries these tests sweep arrive through `addNotification` the
/// way the app delivers them, and the reason is read back as the externally
/// observable fact rather than reconstructed from the list.
class _RecordingNotifications extends Notifications {
  final removals = <(int, NotificationRemovalReason)>[];

  @override
  void removeNotification(
    int notificationId, {
    required NotificationRemovalReason reason,
  }) {
    removals.add((notificationId, reason));
    super.removeNotification(notificationId, reason: reason);
  }
}

/// Counts the sweeps that actually ran.
///
/// "Swept once, without a second fire" cannot be read off the removals: a fire
/// that removes nothing is indistinguishable from one that never happened. An
/// arming placed a whole second before the deadline produces thousands of them.
class _CountingNotifications extends _RecordingNotifications {
  int fires = 0;

  @override
  void sweepExpired() {
    fires++;
    super.sweepExpired();
  }
}

/// A recording notifier that starts from a list the test chose.
///
/// The only way to put an entry whose deadline is already behind it into the
/// list: `addNotification` drops a request that arrives past its deadline, so
/// such an entry can only have been there already.
class _SeededRecordingNotifications extends _RecordingNotifications {
  _SeededRecordingNotifications(this._seed);

  final List<NotificationData> _seed;

  @override
  List<NotificationData> build() => _seed;
}

/// Waits until [condition] holds, giving up after [timeout].
///
/// Polled rather than slept on a delay sized to the deadline: the suite runs at
/// `--concurrency=16` under a random seed, where a fixed sleep that has to land
/// just after a real timer is a race. The ceiling keeps a genuine regression a
/// failure rather than a hang.
Future<void> _waitUntil(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final giveUpAt = DateTime.now().add(timeout);
  while (!condition() && DateTime.now().isBefore(giveUpAt)) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

/// A window service with every command stubbed to succeed, recording the badge
/// counts it is given into [badgeWrites] when one is passed.
///
/// Built per test rather than once for the file: a mock reused across tests
/// keeps its recorded invocations, which makes `verify(...).called(n)`
/// order-dependent (docs/TESTING.md).
MockDesktopWindowService _stubbedWindowService({List<int>? badgeWrites}) {
  final service = MockDesktopWindowService();
  when(() => service.onRequestDelivered(any())).thenAnswer((_) async {});
  when(() => service.onRequestResolved(any(), any())).thenAnswer((_) async {});
  when(() => service.abandonEpisode()).thenAnswer((_) async {});

  // Stubbed whether or not anyone is recording: an unstubbed `Future<void>`
  // answers `null`, which the notifier hands to `unawaited` and which fails as
  // a type error rather than as the assertion the test was making.
  when(() => service.setPendingBadge(any())).thenAnswer((invocation) async {
    badgeWrites?.add(invocation.positionalArguments.first as int);
  });

  return service;
}

/// A container with the notifier's three collaborators overridden, disposed
/// with the test that built it.
///
/// [notifier] replaces the notifier itself, which is how a test both seeds the
/// list and reads back the reason each removal was made under.
ProviderContainer _notificationsContainer({
  required MockDesktopWindowService windowService,
  LocalNotificationService? localNotifications,
  Notifications Function()? notifier,
}) {
  final container = ProviderContainer.test(
    overrides: [
      localNotificationsProvider.overrideWithValue(
        localNotifications ?? MockLocalNotificationService(),
      ),
      desktopDialogProvider.overrideWithValue(MockDesktopDialog()),
      desktopWindowServiceProvider.overrideWithValue(windowService),
      if (notifier != null) notificationsProvider.overrideWith(notifier),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Raises the desktop flavour, which is what makes the app-icon badge and the
/// window commands reachable at all.
void _useDesktopFlavour() {
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableNetworkSettings: false,
      enableJade: true,
      enableLocalEndpoint: false,
      isDesktop: true,
    ),
  );
}

void main() {
  // Set up fallback values for protobuf types
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(From_SignerRequest());
    registerFallbackValue(NotificationRemovalReason.expired);
    registerFallbackValue(From_SignerRequest_Sign());
    registerFallbackValue(Option<NotificationData>.none());
    // Suppress logging to prevent async errors from path_provider
    logger = CustomLogger('SideSwap', output: _logOutput);
  });

  // The logger is a global; clear what it captured before each test rather
  // than after, so an earlier failed expectation cannot leave it dirty.
  setUp(_logOutput.lines.clear);

  // FlavorConfig is a global too, and the notifier now reads it while it is
  // being built. Restored to the non-desktop default before each test rather
  // than after the group that raises it: end-of-test cleanup is skipped when an
  // earlier expectation throws, and under a randomised seed the next test would
  // then run on a flavour it never asked for (docs/TESTING.md).
  setUp(() {
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

  group('NotificationItemState', () {
    test('creates empty state', () {
      const state = NotificationItemState.empty();
      expect(state, isA<NotificationItemStateEmpty>());
    });

    test('creates canceled state', () {
      const state = NotificationItemState.canceled();
      expect(state, isA<NotificationItemStateCanceled>());
    });
  });

  group('NotificationType', () {
    group('connect', () {
      test('creates connect notification with all fields', () {
        final createdAt = DateTime.now();
        const reqId = 'req-123';
        const origin = 'https://example.com';
        const state = NotificationItemState.empty();
        final ttl = Option.of(5000);

        final type = NotificationType.connect(
          reqId,
          origin,
          state,
          createdAt,
          ttl,
        );

        expect(type, isA<NotificationTypeConnect>());
        expect((type as NotificationTypeConnect).reqId, reqId);
        expect(type.origin, origin);
        expect(type.notificationItemState, state);
        expect(type.createdAt, createdAt);
        expect(type.ttlMilliseconds, ttl);
      });

      test('creates connect notification without TTL', () {
        final createdAt = DateTime.now();
        const ttl = None();

        final type = NotificationType.connect(
          'req-123',
          'origin',
          NotificationItemState.empty(),
          createdAt,
          ttl,
        );

        expect((type as NotificationTypeConnect).ttlMilliseconds, ttl);
      });
    });

    group('signRequest', () {
      test('creates signRequest notification with all fields', () {
        final createdAt = DateTime.now();
        final sign = From_SignerRequest_Sign();
        const reqId = 'req-456';
        const origin = 'https://example.com';
        const state = NotificationItemState.empty();
        final ttl = Option.of(3000);

        final type = NotificationType.signRequest(
          sign,
          reqId,
          origin,
          state,
          createdAt,
          ttl,
        );

        expect(type, isA<NotificationTypeSignRequest>());
        expect((type as NotificationTypeSignRequest).sign, sign);
        expect(type.reqId, reqId);
        expect(type.origin, origin);
        expect(type.notificationItemState, state);
        expect(type.createdAt, createdAt);
        expect(type.ttlMilliseconds, ttl);
      });
    });
  });

  group('NotificationData', () {
    test('creates notification data with id and type', () {
      const id = 42;
      final type = NotificationType.connect(
        'req-123',
        'origin',
        NotificationItemState.empty(),
        DateTime.now(),
        none(),
      );

      final notificationData = NotificationData(id, type);

      expect(notificationData.id, id);
      expect(notificationData.type, type);
    });
  });

  group('pendingBadgeCount', () {
    // The badge's unit, pinned by ADR-0005 decision 3: notification entries not
    // in the cancelled state. Exercised end-to-end through the notifier by the
    // badge tests further down; pinned here against literal lists too, because
    // a public top-level function tested directly is what docs/TESTING.md
    // prescribes in place of widening a private member's visibility.
    NotificationData connectEntry(int id, NotificationItemState itemState) =>
        NotificationData(
          id,
          NotificationType.connect(
            'req-$id',
            'https://example.com',
            itemState,
            DateTime.now(),
            none(),
          ),
        );

    NotificationData signEntry(int id, NotificationItemState itemState) =>
        NotificationData(
          id,
          NotificationType.signRequest(
            From_SignerRequest_Sign(),
            'req-$id',
            'https://example.com',
            itemState,
            DateTime.now(),
            none(),
          ),
        );

    test('nothing is waiting when the list is empty', () {
      expect(pendingBadgeCount([]), 0);
    });

    test('a connect entry the user has still to decide on is counted', () {
      expect(
        pendingBadgeCount([connectEntry(1, NotificationItemState.empty())]),
        1,
      );
    });

    test('a sign entry the user has still to decide on is counted', () {
      expect(
        pendingBadgeCount([signEntry(1, NotificationItemState.empty())]),
        1,
      );
    });

    test('a cancelled connect entry is not counted', () {
      expect(
        pendingBadgeCount([connectEntry(1, NotificationItemState.canceled())]),
        0,
      );
    });

    test('a cancelled sign entry is not counted', () {
      expect(
        pendingBadgeCount([signEntry(1, NotificationItemState.canceled())]),
        0,
      );
    });

    test('a mixed list counts only what is still awaited', () {
      expect(
        pendingBadgeCount([
          connectEntry(1, NotificationItemState.empty()),
          signEntry(1, NotificationItemState.canceled()),
          signEntry(2, NotificationItemState.empty()),
          connectEntry(3, NotificationItemState.canceled()),
        ]),
        2,
      );
    });
  });

  group('requestDeadlinePassed', () {
    // Asked of a request that is about to be presented, before its dialog is
    // built. The countdown provider cannot answer it: it is autoDispose and
    // starts a timer on build, and its `none()` means both "no deadline" and
    // "no such entry". ADR-0006 decision 5.
    final now = DateTime(2026, 1, 1, 12);

    NotificationData connectEntry({
      required DateTime createdAt,
      required Option<int> ttlMilliseconds,
    }) => NotificationData(
      1,
      NotificationType.connect(
        'req-A',
        'https://example.com',
        NotificationItemState.empty(),
        createdAt,
        ttlMilliseconds,
      ),
    );

    test('answers no for a request that carries no countdown', () {
      // A request without a deadline is not expired locally: there is no
      // deadline to enforce and none is invented. ADR-0006 decision 7.
      expect(
        requestDeadlinePassed(
          connectEntry(createdAt: now, ttlMilliseconds: none()),
          now: now,
        ),
        isFalse,
      );
    });

    test('answers no while the deadline is still ahead', () {
      expect(
        requestDeadlinePassed(
          connectEntry(createdAt: now, ttlMilliseconds: Option.of(30000)),
          now: now,
        ),
        isFalse,
      );
    });

    test('answers yes once the deadline has passed', () {
      expect(
        requestDeadlinePassed(
          connectEntry(
            createdAt: now.subtract(Duration(seconds: 10)),
            ttlMilliseconds: Option.of(1000),
          ),
          now: now,
        ),
        isTrue,
      );
    });

    // The boundary is the deadline itself, to the millisecond. The predicate
    // used to truncate to whole seconds and so answered "passed" from 999 ms
    // before the deadline; a request is no longer treated as expired while any
    // of its window remains. ADR-0010 decision 2.
    test('answers no while a part-second of the window remains', () {
      expect(
        requestDeadlinePassed(
          connectEntry(
            createdAt: now.subtract(Duration(milliseconds: 600)),
            ttlMilliseconds: Option.of(1000),
          ),
          now: now,
        ),
        isFalse,
      );
    });

    test('answers no with a single millisecond of the window left', () {
      expect(
        requestDeadlinePassed(
          connectEntry(
            createdAt: now.subtract(Duration(milliseconds: 999)),
            ttlMilliseconds: Option.of(1000),
          ),
          now: now,
        ),
        isFalse,
      );
    });

    test('answers yes at the deadline itself', () {
      expect(
        requestDeadlinePassed(
          connectEntry(
            createdAt: now.subtract(Duration(milliseconds: 1000)),
            ttlMilliseconds: Option.of(1000),
          ),
          now: now,
        ),
        isTrue,
      );
    });

    test('answers the same way for a sign request', () {
      final entry = NotificationData(
        1,
        NotificationType.signRequest(
          From_SignerRequest_Sign(),
          'req-A',
          'https://example.com',
          NotificationItemState.empty(),
          now.subtract(Duration(seconds: 10)),
          Option.of(1000),
        ),
      );

      expect(requestDeadlinePassed(entry, now: now), isTrue);
    });
  });

  group('Notifications (Notifier)', () {
    late ProviderContainer container;
    late MockDesktopWindowService mockDesktopWindowService;

    void setupContainer([MockLocalNotificationService? mockNotifications]) {
      container = _notificationsContainer(
        windowService: mockDesktopWindowService,
        localNotifications: mockNotifications,
      );
    }

    setUp(() {
      mockDesktopWindowService = _stubbedWindowService();
      setupContainer();
    });

    group('build', () {
      test('returns empty list initially', () {
        final notifications = container.read(notificationsProvider);
        expect(notifications, isEmpty);
      });
    });

    group('addNotification with connect request', () {
      test(
        'adds connect notification to state when signRequest has connect',
        () {
          final mockLocalNotifications = MockLocalNotificationService();
          setupContainer(mockLocalNotifications);

          final signRequest = _createConnectRequest(
            reqId: 'req-123',
            origin: 'https://example.com',
          );

          final notifier = container.read(notificationsProvider.notifier);
          notifier.addNotification(signRequest);

          final notifications = container.read(notificationsProvider);

          expect(notifications, hasLength(1));
          expect(notifications.first.id, 1);
          expect(notifications.first.type, isA<NotificationTypeConnect>());
          final connectType =
              notifications.first.type as NotificationTypeConnect;
          expect(connectType.reqId, 'req-123');
          expect(connectType.origin, 'https://example.com');
          expect(
            connectType.notificationItemState,
            isA<NotificationItemStateEmpty>(),
          );
        },
      );

      test('multiple addNotifications increment id sequentially', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createConnectRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);

        final notifications = container.read(notificationsProvider);

        expect(notifications, hasLength(2));
        expect(notifications[0].id, 2); // Most recent first
        expect(notifications[1].id, 1);
      });

      test('preserves existing notifications when adding new connect', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createConnectRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);

        final notifications = container.read(notificationsProvider);

        // Both should exist, most recent first
        expect(notifications, hasLength(2));
        expect(notifications.map((n) => n.id), [2, 1]);
      });

      test('handles connect with TTL', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createConnectRequest(
          reqId: 'req-123',
          origin: 'origin',
          ttlMilliseconds: 5000,
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        final connectType = notifications.first.type as NotificationTypeConnect;

        expect(connectType.ttlMilliseconds.isSome(), true);
        expect(connectType.ttlMilliseconds.getOrElse(() => -1), 5000);
      });

      test('handles connect without TTL', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createConnectRequest(
          reqId: 'req-123',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        final connectType = notifications.first.type as NotificationTypeConnect;

        expect(connectType.ttlMilliseconds.isNone(), true);
      });
    });

    group('addNotification with sign request', () {
      test('adds sign notification to state when signRequest has sign', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createSignRequest(
          reqId: 'req-456',
          origin: 'https://example.com',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);

        expect(notifications, hasLength(1));
        expect(notifications.first.id, 1);
        expect(notifications.first.type, isA<NotificationTypeSignRequest>());
        final signType =
            notifications.first.type as NotificationTypeSignRequest;
        expect(signType.reqId, 'req-456');
        expect(signType.origin, 'https://example.com');
        expect(signType.sign, isA<From_SignerRequest_Sign>());
        expect(
          signType.notificationItemState,
          isA<NotificationItemStateEmpty>(),
        );
      });

      test('handles sign with TTL', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createSignRequest(
          reqId: 'req-456',
          origin: 'origin',
          ttlMilliseconds: 3000,
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        final signType =
            notifications.first.type as NotificationTypeSignRequest;

        expect(signType.ttlMilliseconds.isSome(), true);
        expect(signType.ttlMilliseconds.getOrElse(() => -1), 3000);
      });

      test('handles sign without TTL', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createSignRequest(
          reqId: 'req-456',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        final signType =
            notifications.first.type as NotificationTypeSignRequest;

        expect(signType.ttlMilliseconds.isNone(), true);
      });
    });

    group('addNotification with both connect and sign', () {
      test('adds both notifications when signRequest has both', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createBothRequest(
          reqId: 'req-both',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);

        // Sign is added last, so it appears first
        expect(notifications, hasLength(2));
        expect(notifications[0].type, isA<NotificationTypeSignRequest>());
        expect(notifications[1].type, isA<NotificationTypeConnect>());
      });
    });

    group('raising the desktop window on request delivery', () {
      test('a request on a non-desktop flavor never raises the window', () {
        final notifier = container.read(notificationsProvider.notifier);

        notifier.addNotification(
          _createBothRequest(reqId: 'req-mobile', origin: 'https://a.com'),
        );

        expect(container.read(notificationsProvider), hasLength(2));
        verifyNever(() => mockDesktopWindowService.onRequestDelivered(any()));
      });

      test('a resolution on a non-desktop flavor never touches the window', () {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createSignRequest(reqId: 'req-mobile-2', origin: 'https://a.com'),
        );

        notifier.removeNotification(
          1,
          reason: NotificationRemovalReason.acceptedByUser,
        );

        verifyNever(
          () => mockDesktopWindowService.onRequestResolved(any(), any()),
        );
      });

      test(
        'a non-desktop flavor never writes a badge at any boundary',
        () async {
          final notifier = container.read(notificationsProvider.notifier);

          notifier.addNotification(
            _createBothRequest(reqId: 'req-mobile-3', origin: 'https://a.com'),
          );
          notifier.cancelNotification('req-mobile-3');
          // Drained before the list is cleared: the removal the cancellation
          // queues reads state, and an invalidated notifier has none.
          await pumpEventQueue();
          notifier.addNotification(
            _createSignRequest(reqId: 'req-mobile-4', origin: 'https://b.com'),
          );
          notifier.removeNotification(
            container.read(notificationsProvider).first.id,
            reason: NotificationRemovalReason.expired,
          );
          notifier.clearAll();
          container.dispose();

          verifyNever(() => mockDesktopWindowService.setPendingBadge(any()));
        },
      );
    });

    group('removeNotification', () {
      test('removes notification by id', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createConnectRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);

        // Remove second notification (id=2)
        notifier.removeNotification(
          2,
          reason: NotificationRemovalReason.acceptedByUser,
        );

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(1));
        expect(notifications.first.id, 1);
      });

      test('does nothing when removing non-existent id', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        // Try to remove non-existent notification
        notifier.removeNotification(
          999,
          reason: NotificationRemovalReason.acceptedByUser,
        );

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(1)); // Still has the original
      });

      test('removes correct notification when multiple have similar ids', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createConnectRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final signRequest3 = _createConnectRequest(
          reqId: 'req-3',
          origin: 'origin3',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);
        notifier.addNotification(signRequest3);

        // Remove middle notification (id=2)
        notifier.removeNotification(
          2,
          reason: NotificationRemovalReason.acceptedByUser,
        );

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(2));
        expect(notifications.map((n) => n.id), [3, 1]);
      });
    });

    group('cancelNotification', () {
      test('cancels connect notification by reqId', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createConnectRequest(
          reqId: 'req-123',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        notifier.cancelNotification('req-123');

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(1));
        final connectType = notifications.first.type as NotificationTypeConnect;
        expect(
          connectType.notificationItemState,
          isA<NotificationItemStateCanceled>(),
        );
      });

      test('cancels sign notification by reqId', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createSignRequest(
          reqId: 'req-456',
          origin: 'origin',
          ttlMilliseconds: 5000,
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final before =
            container.read(notificationsProvider).single.type
                as NotificationTypeSignRequest;

        notifier.cancelNotification('req-456');

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(1));
        final signType =
            notifications.first.type as NotificationTypeSignRequest;
        expect(
          signType.notificationItemState,
          isA<NotificationItemStateCanceled>(),
        );
        // Cancelling replaces only the state; every other field survives.
        expect(signType.sign, same(before.sign));
        expect(signType.reqId, 'req-456');
        expect(signType.origin, 'origin');
        expect(signType.createdAt, before.createdAt);
        expect(signType.ttlMilliseconds, Option.of(5000));
      });

      test('cancels only the named request, leaving others pending', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createSignRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);

        notifier.cancelNotification('req-1');

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(2));

        final byReqId = {
          for (final notification in notifications)
            notification.type.reqId: notification.type.notificationItemState,
        };

        expect(byReqId['req-1'], isA<NotificationItemStateCanceled>());
        expect(byReqId['req-2'], isA<NotificationItemStateEmpty>());
      });

      test('leaves every request pending when the reqId matches nothing', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final connectRequest = _createConnectRequest(
          reqId: 'req-123',
          origin: 'origin',
        );
        final signRequest = _createSignRequest(
          reqId: 'req-456',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(connectRequest);
        notifier.addNotification(signRequest);

        notifier.cancelNotification('req-999');

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(2));
        for (final notification in notifications) {
          expect(
            notification.type.notificationItemState,
            isA<NotificationItemStateEmpty>(),
          );
        }
      });

      test(
        'removes the cancelled request from the list, keeping the rest',
        () async {
          final mockLocalNotifications = MockLocalNotificationService();
          setupContainer(mockLocalNotifications);

          final connectRequest = _createConnectRequest(
            reqId: 'req-1',
            origin: 'origin1',
          );
          final signRequest = _createSignRequest(
            reqId: 'req-2',
            origin: 'origin2',
          );

          final notifier = container.read(notificationsProvider.notifier);
          notifier.addNotification(connectRequest);
          notifier.addNotification(signRequest);

          notifier.cancelNotification('req-1');
          await Future.microtask(() {});

          final notifications = container.read(notificationsProvider);
          expect(notifications, hasLength(1));
          expect(notifications.single.type.reqId, 'req-2');
        },
      );

      test('cancels multiple notifications with same reqId pattern', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-same',
          origin: 'origin1',
        );

        final signRequest2 = _createSignRequest(
          reqId: 'req-same',
          origin: 'origin2',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);

        notifier.cancelNotification('req-same');

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(2));

        for (final notification in notifications) {
          final state = notification.type.map(
            connect: (c) => c.notificationItemState,
            signRequest: (s) => s.notificationItemState,
          );
          expect(state, isA<NotificationItemStateCanceled>());
        }
      });
    });

    group('clearAll', () {
      test('clears all notifications', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createConnectRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);

        notifier.clearAll();

        final notifications = container.read(notificationsProvider);
        expect(notifications, isEmpty);
      });

      test('works when already empty', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final notifier = container.read(notificationsProvider.notifier);
        notifier.clearAll();

        final notifications = container.read(notificationsProvider);
        expect(notifications, isEmpty);
      });

      // The one measured fact about the id counter, and the reason no document
      // in this repo claims otherwise any more (#211). `clearAll()` ends in
      // `ref.invalidateSelf()`, which rebuilds the element but does not replace
      // the notifier riverpod caches against it, so `_id` is the same field
      // afterwards and keeps counting rather than starting over.
      //
      // Driven through `addNotification` on both sides of the call, because
      // that is the only path that mints an id at all: every other test in this
      // suite seeds entries with ids of its own choosing, which is exactly why
      // the suite could carry the opposite claim in its comments for as long as
      // it did. Asserted as `greaterThan` rather than as the successor, so the
      // one thing under test is that the counter did not go backwards.
      //
      // The notifier is read through the container at every step rather than
      // hoisted into a local, so no step presupposes the instance identity that
      // is the thing being measured.
      test('the id counter keeps counting across clearAll', () {
        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createConnectRequest(
                reqId: 'req-before',
                origin: 'https://a.com',
              ),
            );
        final idBefore = container.read(notificationsProvider).single.id;

        container.read(notificationsProvider.notifier).clearAll();
        expect(container.read(notificationsProvider), isEmpty);

        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createConnectRequest(
                reqId: 'req-after',
                origin: 'https://b.com',
              ),
            );
        final idAfter = container.read(notificationsProvider).single.id;

        expect(idAfter, greaterThan(idBefore));
      });
    });

    group('getNotification', () {
      test('returns notification with matching id', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createConnectRequest(
          reqId: 'req-123',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final result = notifier.getNotification(1);

        expect(result.isSome(), true);
        result.fold(
          () {
            fail('Expected Some but got None');
          },
          (data) {
            expect(data.id, 1);
          },
        );
      });

      test('returns none when id does not match', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest = _createConnectRequest(
          reqId: 'req-123',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest);

        final result = notifier.getNotification(999);

        expect(result.isNone(), true);
      });

      test('returns correct notification when multiple exist', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final signRequest1 = _createConnectRequest(
          reqId: 'req-1',
          origin: 'origin1',
        );

        final signRequest2 = _createConnectRequest(
          reqId: 'req-2',
          origin: 'origin2',
        );

        final signRequest3 = _createConnectRequest(
          reqId: 'req-3',
          origin: 'origin3',
        );

        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(signRequest1);
        notifier.addNotification(signRequest2);
        notifier.addNotification(signRequest3);

        final result = notifier.getNotification(2);

        expect(result.isSome(), true);
        result.fold(
          () {
            fail('Expected Some but got None');
          },
          (data) {
            expect(data.id, 2);
            expect((data.type as NotificationTypeConnect).reqId, 'req-2');
          },
        );
      });

      test('returns none when empty', () {
        final mockLocalNotifications = MockLocalNotificationService();
        setupContainer(mockLocalNotifications);

        final notifier = container.read(notificationsProvider.notifier);
        final result = notifier.getNotification(1);

        expect(result.isNone(), true);
      });
    });
  });

  // The notifier removes a request whose deadline has passed whether or not
  // anything is watching: no widget mounted, no panel open, no provider
  // watched. ADR-0010 decisions 1 and 3.
  group('the expiry sweep', () {
    late ProviderContainer container;
    late MockDesktopWindowService mockDesktopWindowService;

    NotificationData connectEntry(
      int id,
      String reqId, {
      required DateTime createdAt,
      required Option<int> ttlMilliseconds,
      NotificationItemState itemState = const NotificationItemState.empty(),
    }) => NotificationData(
      id,
      NotificationType.connect(
        reqId,
        'https://example.com',
        itemState,
        createdAt,
        ttlMilliseconds,
      ),
    );

    /// Puts [notifier] behind [notificationsProvider] in a fresh container,
    /// which it leaves in [container], and builds it.
    ///
    /// What comes back is the same instance, so the removals it recorded are
    /// read straight off it.
    T built<T extends Notifications>(T notifier) {
      container = _notificationsContainer(
        windowService: mockDesktopWindowService,
        notifier: () => notifier,
      );
      container.read(notificationsProvider.notifier);
      return notifier;
    }

    setUp(() {
      mockDesktopWindowService = _stubbedWindowService();
    });

    test(
      'removes an entry whose deadline passes with nothing watching',
      () async {
        final notifier = built(_RecordingNotifications());

        notifier.addNotification(
          _createConnectRequest(
            reqId: 'req-A',
            origin: 'https://example.com',
            ttlMilliseconds: 400,
          ),
        );
        expect(notifier.removals, isEmpty);

        await _waitUntil(() => notifier.removals.isNotEmpty);

        expect(notifier.removals, [(1, NotificationRemovalReason.expired)]);
        expect(container.read(notificationsProvider), isEmpty);
      },
    );

    // Observable ordering only: that one timer serves the whole list rather
    // than one per entry is a design rule, not an output.
    test('entries leave in deadline order', () async {
      final notifier = built(_RecordingNotifications());

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 400,
        ),
      );
      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-B',
          origin: 'https://example.com',
          ttlMilliseconds: 2500,
        ),
      );

      await _waitUntil(() => notifier.removals.isNotEmpty);

      expect(notifier.removals, [(1, NotificationRemovalReason.expired)]);
      expect(container.read(notificationsProvider).map((entry) => entry.id), [
        2,
      ]);

      await _waitUntil(() => notifier.removals.length == 2);

      expect(notifier.removals, [
        (1, NotificationRemovalReason.expired),
        (2, NotificationRemovalReason.expired),
      ]);
    });

    // A request carrying no deadline is never past one: none is invented for it
    // (ADR-0006 decision 7). Stated as "no expiry is recorded" — such a request
    // can still leave through remote cancel or a user action.
    test('never sweeps an entry that carries no deadline', () async {
      final notifier = built(_RecordingNotifications());

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 400,
        ),
      );
      notifier.addNotification(
        _createConnectRequest(reqId: 'req-B', origin: 'https://example.com'),
      );

      await _waitUntil(() => notifier.removals.isNotEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(notifier.removals, [(1, NotificationRemovalReason.expired)]);
      expect(container.read(notificationsProvider).map((entry) => entry.id), [
        2,
      ]);
    });

    // A cancelled entry is leaving as *remote cancel*, under a resolution the
    // server performed. Recording it as *expired* would replace a known cause
    // with a guessed one, and the reason is what the window policy turns on.
    // ADR-0010 decision 3.
    test('never records a cancelled entry as expired', () async {
      final notifier = built(
        _SeededRecordingNotifications([
          connectEntry(
            9,
            'req-X',
            createdAt: DateTime.now().subtract(const Duration(seconds: 5)),
            ttlMilliseconds: Option.of(1000),
            itemState: const NotificationItemState.canceled(),
          ),
        ]),
      );

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 400,
        ),
      );

      await _waitUntil(() => notifier.removals.isNotEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(notifier.removals, [(1, NotificationRemovalReason.expired)]);
      expect(container.read(notificationsProvider).map((entry) => entry.id), [
        9,
      ]);
    });

    // An arming at `deadline - 1s` — the instant the truncating comparison used
    // to answer "expired" at — fires where the predicate answers false, so it
    // would remove nothing and leave the entry for a later rearm. The elapsed
    // assertion is what fails then; it cannot be flaky in the other direction,
    // because a late fire only makes the measurement larger.
    test('arms at the deadline and sweeps once', () async {
      final notifier = built(_CountingNotifications());

      final startedAt = DateTime.now();
      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 600,
        ),
      );

      await _waitUntil(() => notifier.removals.isNotEmpty);

      expect(
        DateTime.now().difference(startedAt),
        greaterThanOrEqualTo(const Duration(milliseconds: 600)),
      );
      expect(notifier.removals, [(1, NotificationRemovalReason.expired)]);

      // The half of the criterion the removals cannot show. An arming at
      // `deadline - 1s` fires where the predicate answers false, removes
      // nothing, rearms on a delay that clamps to zero and spins until the real
      // deadline — same removal, tens of thousands of fires. Two is allowed
      // rather than one because `Timer` truncates its delay to whole
      // milliseconds, so a fire can land a few microseconds inside the boundary
      // and be rearmed once.
      expect(notifier.fires, lessThanOrEqualTo(2));
    });

    // One sweep, two removals, one rearm at the end of it — the rule is per
    // operation, not per `removeNotification`. Both entries are seeded past
    // their deadline, so the arming clamps to the first opportunity rather than
    // scheduling a negative delay. ADR-0010 decision 3.
    test('one sweep takes every entry already past its deadline', () async {
      final notifier = built(
        _SeededRecordingNotifications([
          connectEntry(
            9,
            'req-X',
            createdAt: DateTime.now().subtract(const Duration(seconds: 5)),
            ttlMilliseconds: Option.of(1000),
          ),
          connectEntry(
            10,
            'req-Y',
            createdAt: DateTime.now().subtract(const Duration(seconds: 4)),
            ttlMilliseconds: Option.of(1000),
          ),
        ]),
      );

      // Any other change to the list rearms, which is what puts the two
      // overdue entries in front of a sweep.
      notifier.addNotification(
        _createConnectRequest(reqId: 'req-A', origin: 'https://example.com'),
      );

      await _waitUntil(() => notifier.removals.length == 2);

      expect(notifier.removals, [
        (9, NotificationRemovalReason.expired),
        (10, NotificationRemovalReason.expired),
      ]);
      expect(container.read(notificationsProvider).map((entry) => entry.id), [
        1,
      ]);
    });

    // The notifier instance survives `clearAll()`'s `invalidateSelf` — riverpod
    // caches it per element — so a timer left running would sweep the next
    // generation's entries in silence rather than raising anything. Asserted
    // inside one container, where a leaked timer can actually reach.
    // The wait sits between `clearAll()` and the next delivery on purpose: a
    // timer that outlived the invalidation gets to fire there, into the new
    // generation, rather than being cancelled by the rearm the next delivery
    // would perform.
    //
    // The removals cannot carry this criterion on their own: the sweep re-reads
    // every deadline at fire time, so a stray timer can only ever remove
    // entries that were due anyway. The fire count is what makes the leak
    // observable, and the wait is what gives the leaked timer somewhere to
    // land.
    test('the expiry timer does not outlive its generation', () async {
      final notifier = built(_CountingNotifications());

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 400,
        ),
      );
      notifier.clearAll();

      await Future<void>.delayed(const Duration(milliseconds: 700));

      // The assertion that carries the criterion. A timer the invalidation did
      // not cancel is still armed for the instant that has just gone by, and
      // firing is the only trace it leaves — the sweep it runs finds an empty
      // list and changes nothing.
      expect(notifier.fires, 0);

      container
          .read(notificationsProvider.notifier)
          .addNotification(
            _createConnectRequest(
              reqId: 'req-B',
              origin: 'https://example.com',
              ttlMilliseconds: 2500,
            ),
          );

      await Future<void>.delayed(const Duration(milliseconds: 800));

      expect(container.read(notificationsProvider), hasLength(1));
      expect(notifier.removals, isEmpty);
    });

    // The sequence the criterion names: the entry's deadline is behind it when
    // `cancelNotification` marks it, so the mark and the microtask that follows
    // both run over an entry the sweep could otherwise have claimed. It leaves
    // as *remote cancel*, under the resolution the server performed, and no
    // expiry is recorded for it. ADR-0010 decision 3.
    //
    // Seeded past its deadline because that is the only way to reach the state:
    // `addNotification` drops a request that arrives past its deadline, and an
    // entry delivered live would be swept before any cancel could reach it.
    test(
      'a cancelled entry past its deadline leaves as a remote cancel',
      () async {
        final notifier = built(
          _SeededRecordingNotifications([
            connectEntry(
              9,
              'req-X',
              createdAt: DateTime.now().subtract(const Duration(seconds: 5)),
              ttlMilliseconds: Option.of(1000),
            ),
          ]),
        );

        notifier.cancelNotification('req-X');

        await _waitUntil(() => notifier.removals.isNotEmpty);
        await Future<void>.delayed(const Duration(milliseconds: 300));

        expect(notifier.removals, [
          (9, NotificationRemovalReason.remoteCancel),
        ]);
        expect(container.read(notificationsProvider), isEmpty);
      },
    );

    // The rule a backwards wall-clock correction exists for: a fire that finds
    // nothing to do produces no state change, so a design that rearmed only on
    // state changes would strand the timer for the rest of the session. That
    // input cannot be produced from a test — the clock is not a seam — so the
    // fire is made directly, which is faithful because a fire consumes the
    // timer that delivered it. ADR-0010 decision 3.
    test('a fire that removes nothing still rearms', () async {
      final notifier = built(_RecordingNotifications());

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 800,
        ),
      );

      notifier.sweepExpired();
      expect(notifier.removals, isEmpty);
      expect(container.read(notificationsProvider), hasLength(1));

      await _waitUntil(() => notifier.removals.isNotEmpty);

      expect(notifier.removals, [(1, NotificationRemovalReason.expired)]);
    });
  });

  // A request whose deadline has already gone by when it arrives never enters
  // the pending set. ADR-0010 decision 4.
  group('a request dropped at delivery', () {
    late ProviderContainer container;
    late MockDesktopWindowService mockDesktopWindowService;
    late List<int> badgeWrites;
    late _RecordingLocalNotificationService mockLocalNotifications;

    setUp(() {
      badgeWrites = [];
      mockDesktopWindowService = _stubbedWindowService(
        badgeWrites: badgeWrites,
      );
      mockLocalNotifications = _RecordingLocalNotificationService();

      // The badge and the window commands are desktop-only, so the flavour has
      // to be raised for their absence to mean anything.
      _useDesktopFlavour();

      container = _notificationsContainer(
        windowService: mockDesktopWindowService,
        localNotifications: mockLocalNotifications,
      );
    });

    test('a request with no time left never enters the pending set', () {
      // Built first, so the zero this notifier writes on the desktop flavour is
      // behind us before the delivery under test.
      final notifier = container.read(notificationsProvider.notifier);
      badgeWrites.clear();
      clearInteractions(mockDesktopWindowService);

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-expired',
          origin: 'https://example.com',
          ttlMilliseconds: 0,
        ),
      );

      expect(container.read(notificationsProvider), isEmpty);
      expect(badgeWrites, isEmpty);
      verifyNever(() => mockDesktopWindowService.onRequestDelivered(any()));
      verifyNever(
        () => mockDesktopWindowService.onRequestResolved(any(), any()),
      );
      expect(mockLocalNotifications.submitted, isEmpty);
    });

    test('the drop is logged once, with a non-negative elapsed amount', () {
      container
          .read(notificationsProvider.notifier)
          .addNotification(
            _createConnectRequest(
              reqId: 'req-expired',
              origin: 'https://example.com',
              ttlMilliseconds: 0,
            ),
          );

      final dropped = _logOutput.lines
          .where((line) => line.contains('Dropped at delivery'))
          .toList();

      expect(dropped, hasLength(1));
      expect(dropped.single, contains('req-expired'));
      expect(dropped.single, contains('https://example.com'));

      final elapsed = int.parse(
        RegExp(r'was already (-?\d+)ms past')
            .firstMatch(dropped.single)!
            .group(1)!,
      );
      expect(elapsed, greaterThanOrEqualTo(0));
    });

    // A short but live TTL is delivered normally and counts down. Suppressing
    // it would need a floor, and a floor invents a deadline the server did not
    // give. Under the truncating comparison this request was dropped; the
    // millisecond-precise one pins the scope to a TTL of zero and nothing else.
    test('a request with a part-second of TTL is delivered normally', () {
      final notifier = container.read(notificationsProvider.notifier);
      badgeWrites.clear();
      clearInteractions(mockDesktopWindowService);

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-brief',
          origin: 'https://example.com',
          ttlMilliseconds: 900,
        ),
      );

      expect(container.read(notificationsProvider), hasLength(1));
      expect(badgeWrites, [1]);
      verify(() => mockDesktopWindowService.onRequestDelivered(1)).called(1);
      expect(
        container.read(signRequestNotificationTtlProvider(1)),
        Option.of(0),
      );
    });

    // Both payloads from one message is a wire state the `oneof` forbids, and
    // the append handles it anyway; the drop is decided above both branches, so
    // it takes both. Prior art for the input: `_createBothRequest`.
    test(
      'a message carrying both payloads with no time left produces nothing',
      () {
        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createBothRequest(
                reqId: 'req-both-expired',
                origin: 'https://example.com',
                ttlMilliseconds: 0,
              ),
            );

        expect(container.read(notificationsProvider), isEmpty);
      },
    );
  });

  // The app-icon badge is desktop-only and the sweep is not, so this is the
  // desktop half of the sweep's contract. ADR-0010 decision 1.
  group('the expiry sweep on the desktop flavour', () {
    late ProviderContainer container;
    late MockDesktopWindowService mockDesktopWindowService;
    late List<int> badgeWrites;

    setUp(() {
      badgeWrites = [];
      mockDesktopWindowService = _stubbedWindowService(
        badgeWrites: badgeWrites,
      );
      _useDesktopFlavour();

      container = _notificationsContainer(
        windowService: mockDesktopWindowService,
      );
    });

    // Asserted on the badge target rather than on `pendingBadgeCount` of a
    // list: that is a pure function of the list and cannot fail once the
    // removal has happened, so it would not tell us the write was made.
    test('a swept request decrements the app-icon badge', () async {
      final notifier = container.read(notificationsProvider.notifier);

      notifier.addNotification(
        _createConnectRequest(
          reqId: 'req-A',
          origin: 'https://example.com',
          ttlMilliseconds: 400,
        ),
      );
      notifier.addNotification(
        _createConnectRequest(reqId: 'req-B', origin: 'https://example.com'),
      );
      expect(badgeWrites.last, 2);

      await _waitUntil(() => badgeWrites.last == 1);

      expect(badgeWrites.last, 1);
      verify(
        () => mockDesktopWindowService.onRequestResolved(
          1,
          NotificationRemovalReason.expired,
        ),
      ).called(1);
    });
  });

  group('activeNotifications', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when notifications list is empty', () {
      final result = container.read(activeNotificationsProvider);
      expect(result, isFalse);
    });

    test('returns true when there is at least one empty notification', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.empty(),
            DateTime.now(),
            none(),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(activeNotificationsProvider);
      expect(result, isTrue);
    });

    test('returns false when all notifications are canceled', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.canceled(),
            DateTime.now(),
            none(),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(activeNotificationsProvider);
      expect(result, isFalse);
    });

    test(
      'returns true when at least one notification is empty (mixed state)',
      () {
        final notifications = [
          NotificationData(
            1,
            NotificationType.connect(
              'req-123',
              'origin',
              NotificationItemState.canceled(),
              DateTime.now(),
              none(),
            ),
          ),
          NotificationData(
            2,
            NotificationType.signRequest(
              From_SignerRequest_Sign(),
              'req-456',
              'origin',
              NotificationItemState.empty(),
              DateTime.now(),
              none(),
            ),
          ),
        ];

        container = ProviderContainer.test(
          overrides: [notificationsProvider.overrideWithValue(notifications)],
        );
        addTearDown(container.dispose);

        final result = container.read(activeNotificationsProvider);
        expect(result, isTrue);
      },
    );

    test('returns false for sign notification that is canceled', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.signRequest(
            From_SignerRequest_Sign(),
            'req-456',
            'origin',
            NotificationItemState.canceled(),
            DateTime.now(),
            none(),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(activeNotificationsProvider);
      expect(result, isFalse);
    });

    test('returns true for sign notification that is empty', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.signRequest(
            From_SignerRequest_Sign(),
            'req-456',
            'origin',
            NotificationItemState.empty(),
            DateTime.now(),
            none(),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(activeNotificationsProvider);
      expect(result, isTrue);
    });
  });

  group('ShowNotificationMenu', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(showNotificationMenuProvider);
      expect(state.isNone(), true);
    });

    test('setState updates state to Some with notification id', () {
      final listener = ProviderListener<Option<int>>();

      container.listen(
        showNotificationMenuProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, const None())]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(showNotificationMenuProvider.notifier);
      notifier.setState(42);

      verifyInOrder([() => listener(const None(), Option.of(42))]);
      verifyNoMoreInteractions(listener);
      expect(container.read(showNotificationMenuProvider).isSome(), true);
      expect(
        container.read(showNotificationMenuProvider).getOrElse(() => -1),
        42,
      );
    });

    test('setState can be called multiple times with different values', () {
      final notifier = container.read(showNotificationMenuProvider.notifier);

      notifier.setState(10);
      expect(
        container.read(showNotificationMenuProvider).getOrElse(() => -1),
        10,
      );

      notifier.setState(20);
      expect(
        container.read(showNotificationMenuProvider).getOrElse(() => -1),
        20,
      );

      notifier.setState(30);
      expect(
        container.read(showNotificationMenuProvider).getOrElse(() => -1),
        30,
      );
    });
  });

  group('SignRequestNotificationTtl', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns none when notifications list is empty', () {
      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue([])],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(1));
      expect(result.isNone(), true);
    });

    test('returns none when notification id does not match', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.empty(),
            DateTime.now(),
            Option.of(5000),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(999));
      expect(result.isNone(), true);
    });

    test('returns none when notification is canceled', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.canceled(),
            DateTime.now(),
            Option.of(5000),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(1));
      expect(result.isNone(), true);
    });

    test('returns none when notification has no TTL', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.empty(),
            DateTime.now(),
            none(),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(1));
      expect(result.isNone(), true);
    });

    // The display is whole seconds and stays whole seconds: making the expiry
    // boundary millisecond-precise did not change the number on the screen.
    // ADR-0010 decision 2.
    test('renders zero for an entry with a part-second of its window left', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.empty(),
            DateTime.now().subtract(const Duration(milliseconds: 100)),
            Option.of(1000),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(signRequestNotificationTtlProvider(1)),
        Option.of(0),
      );
    });

    test(
      'returns initial ttl value in seconds when notification is not expired',
      () {
        final now = DateTime.now();
        final ttlMs = 10000; // 10 seconds

        final notifications = [
          NotificationData(
            1,
            NotificationType.connect(
              'req-123',
              'origin',
              NotificationItemState.empty(),
              now,
              Option.of(ttlMs),
            ),
          ),
        ];

        container = ProviderContainer.test(
          overrides: [notificationsProvider.overrideWithValue(notifications)],
        );
        addTearDown(container.dispose);

        final result = container.read(signRequestNotificationTtlProvider(1));

        expect(result.isSome(), true);
        // Should be around 10 seconds (allowing some margin for execution time)
        expect(result.getOrElse(() => -1), greaterThan(8));
        expect(result.getOrElse(() => -1), lessThanOrEqualTo(10));
      },
    );

    test('returns 0 when notification is expired', () {
      final now = DateTime.now();
      final expiredTime = now.subtract(
        const Duration(seconds: 5),
      ); // Expired 5 seconds ago
      final ttlMs = 3000; // Was 3 seconds TTL

      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.empty(),
            expiredTime,
            Option.of(ttlMs),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(1));

      expect(result.isSome(), true);
      expect(result.getOrElse(() => -1), 0);
    });

    test('works with sign request notifications', () {
      final now = DateTime.now();
      final ttlMs = 5000;

      final notifications = [
        NotificationData(
          1,
          NotificationType.signRequest(
            From_SignerRequest_Sign(),
            'req-456',
            'origin',
            NotificationItemState.empty(),
            now,
            Option.of(ttlMs),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(1));

      expect(result.isSome(), true);
      expect(result.getOrElse(() => -1), greaterThan(3));
      expect(result.getOrElse(() => -1), lessThanOrEqualTo(5));
    });

    test('returns none for canceled sign request', () {
      final notifications = [
        NotificationData(
          1,
          NotificationType.signRequest(
            From_SignerRequest_Sign(),
            'req-456',
            'origin',
            NotificationItemState.canceled(),
            DateTime.now(),
            Option.of(5000),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      final result = container.read(signRequestNotificationTtlProvider(1));
      expect(result.isNone(), true);
    });

    test('creates timer when notification has TTL (timer line coverage)', () {
      // This test specifically covers line 228-230: Timer.periodic creation
      // We verify by reading the provider with a notification that has TTL
      final now = DateTime.now();
      final ttlMs = 30000; // 30 seconds

      final notifications = [
        NotificationData(
          1,
          NotificationType.connect(
            'req-123',
            'origin',
            NotificationItemState.empty(),
            now,
            Option.of(ttlMs),
          ),
        ),
      ];

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue(notifications)],
      );
      addTearDown(container.dispose);

      // Reading the provider triggers Timer.periodic creation on line 228-230
      final result = container.read(signRequestNotificationTtlProvider(1));

      // Verify the timer was created and initial state is set
      expect(result.isSome(), true);
      expect(result.getOrElse(() => -1), greaterThan(20));
      expect(result.getOrElse(() => -1), lessThanOrEqualTo(30));
    });

    test('periodic timer tick updates TTL state', () {
      fakeAsync((async) {
        final now = DateTime.now();
        final ttlMs = 5000; // 5 seconds

        final notifications = [
          NotificationData(
            1,
            NotificationType.connect(
              'req-123',
              'origin',
              NotificationItemState.empty(),
              now,
              Option.of(ttlMs),
            ),
          ),
        ];

        container = ProviderContainer.test(
          overrides: [notificationsProvider.overrideWithValue(notifications)],
        );
        addTearDown(container.dispose);

        // An active listener keeps the autoDispose provider (and the periodic
        // timer started in build()) alive across the elapse below.
        container.listen(signRequestNotificationTtlProvider(1), (_, _) {});

        // Advancing fake time fires the timer callback, which updates state.
        async.elapse(Duration(seconds: 1));

        final result = container.read(signRequestNotificationTtlProvider(1));
        expect(result.isSome(), true);
        expect(result.getOrElse(() => -1), greaterThan(0));
      });
    });

    // A request carrying no countdown is not expired locally: there is no
    // deadline to enforce and none is invented. ADR-0006 decision 7. Stated as
    // "starts no countdown" rather than "it never leaves" — such a request can
    // still go through remote cancel, a user action, or Clear all.
    test('starts no countdown for a request that carries no deadline', () {
      fakeAsync((async) {
        final notifications = [
          NotificationData(
            1,
            NotificationType.connect(
              'req-123',
              'origin',
              NotificationItemState.empty(),
              DateTime.now(),
              none<int>(),
            ),
          ),
        ];

        container = ProviderContainer.test(
          overrides: [notificationsProvider.overrideWithValue(notifications)],
        );
        addTearDown(container.dispose);

        container.listen(signRequestNotificationTtlProvider(1), (_, _) {});

        async.elapse(Duration(minutes: 5));

        expect(async.pendingTimers, isEmpty);
        expect(
          container.read(signRequestNotificationTtlProvider(1)).isNone(),
          isTrue,
        );
      });
    });
  });

  group('pendingRequest', () {
    late ProviderContainer container;

    NotificationData connectEntry(
      int id,
      String reqId, {
      NotificationItemState itemState = const NotificationItemState.empty(),
    }) => NotificationData(
      id,
      NotificationType.connect(
        reqId,
        'origin',
        itemState,
        DateTime.now(),
        Option.of(30000),
      ),
    );

    test('yields the entry while the request is pending', () {
      final entry = connectEntry(1, 'req-A');

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([entry]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pendingRequestProvider(1, 'req-A')),
        Option.of(entry),
      );
    });

    test('yields the entry for a sign request too', () {
      final entry = NotificationData(
        1,
        NotificationType.signRequest(
          From_SignerRequest_Sign(),
          'req-A',
          'origin',
          NotificationItemState.empty(),
          DateTime.now(),
          Option.of(30000),
        ),
      );

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([entry]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pendingRequestProvider(1, 'req-A')),
        Option.of(entry),
      );
    });

    test('yields nothing when the list holds no such id', () {
      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([connectEntry(2, 'req-A')]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pendingRequestProvider(1, 'req-A')).isNone(),
        isTrue,
      );
    });

    test('yields nothing when the list is empty', () {
      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue([])],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pendingRequestProvider(1, 'req-A')).isNone(),
        isTrue,
      );
    });

    test('yields nothing when the entry is in the cancelled state', () {
      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([
            connectEntry(
              1,
              'req-A',
              itemState: NotificationItemState.canceled(),
            ),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pendingRequestProvider(1, 'req-A')).isNone(),
        isTrue,
      );
    });

    // The local id is an arrival counter, so a bare integer match is not an
    // identity: the request id is what says the entry under this id is the one
    // the caller captured. `addNotification` cannot produce this pairing on its
    // own — it mints one id per delivery from a counter that only goes up
    // (#211), so it never files two *different* requests under one id — which
    // is why it is seeded here. ADR-0006 decision 3.
    test('yields nothing when the id addresses a different request', () {
      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([connectEntry(1, 'req-B')]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(pendingRequestProvider(1, 'req-A')).isNone(),
        isTrue,
      );
    });

    test('re-emits when its answer changes', () async {
      final entry = connectEntry(1, 'req-A');
      final seeded = _SeededNotifications([entry]);
      final listener = ProviderListener<Option<NotificationData>>();

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWith(() => seeded)],
      );
      addTearDown(container.dispose);

      container.listen(
        pendingRequestProvider(1, 'req-A'),
        listener.call,
        fireImmediately: true,
      );

      seeded.setEntries([]);
      // A derived provider reaches its listeners on the microtask after its
      // dependency changed, not synchronously with it.
      await Future<void>.delayed(Duration.zero);

      verifyInOrder([
        () => listener(null, Option.of(entry)),
        () => listener(Option.of(entry), none()),
      ]);
    });

    // The reason the lookup lives in a provider rather than in the dialog: a
    // list rebuild that leaves this request untouched must not churn the
    // dialog watching it. ADR-0006 decision 3.
    test('does not re-emit when its answer is unchanged', () async {
      final entry = connectEntry(1, 'req-A');
      final seeded = _SeededNotifications([entry]);
      final listener = ProviderListener<Option<NotificationData>>();

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWith(() => seeded)],
      );
      addTearDown(container.dispose);

      container.listen(
        pendingRequestProvider(1, 'req-A'),
        listener.call,
        fireImmediately: true,
      );

      // A second request arriving: the list is a new object, this request's
      // answer is not.
      seeded.setEntries([connectEntry(2, 'req-B'), entry]);
      await Future<void>.delayed(Duration.zero);

      verify(() => listener(any(), any())).called(1);
    });
  });

  group('nextPendingRequest', () {
    late ProviderContainer container;

    NotificationData connectEntry(
      int id,
      String reqId, {
      NotificationItemState itemState = const NotificationItemState.empty(),
    }) => NotificationData(
      id,
      NotificationType.connect(
        reqId,
        'origin',
        itemState,
        DateTime.now(),
        Option.of(30000),
      ),
    );

    NotificationData signEntry(int id, String reqId) => NotificationData(
      id,
      NotificationType.signRequest(
        From_SignerRequest_Sign(),
        reqId,
        'origin',
        NotificationItemState.empty(),
        DateTime.now(),
        Option.of(30000),
      ),
    );

    test('yields nothing when nothing is waiting', () {
      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWithValue([])],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider).isNone(), isTrue);
    });

    test('yields nothing when every entry has been cancelled', () {
      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([
            connectEntry(
              1,
              'req-A',
              itemState: NotificationItemState.canceled(),
            ),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider).isNone(), isTrue);
    });

    test('yields the only request waiting', () {
      final entry = connectEntry(1, 'req-A');

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([entry]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider), Option.of(entry));
    });

    // Oldest first, because a queue served newest-first starves the request
    // with the least time left on it. ADR-0006 decision 5. The list is held
    // newest-first, so this is not the head of it.
    test('yields the oldest of several waiting', () {
      final oldest = connectEntry(1, 'req-A');

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([
            connectEntry(3, 'req-C'),
            connectEntry(2, 'req-B'),
            oldest,
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider), Option.of(oldest));
    });

    // The list is built newest-first today, and the answer must not depend on
    // that: it is folded out of the whole list rather than read off one end.
    test('yields the oldest whichever order the list is held in', () {
      final oldest = connectEntry(1, 'req-A');

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([
            oldest,
            connectEntry(2, 'req-B'),
            connectEntry(3, 'req-C'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider), Option.of(oldest));
    });

    test('passes over a cancelled entry to reach the oldest one waiting', () {
      final pending = connectEntry(2, 'req-B');

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([
            pending,
            connectEntry(
              1,
              'req-A',
              itemState: NotificationItemState.canceled(),
            ),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider), Option.of(pending));
    });

    // Two entries under one id is what `addNotification` would build for a
    // request carrying both a connect and a sign payload, which the wire makes
    // impossible today — the two are a protobuf `oneof`. Pinned anyway, because
    // the tie-break is the reason this is a fold rather than a read off one end
    // of the list: the entry the list holds first wins, which is the same one
    // `pendingRequest` answers with, and the two have to agree about which
    // entry an id addresses.
    test('keeps the entry the list holds first when two share an id', () {
      final sign = signEntry(1, 'req-A');

      container = ProviderContainer.test(
        overrides: [
          notificationsProvider.overrideWithValue([
            sign,
            connectEntry(1, 'req-A'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(nextPendingRequestProvider), Option.of(sign));
    });

    test('re-emits when the request to present next changes', () async {
      final first = connectEntry(1, 'req-A');
      final second = connectEntry(2, 'req-B');
      final seeded = _SeededNotifications([second, first]);
      final listener = ProviderListener<Option<NotificationData>>();

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWith(() => seeded)],
      );
      addTearDown(container.dispose);

      container.listen(
        nextPendingRequestProvider,
        listener.call,
        fireImmediately: true,
      );

      seeded.setEntries([second]);
      await Future<void>.delayed(Duration.zero);

      verifyInOrder([
        () => listener(null, Option.of(first)),
        () => listener(Option.of(first), Option.of(second)),
      ]);
    });

    // What makes "a second request opens no window" true without anything
    // guarding it: a later arrival is not the oldest, so the answer the
    // listener watches does not change at all. ADR-0006 decision 5.
    test('does not re-emit when a later request joins the queue', () async {
      final first = connectEntry(1, 'req-A');
      final seeded = _SeededNotifications([first]);
      final listener = ProviderListener<Option<NotificationData>>();

      container = ProviderContainer.test(
        overrides: [notificationsProvider.overrideWith(() => seeded)],
      );
      addTearDown(container.dispose);

      container.listen(
        nextPendingRequestProvider,
        listener.call,
        fireImmediately: true,
      );

      seeded.setEntries([connectEntry(2, 'req-B'), first]);
      await Future<void>.delayed(Duration.zero);

      verify(() => listener(any(), any())).called(1);
    });
  });

  group('Notifications (Notifier) - Desktop flavor', () {
    late ProviderContainer container;
    late MockDesktopWindowService mockDesktopWindowService;

    /// Every count the notifier has put on the app icon, in order.
    ///
    /// The values are what the badge means; how many writes it took to arrive
    /// at them is not, and a behaviour-preserving change to the notifier's
    /// boundaries would legitimately alter the second (docs/TESTING.md).
    late List<int> badgeWrites;

    void setupDesktopContainer([
      MockLocalNotificationService? mockNotifications,
    ]) {
      container = _notificationsContainer(
        windowService: mockDesktopWindowService,
        localNotifications: mockNotifications,
      );
    }

    setUp(() {
      badgeWrites = [];
      mockDesktopWindowService = _stubbedWindowService(
        badgeWrites: badgeWrites,
      );
      _useDesktopFlavour();
      setupDesktopContainer();
    });

    group('addNotification with connect request on desktop', () {
      test('executes desktop path when isDesktop=true for connect', () {
        final signRequest = _createConnectRequest(
          reqId: 'req-desktop-1',
          origin: 'https://example.com',
        );

        final notifier = container.read(notificationsProvider.notifier);
        // This call executes lines 79-88 (desktop connect path)
        notifier.addNotification(signRequest);

        // Verify notification was added to state
        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(1));
        expect(notifications.first.type, isA<NotificationTypeConnect>());
        final connectType = notifications.first.type as NotificationTypeConnect;
        expect(connectType.reqId, 'req-desktop-1');
      });

      test('desktop connect with TTL takes desktop path', () {
        final signRequest = _createConnectRequest(
          reqId: 'req-desktop-ttl',
          origin: 'origin',
          ttlMilliseconds: 5000,
        );

        final notifier = container.read(notificationsProvider.notifier);
        // This call executes lines 79-88
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        final connectType = notifications.first.type as NotificationTypeConnect;
        expect(connectType.ttlMilliseconds.isSome(), true);
        expect(connectType.ttlMilliseconds.getOrElse(() => -1), 5000);
      });
    });

    group('addNotification with sign request on desktop', () {
      test('executes desktop path when isDesktop=true for sign', () {
        final signRequest = _createSignRequest(
          reqId: 'req-desktop-sign-1',
          origin: 'https://example.com',
        );

        final notifier = container.read(notificationsProvider.notifier);
        // This call executes lines 114-123 (desktop sign path)
        notifier.addNotification(signRequest);

        // Verify notification was added to state
        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(1));
        expect(notifications.first.type, isA<NotificationTypeSignRequest>());
        final signType =
            notifications.first.type as NotificationTypeSignRequest;
        expect(signType.reqId, 'req-desktop-sign-1');
      });

      test('desktop sign with TTL takes desktop path', () {
        final signRequest = _createSignRequest(
          reqId: 'req-desktop-sign-ttl',
          origin: 'origin',
          ttlMilliseconds: 3000,
        );

        final notifier = container.read(notificationsProvider.notifier);
        // This call executes lines 114-123
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        final signType =
            notifications.first.type as NotificationTypeSignRequest;
        expect(signType.ttlMilliseconds.isSome(), true);
        expect(signType.ttlMilliseconds.getOrElse(() => -1), 3000);
      });
    });

    group('addNotification with both connect and sign on desktop', () {
      test('adds both notifications when isDesktop=true with both types', () {
        final signRequest = _createBothRequest(
          reqId: 'req-both-desktop',
          origin: 'origin',
        );

        final notifier = container.read(notificationsProvider.notifier);
        // This call executes both desktop paths: lines 79-88 and 114-123
        notifier.addNotification(signRequest);

        final notifications = container.read(notificationsProvider);
        expect(notifications, hasLength(2));
        // Sign is added last, so it appears first
        expect(notifications[0].type, isA<NotificationTypeSignRequest>());
        expect(notifications[1].type, isA<NotificationTypeConnect>());
      });
    });

    group('raising the desktop window on request delivery', () {
      test('a connect request opens the raise episode for it', () {
        final signRequest = _createConnectRequest(
          reqId: 'req-raise-connect',
          origin: 'https://example.com',
        );

        container
            .read(notificationsProvider.notifier)
            .addNotification(signRequest);

        verify(() => mockDesktopWindowService.onRequestDelivered(1)).called(1);
      });

      test('a sign request opens the raise episode for it', () {
        final signRequest = _createSignRequest(
          reqId: 'req-raise-sign',
          origin: 'https://example.com',
        );

        container
            .read(notificationsProvider.notifier)
            .addNotification(signRequest);

        verify(() => mockDesktopWindowService.onRequestDelivered(1)).called(1);
      });

      test('a request arriving while another is pending is delivered too', () {
        final notifier = container.read(notificationsProvider.notifier);

        notifier.addNotification(
          _createSignRequest(reqId: 'req-first', origin: 'https://example.com'),
        );
        notifier.addNotification(
          _createSignRequest(reqId: 'req-second', origin: 'https://other.com'),
        );

        // The first request is still unresolved when the second arrives.
        expect(container.read(notificationsProvider), hasLength(2));
        verify(() => mockDesktopWindowService.onRequestDelivered(1)).called(1);
        verify(() => mockDesktopWindowService.onRequestDelivered(2)).called(1);
      });

      test('a request carrying both connect and sign is delivered once', () {
        final signRequest = _createBothRequest(
          reqId: 'req-raise-both',
          origin: 'https://example.com',
        );

        container
            .read(notificationsProvider.notifier)
            .addNotification(signRequest);

        verify(() => mockDesktopWindowService.onRequestDelivered(1)).called(1);
      });

      test('resolving a notification never opens a raise episode', () {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createSignRequest(reqId: 'req-resolve', origin: 'https://a.com'),
        );
        clearInteractions(mockDesktopWindowService);

        notifier.removeNotification(
          1,
          reason: NotificationRemovalReason.acceptedByUser,
        );
        notifier.cancelNotification('req-resolve');

        verifyNever(() => mockDesktopWindowService.onRequestDelivered(any()));
      });

      test(
        'a refused raise does not escape or lose the notification',
        () async {
          when(() => mockDesktopWindowService.onRequestDelivered(any()))
              .thenThrow(Exception('window manager refused activation'));

          container
              .read(notificationsProvider.notifier)
              .addNotification(
                _createSignRequest(
                  reqId: 'req-refused',
                  origin: 'https://a.com',
                ),
              );
          // Drain the microtask queue the discarded future completes on; an
          // unhandled rejection would fail this test.
          await Future<void>.delayed(Duration.zero);

          expect(container.read(notificationsProvider), hasLength(1));
        },
      );
    });

    group('resolving a request through the raise episode', () {
      setUp(() {
        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createSignRequest(
                reqId: 'req-resolution',
                origin: 'https://a.com',
              ),
            );
        clearInteractions(mockDesktopWindowService);
      });

      for (final reason in NotificationRemovalReason.values) {
        test('a removal reported as ${reason.name} carries that reason', () {
          container
              .read(notificationsProvider.notifier)
              .removeNotification(1, reason: reason);

          verify(() => mockDesktopWindowService.onRequestResolved(1, reason))
              .called(1);
        });
      }

      test(
        'a remote cancel resolves the swept entry as remoteCancel',
        () async {
          container
              .read(notificationsProvider.notifier)
              .cancelNotification('req-resolution');
          // The sweep that removes cancelled entries runs a microtask later.
          await Future<void>.delayed(Duration.zero);

          verify(
            () => mockDesktopWindowService.onRequestResolved(
              1,
              NotificationRemovalReason.remoteCancel,
            ),
          ).called(1);
        },
      );

      test('a refused resolution does not escape', () async {
        when(() => mockDesktopWindowService.onRequestResolved(any(), any()))
            .thenThrow(Exception('window manager refused'));

        container
            .read(notificationsProvider.notifier)
            .removeNotification(
              1,
              reason: NotificationRemovalReason.acceptedByUser,
            );
        await Future<void>.delayed(Duration.zero);

        expect(container.read(notificationsProvider), isEmpty);
      });

      test('clearing every notification gives the raise episode up instead of '
          'resolving anything: nothing else would ever empty it', () {
        container.read(notificationsProvider.notifier).clearAll();

        verify(() => mockDesktopWindowService.abandonEpisode()).called(1);
        verifyNever(
          () => mockDesktopWindowService.onRequestResolved(any(), any()),
        );
      });

      test('a refused abandon does not escape', () async {
        when(() => mockDesktopWindowService.abandonEpisode())
            .thenThrow(Exception('window manager refused'));

        container.read(notificationsProvider.notifier).clearAll();
        await Future<void>.delayed(Duration.zero);

        expect(container.read(notificationsProvider), isEmpty);
      });
    });

    group('posting the OS notification on request delivery', () {
      test(
        'a refused sign notification does not escape or lose the request',
        () async {
          setupDesktopContainer(_ThrowingLocalNotificationService());

          container
              .read(notificationsProvider.notifier)
              .addNotification(
                _createSignRequest(
                  reqId: 'req-refused-sign-banner',
                  origin: 'https://a.com',
                ),
              );
          // Drain the microtask queue the discarded submission future
          // completes on; an unhandled rejection would fail this test.
          await Future<void>.delayed(Duration.zero);

          // Asserted together: the submission really did fail, and the request
          // survived it. The length alone would hold even without the fix.
          expect(
            _logOutput.lines.join('\n'),
            contains('req-refused-sign-banner'),
          );
          expect(container.read(notificationsProvider), hasLength(1));
        },
      );

      test(
        'a refused connect notification does not escape or lose the request',
        () async {
          setupDesktopContainer(_ThrowingLocalNotificationService());

          container
              .read(notificationsProvider.notifier)
              .addNotification(
                _createConnectRequest(
                  reqId: 'req-refused-connect-banner',
                  origin: 'https://b.com',
                ),
              );
          await Future<void>.delayed(Duration.zero);

          expect(
            _logOutput.lines.join('\n'),
            contains('req-refused-connect-banner'),
          );
          expect(container.read(notificationsProvider), hasLength(1));
        },
      );

      test('a refused notification is logged against its request', () async {
        setupDesktopContainer(_ThrowingLocalNotificationService());

        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createSignRequest(
                reqId: 'req-logged-failure',
                origin: 'https://logged.example.com',
              ),
            );
        await Future<void>.delayed(Duration.zero);

        expect(
          _logOutput.lines.join('\n'),
          allOf(
            contains('req-logged-failure'),
            contains('https://logged.example.com'),
            contains('type=swaptionSign'),
            contains('notification center refused the submission'),
          ),
        );
      });

      test(
        'a request carrying both kinds logs each submission apart',
        () async {
          setupDesktopContainer();

          container
              .read(notificationsProvider.notifier)
              .addNotification(
                _createBothRequest(
                  reqId: 'req-both-logged',
                  origin: 'https://both.example.com',
                ),
              );
          await Future<void>.delayed(Duration.zero);

          // Both submissions share one notification id, so the payload type is
          // the only thing telling the connect banner from the sign banner.
          expect(
            _logOutput.lines.join('\n'),
            allOf(
              contains('type=swaptionConnect'),
              contains('type=swaptionSign'),
            ),
          );
        },
      );

      test('an accepted notification is logged against its request', () async {
        setupDesktopContainer();

        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createSignRequest(
                reqId: 'req-accepted',
                origin: 'https://accepted.example.com',
              ),
            );
        await Future<void>.delayed(Duration.zero);

        expect(
          _logOutput.lines.join('\n'),
          allOf(
            contains('req-accepted'),
            contains('https://accepted.example.com'),
            contains('type=swaptionSign'),
            // A success proves submission was accepted, not that a banner
            // was shown; the log must not overclaim.
            contains('does not prove a banner was displayed'),
          ),
        );
      });
    });

    group('the pending badge on the app icon', () {
      test('a built notifier writes the count of the list it built', () {
        // Reconciled rather than assumed: the badge lives on the process's
        // Dock tile, so a notifier rebuilt after invalidation would otherwise
        // inherit a count it never wrote (ADR-0005 decision 3).
        container.read(notificationsProvider);

        expect(badgeWrites, isNotEmpty);
        expect(badgeWrites.last, 0);
      });

      test('a delivered request is counted', () {
        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createConnectRequest(
                reqId: 'req-badge-1',
                origin: 'https://a.com',
              ),
            );

        expect(badgeWrites.last, 1);
      });

      test('a second request pending alongside the first reads two', () {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createConnectRequest(reqId: 'req-badge-a', origin: 'https://a.com'),
        );
        notifier.addNotification(
          _createSignRequest(reqId: 'req-badge-b', origin: 'https://b.com'),
        );

        expect(badgeWrites.last, 2);
      });

      test('a request carrying both a connect and a sign payload counts as the '
          'two cards the user actually sees', () {
        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createBothRequest(
                reqId: 'req-badge-both',
                origin: 'https://both.com',
              ),
            );

        expect(badgeWrites.last, 2);
      });

      for (final reason in NotificationRemovalReason.values) {
        test(
          'a removal for ${reason.name} drops the count to what is left',
          () {
            final notifier = container.read(notificationsProvider.notifier);
            notifier.addNotification(
              _createConnectRequest(
                reqId: 'req-badge-kept',
                origin: 'https://a.com',
              ),
            );
            notifier.addNotification(
              _createSignRequest(
                reqId: 'req-badge-gone',
                origin: 'https://b.com',
              ),
            );
            final resolved = container.read(notificationsProvider).first.id;

            notifier.removeNotification(resolved, reason: reason);

            expect(badgeWrites.last, 1);
          },
        );
      }

      test('the last removal empties the badge', () {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createConnectRequest(
            reqId: 'req-badge-only',
            origin: 'https://a.com',
          ),
        );
        final onlyOne = container.read(notificationsProvider).first.id;

        notifier.removeNotification(
          onlyOne,
          reason: NotificationRemovalReason.acceptedByUser,
        );

        expect(badgeWrites.last, 0);
      });

      test('a remotely cancelled request stops counting the moment the '
          'cancellation is recorded, not when the microtask removes it', () {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createConnectRequest(
            reqId: 'req-badge-cancelled',
            origin: 'https://a.com',
          ),
        );
        notifier.addNotification(
          _createSignRequest(
            reqId: 'req-badge-surviving',
            origin: 'https://b.com',
          ),
        );

        notifier.cancelNotification('req-badge-cancelled');

        // Asserted with the microtask still queued: the entry is in the list
        // and already out of the count.
        expect(container.read(notificationsProvider), hasLength(2));
        expect(badgeWrites.last, 1);
      });

      test('the microtask that removes a cancelled entry does not change the '
          'count it was already excluded from', () async {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createConnectRequest(
            reqId: 'req-badge-cancelled',
            origin: 'https://a.com',
          ),
        );
        notifier.addNotification(
          _createSignRequest(
            reqId: 'req-badge-surviving',
            origin: 'https://b.com',
          ),
        );
        notifier.cancelNotification('req-badge-cancelled');

        await pumpEventQueue();

        expect(container.read(notificationsProvider), hasLength(1));
        expect(badgeWrites.last, 1);
      });

      test('clearing the list empties the badge without waiting for a read', () {
        final notifier = container.read(notificationsProvider.notifier);
        notifier.addNotification(
          _createConnectRequest(reqId: 'req-badge-x', origin: 'https://a.com'),
        );
        notifier.addNotification(
          _createSignRequest(reqId: 'req-badge-y', origin: 'https://b.com'),
        );

        final writesBeforeClear = badgeWrites.length;
        notifier.clearAll();

        // Asserted without reading the provider again: clearAll() invalidates
        // rather than assigning, so a badge that only followed the rebuilt
        // state would still be reading two here (ADR-0005 decision 3).
        //
        // Two zeros, not one, and the count is the behaviour rather than an
        // implementation detail: the invalidation disposes the notifier, and
        // that disposal writes a zero of its own. Asserting only the last value
        // would pass with the explicit write deleted — leaving the badge
        // relying on invalidation to propagate it, which is the one thing the
        // criterion forbids. Sound because badgeWrites is reset per test.
        expect(badgeWrites.sublist(writesBeforeClear), [0, 0]);
      });

      test('disposing the provider takes the badge with it', () {
        container
            .read(notificationsProvider.notifier)
            .addNotification(
              _createConnectRequest(
                reqId: 'req-badge-disposed',
                origin: 'https://a.com',
              ),
            );
        expect(badgeWrites.last, 1);

        container.dispose();

        expect(badgeWrites.last, 0);
      });
    });
  });
}
