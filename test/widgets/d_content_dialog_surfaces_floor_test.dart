/// ADR-0014 floor sweep, `DContentDialog` family.
///
/// Issue #268. Every surface here is mounted in its tallest realistic provider
/// state at [designHeight] and at [floor]. At the design height the wrapper's
/// own scroll owner has nothing to scroll; at the floor nothing overflows
/// vertically and the surface's primary control is `hitTestable()`.
///
/// **When a `textScale` appears at a call site, read the comment beside it.**
/// `--no-test-assets` gives the wrong glyph metrics, so a surface can carry a
/// vertical overflow or a scroll extent that production never has. The rule
/// this sweep applies before calling one an artefact rather than a defect, and
/// every call site records its own figures against it:
///
/// 1. the figure is the same at the design height and at the floor, and the
///    surface sits in a box whose height is a literal below the floor, so the
///    window height never reaches it; and
/// 2. the figure falls to zero at a mild text scale.
///
/// A figure that survives a scale of 0.5 fails the rule and is filed as a
/// defect instead -- that is what separated `WalletLocked` (85px at 1.0, 72px
/// at 0.5, issue #294) from the artefacts the sweep ruled out. A test that
/// runs at a scale states its property of the surface *at that scale*.
///
/// **What the rule cannot do.** Shrinking the text shrinks real content as
/// well as block-font noise, so part 2 alone cannot tell a glyph artefact from
/// a content overflow that a smaller font happens to absorb. What the rule
/// does establish is part 1: the box is correct and the window height is not
/// what fills it. docs/TESTING.md draws the same line -- a layout test at the
/// floor bounds the box, not the glyphs, and the glyph fit is what the
/// on-device check is for. Every surface carrying a scale here is therefore
/// also on the manual-test list of the pull request, to be confirmed at
/// 1280x720 with the production font.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
// Riverpod 3 does not export `Override` from its Flutter entry point -- prior
// art: test/helpers/settings_container.dart.
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/addresses/d_addresses.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/main/d_generate_address_popup.dart';
import 'package:sideswap/desktop/markets/widgets/d_accept_quote_error_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_edit_order_error_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_order_submit_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_preview_order_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_start_order_error_dialog.dart';
import 'package:sideswap/desktop/settings/d_need_restart_dialog.dart';
import 'package:sideswap/desktop/settings/d_settings_custom_host.dart';
import 'package:sideswap/desktop/settings/d_settings_delete_wallet.dart';
import 'package:sideswap/desktop/settings/d_settings_jade_device.dart';
import 'package:sideswap/desktop/settings/d_settings_pin_disable_success.dart';
import 'package:sideswap/desktop/settings/d_settings_pin_success.dart';
import 'package:sideswap/desktop/stokr/d_stokr_country_restrictions_info_popup.dart';
import 'package:sideswap/desktop/stokr/d_stokr_need_register_popup.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/listeners/launch_page_delete_wallet_listener.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

