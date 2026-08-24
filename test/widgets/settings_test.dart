import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings.dart';
import 'package:sideswap/screens/settings/widgets/export_descriptors_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';

import '../helpers/fake_configuration.dart';

class MockEncryptionRepository extends Mock
    implements AbstractEncryptionRepository {}

/// Software-wallet settings (empty `jadeId`) so `isJadeWalletProvider` picks the
/// software layout, which renders the `PIN protection` security row.
SideswapSettings _softwareSettings() => SideswapSettings.empty(
  mnemonicEncrypted: Uint8List.fromList([]),
  jadeId: '',
);

/// Jade-wallet settings so `isJadeWalletProvider` collapses both security rows
/// to `SizedBox`, leaving Export anchored directly after the (empty) security
/// column.
SideswapSettings _jadeSettings() => SideswapSettings.empty(
  mnemonicEncrypted: Uint8List.fromList([]),
  jadeId: 'jade1',
);

void main() {
  // `Localization` and `FlavorConfig` are process-wide/static, so per
  // docs/TESTING.md both are (re)initialised in setUp -- never setUpAll.
  setUp(() {
    Localization.load(const Locale('en'));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: true,
        enableJade: false,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // `isBiometricAvailableProvider` calls `encryptionRepository.canAuthenticate()`
  // (a platform channel); a mock returning false keeps the biometric row a
  // `SizedBox` so the security section is deterministic and channel-free. The
  // PIN row's visibility comes from `isPinAvailableProvider` (sync, jade-gated),
  // so it renders for a software wallet without any biometric resolution.
  Future<void> pumpSettings(
    WidgetTester tester, {
    required SideswapSettings settings,
  }) => tester.runAsync(() async {
    final encryption = MockEncryptionRepository();
    when(() => encryption.canAuthenticate()).thenAnswer((_) async => false);

    tester.view.physicalSize = const Size(500, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
          encryptionRepositoryProvider.overrideWithValue(encryption),
        ],
        child: MaterialApp(
          // CustomAppBar reads this theme extension via a null-check; the app
          // supplies it in production, so the test theme must too.
          theme: ThemeData(extensions: [CustomBackButtonStyle.standard()]),
          home: const Settings(),
        ),
      ),
    );
    // Flush the biometric future (resolves to a hidden row -- ordering is
    // unaffected either way).
    await tester.pump();
  });

  double topText(WidgetTester tester, String text) =>
      tester.getTopLeft(find.text(text)).dy;

  // Top of a settings button by its label -- the same reference frame as
  // `buttonsBetween` (button top, not the label's y within the button).
  double topButton(WidgetTester tester, String text) =>
      tester.getTopLeft(find.widgetWithText(SettingsButton, text)).dy;

  // Count of settings-button rows whose top falls strictly between two y
  // offsets -- used to assert "immediately above" (zero rows between) rather
  // than mere relative order.
  int buttonsBetween(WidgetTester tester, double topDy, double bottomDy) {
    var count = 0;
    for (final element in find.byType(SettingsButton).evaluate()) {
      final dy = (element.renderObject! as RenderBox)
          .localToGlobal(Offset.zero)
          .dy;
      if (dy > topDy && dy < bottomDy) count++;
    }
    return count;
  }

  testWidgets(
    'the export entry renders immediately after the security section and above '
    'Network Access for a software wallet, with no duplicate',
    (tester) async {
      await pumpSettings(tester, settings: _softwareSettings());

      // About us -> PIN protection (security section) -> Export -> Network.
      expect(
        topText(tester, 'About us'),
        lessThan(topText(tester, 'PIN protection')),
      );
      expect(
        topText(tester, 'PIN protection'),
        lessThan(topText(tester, 'Export watch-only descriptors')),
      );
      expect(
        topText(tester, 'Export watch-only descriptors'),
        lessThan(topText(tester, 'Network access')),
      );
      // Immediately above Network: no settings-button row between Export and
      // Network access.
      expect(
        buttonsBetween(
          tester,
          topButton(tester, 'Export watch-only descriptors'),
          topButton(tester, 'Network access'),
        ),
        0,
      );

      // The old Export instance (above About us) is gone -- exactly one remains.
      expect(find.byType(ExportDescriptorsButton), findsOneWidget);
    },
  );

  testWidgets(
    'the export entry renders after the (empty) security section and above '
    'Network Access for a Jade wallet',
    (tester) async {
      await pumpSettings(tester, settings: _jadeSettings());

      // Jade collapses both security rows, so Export follows About us directly.
      expect(find.text('PIN protection'), findsNothing);
      expect(find.text('Biometric protection'), findsNothing);
      expect(
        topText(tester, 'About us'),
        lessThan(topText(tester, 'Export watch-only descriptors')),
      );
      expect(
        topText(tester, 'Export watch-only descriptors'),
        lessThan(topText(tester, 'Network access')),
      );
      // Immediately above Network: no settings-button row between them.
      expect(
        buttonsBetween(
          tester,
          topButton(tester, 'Export watch-only descriptors'),
          topButton(tester, 'Network access'),
        ),
        0,
      );
      expect(find.byType(ExportDescriptorsButton), findsOneWidget);
    },
  );

  testWidgets(
    'when Network Access is flavor-disabled, Language follows the export entry',
    (tester) async {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: false,
        ),
      );

      await pumpSettings(tester, settings: _softwareSettings());

      expect(find.text('Network access'), findsNothing);
      expect(
        topText(tester, 'Export watch-only descriptors'),
        lessThan(topText(tester, 'Language')),
      );
    },
  );

  testWidgets(
    'the export entry stays disabled while the descriptors are not loaded',
    (tester) async {
      // `walletDescriptorsProvider` defaults to null (not loaded).
      await pumpSettings(tester, settings: _softwareSettings());

      final exportButton = find.widgetWithText(
        SettingsButton,
        'Export watch-only descriptors',
      );
      expect(exportButton, findsOneWidget);
      expect(tester.widget<SettingsButton>(exportButton).disabled, isTrue);
    },
  );
}
