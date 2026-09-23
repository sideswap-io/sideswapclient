/// The desktop shell keeps the scroll offset of its lists for one *visit*.
///
/// A visit is one continuous stay on one desktop navigation item; see the
/// `Visit` term in CONTEXT.md and issue #296. These tests pin the three things
/// that follow from it, for the address list and the transaction list alike:
///
///  * a dialog pushed over the list and popped again leaves the offset alone,
///  * the shell can be unmounted and mounted again -- which the return from
///    Settings does -- and the offset comes back, twice over,
///  * a change of the navigation item and back starts the list at the top.
///
/// The offset is read from the `ScrollPosition` and never from a pixel, and it
/// is set with `jumpTo`, which ends the scroll synchronously. A scrollable
/// writes its offset into the enclosing `PageStorage` at scroll end and never
/// in `dispose`, so a drag left mid-fling would store nothing.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
// Riverpod 3 does not export `Override` from its Flutter entry point -- prior
// art: test/helpers/settings_container.dart.
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/desktop_wallet_main.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/ignore_overflow.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The address list, found by the constant key the shell's `PageStorage`
/// stores it under. Finding it by that key is also the assertion that the key
/// landed: a list without it saves nothing.
final _addresses = find.byKey(const PageStorageKey('addresses'));

/// The transaction list, found the same way.
final _transactions = find.byKey(const PageStorageKey('transactions'));

/// Enough rows for the list to scroll well past the offset the tests use.
const _rowCount = 60;

List<AddressesItem> _addressRows() => List.generate(
  _rowCount,
  (index) => AddressesItem(
    account: Account.REG,
    address: 'lq1qqw0address00000000000000000000000000000000000$index',
    unconfidentialAddress: 'ex1qunconfidential00000000000$index',
    index: index,
    isInternal: false,
    utxos: const [],
  ),
);

List<TransItem> _transactionRows() => List.generate(
  _rowCount,
  (index) => TransItem(
    id: 'tx$index',
    createdAt: Int64(1700000000 + index),
    tx: Tx(txid: 'txid$index'),
  ),
);

/// The shell on its addresses tab.
class _AddressesTab extends UiStateArgsNotifier {
  @override
  WalletMainArguments build() => WalletMainArguments(
    currentIndex: 5,
    navigationItemEnum: WalletMainNavigationItemEnum.addresses,
  );
}

/// The shell on its transactions tab.
class _TransactionsTab extends UiStateArgsNotifier {
  @override
  WalletMainArguments build() => WalletMainArguments(
    currentIndex: 3,
    navigationItemEnum: WalletMainNavigationItemEnum.transactions,
  );
}

