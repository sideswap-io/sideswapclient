import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/signer_acceptance_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// Seeds the real notifier with a known list and lets a test replace it while
/// an acceptance is mid-flight.
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

const _reqA = 'req-A';
const _reqB = 'req-B';
const _origin = 'https://origin.test';

/// Matches the one message an acceptance is allowed to put on the wire.
Matcher _acceptanceFor(String reqId) => predicate<To>(
  (msg) =>
      msg.hasSignerResponse() &&
      msg.signerResponse.reqId == reqId &&
      msg.signerResponse.accept,
  'a signer response accepting $reqId',
);

/// Neither fixture carries a TTL, so nothing counts down under the test.
NotificationData _signEntry({
  int id = 1,
  String reqId = _reqA,
  NotificationItemState itemState = const NotificationItemState.empty(),
}) => NotificationData(
  id,
  NotificationType.signRequest(
    From_SignerRequest_Sign(),
    reqId,
    _origin,
    itemState,
    DateTime(2026, 1, 1),
    none<int>(),
  ),
);

NotificationData _connectEntry({
  int id = 1,
  String reqId = _reqA,
  NotificationItemState itemState = const NotificationItemState.empty(),
}) => NotificationData(
  id,
  NotificationType.connect(
    reqId,
    _origin,
    itemState,
    DateTime(2026, 1, 1),
    none<int>(),
  ),
);