void main() {
  late MockWallet wallet;
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    routeRecorder = RouteRecorder();
    // `goBack()` and `isAuthenticated()` return values, so an unstubbed call
    // throws on the null return before a tap's effect can be observed.
    when(() => wallet.goBack()).thenReturn(true);
    when(() => wallet.isAuthenticated()).thenAnswer((_) async => false);
  });

  /// Mounts [surface] alone in a desktop window of [view].
  ///
  /// The theme is the real desktop one: several of these dialogs dereference
  /// `Theme.of(context).extension<...>()!`, which a bare `ThemeData` has not
  /// got. Prior art: test/widgets/d_markets_dialogs_floor_test.dart.
  ///
  /// The pump runs inside `runAsync` because every `DButton` resolves its
  /// focus theme through a throwaway `ProviderContainer` whose zero-duration
  /// dispose timer never settles under fake async.
  ///
  /// The surface is *pushed* on a route above a blank home rather than mounted
  /// as the home itself: `Navigator.pop` refuses to remove the root route, so
  /// a surface whose primary action pops would have no observable effect.
  /// Prior art: [RouteRecorder] in test/helpers/surface_floor.dart.
  Future<void> pump(
    WidgetTester tester,
    Size view,
    Widget surface, {
    List<Override> overrides = const [],
    String? routeName,
    double textScale = 1.0,
  }) => tester.runAsync(() async {
    sizeView(tester, view);
    final container = ProviderContainer.test(
      overrides: [
        ...overrides,
        walletProvider.overrideWithValue(wallet),
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(
              mnemonicEncrypted: Uint8List.fromList([]),
              jadeId: '',
            ),
          ),
        ),
      ],
    );
    final themeData = container.read(desktopAppThemeProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            brightness: themeData.brightness,
            textTheme: themeData.textTheme,
            extensions: themeData.themeExtensions,
            // `--no-test-assets` has no ink shader.
            splashFactory: NoSplash.splashFactory,
          ),
          navigatorObservers: [routeRecorder],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    unawaited(
      Navigator.of(tester.element(find.byType(Scaffold))).push(
        MaterialPageRoute<void>(
          settings: RouteSettings(name: routeName),
          builder: (_) => Scaffold(body: surface),
        ),
      ),
    );
    // Not `pumpAndSettle`: some of these surfaces keep an animation alive
    // indefinitely, which never settles.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  /// The two cases ADR-0014 decision 13 asks of every surface.
  ///
  /// [primary] is the surface's primary control. [tapped] is the effect
  /// tapping it must have; a surface whose primary control is not tappable in
  /// isolation passes `null` and the floor case asserts reachability only.
  ///
  /// [pinned] says the surface puts its primary control in the wrapper's
  /// `actions` slot, which the wrapper keeps outside the scroll body. Most of
  /// this family instead declares a `maxHeight` at or below the floor -- seven
  /// of them at 605 against the floor's 620 -- and puts its button inside
  /// `content`; there the control is legitimately inside the scroll region and
  /// nothing ever scrolls, so the assertion would be false.
  ///
  /// The corollary is worth stating: a surface whose declared box is smaller
  /// than the floor lays out identically at both sizes, so its green floor
  /// result is structural rather than measured. The floor case still earns its
  /// keep -- it is what would catch a box that grew past 620 -- but it is not
  /// evidence that the floor was tight and the surface survived it.
  void sweep(
    String name, {
    required Widget Function() build,
    required Finder Function() primary,
    List<Override> Function()? overrides,
    void Function()? tapped,
    bool pinned = false,
    String? routeName,
    double textScale = 1.0,
    Finder? evidence,
  }) {
    group(name, () {
      /// Mounts the surface at [view]. [build] and [overrides] are invoked
      /// per call, never hoisted: a shared widget or override list would leak
      /// the first test's state into the second.
      Future<void> mount(WidgetTester tester, Size view) => pump(
        tester,
        view,
        build(),
        overrides: overrides?.call() ?? const [],
        routeName: routeName,
        textScale: textScale,
      );

      testWidgets('at the design height the body is unscrolled', (
        tester,
      ) async {
        final errors = captureOverflow();

        await mount(tester, designHeight);

        // The surface really rendered its tallest branch. Without this a fake
        // that silently failed to take, or a provider that resolved to its
        // empty state, would leave that branch unrendered and every assertion
        // below would pass on an empty dialog.
        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        expect(ownScrollView, findsOneWidget);
        if (pinned) {
          // The one match is the wrapper's own owner: the pinned control is
          // outside it.
          expect(
            find.descendant(of: ownScrollView, matching: primary()),
            findsNothing,
          );
        }
        expect(extentOf(tester, ownScrollView), 0);
        expect(verticalOverflows(errors), isEmpty);
      });

      testWidgets('at the floor nothing overflows and the primary control is '
          'reachable', (tester) async {
        final errors = captureOverflow();

        await mount(tester, floor);

        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        expect(verticalOverflows(errors), isEmpty);
        expect(
          tester.getBottomLeft(primary()).dy,
          lessThanOrEqualTo(floor.height),
        );
        expect(primary().hitTestable(), findsOneWidget);
        if (tapped != null) {
          await tapAndDrain(tester, primary());
          tapped();
        }
      });
    });
  }

  final closeButton = find.widgetWithText(DCustomFilledBigButton, 'Close');
  final okButton = find.widgetWithText(DCustomFilledBigButton, 'OK');
  final registerOnStokr = find.widgetWithText(
    DCustomFilledBigButton,
    'REGISTER ON STOKR',
  );
  var closed = 0;
  setUp(() => closed = 0);
  void onClose() => closed++;

  sweep(
    'DAcceptQuoteErrorDialog',
    build: () => const DAcceptQuoteErrorDialog(),
    overrides: () => [
      marketAcceptQuoteErrorProvider.overrideWithValue(
        Option.of('The quote expired before it could be accepted.'),
      ),
    ],
    primary: () => closeButton,
    evidence: find.text('The quote expired before it could be accepted.'),
  );

  sweep(
    'DStartOrderErrorDialog',
    build: () => DStartOrderErrorDialog(onClose: onClose),
    overrides: () => [
      marketStartOrderErrorProvider.overrideWith(
        () => _FakeStartOrderError(
          const StartOrderError(error: 'The order could not be started.'),
        ),
      ),
    ],
    primary: () => closeButton,
    evidence: find.text('The order could not be started.'),
    tapped: () => expect(closed, 1),
  );

  sweep(
    'DStartOrderQuoteErrorDialog',
    build: () => DStartOrderQuoteErrorDialog(
      onClose: onClose,
      optionStartOrderQuoteError: Option.of(
        QuoteError(error: 'The server refused the quote.'),
      ),
    ),
    primary: () => closeButton,
    evidence: find.text('The server refused the quote.'),
    tapped: () => expect(closed, 1),
  );

  sweep(
    'DStartOrderUnregisteredGaidDialog',
    build: () => DStartOrderUnregisteredGaidDialog(
      onClose: onClose,
      optionStartOrderUnregisteredGaid: Option.of(
        QuoteUnregisteredGaid(
          orderId: Int64(),
          quoteUnregisteredGaid: From_Quote_UnregisteredGaid(
            domainAgent: 'example.com',
          ),
        ),
      ),
    ),
    primary: () => closeButton,
    evidence: find.text('https://example.com'),
    tapped: () => expect(closed, 1),
  );

  sweep(
    'OrderSubmitErrorDialog',
    build: () => OrderSubmitErrorDialog(onClose: onClose),
    overrides: () => [
      orderSubmitErrorProvider.overrideWith(
        () => _FakeOrderSubmitError('The order was rejected by the server.'),
      ),
    ],
    primary: () => closeButton,
    evidence: find.text('The order was rejected by the server.'),
    tapped: () => expect(closed, 1),
  );

  sweep(
    'OrderSubmitUnregisteredGaid',
    build: () => OrderSubmitUnregisteredGaid(onClose: onClose),
    overrides: () => [
      orderSubmitUnregisteredGaidProvider.overrideWith(
        () => _FakeOrderSubmitUnregisteredGaid('example.com'),
      ),
    ],
    primary: () => closeButton,
    tapped: () => expect(closed, 1),
  );

  sweep(
    'DNeedRestartPopupDialog',
    build: () => const DNeedRestartPopupDialog(),
    primary: () => find.widgetWithText(DCustomButton, 'OK'),
    // OK saves the network settings and pops the dialog; the pop is the
    // externally observable half.
    tapped: () => expect(routeRecorder.pops, 1),
  );

  sweep(
    'DSettingsPinSuccess',
    build: () => const DSettingsPinSuccess(),
    primary: () => okButton,
    pinned: true,
    tapped: () => verify(() => wallet.settingsViewPage()).called(1),
  );

  sweep(
    'DSettingsPinDisableSuccess',
    build: () => const DSettingsPinDisableSuccess(),
    primary: () => okButton,
    pinned: true,
    tapped: () => verify(() => wallet.settingsViewPage()).called(1),
  );

  sweep(
    'DSettingsDeleteWallet',
    build: () => const DSettingsDeleteWallet(),
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'YES'),
    pinned: true,
    tapped: () => verify(() => wallet.isAuthenticated()).called(1),
  );

  sweep(
    'DeleteWalletConfirmationDialog',
    build: () => const DeleteWalletConfirmationDialog(),
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'YES'),
    tapped: () => expect(routeRecorder.pops, 1),
  );

  sweep(
    'DStokrNeedRegisterPopup',
    build: () => const DStokrNeedRegisterPopup(),
    primary: () => registerOnStokr,
    // Not tapped: the button opens the asset's domain-agent URL, and the
    // production widget resolves that asset to `null` today
    // (d_stokr_need_register_popup.dart:29), so the callback is a no-op with
    // nothing observable to assert.
  );

  sweep(
    'DStokrCountryRestrictionsInfoPopup',
    build: () => const DStokrCountryRestrictionsInfoPopup(),
    primary: () => registerOnStokr,
    // Not tapped: same domain-agent URL, which `openUrl` sends to the platform
    // channel rather than to anything the test can observe.
  );

  sweep(
    'EditOrderErrorDialog',
    build: () => const EditOrderErrorDialog(),
    overrides: () => [
      marketEditOrderErrorProvider.overrideWith(
        () => _FakeEditOrderError('The order could not be edited.'),
      ),
    ],
    primary: () => closeButton,
    evidence: find.text('The order could not be edited.'),
    // Pushed under the route name production gives it: the dialog closes with
    // `popUntil(route.settings.name != <name>)`, so without the name the tap
    // has nothing to remove and no observable effect.
    routeName: editOrderErrorRouteName,
    tapped: () => expect(routeRecorder.pops, 1),
  );

  sweep(
    'DGenerateAddressPopup',
    build: () => const DGenerateAddressPopup(),
    primary: () => find.widgetWithText(DCustomButton, 'GENERATE'),
    // The two wallet-type panels are a fixed `SizedBox(height: 280)` whose
    // description text wraps under the `--no-test-assets` block font. Measured:
    // the inner column overflows by the same 88 px at the design height and at
    // the floor, and clears at a text scale of 0.7 and below -- so it is a
    // glyph-metric artefact of the test font, not a floor defect. Scaling the
    // text cannot move the surface's own extents: the dialog is bounded at
    // `maxHeight: 505`, well under the floor.
    textScale: 0.7,
    // Not tapped: GENERATE pops the popup and then asks the desktop dialog
    // host to open the receive-address dialog
    // (d_generate_address_popup.dart:109). A surface-level harness has no such
    // host, so the tap fails on the second half whatever the first half did.
  );

  sweep(
    'DStartOrderLowBalanceErrorDialog',
    build: () => DStartOrderLowBalanceErrorDialog(
      onClose: onClose,
      optionStartOrderQuoteLowBalance: Option.of(_lowBalance()),
    ),
    primary: () => closeButton,
    evidence: find.text('1.00000000'),
    tapped: () => expect(closed, 1),
  );

  sweep(
    'OrderSubmitSuccessDialog',
    build: () => OrderSubmitSuccessDialog(onClose: onClose),
    overrides: () => [
      orderSubmitSuccessProvider.overrideWith(_FakeOrderSubmitSuccess.new),
    ],
    primary: () => okButton,
    evidence: find.text('BASE/QUOTE'),
    tapped: () => expect(closed, 1),
  );

  sweep(
    'DSettingsCustomHost',
    build: () => const DSettingsCustomHost(),
    // ADR-0014 decision 13 asks for the wrapper's `actions` row; here that is
    // BACK. APPLY sits inside the body and is disabled until the host and the
    // port are both filled in.
    primary: () => find.widgetWithText(DCustomTextBigButton, 'BACK'),
    pinned: true,
    tapped: () => expect(routeRecorder.pops, 1),
  );

  sweep(
    'DSettingsJadeDevice',
    build: () => const DSettingsJadeDevice(),
    overrides: () => [
      jadeDeviceProvider.overrideWith(_FakeJadeDevices.new),
    ],
    // The dialog has no `actions` row and mounts its device rows with
    // `register: false`, so no REGISTER button exists. Its only control is the
    // close button in the title, which the wrapper keeps outside the scroll
    // body exactly as it keeps `actions`. Prior art:
    // test/widgets/d_amp_login_dialogs_height_test.dart.
    primary: () => find.byIcon(Icons.close),
    pinned: true,
    // The device list is the dialog's tallest state; the spinner branch is
    // shorter. Two devices, because the dialog renders a card per device.
    evidence: find.text('COM4'),
    tapped: () => expect(routeRecorder.pops, 1),
  );

  sweep(
    'DPreviewOrderDialog',
    build: () => const DPreviewOrderDialog(),
    overrides: () => [
      previewOrderQuoteSuccessProvider.overrideWith(_FakeQuoteSuccess.new),
      // A non-zero time to live. The production notifier starts a periodic
      // timer and closes the dialog the moment the quote expires, so a zero
      // here would unmount the surface before it could be measured.
      orderSignTtlProvider.overrideWith(_FakeOrderSignTtl.new),
    ],
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'Accept'),
    evidence: find.text('4.00000000'),
    // Not tapped: accepting sends the quote to the wallet through a Jade
    // authorisation the harness has no device for, and the dialog then waits
    // for a server reply that never arrives.
    routeName: desktopOrderPreviewRouteName,
  );

  sweep(
    'DAddressesDetails',
    build: () => const DAddressesDetails(),
    overrides: () => [
      addressDetailsDialogProvider.overrideWith(_FakeAddressDetails.new),
    ],
    // Without a selected address every field of the body renders empty.
    evidence: find.text(
      'lq1qqw0address0000000000000000000000000000000000000000',
    ),
    primary: () => find.byIcon(Icons.close),
    pinned: true,
    // The details column overflows its declared `SizedBox(height: 470)` by
    // 16px under the `--no-test-assets` block font, and by nothing at a text
    // scale of 0.8. The dialog is bounded at `maxHeight: 600`, so the window
    // height never reaches the column: the overflow is a glyph-metric artefact
    // of the test font, not a floor defect.
    textScale: 0.8,
    tapped: () => expect(routeRecorder.pops, 1),
  );
}

