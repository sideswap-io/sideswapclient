import 'dart:async';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/pin/pin_protection.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The PIN dialog must not reset PIN state from inside its own build: the reset
/// is a `ref.invalidate`, and riverpod answers one with a scheduled refresh —
/// `setState` on the enclosing `ProviderScope` — whenever the invalidated
/// provider still has a mounted listener. A dialog raised while any other
/// subtree is listening therefore crashed on its first build.
void main() {
  late MockWallet wallet;

  setUp(() {
    Localization.load(const Locale('en'));
    wallet = MockWallet();
    // Both screens read FlavorConfig through SideSwapScaffold during build.
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

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  ProviderContainer makeContainer() => ProviderContainer.test(
    overrides: [walletProvider.overrideWith((ref) => wallet)],
  );

  /// The dialog stacks fixed paddings that assume a phone; the 800x600 default
  /// test surface overflows before anything is asserted.
  void useHandsetSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('opens cleanly with nothing else listening', (tester) async {
    useHandsetSurface(tester);

    final container = makeContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: PinProtectionBody(iconType: PinKeyboardAcceptType.unlock),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('opens while another listener holds the PIN providers', (
    tester,
  ) async {
    useHandsetSurface(tester);

    final container = makeContainer();
    // Stands in for any subtree that outlives one dialog and reaches the next:
    // an outgoing route mid-pop, or a second dialog raised over the first.
    container.listen(pinProtectionStateProvider, (_, _) {});
    container.listen(pinCodeProtectionProvider, (_, _) {});

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: PinProtectionBody(iconType: PinKeyboardAcceptType.unlock),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('opens while a first dialog is still on screen', (tester) async {
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final container = makeContainer();
    Future<void> pump(List<Widget> bodies) => tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [for (final body in bodies) Expanded(child: body)],
            ),
          ),
        ),
      ),
    );

    await pump(const [
      PinProtectionBody(iconType: PinKeyboardAcceptType.unlock),
    ]);
    await pump(const [
      PinProtectionBody(iconType: PinKeyboardAcceptType.unlock),
      PinProtectionBody(iconType: PinKeyboardAcceptType.unlock),
    ]);

    expect(tester.takeException(), isNull);
  });

  testWidgets('is re-raised the moment the first one pops', (tester) async {
    useHandsetSurface(tester);

    final container = makeContainer();
    late BuildContext rootContext;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            // CustomAppBar force-unwraps this extension.
            extensions: [CustomBackButtonStyle.standard()],
            splashFactory: NoSplash.splashFactory,
          ),
          home: Builder(
            builder: (context) {
              rootContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      ),
    );

    // `onPinBlockade` in app_main.dart: reset, raise, reset on the way out.
    Future<bool> raise() async {
      container.read(pinProtectionHelperProvider).init();
      final ret = await showDialog<bool>(
        context: rootContext,
        barrierDismissible: false,
        builder: (context) => const PinProtection(),
      );
      container.read(pinProtectionHelperProvider).deinit();
      return ret ?? false;
    }

    final first = raise();
    await tester.pumpAndSettle();

    // The user backs out of the dialog, and `SideswapWallet.unlockWallet`
    // (wallet.dart:324) raises it again in the same turn — while the outgoing
    // route is still mounted and still listening.
    Navigator.of(rootContext).pop(false);
    await first;
    unawaited(raise());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  group('the keyboard shows the same state as the field', () {
    Future<PinKeyboard> pumpUnlock(
      WidgetTester tester, {
      required PinProtectionState state,
    }) async {
      useHandsetSurface(tester);

      final container = makeContainer();
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(state);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PinProtectionBody(iconType: PinKeyboardAcceptType.unlock),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      return tester.widget<PinKeyboard>(find.byType(PinKeyboard));
    }

    testWidgets('idle keeps every key live', (tester) async {
      final keyboard = await pumpUnlock(
        tester,
        state: const PinProtectionState.idle(),
      );

      expect(keyboard.enabled, isTrue);
    });

    testWidgets('waiting closes every key', (tester) async {
      final keyboard = await pumpUnlock(
        tester,
        state: const PinProtectionState.waiting(),
      );

      // The keys were already inert while waiting; ADR-0013 decision 12 stops
      // the appearance from lying about it.
      expect(keyboard.enabled, isFalse);
    });
  });
}
