// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/wallet_descriptors.dart';
import 'package:sideswap/providers/wallet_descriptors_gate_provider.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';
import 'package:sideswap/screens/settings/widgets/export_descriptors_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';

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

  Future<void> pumpButton(
    WidgetTester tester, {
    required WalletDescriptors? descriptors,
    WalletDescriptorsGate? gate,
  }) => tester.pumpWidget(
    ProviderScope(
      overrides: [
        walletDescriptorsProvider.overrideWith(
          () => _FakeWalletDescriptorsNotifier(descriptors),
        ),
        if (gate != null)
          walletDescriptorsGateProvider.overrideWithValue(gate),
      ],
      child: const MaterialApp(
        home: Scaffold(body: ExportDescriptorsButton()),
      ),
    ),
  );

  group('ExportDescriptorsButton', () {
    testWidgets('wires the export icon and is disabled while not loaded', (
      tester,
    ) async {
      await pumpButton(tester, descriptors: null);

      final button = tester.widget<SettingsButton>(
        find.byType(SettingsButton),
      );
      expect(button.type, SettingsButtonType.export);
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

      final button = tester.widget<SettingsButton>(
        find.byType(SettingsButton),
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

      await tester.tap(find.byType(SettingsButton));
      await tester.pump();

      verify(() => gate.open()).called(1);
    });
  });
}
