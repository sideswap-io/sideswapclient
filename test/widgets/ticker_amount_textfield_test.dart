// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/widgets/ticker_amount_textfield.dart';
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

/// `ChangeNotifier.addListener` asserts the notifier has not been disposed,
/// which makes it the discriminator for "was this node freed?" — there is no
/// public `debugDisposed` on `FocusNode`.
final isNotDisposed = returnsNormally;

/// The inputs a caller can change without remounting the widget: the three the
/// focus listener reads, plus [hintText], which the effect does not key on and
/// so rebuilds the widget without re-running it.
typedef FieldProps = ({
  FocusNode focusNode,
  bool showHintText,
  bool readOnly,
  String hintText,
});

FieldProps fieldProps(
  FocusNode focusNode, {
  bool showHintText = false,
  bool readOnly = false,
  String hintText = 'hint',
}) => (
  focusNode: focusNode,
  showHintText: showHintText,
  readOnly: readOnly,
  hintText: hintText,
);

/// The tree the tests pump. [swapType] is the fourth input the focus listener
/// reads, and it reaches the widget through a provider rather than through a
/// constructor argument.
Widget fieldScope(ValueNotifier<FieldProps> notifier, SwapType swapType) {
  return ProviderScope(
    overrides: [
      assetFromAssetIdProvider(_assetId).overrideWithValue(Option.of(_asset)),
      swapTypeProvider.overrideWithValue(swapType),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: ValueListenableBuilder<FieldProps>(
          valueListenable: notifier,
          builder: (context, value, _) => TickerAmountTextField(
            dropdownValue: _assetId,
            availableAssets: const [_assetId],
            focusNode: value.focusNode,
            hintText: value.hintText,
            showHintText: value.showHintText,
            readOnly: value.readOnly,
          ),
        ),
      ),
    ),
  );
}

/// Pumps the field under a rebuild trigger that drives the constructor inputs:
/// assigning to the returned notifier rebuilds the widget, re-running the focus
/// effect only when a keyed input changed.
Future<ValueNotifier<FieldProps>> pumpField(
  WidgetTester tester,
  FieldProps props, {
  SwapType swapType = const SwapType.pegOut(),
}) async {
  final notifier = ValueNotifier<FieldProps>(props);
  addTearDown(notifier.dispose);

  await tester.pumpWidget(fieldScope(notifier, swapType));
  await tester.pumpAndSettle();

  return notifier;
}

/// The rebuilt widget's own [TickerAmountTextField.hintText] — proof the
/// rebuild trigger actually fired, so the assertions after it cannot pass
/// vacuously.
String renderedHint(WidgetTester tester) => tester
    .widget<TickerAmountTextField>(find.byType(TickerAmountTextField))
    .hintText;

/// A node that reports which listeners are still registered on it. It tracks
/// the references themselves, not a running count: `ChangeNotifier` ignores a
/// `removeListener` call that names a reference it never registered, so a
/// counter would reach zero even when the cleanup removed the wrong closure.
/// The `TextField` beneath registers and removes one of its own symmetrically,
/// so a balanced widget leaves this empty once the field is gone.
class CountingFocusNode extends FocusNode {
  final List<VoidCallback> registered = [];

  int get listeners => registered.length;

  @override
  void addListener(VoidCallback listener) {
    registered.add(listener);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    registered.remove(listener);
    super.removeListener(listener);
  }
}

/// What the field actually offers as its hint — `''` when the widget decided to
/// hide it.
String fieldHintText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).decoration!.hintText!;

/// The colour of the underline the widget draws, which is what `hasFocus`
/// drives.
Color fieldBorderColor(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(TickerAmountTextField),
          matching: find.byType(Container),
        )
        .first,
  );

  return ((container.decoration! as BoxDecoration).border! as Border)
      .bottom
      .color;
}

FocusNode fieldNode(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).focusNode!;