/// The dialogs read `.notifier`-backed providers, which `overrideWithValue`
/// does not supply -- prior art: test/widgets/d_markets_dialogs_floor_test.dart.
class _FakeStartOrderError extends MarketStartOrderErrorNotifier {
  _FakeStartOrderError(this._error);

  final StartOrderError _error;

  @override
  Option<StartOrderError> build() => Option.of(_error);
}

class _FakeOrderSubmitError extends OrderSubmitErrorNotifier {
  _FakeOrderSubmitError(this._error);

  final String _error;

  @override
  Option<String> build() => Option.of(_error);
}

class _FakeOrderSubmitUnregisteredGaid
    extends OrderSubmitUnregisteredGaidNotifier {
  _FakeOrderSubmitUnregisteredGaid(this._domainAgent);

  final String _domainAgent;

  @override
  Option<String> build() => Option.of(_domainAgent);
}

/// The submitted order the success dialog renders, in its tallest realistic
/// state: a price-tracking order, which is the branch that adds the tracking
/// row. Prior art: test/widgets/d_markets_dialogs_floor_test.dart.
class MockUiOwnOrder extends Mock implements UiOwnOrder {}

MockUiOwnOrder _submittedOrder() {
  final asset = Asset(
    assetId: 'base',
    ticker: 'BASE',
    name: 'Base',
    precision: 8,
  );
  final quote = Asset(
    assetId: 'quote',
    ticker: 'QUOTE',
    name: 'Quote',
    precision: 8,
  );
  final order = MockUiOwnOrder();
  when(() => order.tradeDir).thenReturn(TradeDir.SELL);
  when(() => order.productName).thenReturn('BASE/QUOTE');
  when(() => order.baseAsset).thenReturn(Option.of(asset));
  when(() => order.quoteAsset).thenReturn(Option.of(quote));
  when(() => order.amountString).thenReturn('1.00000000');
  when(() => order.priceString).thenReturn('2.00000000');
  when(() => order.total).thenReturn('2.00000000');
  when(() => order.amountIcon).thenReturn(const SizedBox(width: 24, height: 24));
  when(() => order.priceIcon).thenReturn(const SizedBox(width: 24, height: 24));
  when(() => order.orderTypeDescription).thenReturn('Public');
  when(() => order.offlineSwapTypeDescription).thenReturn('Online');
  when(() => order.isPriceTracking).thenReturn(true);
  when(() => order.priceTrackingPercent).thenReturn(Decimal.zero);
  when(() => order.orderId).thenReturn(OrderId());
  return order;
}