void main() {
  late _MockWallet wallet;
  late _SeededNotifications seeded;
  late ProviderContainer container;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(To());
    // The default logger writes through path_provider, which has no
    // implementation under the test binding and surfaces as a stray
    // MissingPluginException after the test completes.
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  // FlavorConfig is a global the notifier reads while it is being built.
  // Restored before each test rather than after: end-of-test cleanup is skipped
  // when an earlier expectation throws (docs/TESTING.md).
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

    wallet = _MockWallet();
    seeded = _SeededNotifications([_signEntry()]);
    container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWithValue(wallet),
        notificationsProvider.overrideWith(() => seeded),
      ],
    );

    // Built eagerly so a test can replace the list while an attempt is at the
    // gate: `setEntries` writes `state`, which a notifier nothing has read yet
    // refuses. In the app the list notifier is `keepAlive` and always built.
    container.read(notificationsProvider);
  });

  /// The one call under test, always unawaited by its production caller.
  Future<void> accept({int notificationId = 1, String reqId = _reqA}) =>
      container
          .read(signerAcceptanceProvider.notifier)
          .accept(notificationId: notificationId, reqId: reqId);

  group('accept', () {
    test('sends the acceptance and records it as accepted by user', () async {
      when(() => wallet.isAuthenticated()).thenAnswer((_) async => true);

      await accept();

      verify(() => wallet.sendMsg(any(that: _acceptanceFor(_reqA)))).called(1);
      expect(container.read(notificationsProvider), isEmpty);
    });

    test(
      'sends nothing and releases the control when the gate refuses',
      () async {
        when(() => wallet.isAuthenticated()).thenAnswer((_) async => false);

        await accept();

        verifyNever(() => wallet.sendMsg(any()));
        expect(container.read(notificationsProvider), hasLength(1));
        expect(container.read(signerAcceptanceProvider), isEmpty);
      },
    );

    test('treats a gate that throws exactly like one that refuses', () async {
      when(
        () => wallet.isAuthenticated(),
      ).thenAnswer((_) => Future<bool>.error(Exception('biometrics channel')));

      // Completing normally is the claim: the call is deliberately unawaited in
      // production, so an escaping error would surface as an unhandled
      // asynchronous error while the control stayed busy.
      await accept();

      verifyNever(() => wallet.sendMsg(any()));
      expect(container.read(notificationsProvider), hasLength(1));
      expect(container.read(signerAcceptanceProvider), isEmpty);
    });

    group('single flight', () {
      late Completer<bool> gate;

      setUp(() {
        gate = Completer<bool>();
        when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);
      });

      test('a second attempt raises no second authentication prompt', () async {
        final first = accept();
        final second = accept();

        verify(() => wallet.isAuthenticated()).called(1);
        expect(container.read(signerAcceptanceProvider), {_reqA});

        gate.complete(true);
        await Future.wait([first, second]);

        verify(() => wallet.sendMsg(any(that: _acceptanceFor(_reqA))))
            .called(1);
        expect(container.read(signerAcceptanceProvider), isEmpty);
      });

      // The identity is the request id, not the pair — ADR-0009 decision 1. So
      // the same request re-delivered under a new local id (what `clearAll()`
      // produces: the counter keeps counting, so the next delivery is filed
      // under a number the cleared one never had) is still refused while the
      // outstanding attempt is at the gate: two prompts for one wire request
      // are what the rule forbids, and refiling it under a new local number
      // does not make it two requests.
      test(
        'a second attempt under a new notification id is refused too',
        () async {
          final first = accept();
          final second = accept(notificationId: 2);

          verify(() => wallet.isAuthenticated()).called(1);

          gate.complete(true);
          await Future.wait([first, second]);
        },
      );

      // The refused press must not run the `finally` that releases the first
      // attempt's guard — which is why the already-running check sits outside
      // the `try`. Without that placement the control re-arms while its own
      // prompt is still on screen, and a third press raises a second one.
      test(
        'a refused second attempt does not release the first attempt',
        () async {
          final first = accept();
          await accept();

          expect(container.read(signerAcceptanceProvider), {_reqA});

          await accept();
          verify(() => wallet.isAuthenticated()).called(1);

          gate.complete(false);
          await first;
        },
      );
    });

    // The four element-churn sequences the panel produces, and the whole point
    // of moving the acceptance out of the widget: in each one the element that
    // started the attempt is unmounted or repurposed while the gate is open,
    // and in each one the acceptance still reaches the wire. Driven here rather
    // than through the panel because after ADR-0009 nothing about an acceptance
    // depends on what the list does to its elements.
    group('while the panel changes shape under the attempt', () {
      late Completer<bool> gate;

      setUp(() {
        gate = Completer<bool>();
        when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);
        seeded.setEntries([_signEntry(), _connectEntry(id: 2, reqId: _reqB)]);
      });

      /// Completes the gate with the list left in [entries], and asserts the
      /// untouched attempt for [_reqA] still landed.
      Future<void> expectAcceptanceSurvives(
        List<NotificationData> entries,
      ) async {
        final attempt = accept();

        seeded.setEntries(entries);
        gate.complete(true);
        await attempt;

        verify(() => wallet.sendMsg(any(that: _acceptanceFor(_reqA))))
            .called(1);
        expect(container.read(signerAcceptanceProvider), isEmpty);
      }

      test('a different entry is removed', () async {
        await expectAcceptanceSurvives([_signEntry()]);
      });

      test('an arrival of the same kind is prepended', () async {
        await expectAcceptanceSurvives([
          _signEntry(id: 3, reqId: 'req-C'),
          _signEntry(),
          _connectEntry(id: 2, reqId: _reqB),
        ]);
      });

      test('an arrival of a different kind is prepended', () async {
        await expectAcceptanceSurvives([
          _connectEntry(id: 3, reqId: 'req-C'),
          _signEntry(),
          _connectEntry(id: 2, reqId: _reqB),
        ]);
      });

      test(
        'an unrelated request is left armed while this one is busy',
        () async {
          final attempt = accept();

          expect(container.read(signerAcceptanceProvider), {_reqA});
          expect(
            container.read(signerAcceptanceProvider).contains(_reqB),
            isFalse,
          );

          gate.complete(true);
          await attempt;
        },
      );
    });

    // Liveness, then identity, then state — ADR-0006 decision 2's order, kept
    // by ADR-0009 decision 2 with its first step re-pointed from a widget's
    // context to the notifier's `ref`. Tearing down the root container abandons
    // the attempt whatever the `keepAlive`, and reading through a disposed
    // `ref` throws exactly in the case the re-check exists to handle.
    test(
      'abandons the attempt when the container is torn down at the gate',
      () async {
        final gate = Completer<bool>();
        when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);

        final attempt = accept();

        container.dispose();
        gate.complete(true);

        // Completing normally is half the claim: the failure this guards is a
        // `StateError` out of a future nobody awaits.
        await attempt;

        verifyNever(() => wallet.sendMsg(any()));
      },
    );

    // The three ways `pendingRequestProvider` answers `none()`. Each is driven
    // by mutating the list *while the gate is open*, which is the window
    // ADR-0006 decision 2's re-check exists to cover: the gate is an ordinary
    // route with the request's timers running underneath it.
    group('when the request stopped being pending while the gate was open', () {
      late Completer<bool> gate;

      setUp(() {
        gate = Completer<bool>();
        when(() => wallet.isAuthenticated()).thenAnswer((_) => gate.future);
      });

      test('sends nothing when the entry became absent', () async {
        final attempt = accept();

        seeded.setEntries([]);
        gate.complete(true);
        await attempt;

        verifyNever(() => wallet.sendMsg(any()));
        expect(container.read(signerAcceptanceProvider), isEmpty);
      });

      test('sends nothing when the entry was cancelled', () async {
        final attempt = accept();

        seeded.setEntries([
          _signEntry(itemState: const NotificationItemState.canceled()),
        ]);
        gate.complete(true);
        await attempt;

        verifyNever(() => wallet.sendMsg(any()));
        expect(container.read(signerAcceptanceProvider), isEmpty);
      });

      test(
        'sends nothing when the id now carries a different request',
        () async {
          final attempt = accept();

          seeded.setEntries([_signEntry(reqId: _reqB)]);
          gate.complete(true);
          await attempt;

          verifyNever(() => wallet.sendMsg(any()));
          expect(container.read(signerAcceptanceProvider), isEmpty);
        },
      );
    });
  });
}