void main() {
  late MockWallet wallet;
  late RouteRecorder routeRecorder;

  // Type registration for `any()`, not a mutable store, so `setUpAll` is the
  // right place for it.
  setUpAll(() => registerFallbackValue(To()));

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    routeRecorder = RouteRecorder();
    // The transaction list turns `txHistoryStateProvider` visible, which makes
    // `AllTxsNotifier` ask the wallet for the history.
    when(() => wallet.sendMsg(any())).thenReturn(null);
  });

  List<Override> addressOverrides() => [
    uiStateArgsProvider.overrideWith(_AddressesTab.new),
    filteredAddressesAsyncProvider.overrideWithValue(
      AsyncValue.data(AddressesModel(addresses: _addressRows())),
    ),
  ];

  List<Override> transactionOverrides() => [
    uiStateArgsProvider.overrideWith(_TransactionsTab.new),
    allTxsSortedProvider.overrideWithValue(_transactionRows()),
  ];

  /// Mounts the shell in a scope whose container the test keeps, behind a
  /// switch the test can turn off and on again.
  ///
  /// The switch is what makes an unmount observable. A second `pumpWidget`
  /// would not do: it reuses the `Navigator`, so the old shell would go
  /// offstage rather than away -- the reason `resizeTo` exists in
  /// test/helpers/surface_floor.dart.
  ///
  /// `runAsync` is needed because every `DToolbarButton` in the shell resolves
  /// its focus theme through a throwaway `ProviderContainer` whose dispose
  /// timer never settles under fake async. Prior art:
  /// test/widgets/d_scaffold_page_surfaces_floor_test.dart.
  Future<(ProviderContainer, ValueNotifier<bool>)> pumpShell(
    WidgetTester tester, {
    required List<Override> overrides,
  }) async {
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
    // `AllTxsNotifier.build` is what listens to `txHistoryStateProvider` and
    // so what keeps that auto-dispose provider alive. Reading it here puts the
    // test in the state the running app is always in; without it the
    // transaction list's own `setVisible` lands on a disposed provider.
    container.read(allTxsProvider);

    final shellMounted = ValueNotifier(true);
    addTearDown(shellMounted.dispose);

    await tester.runAsync(() async {
      sizeView(tester, designHeight);
      final themeData = container.read(desktopAppThemeProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(
              brightness: themeData.brightness,
              textTheme: themeData.textTheme,
              extensions: themeData.themeExtensions,
              // --no-test-assets has no shaders/ink_sparkle.frag, so the
              // default ink splash cannot paint.
              splashFactory: NoSplash.splashFactory,
            ),
            navigatorObservers: [routeRecorder],
            home: ValueListenableBuilder<bool>(
              valueListenable: shellMounted,
              builder: (_, mounted, _) =>
                  mounted ? const DesktopWalletMain() : const SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });

    return (container, shellMounted);
  }

  /// Scrolls [list] to [offset] and settles it, so the enclosing
  /// `PageStorage` is written.
  Future<void> scrollTo(
    WidgetTester tester,
    Finder list,
    double offset,
  ) async {
    // A list too short to reach the offset would make every later assertion
    // pass against 0, so state the precondition.
    expect(extentOf(tester, list), greaterThan(offset));
    scrollPositionOf(tester, list).jumpTo(offset);
    await tester.runAsync(() => tester.pump());
  }

  Future<void> remountShell(
    WidgetTester tester,
    ValueNotifier<bool> shellMounted,
    Finder list,
  ) => tester.runAsync(() async {
    shellMounted.value = false;
    await tester.pump();
    expect(list, findsNothing);

    shellMounted.value = true;
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  Future<void> selectTab(
    WidgetTester tester,
    ProviderContainer container,
    WalletMainArguments arguments,
  ) => tester.runAsync(() async {
    container
        .read(uiStateArgsProvider.notifier)
        .setWalletMainArguments(arguments);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  group('address list', () {
    // A `RawDialogRoute` is a `PopupRoute`, and a `PopupRoute` is not opaque,
    // so the list stays mounted under it and keeps its own `ScrollPosition`.
    // What this asserts is therefore that nothing disturbs the list's key
    // while the dialog is up -- which the old mount-time invalidation of the
    // shared key did -- and not a dispose-and-restore round trip. Do not
    // "strengthen" it into the latter; it cannot prove it.
    testWidgets('keeps its offset while a dialog is pushed over it and popped', (
      tester,
    ) async {
      await pumpShell(tester, overrides: addressOverrides());
      await scrollTo(tester, _addresses, 240);
      final pushesBefore = routeRecorder.pushes;

      await tester.runAsync(() async {
        // A bare route, not `DAddressesDetails`: the criterion is about a
        // `RawDialogRoute` over the list, not about that dialog's own content.
        unawaited(
          Navigator.of(tester.element(_addresses)).push(
            RawDialogRoute<void>(
              pageBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });
      expect(routeRecorder.pushes, pushesBefore + 1);

      await tester.runAsync(() async {
        Navigator.of(tester.element(_addresses)).pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      });
      expect(routeRecorder.pops, 1);

      expect(offsetOf(tester, _addresses), 240);
    });

    testWidgets('keeps its offset across two rebuilds of the shell', (
      tester,
    ) async {
      final (_, shellMounted) = await pumpShell(
        tester,
        overrides: addressOverrides(),
      );
      await scrollTo(tester, _addresses, 240);

      await remountShell(tester, shellMounted, _addresses);
      expect(offsetOf(tester, _addresses), 240);

      await remountShell(tester, shellMounted, _addresses);
      expect(offsetOf(tester, _addresses), 240);
    });

    testWidgets('starts at the top on the next visit', (tester) async {
      final (container, _) = await pumpShell(
        tester,
        overrides: addressOverrides(),
      );
      await scrollTo(tester, _addresses, 240);

      // `home` is the tab the manual test leaves for, and the one the desktop
      // bottom bar reaches. `accounts` would also end the visit, but
      // `fromIndexDesktop` never produces it, so it would test a transition no
      // user can make.
      await selectTab(
        tester,
        container,
        WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        ),
      );
      expect(_addresses, findsNothing);

      await selectTab(
        tester,
        container,
        WalletMainArguments(
          currentIndex: 5,
          navigationItemEnum: WalletMainNavigationItemEnum.addresses,
        ),
      );

      expect(offsetOf(tester, _addresses), 0);
    });
  });

  group('transaction list', () {
    testWidgets('keeps its offset across two rebuilds of the shell', (
      tester,
    ) async {
      // A transaction row lays out to the app's own font; the block font of
      // `--no-test-assets` is wider and overflows the date column. That is the
      // harness, not the layout, and layout is not what these tests assert.
      ignoreOverflow();
      final (_, shellMounted) = await pumpShell(
        tester,
        overrides: transactionOverrides(),
      );
      await scrollTo(tester, _transactions, 240);

      await remountShell(tester, shellMounted, _transactions);
      expect(offsetOf(tester, _transactions), 240);

      await remountShell(tester, shellMounted, _transactions);
      expect(offsetOf(tester, _transactions), 240);
    });

    testWidgets('starts at the top on the next visit', (tester) async {
      ignoreOverflow();
      final (container, _) = await pumpShell(
        tester,
        overrides: transactionOverrides(),
      );
      await scrollTo(tester, _transactions, 240);

      await selectTab(
        tester,
        container,
        WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        ),
      );
      expect(_transactions, findsNothing);

      await selectTab(
        tester,
        container,
        WalletMainArguments(
          currentIndex: 3,
          navigationItemEnum: WalletMainNavigationItemEnum.transactions,
        ),
      );

      expect(offsetOf(tester, _transactions), 0);
    });
  });
}
