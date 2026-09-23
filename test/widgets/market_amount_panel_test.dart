import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';

Asset _asset(String id, String ticker) => Asset(
  assetId: id,
  name: ticker,
  ticker: ticker,
  icon: '',
  precision: 8,
  swapMarket: true,
  domain: '',
  unregistered: false,
  ampMarket: false,
  domainAgent: '',
  instantSwaps: false,
);

/// `ChangeNotifier.addListener` asserts the notifier has not been disposed,
/// which makes it the discriminator for "was this node freed?" — there is no
/// public `debugDisposed` on `FocusNode`.
final isDisposed = throwsAssertionError;

/// Pumps the panel under a rebuild trigger that never touches the focus node.
/// The builder hands the panel a fresh `onChanged` closure per build, which is
/// what proves the rebuild actually reached the panel — the panel renders no
/// prop of its own that a test could read back.
Future<ValueNotifier<String>> pumpPanel(WidgetTester tester) async {
  final trigger = ValueNotifier<String>('a');
  addTearDown(trigger.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        marketSubscribedBaseAssetProvider.overrideWithValue(
          Option.of(_asset('base', 'BASE')),
        ),
        marketSubscribedQuoteAssetProvider.overrideWithValue(
          Option.of(_asset('quote', 'QUOTE')),
        ),
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(mnemonicEncrypted: Uint8List.fromList([])),
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
          extensions: [
            MarketColorsStyle(
              sellColor: SideSwapColors.bitterSweet,
              buyColor: SideSwapColors.turquoise,
            ),
          ],
        ),
        home: Scaffold(
          body: ValueListenableBuilder<String>(
            valueListenable: trigger,
            builder: (context, value, _) =>
                MarketAmountPanel(onChanged: (_) => value),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return trigger;
}

ValueChanged<String>? panelOnChanged(WidgetTester tester) =>
    tester.widget<MarketAmountPanel>(find.byType(MarketAmountPanel)).onChanged;

FocusNode fieldNode(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).focusNode!;

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    // The amount field branches on the flavour
    // (market_amount_text_field.dart:190), and the desktop branch is the one
    // this panel is laid out for.
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
        isDesktop: true,
      ),
    );
  });

  testWidgets(
    'owns one focus node, focuses it, and keeps it across a rebuild',
    (tester) async {
      final trigger = await pumpPanel(tester);

      final node1 = fieldNode(tester);
      // The panel drives focus onto this node two ways — `autofocus: true` on
      // the field and its own `requestFocus` effect — so this asserts the node
      // is focusable and attached, not which of the two got there first.
      expect(node1.hasFocus, isTrue);
      final onChanged1 = panelOnChanged(tester);

      trigger.value = 'b';
      await tester.pump();
      expect(
        identical(onChanged1, panelOnChanged(tester)),
        isFalse,
        reason: 'precondition: it rebuilt',
      );

      final node2 = fieldNode(tester);
      expect(
        identical(node1, node2),
        isTrue,
        reason: 'the private node must survive a rebuild',
      );
      expect(node2.hasFocus, isTrue, reason: 'focus must survive a rebuild');

      // The desktop button family schedules a riverpod dispose timer; draining
      // it keeps the pending-timer invariant from failing the test.
      await tester.pump(Duration.zero);
    },
  );

  testWidgets('disposes the node it created', (tester) async {
    await pumpPanel(tester);
    final internal = fieldNode(tester);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);

    expect(() => internal.addListener(() {}), isDisposed);
  });
}