class _FakeOrderSubmitSuccess extends OrderSubmitSuccessNotifier {
  final MockUiOwnOrder order = _submittedOrder();

  @override
  Option<UiOwnOrder> build() => Option.of(order);
}

class _FakeEditOrderError extends MarketEditOrderErrorNotifier {
  _FakeEditOrderError(this._error);

  final String _error;

  @override
  Option<String> build() => Option.of(_error);
}

/// The low-balance quote the dialog renders. Only the five fields the dialog
/// reads are stubbed; the rest of `QuoteLowBalance` is derived state a
/// behaviour-preserving refactor is free to move.
class MockQuoteLowBalance extends Mock implements QuoteLowBalance {}

MockQuoteLowBalance _lowBalance() {
  final deliver = Asset(
    assetId: 'deliver',
    ticker: 'DELIVER',
    name: 'Deliver',
    precision: 8,
  );
  final receive = Asset(
    assetId: 'receive',
    ticker: 'RECEIVE',
    name: 'Receive',
    precision: 8,
  );
  final lowBalance = MockQuoteLowBalance();
  when(() => lowBalance.deliverAsset).thenReturn(Option.of(deliver));
  when(() => lowBalance.deliverAmount).thenReturn('3.00000000');
  when(() => lowBalance.receiveAsset).thenReturn(Option.of(receive));
  when(() => lowBalance.receiveAmount).thenReturn('6.00000000');
  when(() => lowBalance.availableAmount).thenReturn('1.00000000');
  return lowBalance;
}

