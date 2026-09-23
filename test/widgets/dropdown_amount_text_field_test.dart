// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/instant_swap/widgets/dropdown_amount_text_field.dart';
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

/// The inputs a caller can change without remounting the widget: the two the
/// focus listener reads, plus [errorText], which the effect does not key on and
/// so rebuilds the widget without re-running it. [errorText] stays null
/// wherever the underline is asserted — on an enabled field a non-null one
/// paints it red regardless of the focus.
typedef FieldProps = ({
  FocusNode focusNode,
  bool disabledAmount,
  String? errorText,
});

FieldProps fieldProps(
  FocusNode focusNode, {
  bool disabledAmount = false,
  String? errorText,
}) => (
  focusNode: focusNode,
  disabledAmount: disabledAmount,
  errorText: errorText,
);

/// Pumps the field under a rebuild trigger that drives those inputs: assigning
/// to the returned notifier rebuilds the widget, re-running the focus effect
/// only when a keyed input changed.
Future<ValueNotifier<FieldProps>> pumpField(
  WidgetTester tester,
  FieldProps props,
) async {
  final notifier = ValueNotifier<FieldProps>(props);
  addTearDown(notifier.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        assetFromAssetIdProvider(_assetId).overrideWithValue(Option.of(_asset)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<FieldProps>(
            valueListenable: notifier,
            builder: (context, value, _) => DropdownAmountTextField(
              availableAssets: const [_assetId],
              selectedAssetId: _assetId,
              focusNode: value.focusNode,
              disabledAmount: value.disabledAmount,
              showBalance: false,
              errorText: value.errorText,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return notifier;
}

/// The rebuilt widget's own [DropdownAmountTextField.errorText] — proof the
/// rebuild trigger actually fired, so the assertions after it cannot pass
/// vacuously.
String renderedError(WidgetTester tester) => tester
    .widget<DropdownAmountTextField>(find.byType(DropdownAmountTextField))
    .errorText!;

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

/// The colour of the underline the widget draws, which is what `hasFocus`
/// drives.
Color fieldBorderColor(WidgetTester tester) {
  final decoratedBox = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(DropdownAmountTextField),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );

  return ((decoratedBox.decoration as BoxDecoration).border! as Border)
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
        fieldProps(supplied, errorText: 'a'),
      );

      expect(fieldNode(tester), same(supplied));

      supplied.requestFocus();
      await tester.pump();
      expect(supplied.hasFocus, isTrue, reason: 'precondition: it is focused');

      props.value = fieldProps(supplied, errorText: 'b');
      await tester.pump();
      expect(renderedError(tester), 'b', reason: 'precondition: it rebuilt');

      expect(fieldNode(tester), same(supplied));
      expect(supplied.hasFocus, isTrue);

      await unmount(tester);

      expect(() => supplied.addListener(() {}), isNotDisposed);
    },
  );

  testWidgets(
    'a change to disabledAmount reaches the listener, so the underline reports '
    'the focus the node already holds',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(
        tester,
        fieldProps(supplied, disabledAmount: true),
      );

      supplied.requestFocus();
      await tester.pumpAndSettle();
      expect(supplied.hasFocus, isTrue, reason: 'precondition: it is focused');
      expect(
        fieldBorderColor(tester),
        SideSwapColors.jellyBean,
        reason:
            'precondition: a disabled field draws no focus underline, which '
            'the render decides on its own',
      );

      props.value = fieldProps(supplied);
      await tester.pump();

      expect(fieldBorderColor(tester), SideSwapColors.brightTurquoise);
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
    'the focus listener is registered once across rebuilds and removed when '
    'the field goes away',
    (tester) async {
      final supplied = CountingFocusNode();
      addTearDown(supplied.dispose);

      final props = await pumpField(tester, fieldProps(supplied));
      final mounted = supplied.listeners;

      props.value = fieldProps(supplied, disabledAmount: true);
      await tester.pump();
      props.value = fieldProps(supplied);
      await tester.pump();
      expect(
        tester
            .widget<DropdownAmountTextField>(
              find.byType(DropdownAmountTextField),
            )
            .disabledAmount,
        isFalse,
        reason: 'precondition: it rebuilt',
      );

      expect(supplied.listeners, mounted);

      await unmount(tester);

      expect(supplied.listeners, 0);
    },
  );
}