/// Unmounting leaves a pending riverpod dispose timer behind; draining it here
/// keeps the pending-timer check from failing the test.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
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

  testWidgets(
    'wires the required node to the field, keeps it across a rebuild, and '
    'never disposes it',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(
        tester,
        fieldProps(supplied, hintText: 'a'),
      );

      expect(fieldNode(tester), same(supplied));

      supplied.requestFocus();
      await tester.pump();
      expect(supplied.hasFocus, isTrue, reason: 'precondition: it is focused');

      props.value = fieldProps(supplied, hintText: 'b');
      await tester.pump();
      expect(renderedHint(tester), 'b', reason: 'precondition: it rebuilt');

      expect(fieldNode(tester), same(supplied));
      expect(supplied.hasFocus, isTrue);

      await unmount(tester);

      expect(() => supplied.addListener(() {}), isNotDisposed);
    },
  );

  testWidgets(
    'a change to showHintText reaches the listener, so the hint appears '
    'without a focus event',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(tester, fieldProps(supplied));

      expect(fieldHintText(tester), '', reason: 'precondition: hint is hidden');

      props.value = fieldProps(supplied, showHintText: true);
      await tester.pump();

      expect(fieldHintText(tester), 'hint');
    },
  );

  testWidgets(
    'focus held while a prop changes is kept and still reported by the '
    'underline',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(tester, fieldProps(supplied));

      supplied.requestFocus();
      await tester.pumpAndSettle();
      expect(
        fieldBorderColor(tester),
        SideSwapColors.brightTurquoise,
        reason: 'precondition: the underline reports focus',
      );

      props.value = fieldProps(supplied, showHintText: true);
      await tester.pump();

      expect(supplied.hasFocus, isTrue);
      expect(fieldBorderColor(tester), SideSwapColors.brightTurquoise);
    },
  );

  testWidgets(
    'the focus listener is registered once across rebuilds and removed when '
    'the field goes away',
    (tester) async {
      final supplied = CountingFocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(tester, fieldProps(supplied));
      final mounted = supplied.listeners;

      props.value = fieldProps(supplied, showHintText: true);
      await tester.pump();
      props.value = fieldProps(supplied);
      await tester.pump();
      expect(
        tester
            .widget<TickerAmountTextField>(find.byType(TickerAmountTextField))
            .showHintText,
        isFalse,
        reason: 'precondition: it rebuilt',
      );

      expect(supplied.listeners, mounted);

      await unmount(tester);

      expect(supplied.listeners, 0);
    },
  );

  testWidgets('the focus listener follows the node it is given', (
    tester,
  ) async {
    final first = FocusNode();
    addTearDown(first.dispose);
    final second = FocusNode();
    addTearDown(second.dispose);

    final props = await pumpField(tester, fieldProps(first));

    first.requestFocus();
    await tester.pumpAndSettle();
    expect(
      fieldBorderColor(tester),
      SideSwapColors.brightTurquoise,
      reason: 'precondition: the first node is focused',
    );

    props.value = fieldProps(second);
    await tester.pump();
    expect(
      fieldNode(tester),
      same(second),
      reason: 'precondition: the field took the new node',
    );

    expect(
      fieldBorderColor(tester),
      SideSwapColors.jellyBean,
      reason: 'the new node holds no focus, and nothing has notified yet',
    );

    second.requestFocus();
    await tester.pumpAndSettle();

    expect(fieldBorderColor(tester), SideSwapColors.brightTurquoise);
  });

  testWidgets(
    'a change to readOnly reaches the listener, so the field it hid the hint '
    'for shows it again',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(
        tester,
        fieldProps(supplied, showHintText: true),
      );
      expect(
        fieldHintText(tester),
        'hint',
        reason: 'precondition: an unfocused editable field offers the hint',
      );

      supplied.requestFocus();
      await tester.pumpAndSettle();
      expect(fieldHintText(tester), '');

      props.value = fieldProps(supplied, showHintText: true, readOnly: true);
      await tester.pump();

      expect(fieldHintText(tester), 'hint');
    },
  );

  testWidgets(
    'a change to swapType reaches the listener, so the hint the peg-in screen '
    'suppressed comes back',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(
        tester,
        fieldProps(supplied, showHintText: true, readOnly: true),
        swapType: const SwapType.pegIn(),
      );

      supplied.requestFocus();
      await tester.pumpAndSettle();
      expect(
        fieldHintText(tester),
        '',
        reason: 'precondition: peg-in suppresses the hint on a read-only field',
      );

      await tester.pumpWidget(fieldScope(props, const SwapType.pegOut()));
      await tester.pump();

      expect(
        supplied.hasFocus,
        isTrue,
        reason: 'precondition: the field was rebuilt, not remounted',
      );
      expect(fieldHintText(tester), 'hint');
    },
  );
}
