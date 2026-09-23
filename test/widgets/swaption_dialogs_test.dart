import 'dart:async';
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
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swaption/swaption_dialogs.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// Records which route each navigator operation took.
///
/// Route identity is the whole subject here and it cannot be read off the
/// rendered tree: a dialog under an opaque route is offstage, so a finder
/// reports it missing whether or not its route was ever taken away. Only the
/// navigator says which route actually went.
class _RouteRecorder extends NavigatorObserver {
  final pushed = <Route<dynamic>>[];
  final gone = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      pushed.add(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      gone.add(route);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      gone.add(route);
}

/// Seeds the real notifier with a known list and lets a test replace it while a
/// dialog is open.
///
/// Overriding [build] rather than driving `addNotification` keeps the entries'
/// ids and request ids under the test's control, which is what makes the
/// identity cases expressible at all. Everything else is the real
/// implementation.
class _SeededNotifications extends Notifications {
  _SeededNotifications(this._seed);

  final List<NotificationData> _seed;

  @override
  List<NotificationData> build() => _seed;

  void setEntries(List<NotificationData> entries) => state = entries;
}

/// Records the reason every removal was made under.
///
/// The reason is the externally observable fact these tests are about — a
/// resolution is what the rest of the app reads back — so it is recorded
/// rather than reconstructed from the list.
class _RecordingNotifications extends _SeededNotifications {
  _RecordingNotifications(super.seed);

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

/// Serves the one SVG the connect dialog paints.
///
/// `tools/coverage.dart` runs with `--no-test-assets`, so the real bundle has
/// nothing under `assets/`.
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
const _originA = 'https://origin-a.test';
const _originB = 'https://origin-b.test';

/// The copy the dialogs interpolate, taken from `assets/translations/en.json`.
///
/// Loaded explicitly because easy_localization falls back to the key when no
/// translations are present, which would render the countdown as
/// `Time-to-live: {} seconds.other` and make its assertions meaningless.
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

/// Matches the one message a resolution is allowed to put on the wire.
Matcher _responseFor(String reqId, {required bool accept}) => predicate<To>(
  (msg) =>
      msg.hasSignerResponse() &&
      msg.signerResponse.reqId == reqId &&
      msg.signerResponse.accept == accept,
  'a signer response ${accept ? 'accepting' : 'rejecting'} $reqId',
);

NotificationData _signEntry({
  int id = 1,
  String reqId = _reqA,
  String origin = _originA,
  NotificationItemState itemState = const NotificationItemState.empty(),
  Option<int> ttlMilliseconds = const None(),
  DateTime? createdAt,
}) => NotificationData(
  id,
  NotificationType.signRequest(
    From_SignerRequest_Sign(),
    reqId,
    origin,
    itemState,
    createdAt ?? DateTime(2026, 1, 1),
    ttlMilliseconds,
  ),
);

NotificationData _connectEntry({
  int id = 1,
  String reqId = _reqA,
  String origin = _originA,
  NotificationItemState itemState = const NotificationItemState.empty(),
  Option<int> ttlMilliseconds = const None(),
  DateTime? createdAt,
}) => NotificationData(
  id,
  NotificationType.connect(
    reqId,
    origin,
    itemState,
    createdAt ?? DateTime(2026, 1, 1),
    ttlMilliseconds,
  ),
);

/// Builds one dialog's fixture, with the fields the cases below vary left open
/// and every other field on its default.
typedef _EntryBuilder =
    NotificationData Function({
      String reqId,
      NotificationItemState itemState,
      Option<int> ttlMilliseconds,
      DateTime? createdAt,
    });

/// The two dialogs that carry the same acceptance path, each with the label of
/// the control that approves it. Only the fixture and that label differ, so the
/// cases below are driven through both.
final _dialogKinds = <({String name, String label, _EntryBuilder entry})>[
  (name: 'a connect request', label: 'Allow', entry: _connectEntry),
  (name: 'a sign request', label: 'Broadcast', entry: _signEntry),
];

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(To());
    // The default logger writes through path_provider, which has no
    // implementation under the test binding and surfaces as a stray
    // MissingPluginException after the test completes.
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  late _MockWallet wallet;
  late _RecordingNotifications seeded;
  late _RouteRecorder routes;

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

