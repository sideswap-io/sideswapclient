import 'dart:convert';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/listeners/swaption_notification_listener.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swaption/swaption_dialogs.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// Seeds the real notifier with a known list.
///
/// Overriding [build] rather than driving `addNotification` keeps the entries'
/// ids and request ids under the test's control. Everything else — including
/// `removeNotification` — is the real implementation, which the queue depends
/// on: the loop only reaches the next request because a removal really takes
/// the current one out of the pending set.
class _SeededNotifications extends Notifications {
  _SeededNotifications(this._seed);

  final List<NotificationData> _seed;

  /// Every removal in order, with the reason it was made under.
  ///
  /// The reason is the externally observable fact these tests are about, and
  /// the order is what separates "records the expiry" from "records the expiry
  /// and then also a rejection".
  final removals = <(int, NotificationRemovalReason)>[];

  @override
  List<NotificationData> build() => _seed;

  void setEntries(List<NotificationData> entries) => state = entries;

  @override
  void removeNotification(
    int notificationId, {
    required NotificationRemovalReason reason,
  }) {
    removals.add((notificationId, reason));
    super.removeNotification(notificationId, reason: reason);
  }
}

/// Serves the one SVG the connect dialog paints, which `--no-test-assets`
/// leaves out of the real bundle.
class _StubAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    return ByteData.sublistView(
      Uint8List.fromList(
        utf8.encode(
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"/>',
        ),
      ),
    );
  }
}

const _reqA = 'req-A';
const _reqB = 'req-B';
const _reqC = 'req-C';
const _origin = 'https://origin-a.test';

Translations get _englishCopy => Translations({
  'Liquid Connect': 'Liquid Connect',
  'Allow': 'Allow',
  'Site:': 'Site:',
  'Scope:': 'Scope:',
  'read-only (watch-only)': 'read-only (watch-only)',
  'Time-to-live: {} seconds': {
    'one': 'Time-to-live: {} second',
    'other': 'Time-to-live: {} seconds',
  },
});

NotificationData _connectEntry({
  int id = 1,
  String reqId = _reqA,
  NotificationItemState itemState = const NotificationItemState.empty(),
  Option<int> ttlMilliseconds = const None(),
  DateTime? createdAt,
}) => NotificationData(
  id,
  NotificationType.connect(
    reqId,
    _origin,
    itemState,
    createdAt ?? DateTime(2026, 1, 1),
    ttlMilliseconds,
  ),
);

NotificationData _signEntry({
  int id = 1,
  String reqId = _reqA,
  NotificationItemState itemState = const NotificationItemState.empty(),
  Option<int> ttlMilliseconds = const None(),
  DateTime? createdAt,
}) => NotificationData(
  id,
  NotificationType.signRequest(
    From_SignerRequest_Sign(),
    reqId,
    _origin,
    itemState,
    createdAt ?? DateTime(2026, 1, 1),
    ttlMilliseconds,
  ),
);