/// Two connected Jades, which is the dialog's tallest state: it renders one
/// card per device (d_settings_jade_device.dart:82), and the unavailable
/// branch renders a single spinner instead.
class _FakeJadeDevices extends JadeDeviceNotifier {
  @override
  JadeDevicesState build() => JadeDevicesState.available(
    devices: [
      From_JadePorts_Port(port: 'COM3', jadeId: 'jade-1'),
      From_JadePorts_Port(port: 'COM4', jadeId: 'jade-2'),
    ],
  );
}

/// The quote the preview dialog renders, in the branch that draws the whole
/// body. Only the fields the body reads are stubbed.
class MockQuoteSuccess extends Mock implements QuoteSuccess {}

MockQuoteSuccess _quoteSuccess() {
  final deliver = Asset(
    assetId: 'deliver',
    ticker: 'DELIVER',
    name: 'Deliver',
    precision: 8,
  );
  final receive = Asset(
    assetId: 'receive',
    ticker: 'RECEIVE',
    name: 'Receive',
    precision: 8,
  );
  final quote = MockQuoteSuccess();
  when(() => quote.tradeDir).thenReturn(TradeDir.SELL);
  when(() => quote.feeAsset).thenReturn(Option.of(receive));
  when(() => quote.deliverAsset).thenReturn(Option.of(deliver));
  when(() => quote.deliverAmount).thenReturn('2.00000000');
  when(() => quote.receiveAsset).thenReturn(Option.of(receive));
  when(() => quote.receiveAmount).thenReturn('4.00000000');
  when(() => quote.priceAsset).thenReturn(Option.of(receive));
  when(() => quote.priceString).thenReturn('2.00000000');
  when(() => quote.fixedFeeString).thenReturn('0.00001000');
  when(() => quote.serverFeeString).thenReturn('0.00002000');
  when(() => quote.startOrderSuccess).thenReturn(null);
  when(() => quote.quoteId).thenReturn(1);
  return quote;
}

class _FakeQuoteSuccess extends PreviewOrderQuoteSuccessNotifier {
  @override
  Option<QuoteSuccess> build() => Option.of(_quoteSuccess());
}

/// A live quote. The production notifier drives a periodic timer off the
/// order's time to live, which a layout test neither needs nor can settle.
class _FakeOrderSignTtl extends OrderSignTtl {
  @override
  int build() => 30;
}

/// The address the details dialog renders. Without one the body is empty.
class _FakeAddressDetails extends AddressDetailsDialogNotifier {
  @override
  AddressDetailsState build() => const AddressDetailsState.data(
    AddressesItem(
      account: Account.REG,
      address: 'lq1qqw0address0000000000000000000000000000000000000000',
      unconfidentialAddress: 'ex1qunconfidential000000000000000',
      index: 7,
      isInternal: false,
      utxos: [],
    ),
  );
}
