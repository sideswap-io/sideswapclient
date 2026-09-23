/// ADR-0014 floor sweep, `SideSwapScaffoldPage` pages.
///
/// Issue #268. Each page is mounted in its tallest realistic provider state at
/// [designHeight] and at [floor]. A page has no wrapper-supplied scroll owner,
/// so what is asserted is that the floor takes nothing away: no vertical
/// overflow at either size, and the page's primary control still reachable at
/// the floor.
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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
// Riverpod 3 does not export `Override` from its Flutter entry point -- prior
// art: test/helpers/settings_container.dart.
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/common/widgets/pulsing_dots.dart';
import 'package:sideswap/desktop/addresses/d_addresses.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';
import 'package:sideswap/desktop/desktop_wallet_main.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_submit_finish_dialog.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
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
  });

  /// Mounts [surface] alone in a desktop window of [view].
  ///
  /// The theme is the real desktop one, and the pump runs inside `runAsync`
  /// because every `DButton` resolves its focus theme through a throwaway
  /// `ProviderContainer` whose dispose timer never settles under fake async.
  Future<void> pump(
    WidgetTester tester,
    Size view,
    Widget surface, {
    List<Override> overrides = const [],
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
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    unawaited(
      Navigator.of(tester.element(find.byType(Scaffold))).push(
        MaterialPageRoute<void>(builder: (_) => Scaffold(body: surface)),
      ),
    );
    // Not `pumpAndSettle`: the splash's dots and the toolbar's hover
    // animations never settle.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  /// The two cases ADR-0014 decision 13 asks of every page.
  void sweep(
    String name, {
    required Widget Function() build,
    required Finder Function() primary,
    List<Override> Function()? overrides,
    Finder? evidence,
  }) {
    group(name, () {
      /// Mounts the page at [view]. [build] and [overrides] are invoked
      /// per call, never hoisted: a shared widget or override list would leak
      /// the first test's state into the second.
      Future<void> mount(WidgetTester tester, Size view) =>
          pump(tester, view, build(), overrides: overrides?.call() ?? const []);

      testWidgets('at the design height nothing overflows', (tester) async {
        final errors = captureOverflow();

        await mount(tester, designHeight);

        // The page really is in the state the overrides describe. Without this
        // a fake that silently failed to take would leave the tall branch
        // unrendered and every assertion below would pass on a spinner.
        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        expect(primary(), findsOneWidget);
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
      });
    });
  }

  sweep(
    'PreLaunchPage',
    build: () => const PreLaunchPage(),
    // The splash has no control at all; its dots are the one thing on it that
    // has to stay on screen.
    primary: () => find.byType(PulsingDots),
  );

  sweep(
    // `content` is caller-supplied, so the page is measured through a real
    // caller: `DPegxSubmitFinishDialog` is the tallest of the three
    // (d_amp_login.dart:53, d_pegx_submit_amp.dart:13,
    // d_pegx_submit_finish_dialog.dart:13).
    'DAmpBackgroundPage',
    build: () => const DPegxSubmitFinishDialog(),
    primary: () => find.byIcon(Icons.close),
  );

  sweep(
    'DesktopWalletMain shell with TopToolbar',
    build: () => const DesktopWalletMain(),
    primary: () => find.widgetWithText(DTopToolbarButton, 'Send'),
  );

  sweep(
    // Measured through its production shell rather than bare. The page is
    // reached only from `DesktopWalletMain` (desktop_wallet_main.dart:42),
    // which spends 34px of the client area on `TopToolbar` and 56px on the
    // bottom navigation bar, so a bare mount would hand the page 620px at the
    // floor where production hands it 530px.
    'DAddresses in the DesktopWalletMain shell',
    build: () => const DesktopWalletMain(),
    overrides: () => [
      // Put the shell on the addresses tab, which is index 5 on desktop
      // (ui_state_args_provider.dart:82).
      uiStateArgsProvider.overrideWith(_AddressesTab.new),
      // A loaded list with a row in it. The pending branch is one spinner, and
      // a loaded-but-empty list renders the header row without any content
      // below it; neither is the page's tallest state.
      filteredAddressesAsyncProvider.overrideWithValue(
        const AsyncValue.data(AddressesModel(addresses: [_address])),
      ),
    ],
    // `DAddressesBottomPanel` is a sibling of the loading/loaded switch
    // (d_addresses.dart:60), so it is on screen in every branch and cannot
    // stand in for the loaded state. `DAddressesList` can.
    evidence: find.byType(DAddressesList),
    // The page's body sits under a `Flexible` (d_addresses.dart:46), which
    // yields rather than overflows, so what the floor case proves is that the
    // pinned filter row survives the shell's chrome and stays reachable.
    primary: () => find.byType(DAddressesBottomPanel),
  );
}

/// The shell on its addresses tab.
class _AddressesTab extends UiStateArgsNotifier {
  @override
  WalletMainArguments build() => WalletMainArguments(
    currentIndex: 5,
    navigationItemEnum: WalletMainNavigationItemEnum.addresses,
  );
}

/// One address row, so the loaded branch has content under its header.
const _address = AddressesItem(
  account: Account.REG,
  address: 'lq1qqw0address0000000000000000000000000000000000000000',
  unconfidentialAddress: 'ex1qunconfidential000000000000000',
  index: 7,
  isInternal: false,
  utxos: [],
);