/// An arriving request as the backend delivers it.
From_SignerRequest _arrival({required String reqId}) {
  final request = From_SignerRequest();
  request.reqId = reqId;
  request.origin = _origin;
  request.connect = Empty();
  return request;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(To());
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  late _MockWallet wallet;
  late _SeededNotifications seeded;
  late ProviderContainer container;
  late GlobalKey<NavigatorState> navigatorKey;

  // Rebuilt before each test rather than cleaned up after one: end-of-test
  // cleanup is skipped when an expectation throws, and under a randomised seed
  // the next test would then run on whatever the failed one left behind
  // (docs/TESTING.md).
  setUp(() {
    Localization.load(const Locale('en'), translations: _englishCopy);
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
    wallet = _MockWallet();
    when(() => wallet.isAuthenticated()).thenAnswer((_) async => true);
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  /// Pumps the listener over a pending set of [entries].
  Future<void> present(
    WidgetTester tester, {
    required List<NotificationData> entries,
  }) async {
    tester.view.physicalSize = const Size(1440, 2800);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    seeded = _SeededNotifications(entries);
    navigatorKey = GlobalKey<NavigatorState>();
    container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWithValue(wallet),
        notificationsProvider.overrideWith(() => seeded),
        // The real one is built from this key, so the delivery path's
        // `closePopups()` runs against the navigator this test pumps.
        navigatorKeyProvider.overrideWithValue(navigatorKey),
      ],
    );
    // `UncontrolledProviderScope` does not own the container it is given, so
    // nothing else would take it down.
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: DefaultAssetBundle(
          bundle: _StubAssetBundle(),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              extensions: [CustomBigButtonStyle()],
            ),
            home: const Scaffold(body: SwaptionNotificationListener()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The identity of the one dialog on screen, or `null` when there is none.
  (int, String)? presented(WidgetTester tester) {
    final dialogs = tester
        .widgetList<SwaptionDialog>(
          find.byType(SwaptionDialog, skipOffstage: false),
        )
        .toList();

    // One at a time is the rule, so more than one is a failure to report here
    // rather than a choice to make.
    expect(dialogs.length, lessThanOrEqualTo(1));

    if (dialogs.isEmpty) {
      return null;
    }

    final dialog = dialogs.single;
    return (dialog.notificationId, dialog.reqId);
  }

  group('presentation order', () {
    testWidgets('presents the request that has been waiting longest', (
      tester,
    ) async {
      // Held newest-first, the way `addNotification` builds the list.
      await present(
        tester,
        entries: [
          _connectEntry(id: 2, reqId: _reqB),
          _connectEntry(),
        ],
      );

      expect(presented(tester), (1, _reqA));
    });

    testWidgets('opens no window for a request that has been cancelled', (
      tester,
    ) async {
      await present(
        tester,
        entries: [
          _connectEntry(itemState: const NotificationItemState.canceled()),
        ],
      );

      expect(presented(tester), isNull);
    });

    testWidgets('presents the next request once the current one is resolved', (
      tester,
    ) async {
      await present(
        tester,
        entries: [
          _connectEntry(id: 2, reqId: _reqB),
          _connectEntry(),
        ],
      );

      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();

      expect(presented(tester), (2, _reqB));
    });

    // Only the close affordance resolves a request by popping its own route.
    // An approval, an expiry and a remote cancel all leave the window to
    // `SwaptionDialog`, which removes that route by identity — and it is that
    // removal completing the awaited window that lets the queue move on. Each
    // is exercised separately, because an empty screen is also what a stalled
    // queue looks like.
    testWidgets('presents the next request when the current one is approved', (
      tester,
    ) async {
      await present(
        tester,
        entries: [_connectEntry(id: 2, reqId: _reqB), _connectEntry()],
      );

      await tester.tap(find.widgetWithText(CustomBigButton, 'Allow'));
      await tester.pumpAndSettle();

      expect(presented(tester), (2, _reqB));
    });

    testWidgets('presents the next request when the current one expires', (
      tester,
    ) async {
      await present(
        tester,
        entries: [_connectEntry(id: 2, reqId: _reqB), _connectEntry()],
      );

      // What the open dialog's own countdown effect does on reaching zero.
      container
          .read(notificationsProvider.notifier)
          .removeNotification(1, reason: NotificationRemovalReason.expired);
      await tester.pumpAndSettle();

      expect(presented(tester), (2, _reqB));
    });

    testWidgets(
      'presents the next request when the origin cancels the current one',
      (tester) async {
        await present(
          tester,
          entries: [_connectEntry(id: 2, reqId: _reqB), _connectEntry()],
        );

        container.read(notificationsProvider.notifier).cancelNotification(_reqA);
        await tester.pumpAndSettle();

        expect(presented(tester), (2, _reqB));
      },
    );

    testWidgets('presents several queued requests oldest first', (
      tester,
    ) async {
      await present(
        tester,
        entries: [
          _connectEntry(id: 3, reqId: _reqC),
          _connectEntry(id: 2, reqId: _reqB),
          _connectEntry(),
        ],
      );

      final order = <(int, String)?>[presented(tester)];

      for (var resolved = 0; resolved < 2; resolved++) {
        await tester.tap(find.byType(CustomBackButton));
        await tester.pumpAndSettle();
        order.add(presented(tester));
      }

      expect(order, [(1, _reqA), (2, _reqB), (3, _reqC)]);
    });
  });

  group('a request arriving while a dialog is open', () {
    testWidgets('opens no window', (tester) async {
      await present(tester, entries: [_connectEntry()]);

      seeded.setEntries([_connectEntry(id: 2, reqId: _reqB), _connectEntry()]);
      await tester.pumpAndSettle();

      expect(presented(tester), (1, _reqA));
    });

    // The queue is the pending set itself, not a holding pen beside it: a
    // request waiting its turn keeps counting towards everything read off that
    // set. ADR-0006 decision 5.
    testWidgets('still counts as pending while it waits', (tester) async {
      await present(tester, entries: [_connectEntry()]);

      seeded.setEntries([_connectEntry(id: 2, reqId: _reqB), _connectEntry()]);
      await tester.pumpAndSettle();

      expect(container.read(notificationsProvider), hasLength(2));
      expect(pendingBadgeCount(container.read(notificationsProvider)), 2);
      expect(container.read(activeNotificationsProvider), isTrue);
    });

    // Driven through the real delivery path rather than by replacing the list,
    // because that path does more than append: it also closes popups, and a
    // dialog taken away by an arrival would be recorded as a rejection the user
    // never made.
    testWidgets('leaves the open dialog alone when it arrives for real', (
      tester,
    ) async {
      await present(tester, entries: []);

      container
          .read(notificationsProvider.notifier)
          .addNotification(_arrival(reqId: _reqA));
      await tester.pumpAndSettle();

      expect(presented(tester), (1, _reqA));

      container
          .read(notificationsProvider.notifier)
          .addNotification(_arrival(reqId: _reqB));
      await tester.pumpAndSettle();

      expect(presented(tester), (1, _reqA));
      expect(seeded.removals, isEmpty);
    });
  });

  group('a queued request whose deadline has passed', () {
    testWidgets('is recorded as expired and never presented', (tester) async {
      await present(
        tester,
        entries: [
          _connectEntry(
            id: 2,
            reqId: _reqB,
            createdAt: DateTime.now().subtract(const Duration(seconds: 10)),
            ttlMilliseconds: Option.of(1000),
          ),
          _connectEntry(),
        ],
      );

      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();

      expect(seeded.removals, [
        (1, NotificationRemovalReason.rejectedByUser),
        (2, NotificationRemovalReason.expired),
      ]);
      expect(presented(tester), isNull);
    });

    testWidgets('is presented while its deadline is still ahead', (
      tester,
    ) async {
      await present(
        tester,
        entries: [
          _connectEntry(
            id: 2,
            reqId: _reqB,
            createdAt: DateTime.now(),
            ttlMilliseconds: Option.of(const Duration(hours: 1).inMilliseconds),
          ),
          _connectEntry(),
        ],
      );

      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();

      expect(presented(tester), (2, _reqB));

      // Resolved as well, so the countdown its dialog started is disposed with
      // it: a periodic timer left running outlives the test.
      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();
    });
  });

  // Every resolution is recorded by the path that performed it, before its
  // window goes; the listener only speaks for a window that closed with its
  // request still pending. ADR-0006 decision 4.
  group('resolutions', () {
    testWidgets('records only the acceptance the dialog performed', (
      tester,
    ) async {
      await present(tester, entries: [_connectEntry()]);

      await tester.tap(find.widgetWithText(CustomBigButton, 'Allow'));
      await tester.pumpAndSettle();

      expect(seeded.removals, [(1, NotificationRemovalReason.acceptedByUser)]);
    });

    // The sign twin, and not redundant: the sign acceptance path now crosses
    // the authentication gate and no longer pops its own window, so *when* the
    // listener's `await showDialog` resolves has changed. The safety net records
    // a rejection for any window found closed over a still-pending request, so
    // an acceptance that recorded itself after its window went would be
    // recorded twice — visible here and nowhere else. ADR-0006 decision 4.
    testWidgets('records only the acceptance a sign dialog performed', (
      tester,
    ) async {
      await present(tester, entries: [_signEntry()]);

      await tester.tap(find.widgetWithText(CustomBigButton, 'Broadcast'));
      await tester.pumpAndSettle();

      expect(seeded.removals, [(1, NotificationRemovalReason.acceptedByUser)]);
      expect(presented(tester), isNull);
    });

    testWidgets('records only the rejection the close affordance performed', (
      tester,
    ) async {
      await present(tester, entries: [_connectEntry()]);

      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();

      expect(seeded.removals, [(1, NotificationRemovalReason.rejectedByUser)]);
    });

    testWidgets('records an expiry without also recording a rejection', (
      tester,
    ) async {
      await present(tester, entries: [_connectEntry()]);

      // What the dialog's own countdown effect does when it reaches zero.
      container
          .read(notificationsProvider.notifier)
          .removeNotification(1, reason: NotificationRemovalReason.expired);
      await tester.pumpAndSettle();

      expect(seeded.removals, [(1, NotificationRemovalReason.expired)]);
      expect(presented(tester), isNull);
    });

    testWidgets(
      'records a remote cancellation without also recording a rejection',
      (tester) async {
        await present(tester, entries: [_connectEntry()]);

        container
            .read(notificationsProvider.notifier)
            .cancelNotification(_reqA);
        await tester.pumpAndSettle();

        expect(seeded.removals, [(1, NotificationRemovalReason.remoteCancel)]);
        expect(presented(tester), isNull);
      },
    );

    // The safety net itself: a window that went without any path having spoken
    // for the user leaves its request pending, and that is what is recorded as
    // a rejection — never an acceptance.
    testWidgets('records a rejection when a window closes with its request '
        'still pending', (tester) async {
      await present(tester, entries: [_connectEntry()]);

      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();

      expect(seeded.removals, [(1, NotificationRemovalReason.rejectedByUser)]);
      // Nothing went on the wire: the listener speaks for the pending set, not
      // to the origin.
      verifyNever(() => wallet.sendMsg(any()));
    });
  });
}
