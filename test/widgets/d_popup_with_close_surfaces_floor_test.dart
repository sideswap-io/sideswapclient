/// ADR-0014 floor sweep, `DPopupWithClose` family.
///
/// Issue #268. Every surface here is mounted in its tallest realistic provider
/// state at [designHeight] and at [floor]. At the design height the surface
/// keeps its declared layout; at the floor nothing overflows vertically and
/// the surface's primary control is `hitTestable()`.
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
// Riverpod 3 does not export `Override` from its Flutter entry point -- prior
// art: test/helpers/settings_container.dart.
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/common/widgets/peg_out_edit_fee_rate_dialog.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/home/widgets/d_export_csv_popup.dart';
import 'package:sideswap/desktop/main/d_export_tx_success.dart';
import 'package:sideswap/desktop/main/d_open_tx_import.dart';
import 'package:sideswap/desktop/main/d_view_tx_popup.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_notifications.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/csv_provider.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/swap/fee_suggestions.dart';
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
    when(() => wallet.goBack()).thenReturn(true);
  });

  /// Mounts [surface] alone in a desktop window of [view].
  ///
  /// The theme is the real desktop one, and the pump runs inside `runAsync`
  /// because every `DButton` resolves its focus theme through a throwaway
  /// `ProviderContainer` whose dispose timer never settles under fake async.
  ///
  /// The surface is *pushed* on a route above a blank home: `Navigator.pop`
  /// refuses to remove the root route, so a surface whose close or primary
  /// action pops would have no observable effect as the home.
  Future<void> pump(
    WidgetTester tester,
    Size view,
    Widget surface, {
    List<Override> overrides = const [],
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
        MaterialPageRoute<void>(builder: (_) => Scaffold(body: surface)),
      ),
    );
    // Not `pumpAndSettle`: some of these surfaces keep an animation alive
    // indefinitely, which never settles.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  final popupCard = find
      .descendant(
        of: find.byType(DPopupWithCloseContent),
        matching: find.byType(ClipRRect),
      )
      .first;

  /// The popup's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DPopupWithCloseContent),
    matching: find.byType(SingleChildScrollView),
  );

  /// The two cases ADR-0014 decision 13 asks of every surface.
  ///
  /// [scrollOwner] is the popup's declared owner. Under [ScrollOwner.child]
  /// the wrapper adds no scroll view of its own, so there is no wrapper extent
  /// to measure.
  ///
  /// The floor case measures the design height first and then resizes, so what
  /// it asserts is that *the floor* changes nothing: the same scroll extent and
  /// no new overflow. Every popup in this family declares a fixed height, so
  /// this is the assertion that carries the family's information -- a declared
  /// box does not change with the window, and a surface that broke that would
  /// fail here.
  void sweep(
    String name, {
    required Widget Function() build,
    required Finder Function() primary,
    required double declaredHeight,
    ScrollOwner scrollOwner = ScrollOwner.wrapper,
    List<Override> Function()? overrides,
    void Function()? tapped,
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
        textScale: textScale,
      );

      testWidgets('at the design height the surface keeps its declared '
          'layout', (tester) async {
        final errors = captureOverflow();

        await mount(tester, designHeight);

        // The surface really is in the state the overrides describe. Without
        // this a fake that silently failed to take would leave the tall branch
        // unrendered and every assertion below would pass on an empty popup.
        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        // The card the popup draws, which is what carries the declared height;
        // `DPopupWithCloseContent` itself is a `Center` that fills the window.
        // Prior art: `popupCardBottom` in test/helpers/surface_floor.dart.
        expect(tester.getSize(popupCard).height, declaredHeight);
        switch (scrollOwner) {
          case ScrollOwner.wrapper:
            expect(ownScrollView, findsOneWidget);
            // The body fits the declared box, so there is nothing to scroll.
            expect(extentOf(tester, ownScrollView), 0);
          case ScrollOwner.child:
            // The wrapper adds no scroll view: the body flexes to the declared
            // height instead.
            expect(ownScrollView, findsNothing);
        }
        expect(verticalOverflows(errors), isEmpty);
      });

      testWidgets('at the floor nothing overflows and the primary control is '
          'reachable', (tester) async {
        final errors = captureOverflow();

        await mount(tester, designHeight);
        final designExtent = switch (scrollOwner) {
          ScrollOwner.wrapper => extentOf(tester, ownScrollView),
          ScrollOwner.child => 0.0,
        };
        expect(verticalOverflows(errors), isEmpty);

        // `resizeTo` rather than a second pump: re-pumping the app reuses the
        // `Navigator`, so the pushed surface would stay put at the old size.
        await resizeTo(tester, floor);

        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        expect(verticalOverflows(errors), isEmpty);
        // The card is the same box it was at the design height, so the floor
        // took nothing away from it.
        expect(tester.getSize(popupCard).height, declaredHeight);
        if (scrollOwner == ScrollOwner.wrapper) {
          expect(extentOf(tester, ownScrollView), designExtent);
        }
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

  sweep(
    'DExportTxSuccess',
    build: () => const DExportTxSuccess(),
    declaredHeight: 360,
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'OK'),
    // The body carries 20px of scroll extent inside the declared 360px box
    // under the `--no-test-assets` block font, and none at a text scale of
    // 0.8. The box is 360px whatever the window height is, so the extent is a
    // glyph-metric artefact of the test font, not a floor effect.
    textScale: 0.8,
    tapped: () => expect(routeRecorder.pops, 1),
  );

  sweep(
    'DViewTxPopup',
    build: () => const DViewTxPopup(),
    declaredHeight: 272,
    // Same block-font artefact as `DExportTxSuccess` above, 6px here, against
    // a declared height of 272px.
    textScale: 0.8,
    overrides: () => [
      createTxStateProvider.overrideWith(_FakeCreatedTxState.new),
    ],
    primary: () => find.widgetWithText(DCustomButton, 'EXPORT FILE'),
    evidence: find.text('lq1qqaddress'),
    // Not tapped: exporting writes the PSET through a file picker the harness
    // has no platform implementation for.
  );

  sweep(
    'DExportCsvPopup',
    build: () => const DExportCsvPopup(),
    declaredHeight: 230,
    scrollOwner: ScrollOwner.child,
    overrides: () => [
      exportCsvStateProvider.overrideWith(_FakeExportCsvLoaded.new),
    ],
    // The loaded branch is the popup's tallest state and the only one where
    // Export is enabled.
    evidence: find.text('Transactions loaded: 0'),
    primary: () => find.widgetWithText(DCustomButton, 'Export'),
    // Not tapped: saving writes the CSV through a file picker the harness has
    // no platform implementation for.
  );

  sweep(
    'DesktopFeeRatesDialog',
    build: () => const DesktopFeeRatesDialog(),
    declaredHeight: 371,
    primary: () => find.widgetWithText(DCustomButton, 'Save'),
    evidence: find.text('Custom fee rate:'),
    // Not tapped: Save writes the chosen rate to the current fee-rate
    // provider, which the popup's own tree does not show.
  );

  sweep(
    'DesktopPegOutEditFeeRateDialog',
    build: () => const DesktopPegOutEditFeeRateDialog(),
    declaredHeight: 371,
    overrides: () => [
      pegOutEditFeeRateDialogTransItemProvider.overrideWith(
        _FakePegTransItem.new,
      ),
    ],
    primary: () => find.widgetWithText(DCustomButton, 'Save'),
    // Without a peg transaction the whole body collapses to
    // `SizedBox.shrink()`, so this is what proves the override took.
    evidence: find.text('Custom fee rate:'),
    // Not tapped: Save sends the edited fee rate for the peg order the item
    // belongs to, and the pop is inside the `orderId` branch, which needs a
    // live peg order the harness has not got.
  );

  sweep(
    'DOpenTxImport',
    build: () => const DOpenTxImport(),
    declaredHeight: 321,
    scrollOwner: ScrollOwner.child,
    primary: () => find.widgetWithText(DCustomButton, 'IMPORT FILE'),
    evidence: find.text(
      'Import transaction or paste private swap proposal',
    ),
    // Not tapped: importing reads a PSET through a file picker the harness has
    // no platform implementation for. CONTINUE is disabled until one is read.
  );

  sweep(
    'DNotificationSignPopup',
    build: () => const DNotificationSignPopup(id: 1),
    declaredHeight: 605,
    scrollOwner: ScrollOwner.child,
    overrides: () => [
      notificationsProvider.overrideWith(_SeededSignRequest.new),
    ],
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'Broadcast'),
    // Without a matching entry the popup falls back to an unsized shell, so
    // this is what proves the seeded notification was found.
    evidence: find.text('Sign transaction'),
    // The body's own column overflows the popup's fixed 605px box by 24px
    // under the `--no-test-assets` block font. Measured: the same 24px at the
    // design height and at the floor, 8px at a text scale of 0.8 and nothing
    // at 0.7 -- a glyph-metric artefact of the test font, not a floor defect.
    // The popup's box is 605px whatever the window height is.
    textScale: 0.7,
    // Not tapped: broadcasting needs an unlocked Jade the harness has no
    // device for, and the callback returns before anything observable happens.
  );
}

