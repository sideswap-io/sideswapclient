import 'dart:async';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/d_notifications.dart';
import 'package:sideswap/desktop/widgets/d_notifications_style.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
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
/// identity case (an id handed to the lookup alongside a request id it does not
/// belong to) expressible at all: `addNotification` mints one id per delivery
/// from a counter that only ever goes up (#211), so it never files two
/// *different* requests under one id, and the pairing has to be seeded.
/// Everything else — `getNotification` and `removeNotification` — is the real
/// implementation.
class _SeededNotifications extends Notifications {
  _SeededNotifications(this._seed);

  final List<NotificationData> _seed;

  @override
  List<NotificationData> build() => _seed;

  void setEntries(List<NotificationData> entries) => state = entries;
}

/// Stands in for `NotificationMenu`, which watches the notification list and
/// rebuilds its items from it (`d_notifications.dart:260`, `:394-448`).
///
/// The items themselves only watch `notificationsProvider.notifier`, which does
/// not re-emit on a state change, so without a parent watching the list an item
/// pumped on its own would never rebuild when the list changes.
/// Lets a test raise the "show the menu for this request" signal the
/// notification listener raises, without the request delivery it comes from.
class _SeededShowMenu extends ShowNotificationMenu {
  @override
  Option<int> build() => none();
}

class _Host extends ConsumerWidget {
  const _Host(this.builder);

  final Widget Function() builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsProvider);
    return builder();
  }
}

const _reqA = 'req-A';
const _reqB = 'req-B';
const _origin = 'https://origin.test';

const _connectStyle = NotificationItemConnectRequestStyle();
const _signStyle = NotificationItemSignRequestStyle();
const _menuStyle = NotificationMenuStyle(
  decoration: BoxDecoration(color: Color(0xFF102437)),
  padding: EdgeInsets.all(10.0),
);

/// What each item lays itself out at, pending and remotely cancelled, and the
/// chrome the panel adds around its first item — all fixed in
/// `d_notifications.dart` (`notificationItemHeight`).
const _signItemHeight = 475.0;
const _connectItemHeight = 358.0;
const _cancelledSignItemHeight = 110.0;
const _cancelledConnectItemHeight = 182.0;
const _menuChrome = 58.0;

/// What the panel is, with nothing in it: the empty item has no height of its
/// own, so this is a standalone number rather than an item plus the chrome.
const _emptyMenuHeight = 163.0;

const _cancelled = NotificationItemState.canceled();

/// Matches the one message an acceptance is allowed to put on the wire.
Matcher _acceptanceFor(String reqId) => predicate<To>(
  (msg) =>
      msg.hasSignerResponse() &&
      msg.signerResponse.reqId == reqId &&
      msg.signerResponse.accept,
  'a signer response accepting $reqId',
);

/// Matches the one message a rejection is allowed to put on the wire.
Matcher _rejectionFor(String reqId) => predicate<To>(
  (msg) =>
      msg.hasSignerResponse() &&
      msg.signerResponse.reqId == reqId &&
      !msg.signerResponse.accept,
  'a signer response rejecting $reqId',
);

