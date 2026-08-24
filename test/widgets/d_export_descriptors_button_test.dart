// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_settings_button.dart';
import 'package:sideswap/desktop/settings/widgets/d_export_descriptors_button.dart';
import 'package:sideswap/models/wallet_descriptors.dart';
import 'package:sideswap/providers/wallet_descriptors_gate_provider.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';

class _FakeWalletDescriptorsNotifier extends WalletDescriptorsNotifier {
  _FakeWalletDescriptorsNotifier(this._value);

  final WalletDescriptors? _value;

  @override
  WalletDescriptors? build() => _value;
}

class _MockWalletDescriptorsGate extends Mock
    implements WalletDescriptorsGate {}

void main() {
  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random seed.
  setUp(() {
    Localization.load(const Locale('en'));
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // DSettingsButton resolves its theme through throwaway ProviderContainers that
  // leave dispose timers on riverpod's scheduler; those never settle under the
  // test binding's fake async, so the pump runs inside `runAsync`.
  Future<void> pumpButton(
    WidgetTester tester, {
    required WalletDescriptors? descriptors,
    WalletDescriptorsGate? gate,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          walletDescriptorsProvider.overrideWith(
            () => _FakeWalletDescriptorsNotifier(descriptors),
          ),
          if (gate != null)
            walletDescriptorsGateProvider.overrideWithValue(gate),
        ],
        // Halve the text scale so the block-font title fits the fixed-width
        // button -- the assertion is on the `disabled` prop, not on layout.
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(0.5)),
                child: const DExportDescriptorsButton(),
              ),
            ),
          ),
        ),
      ),
    );
  });

  group('DExportDescriptorsButton', () {
    testWidgets('wires the export icon and is disabled while not loaded', (
      tester,
    ) async {
      await pumpButton(tester, descriptors: null);

      final button = tester.widget<DSettingsButton>(
        find.byType(DSettingsButton),
      );
      expect(button.icon, DSettingsButtonIcon.export);
      expect(button.disabled, isTrue);
    });

    testWidgets('is enabled once the descriptors are loaded', (tester) async {
      await pumpButton(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: 'native',
          nestedSegwit: 'nested',
        ),
      );

      final button = tester.widget<DSettingsButton>(
        find.byType(DSettingsButton),
      );
      expect(button.disabled, isFalse);
    });

    testWidgets('tapping the enabled entry runs the access gate', (
      tester,
    ) async {
      final gate = _MockWalletDescriptorsGate();
      when(() => gate.open()).thenAnswer((_) async {});

      await pumpButton(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: 'native',
          nestedSegwit: 'nested',
        ),
        gate: gate,
      );

      await tester.runAsync(() async {
        await tester.tap(find.byType(DSettingsButton));
        await tester.pump();
      });

      verify(() => gate.open()).called(1);
    });
  });
}
