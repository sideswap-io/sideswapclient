// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/desktop/pin/d_pin_protection.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The desktop counterpart of `pin_protection_init_test.dart`. ADR-0013
/// decision 12 gives the unlock keyboard the same state as the field, and
/// nothing asserted that before.
void main() {
  late MockWallet wallet;

  setUp(() {
    Localization.load(const Locale('en'));
    wallet = MockWallet();
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: true,
      ),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  /// The pump runs inside `runAsync`: every key is a `DButton`, and
  /// `DButton.defaultStyleOf` leaves zero-duration riverpod dispose timers that
  /// never fire under the fake-async binding.
  Future<DPinKeyboard> pumpUnlock(
    WidgetTester tester, {
    required PinProtectionState state,
  }) async {
    late DPinKeyboard keyboard;

    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWith((ref) => wallet)],
      );
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(state);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: DPinProtection())),
        ),
      );

      keyboard = tester.widget<DPinKeyboard>(find.byType(DPinKeyboard));
    });

    return keyboard;
  }

  testWidgets('the field takes focus when the dialog opens', (tester) async {
    await pumpUnlock(tester, state: const PinProtectionState.idle());

    // The field is the only thing on this dialog the user can type into, and
    // `DPinTextField` forwards `autofocus` now instead of hard-coding it.
    expect(tester.widget<TextField>(find.byType(TextField)).autofocus, isTrue);
  });

  testWidgets('opens cleanly', (tester) async {
    await pumpUnlock(tester, state: const PinProtectionState.idle());

    expect(tester.takeException(), isNull);
  });

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

    expect(keyboard.enabled, isFalse);
  });
}