  /// Pumps an app and opens [SwaptionDialog] on its root navigator, the way
  /// `SwaptionNotificationListener` does.
  ///
  /// Returns the navigator key. The route carries no value: what a resolution
  /// was is read from the reason it was recorded under, never from what the
  /// window closed with — a closing value goes to whatever route is on top, and
  /// wallet authentication is a route on this same navigator. ADR-0006
  /// decision 4.
  Future<GlobalKey<NavigatorState>> pumpDialog(
    WidgetTester tester, {
    required List<NotificationData> entries,
    int notificationId = 1,
    String reqId = _reqA,
  }) async {
    // Wide enough that the site row lays the origin out beside its label
    // without overflowing under the test font, which is wider than the shipped
    // one.
    tester.view.physicalSize = const Size(1440, 2800);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    routes = _RouteRecorder();
    seeded = _RecordingNotifications(entries);
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          walletProvider.overrideWithValue(wallet),
          notificationsProvider.overrideWith(() => seeded),
        ],
        child: DefaultAssetBundle(
          bundle: _StubAssetBundle(),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [routes],
            // NoSplash avoids Material's InkSparkle fragment shader, whose
            // asset is unavailable under `--no-test-assets`. CustomBigButton
            // reads its style extension through a null-check, so the test theme
            // must carry one just as the app's does.
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              extensions: [CustomBigButtonStyle()],
            ),
            home: const Scaffold(body: SizedBox.expand()),
          ),
        ),
      ),
    );

    unawaited(
      showDialog<void>(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (_) =>
            SwaptionDialog(notificationId: notificationId, reqId: reqId),
      ),
    );
    await tester.pumpAndSettle();

    return navigatorKey;
  }

  group('SwaptionDialog identity', () {
    testWidgets('keeps showing its own request when a second request arrives', (
      tester,
    ) async {
      final entry = _connectEntry();
      await pumpDialog(tester, entries: [entry]);

      expect(find.text(_originA), findsWidgets);

      // A second request arriving repoints the global selection today; the
      // dialog must not follow it.
      seeded.setEntries([
        _connectEntry(id: 2, reqId: _reqB, origin: _originB),
        entry,
      ]);
      await tester.pumpAndSettle();

      expect(find.text(_originA), findsWidgets);
      expect(find.text(_originB), findsNothing);
    });
  });

  group('SwaptionDialog teardown', () {
    testWidgets('closes its own window when its request is removed', (
      tester,
    ) async {
      await pumpDialog(tester, entries: [_connectEntry()]);

      expect(find.byType(SwaptionDialog), findsOneWidget);

      seeded.setEntries([]);
      await tester.pumpAndSettle();

      expect(find.byType(SwaptionDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('closes its window when its entry is cancelled', (
      tester,
    ) async {
      await pumpDialog(tester, entries: [_connectEntry()]);

      seeded.setEntries([
        _connectEntry(itemState: const NotificationItemState.canceled()),
      ]);
      await tester.pumpAndSettle();

      expect(find.byType(SwaptionDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });

    // The case route teardown by identity exists for: wallet authentication is
    // itself a route on this navigator, so a teardown that took the top route
    // would take whatever is above instead. ADR-0006 decision 3.
    testWidgets(
      'closes its own window and leaves the route above it in place',
      (tester) async {
        final navigatorKey = await pumpDialog(
          tester,
          entries: [_connectEntry()],
        );
        final dialogRoute = routes.pushed.last;

        final above = MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('above')),
        );
        navigatorKey.currentState!.push(above);
        await tester.pumpAndSettle();

        expect(find.text('above'), findsOneWidget);

        seeded.setEntries([]);
        await tester.pumpAndSettle();

        // The dialog's own route went, and only it. Asserted through the
        // navigator rather than the tree: under an opaque route the dialog is
        // offstage, so a finder reports it missing either way.
        expect(routes.gone, [dialogRoute]);
        expect(above.isActive, isTrue);
        expect(find.text('above'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('SwaptionDialog countdown', () {
    /// The seconds the dialog is currently showing.
    int renderedTtl(WidgetTester tester) {
      final text = tester
          .widgetList<Text>(find.textContaining('Time-to-live:'))
          .single
          .data!;
      return int.parse(RegExp(r'\d+').firstMatch(text)!.group(0)!);
    }

    // Identity is fixed, but the entry behind it stays live — so the countdown
    // a dialog shows keeps running for as long as its window is up.
    testWidgets('keeps counting down while the dialog is open', (tester) async {
      // The countdown is driven by a periodic timer against the wall clock, so
      // it only advances under real time: pumping fake time fires the timer but
      // leaves `DateTime.now()` where it was.
      await tester.runAsync(() async {
        await pumpDialog(
          tester,
          entries: [
            _connectEntry(
              createdAt: DateTime.now(),
              // An hour, not seconds: the wait below is real time, so a
              // deadline this test could reach on a slow machine would make it
              // flaky rather than strict.
              ttlMilliseconds: Option.of(
                const Duration(hours: 1).inMilliseconds,
              ),
            ),
          ],
        );

        final before = renderedTtl(tester);

        // Longer than a whole second, so the truncating division is certain to
        // have moved on.
        await Future<void>.delayed(const Duration(milliseconds: 1100));
        await tester.pump();

        expect(renderedTtl(tester), lessThan(before));
      });
    });
  });

  // The dialog does not record an expiry any more — nothing mounted does. The
  // notifier sweeps the request out of the pending set on its own timer, and
  // what is left here is the dialog's reaction to that removal. The sweep's own
  // behaviour is covered where it can be asserted with nothing mounted, in
  // `test/providers/notifications_provider_test.dart`. ADR-0010 decision 5.
  group('SwaptionDialog expiry', () {
    // A request carrying no countdown is not expired locally: there is no
    // deadline to enforce and none is invented. Stated as "no expiry is
    // recorded" rather than "it never leaves" — such a request can still go
    // through remote cancel or a user action. ADR-0006 decision 7.
    testWidgets('records no expiry for a request that carries no countdown', (
      tester,
    ) async {
      await tester.runAsync(() async {
        // No TTL: the fixture default.
        await pumpDialog(tester, entries: [_connectEntry()]);

        await Future<void>.delayed(const Duration(milliseconds: 1100));
        await tester.pump();

        expect(seeded.removals, isEmpty);
      });
    });

    // Expiry records the resolution and nothing else; taking the window away is
    // the router's job, from the request leaving the pending set. The trigger
    // is the sweep now rather than an effect inside the dialog — the seeded
    // harness overrides `build` without calling `super.build`, so no arming
    // ever ran for these entries and the fire is made directly.
    for (final kind in _dialogKinds) {
      testWidgets('${kind.name} that is swept loses its dialog window', (
        tester,
      ) async {
        await pumpDialog(
          tester,
          entries: [
            kind.entry(
              // Already past its deadline when the dialog opens.
              createdAt: DateTime.now().subtract(const Duration(seconds: 10)),
              ttlMilliseconds: Option.of(1000),
            ),
          ],
        );
        final dialogRoute = routes.pushed.last;

        seeded.sweepExpired();
        await tester.pumpAndSettle();

        expect(seeded.removals, [(1, NotificationRemovalReason.expired)]);
        expect(routes.gone, contains(dialogRoute));
        expect(find.byType(SwaptionDialog), findsNothing);
      });
    }

    testWidgets('a sign request shows its countdown too', (tester) async {
      await tester.runAsync(() async {
        await pumpDialog(
          tester,
          entries: [
            _signEntry(
              createdAt: DateTime.now(),
              ttlMilliseconds: Option.of(
                const Duration(hours: 1).inMilliseconds,
              ),
            ),
          ],
        );

        expect(find.textContaining('Time-to-live:'), findsOneWidget);
      });
    });
  });

  // A request can be gone before its dialog's first frame: the listener checks
  // the request is present, then defers opening the window to a microtask.
  group('SwaptionDialog opened for a request already resolved', () {
    testWidgets('takes its window away without waiting for a change', (
      tester,
    ) async {
      await pumpDialog(tester, entries: [_connectEntry(id: 2, reqId: _reqB)]);

      // The dialog was opened for (1, req-A), which the list does not hold.
      expect(routes.gone, hasLength(1));
      expect(find.byType(SwaptionDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  // Every resolution names its own reason, and the recorded reason — not the
  // value the window closed with — is what says what happened. Each assertion
  // is against the whole list of removals rather than `contains`, because
  // "records the expiry and not also a rejection" is a statement about what
  // else was recorded. ADR-0006 decision 4.
  group('SwaptionDialog resolution', () {
    testWidgets('approving records the request as accepted', (tester) async {
      await pumpDialog(tester, entries: [_connectEntry()]);
      final dialogRoute = routes.pushed.last;

      await tester.tap(find.widgetWithText(CustomBigButton, 'Allow'));
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: true))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.acceptedByUser)]);
      // The approval crossed an authentication await, so it leaves the window
      // to removal by identity rather than popping whatever is on top.
      expect(routes.gone, [dialogRoute]);
    });

    // A refused gate is not a resolution: the request is still pending, and the
    // dialog the user was refused at stays where it is. ADR-0006 decision 6.
    testWidgets('a refused authentication records nothing and keeps the '
        'dialog open', (tester) async {
      when(() => wallet.isAuthenticated()).thenAnswer((_) async => false);

      await pumpDialog(tester, entries: [_connectEntry()]);

      await tester.tap(find.widgetWithText(CustomBigButton, 'Allow'));
      await tester.pumpAndSettle();

      verifyNever(() => wallet.sendMsg(any()));
      expect(seeded.removals, isEmpty);
      expect(find.byType(SwaptionConnectDialog), findsOneWidget);
      expect(routes.gone, isEmpty);
      // The control comes back, so the user can authenticate again. A refused
      // gate that left it disabled would make the close affordance the only way
      // out of a request the user meant to approve. ADR-0006 decision 6.
      expect(
        tester
            .widget<CustomBigButton>(
              find.widgetWithText(CustomBigButton, 'Allow'),
            )
            .onPressed,
        isNotNull,
      );
    });

    testWidgets('the close affordance sends the rejection and records it', (
      tester,
    ) async {
      await pumpDialog(tester, entries: [_connectEntry()]);
      final dialogRoute = routes.pushed.last;

      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: false))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.rejectedByUser)]);
      expect(routes.gone, [dialogRoute]);
    });

    // Reachable only while this dialog is on top, so it crossed no await and
    // may close its own window directly — and must take only its own.
    testWidgets('the device back button behaves identically to the close '
        'affordance', (tester) async {
      final navigatorKey = await pumpDialog(tester, entries: [_connectEntry()]);
      final dialogRoute = routes.pushed.last;

      final below = navigatorKey.currentState!;

      await simulateSystemBack();
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: false))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.rejectedByUser)]);
      // Only the dialog's own route went: the screen underneath it is still
      // there, which a framework-driven pop would have taken instead.
      expect(routes.gone, [dialogRoute]);
      expect(below.canPop(), isFalse);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('a sign request records its acceptance the same way', (
      tester,
    ) async {
      await pumpDialog(tester, entries: [_signEntry()]);
      final dialogRoute = routes.pushed.last;

      await tester.tap(find.widgetWithText(CustomBigButton, 'Broadcast'));
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: true))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.acceptedByUser)]);
      verify(() => wallet.isAuthenticated()).called(1);
      // This approval crossed the gate, so it leaves the window to removal by
      // identity rather than popping whatever is on top.
      expect(routes.gone, [dialogRoute]);
    });

    // The gate is a route on this same navigator, so a programmatic pop issued
    // from the acceptance path would take the prompt instead of this dialog —
    // which is why the path that crossed an await removes by identity.
    // ADR-0006 decision 3.
    testWidgets('an approved sign request takes its own window and leaves the '
        'route above it in place', (tester) async {
      final gate = Completer<bool>();
      when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);

      final navigatorKey = await pumpDialog(tester, entries: [_signEntry()]);
      final dialogRoute = routes.pushed.last;

      await tester.tap(find.widgetWithText(CustomBigButton, 'Broadcast'));
      await tester.pump();

      // Stands in for the authentication prompt: a route pushed over this
      // dialog while the gate is outstanding.
      final above = MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('above')),
      );
      unawaited(navigatorKey.currentState!.push(above));
      await tester.pumpAndSettle();

      gate.complete(true);
      await tester.pumpAndSettle();

      expect(routes.gone, [dialogRoute]);
      expect(above.isActive, isTrue);
      expect(find.text('above'), findsOneWidget);
    });

    // Stated as an ordering rather than as co-occurrence: an acceptance built
    // before the gate and sent after it would satisfy "the gate ran", so what
    // is asserted is that nothing has left the app while the gate is still
    // outstanding. ADR-0006 decision 1.
    testWidgets(
      'a sign request sends nothing until authentication has returned',
      (tester) async {
        final gate = Completer<bool>();
        when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);

        await pumpDialog(tester, entries: [_signEntry()]);

        await tester.tap(find.widgetWithText(CustomBigButton, 'Broadcast'));
        await tester.pump();

        verifyNever(() => wallet.sendMsg(any()));
        expect(seeded.removals, isEmpty);

        gate.complete(true);
        await tester.pumpAndSettle();

        verify(
          () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: true))),
        ).called(1);
        expect(seeded.removals, [
          (1, NotificationRemovalReason.acceptedByUser),
        ]);
      },
    );

    // The sign twin of the connect case above. A refused gate is not a
    // resolution: nothing is sent, nothing is recorded, and the window the user
    // was refused at is left standing so they can try again. ADR-0006
    // decision 6.
    testWidgets('a refused authentication on a sign request records nothing '
        'and keeps the dialog open', (tester) async {
      when(() => wallet.isAuthenticated()).thenAnswer((_) async => false);

      await pumpDialog(tester, entries: [_signEntry()]);

      await tester.tap(find.widgetWithText(CustomBigButton, 'Broadcast'));
      await tester.pumpAndSettle();

      verifyNever(() => wallet.sendMsg(any()));
      expect(seeded.removals, isEmpty);
      expect(find.byType(SwaptionSignRequestDialog), findsOneWidget);
      expect(routes.gone, isEmpty);
    });

    testWidgets('a sign request records its rejection the same way', (
      tester,
    ) async {
      await pumpDialog(tester, entries: [_signEntry()]);
      final dialogRoute = routes.pushed.last;

      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: false))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.rejectedByUser)]);
      expect(routes.gone, [dialogRoute]);
    });

    // The sign twin of the connect case above. Reachable only while this dialog
    // is on top, so it crossed no await and may close its own window directly —
    // and must take only its own.
    testWidgets('the device back button on a sign request sends the rejection', (
      tester,
    ) async {
      final navigatorKey = await pumpDialog(tester, entries: [_signEntry()]);
      final dialogRoute = routes.pushed.last;

      final below = navigatorKey.currentState!;

      await simulateSystemBack();
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: false))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.rejectedByUser)]);
      expect(routes.gone, [dialogRoute]);
      expect(below.canPop(), isFalse);
      expect(find.byType(Scaffold), findsOneWidget);
      // The rejection path never reaches the gate.
      verifyNever(() => wallet.isAuthenticated());
    });

    // The retry ADR-0006 decision 6 promises has to actually land, not merely
    // be reachable: the control coming back is asserted above, and this is the
    // second attempt succeeding. Driven through both dialogs, since the flag
    // that could strand either one is per-dialog state.
    for (final kind in _dialogKinds) {
      testWidgets(
        'after a refused authentication ${kind.name} can be approved again',
        (tester) async {
          when(() => wallet.isAuthenticated()).thenAnswer((_) async => false);

          await pumpDialog(tester, entries: [kind.entry()]);

          final approve = find.widgetWithText(CustomBigButton, kind.label);

          await tester.tap(approve);
          await tester.pumpAndSettle();

          verifyNever(() => wallet.sendMsg(any()));
          expect(seeded.removals, isEmpty);

          // The user authenticates successfully the second time.
          when(() => wallet.isAuthenticated()).thenAnswer((_) async => true);

          await tester.tap(approve);
          await tester.pumpAndSettle();

          verify(
            () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: true))),
          ).called(1);
          expect(seeded.removals, [
            (1, NotificationRemovalReason.acceptedByUser),
          ]);
        },
      );
    }

    // Awaiting the gate opens a window in which the request can be resolved
    // underneath the prompt — its deadline elapses, or the origin withdraws it.
    // Nothing is sent into that window. ADR-0006 decision 2.
    //
    // Both dialogs carry the same acceptance path, so both are driven through
    // the same three ways a request can stop being pending — the three the
    // provider answers `none()` for.
    //
    // No frame is pumped between the resolution and the gate returning, which
    // is what makes these tests about the re-check rather than about the
    // mounted guard: a rebuild would unmount the dialog and the guard above
    // would answer first, leaving the re-check unexercised. The interleaving
    // is the honest one — `removeNotification` updates the provider
    // synchronously, but the rebuild that unmounts this widget is a frame away,
    // so the continuation really can resume with the widget still mounted and
    // the request already gone.
    for (final kind in _dialogKinds) {
      group('${kind.name} resolved while authentication was open', () {
        /// Taps approve, resolves the request the way [resolveTo] says, and
        /// only then lets the gate return.
        Future<void> approveWhile(
          WidgetTester tester, {
          required List<NotificationData> resolveTo,
        }) async {
          final gate = Completer<bool>();
          when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);

          await pumpDialog(tester, entries: [kind.entry()]);

          await tester.tap(find.widgetWithText(CustomBigButton, kind.label));
          await tester.pump();

          seeded.setEntries(resolveTo);
          gate.complete(true);
          await tester.pumpAndSettle();
        }

        testWidgets('sends no acceptance when the request became absent', (
          tester,
        ) async {
          await approveWhile(tester, resolveTo: []);

          verifyNever(() => wallet.sendMsg(any()));
          expect(seeded.removals, isEmpty);
        });

        // Set directly rather than through `cancelNotification`, whose
        // follow-up removes the entry outright — which would make this the
        // absence case again instead of the cancelled one.
        testWidgets('sends no acceptance when the entry is cancelled', (
          tester,
        ) async {
          await approveWhile(
            tester,
            resolveTo: [
              kind.entry(itemState: const NotificationItemState.canceled()),
            ],
          );

          verifyNever(() => wallet.sendMsg(any()));
          expect(seeded.removals, isEmpty);
        });

        // The local id is an arrival counter, so a bare integer is not an
        // identity: presence alone would accept this entry even though the
        // request id says it is not the one the press was about. The pairing is
        // seeded rather than delivered: `addNotification` mints one id per
        // delivery from a counter that only goes up (#211), so it never files
        // two *different* requests under one id.
        testWidgets(
          'sends no acceptance when the entry carries a different request id',
          (tester) async {
            await approveWhile(tester, resolveTo: [kind.entry(reqId: _reqB)]);

            verifyNever(() => wallet.sendMsg(any()));
            expect(seeded.removals, isEmpty);
          },
        );
      });
    }

    // The authentication prompt is itself a route on this navigator. A second
    // one raised over a dialog that is on its way out would outlive it, and its
    // answer would land on nothing. ADR-0006 decision 4.
    testWidgets('a second tap while authenticating raises no second prompt', (
      tester,
    ) async {
      final gate = Completer<bool>();
      when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);

      await pumpDialog(tester, entries: [_connectEntry()]);

      // No pump between the taps: that is what "rapid" means here, and it is
      // the only case the in-body guard has to catch, since the rebuild that
      // disables the control has not landed yet. Pumping between them would
      // leave the guard unexercised and assert only the disabled control.
      await tester.tap(find.widgetWithText(CustomBigButton, 'Allow'));
      await tester.tap(find.widgetWithText(CustomBigButton, 'Allow'));

      verify(() => wallet.isAuthenticated()).called(1);
      await tester.pump();

      // Disabled rather than merely inert: the control says an attempt is
      // outstanding. ADR-0006 decision 4.
      expect(
        tester
            .widget<CustomBigButton>(
              find.widgetWithText(CustomBigButton, 'Allow'),
            )
            .onPressed,
        isNull,
      );

      gate.complete(true);
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: true))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.acceptedByUser)]);
    });

    testWidgets('a second tap on a sign request raises no second prompt', (
      tester,
    ) async {
      final gate = Completer<bool>();
      when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);

      await pumpDialog(tester, entries: [_signEntry()]);

      final broadcast = find.widgetWithText(CustomBigButton, 'Broadcast');

      // No pump between the taps: that is what "rapid" means here, and it is
      // the only case the in-body guard has to catch, since the rebuild that
      // disables the control has not landed yet.
      await tester.tap(broadcast);
      await tester.tap(broadcast);

      // The attempt count is the behaviour under test, so it is asserted as a
      // count — see docs/TESTING.md on when a count is meaningful.
      verify(() => wallet.isAuthenticated()).called(1);
      await tester.pump();

      // Disabled rather than merely inert: the control says an attempt is
      // outstanding. ADR-0006 decision 4.
      expect(tester.widget<CustomBigButton>(broadcast).onPressed, isNull);

      gate.complete(true);
      await tester.pumpAndSettle();

      verify(
        () => wallet.sendMsg(any(that: _responseFor(_reqA, accept: true))),
      ).called(1);
      expect(seeded.removals, [(1, NotificationRemovalReason.acceptedByUser)]);
    });
  });
}

/// Presses the device back button, which reaches the app as a platform message
/// rather than through the widget tree.
///
/// `flutter_test` does not export a helper for this; this is the one from
/// Flutter's own `packages/flutter/test/widgets/navigator_utils.dart`.
Future<void> simulateSystemBack() {
  return TestDefaultBinaryMessengerBinding
      .instance
      .defaultBinaryMessenger
      .handlePlatformMessage(
        'flutter/navigation',
        const JSONMethodCodec().encodeMethodCall(
          const MethodCall('popRoute'),
        ),
        (_) {},
      );
}
