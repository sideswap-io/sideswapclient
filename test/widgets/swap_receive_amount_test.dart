// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';
import 'package:sideswap/screens/swap/widgets/swap_receive_amount.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const _assetId = 'lbtc';

Asset get _asset => Asset(
  assetId: _assetId,
  name: 'Liquid Bitcoin',
  ticker: 'L-BTC',
  icon: '',
  precision: 8,
  swapMarket: true,
  domain: '',
  unregistered: false,
  ampMarket: false,
  domainAgent: '',
  instantSwaps: false,
);

/// The external-address field, which the peg-out swap type is what puts on
/// screen: `swapRecvWallet` is `extern` for `SwapType.pegOut` only.
Finder get addressField => find.descendant(
  of: find.byType(ShareCopyScanTextFormField),
  matching: find.byType(TextField),
);

Future<void> pumpReceiveAmount(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        swapTypeProvider.overrideWithValue(const SwapType.pegOut()),
        swapReceiveAssetProvider.overrideWithValue(
          const SwapAsset(assetId: _assetId, assetList: [_assetId]),
        ),
        assetFromAssetIdProvider(_assetId).overrideWithValue(Option.of(_asset)),
      ],
      // The test font draws every glyph as a fixed-width block, which
      // overflows this screen's fixed-width rows at the normal scale.
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(0.4)),
          child: child!,
        ),
        home: const Scaffold(body: SwapReceiveAmount()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
      ),
    );
  });

  testWidgets('the address field drops its focus when editing completes', (
    tester,
  ) async {
    await pumpReceiveAmount(tester);

    final node = tester.widget<TextField>(addressField).focusNode!;
    node.requestFocus();
    await tester.pump();
    expect(node.hasFocus, isTrue, reason: 'precondition: it is focused');

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(node.hasFocus, isFalse);
  });
}