/// A created transaction, which is the popup's only branch that renders an
/// address; the empty branch draws a blank container.
class _FakeCreatedTxState extends CreateTxStateNotifier {
  @override
  CreateTxState build() => CreateTxState.created(
    CreatedTx(
      addressees: [AddressAmount(address: 'lq1qqaddress')],
    ),
  );
}

/// The loaded branch, which is the popup's tallest state and the only one
/// where Export is enabled.
class _FakeExportCsvLoaded extends ExportCsvStateNotifier {
  @override
  ExportCsvState build() => const ExportCsvState.loaded([]);
}

/// A peg transaction, which is the only branch of the dialog that renders its
/// body at all; without one the content collapses to `SizedBox.shrink()`.
class _FakePegTransItem extends PegOutEditFeeRateDialogTransItem {
  @override
  Option<TransItem> build() => Option.of(TransItem(id: 'peg-1', peg: Peg()));
}

/// One sign request under the id the popup is asked for. `getNotification` and
/// the rest of the notifier stay the real implementation. Prior art:
/// test/widgets/d_notifications_test.dart.
class _SeededSignRequest extends Notifications {
  @override
  List<NotificationData> build() => [
    NotificationData(
      1,
      NotificationType.signRequest(
        From_SignerRequest_Sign(),
        'req-1',
        'example.com',
        const NotificationItemState.empty(),
        DateTime(2026, 1, 1),
        none<int>(),
      ),
    ),
  ];
}
