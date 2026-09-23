import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/widgets/d_swaption_connections_button.dart';
import 'package:sideswap/providers/swaption_session_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// Seeds the session list and lets a test replace it while the panel is open.
class _SeededSessions extends SwaptionSessionNotifier {
  _SeededSessions(this._seed);

  final List<SwaptionSession> _seed;

  @override
  List<SwaptionSession> build() => _seed;

  void setSessions(List<SwaptionSession> sessions) => state = sessions;
}

SwaptionSession _session(String id) =>
    SwaptionSession(sessionId: id, domain: '$id.example', isLocal: false);

void main() {
  late _MockWallet wallet;
  late _SeededSessions seeded;

  setUp(() {
    wallet = _MockWallet();
    seeded = _SeededSessions(const []);
  });

  void sizeView(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

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

  Widget appWith(Widget body, {GlobalKey<NavigatorState>? navigatorKey}) =>
      ProviderScope(
        overrides: [
          walletProvider.overrideWithValue(wallet),
          swaptionSessionProvider.overrideWith(() => seeded),
          if (navigatorKey != null)
            navigatorKeyProvider.overrideWithValue(navigatorKey),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Scaffold(body: body),
        ),
      );

  group('SwaptionConnectionsMenu', () {
    const menuOffset = Offset(400, 100);
    const leftOfPanel = Offset(100, 700);

    Future<void> pumpMenu(
      WidgetTester tester,
      List<SwaptionSession> sessions, {
      Offset offset = Offset.zero,
      VoidCallback? onTap,
      Widget? underneath,
    }) => tester.runAsync(() async {
      ignoreOverflow();
      sizeView(tester, const Size(900, 1400));

      seeded = _SeededSessions(sessions);

      final controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 150),
        value: 1,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        appWith(
          Stack(
            children: [
              if (underneath != null) Positioned.fill(child: underneath),
              Positioned.fill(
                child: SwaptionConnectionsMenu(
                  offset: offset,
                  animationController: controller,
                  heightFactor: controller.drive(
                    CurveTween(curve: Curves.fastOutSlowIn),
                  ),
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
    });

    testWidgets('dismisses on a click outside it', (tester) async {
      var dismissals = 0;
      await pumpMenu(
        tester,
        [_session('a')],
        offset: menuOffset,
        onTap: () => dismissals++,
      );

      await tester.runAsync(() async {
        await tester.tapAt(leftOfPanel);
        await tester.pump();
      });

      expect(dismissals, 1);
    });

    testWidgets('swallows the dismissing click instead of passing it down', (
      tester,
    ) async {
      var dismissals = 0;
      var pointersBeneath = 0;
      var pressesBeneath = 0;

      await pumpMenu(
        tester,
        [_session('a')],
        offset: menuOffset,
        onTap: () => dismissals++,
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
      // Recorded separately so a failure of the first does not hide the
      // second: a translucent catcher leaks the raw pointer, but the tap it
      // recognises still wins the gesture arena over the button beneath.
      expect(pressesBeneath, 0, reason: 'tap beneath');
      expect(pointersBeneath, 0, reason: 'pointer beneath');
    });
  });

  group('DSwaptionConnectionsButton', () {
    final panel = find.byType(SwaptionConnectionsMenu);

    Future<void> pumpToolbar(
      WidgetTester tester, {
      List<SwaptionSession> sessions = const [],
    }) => tester.runAsync(() async {
      ignoreOverflow();
      sizeView(tester, const Size(1200, 900));

      seeded = _SeededSessions(sessions);

      await tester.pumpWidget(
        appWith(
          const Align(
            alignment: Alignment.topRight,
            child: DSwaptionConnectionsButton(),
          ),
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
      );
      await tester.pump();
    });

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 4; i++) {
        await Future<void>.delayed(Duration.zero);
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> press(WidgetTester tester) => tester.runAsync(() async {
      await tester.tap(find.byType(DSwaptionConnectionsButton));
      await Future<void>.delayed(Duration.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });

    const outside = Offset(100, 700);

    testWidgets('opens from the toolbar', (tester) async {
      await pumpToolbar(tester, sessions: [_session('a')]);
      await press(tester);

      expect(panel, findsOneWidget);
    });

    // The catcher covers the whole window, the toolbar button included, so a
    // click on the button while the panel is open never reaches the button.
    // What matters is the result the user sees, not which widget took the
    // click: the panel has to go, and the button has to bring it back.
    testWidgets('closes when the toolbar button is clicked while it is open', (
      tester,
    ) async {
      await pumpToolbar(tester, sessions: [_session('a')]);
      await press(tester);

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tap(
          find.byType(DSwaptionConnectionsButton),
          warnIfMissed: false,
        );
        await Future<void>.delayed(Duration.zero);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);

      await press(tester);

      expect(panel, findsOneWidget);
    });

    testWidgets('stays dismissed when the outside click is repeated', (
      tester,
    ) async {
      await pumpToolbar(tester, sessions: [_session('a')]);
      await press(tester);

      expect(panel, findsOneWidget);

      await tester.runAsync(() async {
        await tester.tapAt(outside);
        // Mid-collapse: the panel is on its way out but its catcher is still
        // mounted, so a second click lands on it too.
        await tester.pump(const Duration(milliseconds: 20));
        await tester.tapAt(outside);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });

      expect(panel, findsNothing);
    });

    // Reads the controller off the mounted panel. The status listener that
    // ends the collapse unmounts the menu, so the tree no longer carries it
    // at the moment its value is worth asserting. The controller outlives the
    // menu: it is a hook on the toolbar button, which stays mounted.
    AnimationController controllerOf(WidgetTester tester) =>
        tester.widget<SwaptionConnectionsMenu>(panel).animationController;

    testWidgets('collapses over its animation when the last session drops', (
      tester,
    ) async {
      await pumpToolbar(tester, sessions: [_session('a')]);
      await press(tester);

      final controller = controllerOf(tester);

      await tester.runAsync(() async {
        seeded.setSessions(const []);
        await Future<void>.delayed(Duration.zero);
        // The effect defers its write, so it costs one frame to schedule and
        // another to take effect. The reverse starts on the second.
        await tester.pump();
        await Future<void>.delayed(Duration.zero);
        await tester.pump();
        // Stops inside the 75 ms reverse. Pumping it out would land the
        // controller on an endpoint, where a collapse that ran and one that
        // never started look the same.
        await tester.pump(const Duration(milliseconds: 30));
      });

      // Mid-collapse: the panel is still mounted and the controller is on its
      // way down. The defect leaves it forward at 1.0 with the panel already
      // gone.
      expect(panel, findsOneWidget, reason: 'mid-collapse');
      expect(controller.value, greaterThan(0.0), reason: 'mid-collapse');
      expect(controller.value, lessThan(1.0), reason: 'mid-collapse');

      await tester.runAsync(() async {
        await settle(tester);
      });

      expect(controller.value, 0.0);
      expect(panel, findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('does nothing when the last session drops while it is closed', (
      tester,
    ) async {
      await pumpToolbar(tester, sessions: [_session('a')]);

      expect(panel, findsNothing);

      await tester.runAsync(() async {
        seeded.setSessions(const []);
        await settle(tester);
      });

      // The effect writes `expanded` only when the panel is open. With it
      // closed there is no entry to retire and nothing to collapse, so the
      // withdrawn inline teardown is not missed.
      expect(tester.takeException(), isNull);
      expect(panel, findsNothing);

      // And the button still opens nothing: the badge is dead with no
      // session to show.
      await press(tester);

      expect(panel, findsNothing);
    });

    testWidgets(
      'opens again after the last session drops and a new one arrives',
      (tester) async {
        await pumpToolbar(tester, sessions: [_session('a')]);
        await press(tester);

        final controller = controllerOf(tester);

        expect(panel, findsOneWidget);

        await tester.runAsync(() async {
          seeded.setSessions(const []);
          await settle(tester);
        });

        expect(tester.takeException(), isNull);
        expect(panel, findsNothing);
        expect(controller.value, 0.0);

        await tester.runAsync(() async {
          seeded.setSessions([_session('b')]);
          await settle(tester);
        });

        await tester.runAsync(() async {
          await tester.tap(find.byType(DSwaptionConnectionsButton));
          // The press writes `expanded` directly, so one frame starts the
          // grow.
          await Future<void>.delayed(Duration.zero);
          await tester.pump();
          // Stops inside the 150 ms forward, for the reason the collapse test
          // states.
          await tester.pump(const Duration(milliseconds: 50));
        });

        // Mid-grow rather than already complete: a controller the collapse
        // left forward at 1.0 finishes this open on the spot.
        expect(panel, findsOneWidget);
        expect(controller.value, greaterThan(0.0), reason: 'mid-grow');
        expect(controller.value, lessThan(1.0), reason: 'mid-grow');

        await tester.runAsync(() async {
          await settle(tester);
        });

        expect(panel, findsOneWidget);
      },
    );
  });
}
