import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/limit_amount_text_field.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
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

/// The production widget that steals the focus: the `SwitchButton` in
/// `MarketOrderPanel`'s header, wired to `tradeDirStateProvider` the same way,
/// and sitting outside the amount field. The harness reproduces that one
/// relationship and nothing else — the real panel also holds a
/// `LimitPriceTextField` and a trade button, which play no part in this bug.
class _TradeDirSwitch extends ConsumerWidget {
  const _TradeDirSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateProvider);

    return SwitchButton(
      width: 142,
      height: 32,
      value: tradeDirState == TradeDir.SELL,
      onToggle: (value) => ref
          .read(tradeDirStateProvider.notifier)
          .setSide(value ? TradeDir.SELL : TradeDir.BUY),
    );
  }
}

Future<void> pumpField(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        marketSubscribedBaseAssetProvider.overrideWithValue(
          Option.of(_asset('base', 'BASE')),
        ),
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(mnemonicEncrypted: Uint8List.fromList([])),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            children: const [LimitAmountTextField(), _TradeDirSwitch()],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

FocusNode fieldNode(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).focusNode!;

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
  });

  // The unfocus-on-tap-outside arm this bug lives on is selected by
  // `defaultTargetPlatform`, not by `dart:io`, so the variant reaches it on
  // every host. See `editable_text.dart` `_EditableTextTapOutsideAction`.
  final windows = TargetPlatformVariant.only(TargetPlatform.windows);

  testWidgets('a pointer-down on the switch really unfocuses the field', (
    tester,
  ) async {
    await pumpField(tester);
    expect(fieldNode(tester).hasFocus, isTrue, reason: 'precondition');

    // Pointer down only. `SwitchButton`'s `GestureDetector.onTap` fires on
    // pointer up, so the trade direction has not flipped yet — this isolates
    // the desktop unfocus that the refocus effect must undo.
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(SwitchButton)),
    );
    await tester.pump();

    expect(fieldNode(tester).hasFocus, isFalse);

    await gesture.up();
    await tester.pumpAndSettle();
  }, variant: windows);

  testWidgets('switching BUY/SELL leaves the amount field focused', (
    tester,
  ) async {
    await pumpField(tester);
    final nodeBefore = fieldNode(tester);

    await tester.tap(find.byType(SwitchButton));
    await tester.pumpAndSettle();

    final nodeAfter = fieldNode(tester);
    expect(
      identical(nodeBefore, nodeAfter),
      isTrue,
      reason: 'the field is rebuilt, not remounted, so autofocus cannot help',
    );
    expect(nodeAfter.hasFocus, isTrue);
  }, variant: windows);

  testWidgets('switching BUY/SELL keeps the typed amount', (tester) async {
    await pumpField(tester);

    await tester.enterText(find.byType(TextField), '1.5');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchButton));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '1.5',
    );
  }, variant: windows);

  testWidgets('switching BUY/SELL leaves a caret, not a selection', (
    tester,
  ) async {
    await pumpField(tester);

    await tester.enterText(find.byType(TextField), '1.5');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchButton));
    await tester.pumpAndSettle();

    // Desktop `TextField`s select all when they gain focus, so a bare
    // `requestFocus` would leave the amount one keystroke from gone. Keeping
    // the amount is only worth something if the next character extends it.
    final selection = tester
        .widget<TextField>(find.byType(TextField))
        .controller!
        .selection;
    expect(selection, const TextSelection.collapsed(offset: 3));
  }, variant: windows);
}
