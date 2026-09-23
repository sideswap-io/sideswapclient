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
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
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

/// Pumps [SwapSideAmount] under a rebuild trigger that never touches the field
/// itself: changing [balance]'s value rebuilds the widget and nothing else.
Future<ValueNotifier<String>> pumpSideAmount(
  WidgetTester tester, {
  FocusNode? focusNode,
  FocusNode? receiveAddressFocusNode,
  TextEditingController? addressController,
  SwapWallet labelGroupValue = const SwapWallet.local(),
}) async {
  final balance = ValueNotifier<String>('1.0');
  addTearDown(balance.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        assetFromAssetIdProvider(_assetId).overrideWithValue(Option.of(_asset)),
        swapTypeProvider.overrideWithValue(const SwapType.pegOut()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<String>(
            valueListenable: balance,
            builder: (context, value, _) => SwapSideAmount(
              text: 'Receive',
              dropdownValue: _assetId,
              availableAssets: const [_assetId],
              swapType: const SwapType.pegOut(),
              balance: value,
              focusNode: focusNode,
              receiveAddressFocusNode: receiveAddressFocusNode,
              addressController: addressController,
              labelGroupValue: labelGroupValue,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return balance;
}

FocusNode amountFieldNode(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).focusNode!;

/// The rebuilt widget's own [SwapSideAmount.balance] — proof the rebuild
/// trigger actually fired, so the assertions after it cannot pass vacuously.
String renderedBalance(WidgetTester tester) =>
    tester.widget<SwapSideAmount>(find.byType(SwapSideAmount)).balance;

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    // The external-wallet address field reads FlavorConfig.isDesktop.
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
      ),
    );
  });

  testWidgets(
    'the amount field keeps its focus node, and its focus, across a rebuild',
    (tester) async {
      final balance = await pumpSideAmount(tester);

      final node1 = amountFieldNode(tester);
      node1.requestFocus();
      await tester.pump();
      expect(
        node1.hasFocus,
        isTrue,
        reason: 'precondition: the field is focused',
      );

      balance.value = '2.0';
      await tester.pump();
      expect(
        renderedBalance(tester),
        '2.0',
        reason: 'precondition: it rebuilt',
      );

      final node2 = amountFieldNode(tester);
      expect(
        identical(node1, node2),
        isTrue,
        reason: 'the node must survive a rebuild',
      );
      expect(node2.hasFocus, isTrue, reason: 'focus must survive a rebuild');
    },
  );

  testWidgets('a caller-supplied focus node is the one the field is wired to', (
    tester,
  ) async {
    final supplied = FocusNode();
    addTearDown(supplied.dispose);

    final balance = await pumpSideAmount(tester, focusNode: supplied);

    expect(amountFieldNode(tester), same(supplied));

    supplied.requestFocus();
    await tester.pump();

    balance.value = '2.0';
    await tester.pump();
    expect(renderedBalance(tester), '2.0', reason: 'precondition: it rebuilt');

    expect(amountFieldNode(tester), same(supplied));
    expect(supplied.hasFocus, isTrue);
  });

  testWidgets(
    'the external-wallet address field is wired to the supplied node and controller',
    (tester) async {
      final suppliedNode = FocusNode();
      addTearDown(suppliedNode.dispose);
      final suppliedController = TextEditingController();
      addTearDown(suppliedController.dispose);

      // What SwapReceiveAmount renders once the receive wallet is external: it
      // always supplies both, so the fallbacks stay unreached.
      final balance = await pumpSideAmount(
        tester,
        receiveAddressFocusNode: suppliedNode,
        addressController: suppliedController,
        labelGroupValue: const SwapWallet.extern(),
      );

      final addressField = find.byType(ShareCopyScanTextFormField);
      expect(addressField, findsOneWidget);
      expect(
        tester.widget<ShareCopyScanTextFormField>(addressField).focusNode,
        same(suppliedNode),
      );
      expect(
        tester.widget<ShareCopyScanTextFormField>(addressField).controller,
        same(suppliedController),
      );

      balance.value = '2.0';
      await tester.pump();
      expect(
        renderedBalance(tester),
        '2.0',
        reason: 'precondition: it rebuilt',
      );

      expect(
        tester.widget<ShareCopyScanTextFormField>(addressField).focusNode,
        same(suppliedNode),
      );
      expect(
        tester.widget<ShareCopyScanTextFormField>(addressField).controller,
        same(suppliedController),
      );
    },
  );
}