/// Builds the one entry a test seeds the notifier with.
///
/// Both fixtures below share this signature so the kind table can hold either.
/// Neither carries a TTL: `SignRequestNotificationTtl.build` returns `none()`
/// before it creates its periodic timer, so nothing counts down under the test.
typedef _Entry = NotificationData Function({
  int id,
  String reqId,
  NotificationItemState itemState,
});

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
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(To());
    // The default logger writes through path_provider, which has no
    // implementation under the test binding and surfaces as a stray
    // MissingPluginException after the test completes.
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  late _MockWallet wallet;
  late Completer<bool> auth;
  late _SeededNotifications seeded;

  /// What the panel is currently rendering at this item's position, or `null`
  /// once the element is gone.
  ///
  /// The element is unmounted and repurposed through this rather than through a
  /// second `pumpWidget`, which would replace the `ProviderScope` as well — and
  /// a torn-down container abandons an attempt for its own reason, so a test
  /// driven that way would keep passing while proving nothing about the element.
  late ValueNotifier<NotificationData?> rendered;

  // Both are process- or test-wide state, so they are rebuilt before each test
  // rather than cleaned up after one: end-of-test cleanup is skipped when an
  // expectation throws, and under a randomised seed the next test would then
  // run on whatever the failed one left behind (docs/TESTING.md). `seeded` is
  // per-test by construction — `pumpItem` builds a fresh one from the entry the
  // test seeds.
  setUp(() {
    Localization.load(const Locale('en'));
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
    auth = Completer<bool>();
    when(() => wallet.isAuthenticated()).thenAnswer((_) => auth.future);
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  /// Sizes the test view for one test and puts it back afterwards.
  void sizeView(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// The scope every harness below pumps into: the mock wallet and the list the
  /// test seeded, behind whatever the harness puts on screen.
  ///
  /// The two optionals are only pinned when a harness asks for them, so a
  /// harness that does not ask keeps the real provider. A [navigatorKey] is
  /// handed to the app *and* to `navigatorKeyProvider` from here rather than by
  /// the caller, because the overlay lookup only works when both are the same
  /// instance. Riverpod 3 does not export the `Override` type, so the pinned
  /// providers are named parameters rather than a list the caller assembles.
  Widget appWith(
    Widget body, {
    List<ThemeExtension<dynamic>> extensions = const [],
    bool? activeNotifications,
    GlobalKey<NavigatorState>? navigatorKey,
    ShowNotificationMenu? showMenu,
  }) => ProviderScope(
    overrides: [
      walletProvider.overrideWithValue(wallet),
      notificationsProvider.overrideWith(() => seeded),
      if (showMenu != null)
        showNotificationMenuProvider.overrideWith(() => showMenu),
      if (activeNotifications != null)
        activeNotificationsProvider.overrideWithValue(activeNotifications),
      if (navigatorKey != null)
        navigatorKeyProvider.overrideWithValue(navigatorKey),
    ],
    child: MaterialApp(
      navigatorKey: navigatorKey,
      // NoSplash avoids Material's InkSparkle fragment shader, whose asset is
      // unavailable under `--no-test-assets` (tools/coverage.dart).
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        extensions: extensions,
      ),
      home: Scaffold(body: body),
    ),
  );

  /// Settles the authentication gate and lets the rebuild it releases land.
  ///
  /// Plain async rather than a `runAsync` of its own: every call site is
  /// already inside one, and `runAsync` refuses to nest.
  Future<void> resolveGate(WidgetTester tester, {required bool allowed}) async {
    auth.complete(allowed);
    await Future<void>.delayed(Duration.zero);
    await tester.pump();
  }

  // The desktop theme resolves through throwaway ProviderContainers that leave
  // dispose timers on riverpod's scheduler; those never settle under the test
  // binding's fake async, so every pump/tap runs inside `runAsync`.
  Future<void> pumpItem(
    WidgetTester tester, {
    required NotificationData entry,
    required Widget Function(NotificationData entry) itemBuilder,
  }) => tester.runAsync(() async {
    sizeView(tester, const Size(700, 900));

    seeded = _SeededNotifications([entry]);
    rendered = ValueNotifier<NotificationData?>(entry);
    addTearDown(rendered.dispose);

    await tester.pumpWidget(
      appWith(
        _Host(
          () => ValueListenableBuilder<NotificationData?>(
            valueListenable: rendered,
            builder: (_, current, _) => current == null
                ? const SizedBox.shrink()
                : itemBuilder(current),
          ),
        ),
      ),
    );
  });

  // Both items answer a press through the one acceptance path — the gate, the
  // re-check and the single-flight all live in `SignerAcceptance` now, and each
  // item only asks it and reads its own request's busy state back (ADR-0009
  // decision 2) — so both are driven through the same scenarios. Only the
  // fixture, the widget and the button label differ. Neither item reads the
  // payload it is constructed with: both re-derive everything from
  // `getNotification(notificationId)`.
  for (final kind
      in <
        ({
          String name,
          String label,
          _Entry entry,
          Widget Function(NotificationData entry) builder,
        })
      >[
        (
          name: 'NotificationItemConnectRequest',
          label: 'Connect',
          entry: _connectEntry,
          builder: (entry) => NotificationItemConnectRequest(
            notificationId: entry.id,
            connect: entry.type as NotificationTypeConnect,
            style: _connectStyle,
          ),
        ),
        (
          name: 'NotificationItemSignRequest',
          label: 'Broadcast',
          entry: _signEntry,
          builder: (entry) => NotificationItemSignRequest(
            notificationId: entry.id,
            signRequest: entry.type as NotificationTypeSignRequest,
            style: _signStyle,
          ),
        ),
      ]) {
    final accept = find.widgetWithText(DCustomFilledBigButton, kind.label);

    Future<void> pump(WidgetTester tester, NotificationData entry) =>
        pumpItem(tester, entry: entry, itemBuilder: kind.builder);

    // `DButton.enabled` is what drives both the disabled foreground colour and
    // the button's `Semantics(enabled:)`, so it is the rendered state of the
    // control rather than a detail of how the callback is wired.
    Finder acceptWith({required bool enabled}) => find.descendant(
      of: accept,
      matching: find.byWidgetPredicate(
        (w) => w is DButton && w.enabled == enabled,
      ),
    );

    group(kind.name, () {
      testWidgets('keeps the approval control focused across a failed gate', (
        tester,
      ) async {
        await pump(tester, kind.entry());

        FocusNode? acceptFocus() =>
            tester.widget<DCustomFilledBigButton>(accept).focusNode;

        expect(acceptFocus()?.hasFocus, isTrue);

        await tester.runAsync(() async {
          await tester.tap(accept);
          await tester.pump();

          await resolveGate(tester, allowed: false);
        });

        // Disabling the control drops its focus, because a disabled
        // FocusableActionDetector stops accepting any. The retry ADR-0006
        // decision 6 promises has to stay reachable from the keyboard, and
        // whether this item held the focus is captured before the press rather
        // than tested after the disable has already moved it.
        expect(acceptFocus()?.hasFocus, isTrue);
      });

      testWidgets('accepts an untouched request and clears it from the panel', (
        tester,
      ) async {
        await pump(tester, kind.entry());

        await tester.runAsync(() async {
          await tester.tap(accept);
          await tester.pump();

          await resolveGate(tester, allowed: true);
        });

        verify(() => wallet.sendMsg(any(that: _acceptanceFor(_reqA))))
            .called(1);
        // The acceptance was recorded: the real notifier dropped the entry, so
        // the item has nothing left to render.
        expect(accept, findsNothing);
      });

      testWidgets(
        'the control is unavailable in flight and available again after a failed gate',
        (tester) async {
          await pump(tester, kind.entry());

          expect(acceptWith(enabled: true), findsOneWidget);

          await tester.runAsync(() async {
            await tester.tap(accept);
            await tester.pump();
          });

          expect(acceptWith(enabled: false), findsOneWidget);

          await tester.runAsync(() async {
            // The user dismissed the prompt; the request itself is untouched.
            await resolveGate(tester, allowed: false);
          });

          verifyNever(() => wallet.sendMsg(any()));
          // Nothing closes on a failed gate: the item stays in the panel and
          // the user can try again (ADR-0006 decision 6).
          expect(accept, findsOneWidget);
          expect(acceptWith(enabled: true), findsOneWidget);
        },
      );

      testWidgets(
        'sends the acceptance when the element that started it is unmounted',
        (tester) async {
          await pump(tester, kind.entry());

          await tester.runAsync(() async {
            await tester.tap(accept);
            await tester.pump();

            // An entry elsewhere in the panel is withdrawn, so this one moves
            // onto a different element and the one it was on is unmounted --
            // while the authentication prompt is still up. The attempt belongs
            // to the request, so nothing about it depends on that.
            rendered.value = null;
            await tester.pump();

            await resolveGate(tester, allowed: true);
          });

          verify(() => wallet.sendMsg(any(that: _acceptanceFor(_reqA))))
              .called(1);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'an element repurposed to another request shows that request as ready',
        (tester) async {
          await pump(tester, kind.entry());

          await tester.runAsync(() async {
            await tester.tap(accept);
            await tester.pump();
          });

          expect(acceptWith(enabled: false), findsOneWidget);

          await tester.runAsync(() async {
            // A prepend of the same kind moves the next request onto this
            // element -- same widget type at the same position, so the element
            // is reused rather than recreated. The busy state is read by
            // request id, so the arriving request does not inherit the
            // outstanding attempt's control.
            final arrival = kind.entry(id: 2, reqId: _reqB);
            seeded.setEntries([arrival, kind.entry()]);
            rendered.value = arrival;
            await tester.pump();
          });

          expect(acceptWith(enabled: true), findsOneWidget);

          await tester.runAsync(() async {
            await resolveGate(tester, allowed: false);
          });
        },
      );

      testWidgets(
        'does not take the focus back from another control on the same item',
        (tester) async {
          await pump(tester, kind.entry());

          final acceptNode = tester
              .widget<DCustomFilledBigButton>(accept)
              .focusNode;

          await tester.runAsync(() async {
            await tester.tap(accept);
            await tester.pump();
          });

          late final FocusNode elsewhere;

          await tester.runAsync(() async {
            // The user moves the focus to this item's Cancel control while the
            // authentication prompt is up. "Unclaimed" is about the focus, not
            // about the item: a control the user chose is not this item's to
            // take back either, even though it is its own.
            final itemScope =
                tester
                        .widget<FocusScope>(
                          find
                              .descendant(
                                of: find.byType(_Host),
                                matching: find.byType(FocusScope),
                              )
                              .first,
                        )
                        .focusNode!
                    as FocusScopeNode;

            elsewhere = itemScope.traversalDescendants.firstWhere(
              (node) => node != acceptNode,
            );
            elsewhere.requestFocus();
            await tester.pump();

            await resolveGate(tester, allowed: false);
          });

          expect(elsewhere.hasFocus, isTrue);
          expect(acceptNode?.hasFocus, isFalse);
        },
      );

      testWidgets(
        'drops the keyboard focus when the element changes request mid-attempt',
        (tester) async {
          await pump(tester, kind.entry());

          await tester.runAsync(() async {
            // The press captures this item as the one holding the focus, so a
            // failed gate can hand it back.
            await tester.tap(accept);
            await tester.pump();
          });

          await tester.runAsync(() async {
            // The request is resolved and the next one moves onto this element
            // in the same frame: the item's request id changes and its attempt
            // is released together. The restoration the press armed belongs to
            // the request that is gone, so it must be abandoned with it rather
            // than land on a request the user has not read.
            final arrival = kind.entry(id: 2, reqId: _reqB);
            seeded.setEntries([arrival]);
            rendered.value = arrival;
            await resolveGate(tester, allowed: true);
          });

          final itemScope = tester.widget<FocusScope>(
            find
                .descendant(
                  of: find.byType(_Host),
                  matching: find.byType(FocusScope),
                )
                .first,
          );
          expect(itemScope.focusNode?.hasFocus, isFalse);
          expect(
            tester.widget<DCustomFilledBigButton>(accept).focusNode?.hasFocus,
            isFalse,
          );
        },
      );

      testWidgets(
        'drops the keyboard focus when the element changes to another request',
        (tester) async {
          await pump(tester, kind.entry());

          FocusNode? acceptFocus() =>
              tester.widget<DCustomFilledBigButton>(accept).focusNode;

          expect(acceptFocus()?.hasFocus, isTrue);

          await tester.runAsync(() async {
            final arrival = kind.entry(id: 2, reqId: _reqB);
            seeded.setEntries([arrival, kind.entry()]);
            rendered.value = arrival;
            await tester.pump();
          });

          // Focus does not ride along: a control left armed on a request the
          // user never read would reject it on the next Enter, or raise the
          // gate for it (ADR-0009 decision 5). Asserted against the item's own
          // scope, because the drop is answered there rather than on the
          // controls -- the button widgets keep their focus nodes private.
          final itemScope = tester.widget<FocusScope>(
            find
                .descendant(
                  of: find.byType(_Host),
                  matching: find.byType(FocusScope),
                )
                .first,
          );
          expect(itemScope.focusNode?.hasFocus, isFalse);
          expect(
            tester.widget<DCustomFilledBigButton>(accept).focusNode?.hasFocus,
            isFalse,
          );
        },
      );
    });
  }

  // Both focus rules below are about the panel around an item, so they need a
  // second entry. Connect items rather than sign ones only because two of them
  // fit the test view without overflowing.
  group('a panel with more than one item', () {
    final accept = find.widgetWithText(DCustomFilledBigButton, 'Connect');

    FocusNode? acceptFocusAt(WidgetTester tester, int index) =>
        tester.widget<DCustomFilledBigButton>(accept.at(index)).focusNode;

    Future<void> pumpTwo(WidgetTester tester, List<NotificationData> entries) =>
        tester.runAsync(() async {
          sizeView(tester, const Size(700, 900));

          seeded = _SeededNotifications(entries);

          await tester.pumpWidget(
            appWith(
              Consumer(
                builder: (context, ref, _) => Column(
                  children: [
                    // Built from the live list, as the real panel is: an item
                    // left behind for an entry that is gone renders the empty
                    // popup instead, which is a Scaffold and does not belong in
                    // a Column.
                    for (final entry in ref.watch(notificationsProvider))
                      NotificationItemConnectRequest(
                        notificationId: entry.id,
                        connect: entry.type as NotificationTypeConnect,
                        style: _connectStyle,
                      ),
                  ],
                ),
              ),
            ),
          );
        });

    testWidgets(
      'a failed gate does not take the focus from a control on another item',
      (tester) async {
        await pumpTwo(tester, [
          _connectEntry(),
          _connectEntry(id: 2, reqId: _reqB),
        ]);

        await tester.runAsync(() async {
          acceptFocusAt(tester, 0)!.requestFocus();
          await tester.pump();

          await tester.tap(accept.at(0));
          await tester.pump();

          // The user tabs to the other item's control while the first item's
          // authentication prompt is up.
          acceptFocusAt(tester, 1)!.requestFocus();
          await tester.pump();

          await resolveGate(tester, allowed: false);
        });

        // The restore is refused: what the disable took has since been claimed
        // by a control this item has no business taking it back from.
        // ADR-0009 decision 5.
        expect(acceptFocusAt(tester, 1)?.hasFocus, isTrue);
        expect(acceptFocusAt(tester, 0)?.hasFocus, isFalse);
      },
    );

    // `DButton.enabled` drives the disabled foreground colour and the button's
    // `Semantics(enabled:)`, so it is the rendered state of the control.
    Finder acceptWith({required bool enabled}) => find.descendant(
      of: accept,
      matching: find.byWidgetPredicate(
        (w) => w is DButton && w.enabled == enabled,
      ),
    );

    testWidgets(
      'an in-flight control stays disabled across a removal and an arrival',
      (tester) async {
        await pumpTwo(tester, [
          _connectEntry(),
          _connectEntry(id: 2, reqId: _reqB),
        ]);

        await tester.runAsync(() async {
          await tester.tap(accept.at(0));
          await tester.pump();
        });

        expect(acceptWith(enabled: false), findsOneWidget);

        await tester.runAsync(() async {
          // The other entry is withdrawn, so the in-flight request moves onto a
          // different element -- and its busy state moves with it, because it
          // is read by request id rather than held in the element.
          seeded.setEntries([_connectEntry()]);
          await tester.pump();
        });

        expect(acceptWith(enabled: false), findsOneWidget);
        expect(acceptWith(enabled: true), findsNothing);

        await tester.runAsync(() async {
          // And an unrelated request arrives ahead of it.
          seeded.setEntries([
            _connectEntry(id: 3, reqId: 'req-C'),
            _connectEntry(),
          ]);
          await tester.pump();
        });

        // The in-flight request is still busy and the newly arrived one is
        // armed, whichever element each of them landed on.
        expect(acceptWith(enabled: false), findsOneWidget);
        expect(acceptWith(enabled: true), findsOneWidget);

        await tester.runAsync(() async {
          await resolveGate(tester, allowed: false);
        });
      },
    );

    testWidgets('approving one request leaves the other in the panel', (
      tester,
    ) async {
      await pumpTwo(tester, [
        _connectEntry(),
        _connectEntry(id: 2, reqId: _reqB),
      ]);

      expect(accept, findsNWidgets(2));

      await tester.runAsync(() async {
        await tester.tap(accept.at(0));
        await tester.pump();

        await resolveGate(tester, allowed: true);
      });

      // Resolving one of several is not a resolution of the panel: the entry
      // that was approved is gone and the other is untouched. No item has the
      // means to collapse the panel any more — the parameter it used to call
      // is not on either widget. ADR-0009 decision 4.
      verify(() => wallet.sendMsg(any(that: _acceptanceFor(_reqA)))).called(1);
      expect(seeded.state, hasLength(1));
      expect(seeded.state.single.type.reqId, _reqB);
    });
  });

  // The panel is a fixed 370 wide and each item lays out to a fixed height, both
  // tuned to the app's own font. The test binding substitutes a block font whose
  // glyphs are wider and taller, so the items overflow their boxes here and
  // would not in the app. That is a rendering artifact of the harness rather
  // than anything these tests assert — every other error, including the
  // duplicate-GlobalKey one below, still fails them.
  /// Installs the overflow filter, from inside the test body — the widget
  /// tester replaces [FlutterError.onError] when the test starts, so a
  /// `setUp` would be overwritten before the first pump.
  void ignoreOverflow() {
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) {
        return;
      }
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  // The panel sizes itself to its first item and its children follow their
  // requests, and neither claim is observable on an item pumped by itself:
  // both are about what the list does to the elements under it.
  group('NotificationMenu', () {
    /// Pumps the panel into a stack that fills the view, the way the overlay
    /// hands it tight constraints in the app.
    ///
    /// The menu goes in as a *positioned* child: its own `Stack` is sized by its
    /// non-positioned children alone, and the dismiss catcher is not one, so a
    /// loosely constrained menu would collapse to nothing here for a reason
    /// that has nothing to do with what these tests assert.
    Future<void> pumpMenu(
      WidgetTester tester,
      List<NotificationData> entries, {
      Offset offset = Offset.zero,
      VoidCallback? onTap,
      Widget? underneath,
      double textScale = 1.0,
    }) => tester.runAsync(() async {
      ignoreOverflow();
      sizeView(tester, const Size(900, 1400));
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      seeded = _SeededNotifications(entries);

      final controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 1),
        value: 1.0,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        appWith(
          Stack(
            children: [
              if (underneath != null) Positioned.fill(child: underneath),
              Positioned.fill(
                child: NotificationMenu(
                  offset: offset,
                  onTap: onTap,
                  animationController: controller,
                  heightFactor: controller.view,
                ),
              ),
            ],
          ),
          extensions: const [_menuStyle, _connectStyle, _signStyle],
        ),
      );

      // Settles the mount-time focus request every item makes, so the keyboard
      // assertions below read a panel that has finished opening.
      await tester.pump();
    });

    /// Hands the open panel a new list, the way the notifier does in the app.
    Future<void> pumpEntries(
      WidgetTester tester,
      List<NotificationData> entries,
    ) => tester.runAsync(() async {
      seeded.setEntries(entries);
      await tester.pump();
    });

    // The panel's own box is what its sizing is observable as: its height is
    // its first item's plus the chrome around it.
    double panelHeight(WidgetTester tester) => tester
        .widget<SizedBox>(
          find.byWidgetPredicate((w) => w is SizedBox && w.width == 370).first,
        )
        .height!;

    testWidgets('resizes itself across a prepend and a removal', (
      tester,
    ) async {
      await pumpMenu(tester, [_signEntry()]);

      expect(panelHeight(tester), _signItemHeight + _menuChrome);

      // A different kind arrives at index 0, so what the panel sizes itself to
      // changes type in one frame.
      await pumpEntries(tester, [
        _connectEntry(id: 2, reqId: _reqB),
        _signEntry(),
      ]);

      expect(tester.takeException(), isNull);
      expect(panelHeight(tester), _connectItemHeight + _menuChrome);

      await pumpEntries(tester, [_signEntry()]);

      expect(tester.takeException(), isNull);
      expect(panelHeight(tester), _signItemHeight + _menuChrome);
    });

    testWidgets('stands at its empty size with nothing to show', (
      tester,
    ) async {
      await pumpMenu(tester, const []);

      expect(panelHeight(tester), _emptyMenuHeight);
    });

    // Everything below drives the real sliver with more than one entry, which
    // is what the identity claims need: `pumpTwo` further up builds a plain
    // Column, and a Column matches its children positionally whatever the list
    // does.
    //
    // Every finder here passes `skipOffstage: false`. The panel is exactly one
    // item tall, so every entry after the first is laid out inside the
    // viewport's cache extent but outside its paint extent, and
    // `SliverMultiBoxAdaptorElement.debugVisitOnstageChildren` hides exactly
    // those from an onstage finder. They are real, mounted elements holding
    // real focus nodes; a default finder simply refuses to look at them.
    //
    // How many of them exist is not the default cache extent's business
    // either: the panel hands the list one that spans every entry, so a case
    // here can seed as many as it likes and expect all of them to be built.
    // A `Bad state: No element` from a finder below therefore means the child
    // really is gone, not that the viewport declined to reach it.
    group('with more than one entry', () {
      /// The child the sliver built for [entry], wherever it currently sits.
      ///
      /// Never `.at(index)`: after a prepend the entry a test is watching has
      /// moved, so an index-based finder compares two different items and goes
      /// green without proving anything.
      Finder childOf(NotificationData entry) =>
          find.byKey(notificationChildKey(entry), skipOffstage: false);

      Finder acceptIn(NotificationData entry) => find.descendant(
        of: childOf(entry),
        matching: find.widgetWithText(
          DCustomFilledBigButton,
          'Connect',
          skipOffstage: false,
        ),
        skipOffstage: false,
      );

      /// The approval control's focus node — hook state created once per
      /// element (`useFocusNode`), so its instance is what survives or does not
      /// survive a list change.
      FocusNode? acceptFocusIn(WidgetTester tester, NotificationData entry) =>
          tester.widget<DCustomFilledBigButton>(acceptIn(entry)).focusNode;

      /// The item widget inside [entry]'s child, excluding the 10px spacer the
      /// builder puts under every child but the last.
      Finder itemIn(NotificationData entry) => find.descendant(
        of: childOf(entry),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is NotificationItemSignRequest ||
              widget is NotificationItemConnectRequest,
          skipOffstage: false,
        ),
        skipOffstage: false,
      );

      /// Puts the keyboard on [entry]'s approval control, the way a user
      /// tabbing to it does.
      Future<void> focusAccept(WidgetTester tester, NotificationData entry) =>
          tester.runAsync(() async {
            acceptFocusIn(tester, entry)!.requestFocus();
            await tester.pump();
          });

      /// A second entry to sit under the one a test is watching, so that
      /// "first" and "relocated" are claims about a list rather than about a
      /// list of one.
      NotificationData behindEntry() =>
          _connectEntry(id: 9, reqId: 'req-behind');

      testWidgets(
        'builds an element for every entry, not just the visible one',
        (tester) async {
          await pumpMenu(tester, [
            _connectEntry(),
            _connectEntry(id: 2, reqId: _reqB),
          ]);

          expect(
            find.byType(NotificationItemConnectRequest, skipOffstage: false),
            findsNWidgets(2),
          );
        },
      );

      // A request carrying both a connect and a sign payload is two entries
      // under one notification id (`notifications_provider.dart:106-181`), and
      // two siblings under one key are not an error the framework reports: the
      // sliver resolves both to one index, overwrites one with the other and
      // ends the pass a child short. So the identity has to carry the kind too,
      // and this is the test that says so.
      testWidgets('gives the two entries of one request distinct children', (
        tester,
      ) async {
        // The order `addNotification` leaves them in: connect is prepended
        // first, sign second, so sign is on top.
        final sign = _signEntry();
        final connect = _connectEntry();

        await pumpMenu(tester, [sign, connect]);

        expect(
          find.byKey(notificationChildKey(sign), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(notificationChildKey(connect), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byType(NotificationItemSignRequest, skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byType(NotificationItemConnectRequest, skipOffstage: false),
          findsOneWidget,
        );
        // Each of the two lays itself out at its own kind's height. Neither
        // can read its kind off the entry it looks up: `getNotification`
        // matches by id, and this is the one case where one id answers with
        // the other twin's entry.
        expect(tester.getSize(itemIn(sign)).height, _signItemHeight);
        expect(tester.getSize(itemIn(connect)).height, _connectItemHeight);
      });

      // The panel is one item tall plus its chrome, and the item it sizes
      // itself to is the *first* one — not the tallest, and not the last. Each
      // case is pumped with a second entry behind it so that "first" is a
      // claim rather than a coincidence.
      for (final first
          in <({String name, NotificationData entry, double height})>[
            (
              name: 'a pending sign request',
              entry: _signEntry(),
              height: _signItemHeight,
            ),
            (
              name: 'a remotely cancelled sign request',
              entry: _signEntry(itemState: _cancelled),
              height: _cancelledSignItemHeight,
            ),
            (
              name: 'a pending connect request',
              entry: _connectEntry(),
              height: _connectItemHeight,
            ),
            (
              name: 'a remotely cancelled connect request',
              entry: _connectEntry(itemState: _cancelled),
              height: _cancelledConnectItemHeight,
            ),
          ]) {
        testWidgets('sizes itself to ${first.name} at the top', (tester) async {
          await pumpMenu(tester, [first.entry, behindEntry()]);

          expect(panelHeight(tester), first.height + _menuChrome);
          // The same claim without the literal: whatever the item actually
          // lays out at is what the panel makes room for. This is what would
          // catch the panel and the item disagreeing about an item's height.
          expect(
            panelHeight(tester),
            tester.getSize(itemIn(first.entry)).height + _menuChrome,
          );
        });
      }

      testWidgets('relocates an existing element when a request arrives', (
        tester,
      ) async {
        final entry = _connectEntry();
        final behind = behindEntry();

        await pumpMenu(tester, [entry, behind]);

        final elementBefore = tester.element(childOf(entry));
        final focusBefore = acceptFocusIn(tester, entry);
        expect(focusBefore, isNotNull);

        await pumpEntries(tester, [
          _connectEntry(id: 2, reqId: _reqB),
          entry,
          behind,
        ]);

        // The same element and the same hook state, one slot further down. A
        // sliver relocates a keyed child only through `findChildIndexCallback`;
        // without one it deactivates the child and inflates a fresh one, and a
        // fresh one comes with a fresh focus node.
        expect(tester.element(childOf(entry)), same(elementBefore));
        expect(acceptFocusIn(tester, entry), same(focusBefore));
      });

      testWidgets('relocates an existing element when a request is removed', (
        tester,
      ) async {
        final withdrawn = _connectEntry();
        final entry = _connectEntry(id: 2, reqId: _reqB);

        await pumpMenu(tester, [withdrawn, entry]);

        final elementBefore = tester.element(childOf(entry));
        final focusBefore = acceptFocusIn(tester, entry);
        expect(focusBefore, isNotNull);

        await pumpEntries(tester, [entry]);

        expect(tester.element(childOf(entry)), same(elementBefore));
        expect(acceptFocusIn(tester, entry), same(focusBefore));
        expect(childOf(withdrawn), findsNothing);
      });

      testWidgets('keeps the keyboard on its control when a request arrives', (
        tester,
      ) async {
        final entry = _connectEntry();
        final behind = behindEntry();

        await pumpMenu(tester, [entry, behind]);
        await focusAccept(tester, entry);

        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);

        final arrival = _connectEntry(id: 2, reqId: _reqB);

        await pumpEntries(tester, [arrival, entry, behind]);

        // The user was answering one request when another turned up. Taking
        // the keyboard to the arriving one puts a control the user has not
        // read under the next Enter — the hazard ADR-0009 decision 5 is about,
        // arriving here through the mount rather than through a repurposed
        // element.
        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);
        expect(acceptFocusIn(tester, arrival)?.hasFocus, isFalse);
      });

      testWidgets('keeps it on a control below the fold across an arrival', (
        tester,
      ) async {
        final entry = _connectEntry(id: 2, reqId: _reqB);

        await pumpMenu(tester, [_connectEntry(), entry]);

        await focusAccept(tester, entry);

        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);

        await pumpEntries(tester, [
          _connectEntry(id: 3, reqId: 'req-C'),
          _connectEntry(),
          entry,
        ]);

        // The panel shows one item at a time, so the control the user is on is
        // already below the fold before anything arrives, and the arrival puts
        // another item between it and the top. An element the list collects
        // takes its focus node with it, and relocating a child the list is
        // about to drop is worth nothing.
        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);
      });

      testWidgets('keeps it there across a second arrival on top of that', (
        tester,
      ) async {
        final entry = _connectEntry(id: 2, reqId: _reqB);
        final first = _connectEntry();
        final c1 = _connectEntry(id: 3, reqId: 'req-C');
        final c2 = _connectEntry(id: 4, reqId: 'req-D');

        await pumpMenu(tester, [first, entry]);

        await focusAccept(tester, entry);

        await pumpEntries(tester, [c1, first, entry]);
        await pumpEntries(tester, [c2, c1, first, entry]);

        // Two arrivals put the watched entry well past what the list lays out,
        // so by now it is held only by its keep-alive. A child held that way
        // is off the sliver's rebuild path, which is where a stale index would
        // show up — as a child rendering someone else's request, or as two
        // children claiming one slot, before it ever showed up as lost focus.
        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);
        expect(childOf(entry), findsOneWidget);
        expect(
          find.byType(NotificationItemConnectRequest, skipOffstage: false),
          findsNWidgets(4),
        );
      });

      testWidgets('keeps the keyboard on its control when a request goes', (
        tester,
      ) async {
        final withdrawn = _connectEntry();
        final entry = _connectEntry(id: 2, reqId: _reqB);

        await pumpMenu(tester, [withdrawn, entry]);
        await focusAccept(tester, entry);

        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);

        await pumpEntries(tester, [entry]);

        expect(acceptFocusIn(tester, entry)?.hasFocus, isTrue);
      });

      testWidgets('gives the keyboard to the first item it opens on', (
        tester,
      ) async {
        final first = _connectEntry();
        final second = _connectEntry(id: 2, reqId: _reqB);

        await pumpMenu(tester, [first, second]);

        // One item, and the top one: a panel that opened on several requests
        // is still answerable from the keyboard, and it is the request the
        // user is looking at that answers.
        expect(acceptFocusIn(tester, first)?.hasFocus, isTrue);
        expect(acceptFocusIn(tester, second)?.hasFocus, isFalse);
      });

      testWidgets('gives it to the first request to reach an empty panel', (
        tester,
      ) async {
        await pumpMenu(tester, const []);

        final first = _connectEntry();

        await pumpEntries(tester, [first]);

        // Nothing was on screen to take it from, so the panel is opening on
        // this request as far as the user is concerned.
        expect(acceptFocusIn(tester, first)?.hasFocus, isTrue);
      });

      testWidgets('takes a same-kind arrival at the top without collision', (
        tester,
      ) async {
        final entry = _connectEntry();

        await pumpMenu(tester, [entry, behindEntry()]);

        // The sequence that used to graft one element onto another: the
        // relocating child and the arriving one are the same kind, so nothing
        // but the identity tells them apart.
        await pumpEntries(tester, [
          _connectEntry(id: 2, reqId: _reqB),
          entry,
          behindEntry(),
        ]);

        // No key is on a child that can move any more, so there is no key for
        // two elements to hold at once.
        expect(tester.takeException(), isNull);
        expect(
          find.byType(NotificationItemConnectRequest, skipOffstage: false),
          findsNWidgets(3),
        );
      });

      testWidgets('shrinks to its first item being cancelled under it', (
        tester,
      ) async {
        final behind = behindEntry();

        await pumpMenu(tester, [_signEntry(), behind]);

        expect(panelHeight(tester), _signItemHeight + _menuChrome);

        // What a remote cancel does: the entry keeps its id and its slot and
        // changes state, so the child is the same child and only its height
        // moves.
        await pumpEntries(tester, [_signEntry(itemState: _cancelled), behind]);

        expect(panelHeight(tester), _cancelledSignItemHeight + _menuChrome);
      });
    });

    // The panel is parked away from the origin so that every side of it has an
    // unambiguous outside, and so that the two regions tapped below are on
    // opposite sides of it rather than both in one corner.
    const menuOffset = Offset(400, 100);
    const leftOfPanel = Offset(100, 600);
    const rightOfPanel = Offset(820, 40);

    testWidgets('dismisses on a click outside it, from either side', (
      tester,
    ) async {
      var dismissals = 0;
      await pumpMenu(
        tester,
        const [],
        offset: menuOffset,
        onTap: () => dismissals++,
      );

      await tester.runAsync(() async {
        await tester.tapAt(leftOfPanel);
        await tester.pump();
      });

      expect(dismissals, 1);

      await tester.runAsync(() async {
        await tester.tapAt(rightOfPanel);
        await tester.pump();
      });

      expect(dismissals, 2);
    });

    testWidgets('swallows the dismissing click instead of passing it down', (
      tester,
    ) async {
      var dismissals = 0;
      var pointersBeneath = 0;
      var pressesBeneath = 0;

      await pumpMenu(
        tester,
        const [],
        offset: menuOffset,
        onTap: () => dismissals++,
        // A control under the whole panel, probed at both levels a click can
        // reach it: the raw pointer a press state or a text field would react
        // to, and the tap a button resolves out of the gesture arena.
        underneath: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => pointersBeneath++,
          child: ElevatedButton(
            onPressed: () => pressesBeneath++,
            child: const Text('beneath'),
          ),
        ),
      );

      await tester.runAsync(() async {
        await tester.tapAt(leftOfPanel);
        await tester.pump();
      });

      expect(dismissals, 1);
      expect(pointersBeneath, 0);
      expect(pressesBeneath, 0);
    });

    testWidgets('leaves a click on its own body and controls alone', (
      tester,
    ) async {
      var dismissals = 0;
      await pumpMenu(
        tester,
        [_connectEntry()],
        offset: menuOffset,
        onTap: () => dismissals++,
        // The item lays out at a height tuned to the app's own font. The block
        // font the test binding substitutes is taller, so at full scale the
        // item's buttons are pushed past the panel's clip — outside it, where a
        // click reaches the catcher rather than the button, which is a fixture
        // artifact and not what this test is about. Scaling the text back down
        // puts the controls inside the panel, where the app has them.
        textScale: 0.5,
      );

      await tester.runAsync(() async {
        await tester.tap(find.text('Notifications'));
        await tester.pump();
      });

      expect(dismissals, 0);

      await tester.runAsync(() async {
        await tester.tap(find.text('Cancel'));
        await tester.pump();
      });

      verify(() => wallet.sendMsg(any(that: _rejectionFor(_reqA)))).called(1);
      expect(dismissals, 0);
    });

    // Most of an open panel is blank: the chrome is a decoration, and layout
    // boxes are not hit targets, so a click that lands between the glyphs and
    // the buttons walks straight past the panel to the catcher behind it unless
    // the panel stops it. The empty state is the extreme case — one centred line
    // of text in a 370x163 box — and it is a state the panel enters by itself
    // the moment the last request is resolved.
    testWidgets('absorbs a click on the blank part of its own body', (
      tester,
    ) async {
      var dismissals = 0;
      await pumpMenu(
        tester,
        const [],
        offset: menuOffset,
        onTap: () => dismissals++,
      );

      await tester.runAsync(() async {
        // Inside the panel's 370x163 box at (400, 100), in the bottom-right
        // corner, clear of the centred empty-state line.
        await tester.tapAt(const Offset(750, 250));
        await tester.pump();
      });

      expect(dismissals, 0);
    });
  });

  // What the dismissal is worth is only observable where the panel is actually
  // mounted and unmounted: through the toolbar button, whose overlay entry is
  // what an outside click has to take away and what the button has to be able
  // to bring back.
  group('DNotificationToolbarButton', () {
    final panel = find.byType(NotificationMenu);

    /// Puts the button on screen with the navigator overlay the app gives it.
    ///
    /// `activeNotifications` is held at false so the panel opens only when this
    /// test opens it: a pending request pulls the panel open on its own, and
    /// that behaviour belongs to #192 rather than to dismissal.
    Future<void> pumpToolbar(
      WidgetTester tester, {
      List<NotificationData> entries = const [],
      bool? activeNotifications = false,
      ShowNotificationMenu? showMenu,
    }) => tester.runAsync(() async {
      ignoreOverflow();
      sizeView(tester, const Size(1200, 900));

      seeded = _SeededNotifications(entries);

      await tester.pumpWidget(
        appWith(
          const Align(
            alignment: Alignment.topRight,
            child: DNotificationToolbarButton(),
          ),
          extensions: const [_menuStyle, _connectStyle, _signStyle],
          activeNotifications: activeNotifications,
          navigatorKey: GlobalKey<NavigatorState>(),
          showMenu: showMenu,
        ),
      );
      await tester.pump();
    });

    /// Lets the panel finish whatever it was asked to do.
    ///
    /// Alternating microtask drains and frames, because opening and closing
    /// both go through a microtask before the animation they start: a run of
    /// `pump`s alone never lets the write land, and a run of drains alone
    /// never advances the animation the write starts.
    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 4; i++) {
        await Future<void>.delayed(Duration.zero);
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    /// Presses the toolbar button and lets the overlay entry land.
    ///
    /// The entry is inserted from a microtask, so the frame that shows it is
    /// one turn of the event loop away from the press.
    Future<void> press(WidgetTester tester) => tester.runAsync(() async {
      await tester.tap(find.byType(DNotificationToolbarButton));
      await Future<void>.delayed(Duration.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });

    // Well clear of the panel, which hangs from the top right corner.
    const outside = Offset(100, 700);

    testWidgets('stays dismissed when the outside click is repeated', (
      tester,
    ) async {
      await pumpToolbar(tester, entries: [_connectEntry()]);
      await press(tester);

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        // Mid-collapse: the panel is on its way out but its catcher is still
        // mounted, so a second click lands on it too. This is the "sometimes I
        // have to click twice" the issue reports.
        await tester.pump(const Duration(milliseconds: 20));
        await tester.tapAt(outside);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);
    });

    // The reported repro: a sign request arrives, the panel opens itself for
    // it, the user rejects it, and the panel is left showing nothing.
    testWidgets('dismisses a panel left empty by rejecting its request', (
      tester,
    ) async {
      await pumpToolbar(
        tester,
        entries: [_signEntry()],
        activeNotifications: null,
      );

      // The arrival opens the panel by itself, one microtask after the frame.
      await tester.runAsync(() => settle(tester));

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await settle(tester);
      });

      expect(tester.takeException(), isNull);

      // The panel has nothing left to show, and nothing left to show is what
      // it closes itself for. Asserted here rather than only after the click
      // below: once this holds, the click has nothing left to prove.
      expect(panel, findsNothing);

      // And it stays closed — the click that used to be needed, and used to do
      // nothing, still lands on whatever is there.
      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);
    });

    // The outside click dismisses a panel whose request is still pending, so
    // the panel goes while the thing that opened it stays. The toolbar button
    // has to be able to bring it back.
    testWidgets('opens again from the toolbar with the request still pending', (
      tester,
    ) async {
      await pumpToolbar(
        tester,
        entries: [_signEntry()],
        activeNotifications: null,
      );

      // The arrival opens the panel by itself.
      await tester.runAsync(() => settle(tester));

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await settle(tester);
      });

      expect(panel, findsNothing);

      await press(tester);

      expect(panel, findsOneWidget);
    });

    testWidgets('TMP banner reopens a panel dismissed with a pending request', (
      tester,
    ) async {
      final showMenu = _SeededShowMenu();
      await pumpToolbar(
        tester,
        entries: [_signEntry()],
        activeNotifications: null,
        showMenu: showMenu,
      );
      await tester.runAsync(() => settle(tester));
      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await settle(tester);
      });
      expect(panel, findsNothing);

      await tester.runAsync(() async {
        showMenu.setState(1);
        await settle(tester);
      });
      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await settle(tester);
      });
      expect(panel, findsNothing);

      await press(tester);
      expect(panel, findsOneWidget);
    });

    testWidgets('TMP request arriving into a hand-opened panel', (tester) async {
      await pumpToolbar(tester, activeNotifications: null);
      await press(tester);
      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        seeded.setEntries([_signEntry()]);
        await settle(tester);
      });
      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await settle(tester);
      });
      expect(panel, findsNothing);

      await press(tester);
      expect(panel, findsOneWidget);
    });

    testWidgets('TMP resize while open', (tester) async {
      await pumpToolbar(tester, entries: [_signEntry()], activeNotifications: null);
      await tester.runAsync(() => settle(tester));
      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        tester.view.physicalSize = const Size(1000, 800);
        await settle(tester);
      });
      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(const Offset(100, 700));
        await settle(tester);
      });
      expect(panel, findsNothing);

      await press(tester);
      expect(panel, findsOneWidget);
    });

    testWidgets('TMP resize while closing', (tester) async {
      await pumpToolbar(tester, entries: [_signEntry()], activeNotifications: null);
      await tester.runAsync(() => settle(tester));
      expect(panel, findsOneWidget);

      // The dismissal starts, and the window is resized inside the 75 ms the
      // collapse takes.
      await tester.runAsync(() async {
        await tester.tapAt(const Offset(100, 700));
        await tester.pump(const Duration(milliseconds: 20));
        tester.view.physicalSize = const Size(1000, 800);
        await settle(tester);
      });

      expect(panel, findsNothing);

      await press(tester);
      expect(panel, findsOneWidget);
    });

    // The same write, in the other direction: the listener asks for the menu
    // while nothing is pending, so the arrival effect's own microtask is not
    // there to open the panel in this one's place.
    testWidgets('opens on a menu request with nothing pending', (tester) async {
      final showMenu = _SeededShowMenu();
      await pumpToolbar(tester, showMenu: showMenu);

      expect(panel, findsNothing);

      await tester.runAsync(() async {
        showMenu.setState(1);
        await settle(tester);
      });

      expect(panel, findsOneWidget);
    });

    testWidgets('dismisses a panel emptied under the user', (tester) async {
      await pumpToolbar(tester, entries: [_connectEntry()]);
      await press(tester);

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        seeded.setEntries(const []);
        await tester.pump();
      });

      expect(tester.takeException(), isNull);
      expect(find.text('No new notifications'), findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);
    });

    testWidgets('dismisses an empty panel on a click outside it', (
      tester,
    ) async {
      await pumpToolbar(tester);
      await press(tester);

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);
    });

    testWidgets('dismisses an empty panel from the toolbar button', (
      tester,
    ) async {
      await pumpToolbar(tester);
      await press(tester);

      expect(panel, findsOneWidget);

      await press(tester);

      expect(panel, findsNothing);
    });

    testWidgets('opens again from the toolbar after an outside click', (
      tester,
    ) async {
      await pumpToolbar(tester, entries: [_connectEntry()]);
      await press(tester);

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);

      await press(tester);

      expect(panel, findsOneWidget);
    });
  });
}
