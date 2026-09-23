import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/main/d_tx_popup.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

final _txid = 'a' * 64;

/// A confirmed transaction with a memo -- the tallest realistic state, since
/// every optional detail row is drawn.
TransItem _tx() {
  final item = TransItem()
    ..id = '$_txid/0'
    ..createdAt = Int64(DateTime(2026, 8, 5, 4, 38).millisecondsSinceEpoch);
  item.tx = Tx()
    ..txid = _txid
    ..memo = 'A memo long enough to wrap onto a second line in the popup'
    ..networkFee = Int64(500);
  return item;
}

/// A completed peg-in, so both explorer links render enabled.
TransItem _peg() {
  final item = TransItem()
    ..id = '$_txid/0'
    ..createdAt = Int64(DateTime(2026, 8, 5, 4, 38).millisecondsSinceEpoch);
  item.peg = Peg()
    ..isPegIn = true
    // The popup looks the peg up by the current txid, so the pay-in txid has
    // to be that id or the surface renders an empty box.
    ..txidSend = _txid
    ..txidRecv = 'c' * 64;
  return item;
}

class FakeCurrentTxPopupItem extends CurrentTxPopupItemNotifier {
  @override
  Option<String> build() => Option.of(_txid);
}

class FakeAllTxs extends AllTxsNotifier {
  @override
  Map<String, TransItem> build() => {_txid: _tx()};
}

class FakeAllPegs extends AllPegsNotifier {
  @override
  Map<String, List<TransItem>> build() => {
    _txid: [_peg()],
  };
}

void main() {
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    routeRecorder = RouteRecorder();
  });

  Future<void> pump(WidgetTester tester, Size view, Widget surface) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(
                  SideswapSettings.empty(
                    mnemonicEncrypted: Uint8List.fromList([]),
                    jadeId: '',
                  ),
                ),
              ),
              currentTxPopupItemProvider.overrideWith(
                FakeCurrentTxPopupItem.new,
              ),
              allTxsProvider.overrideWith(FakeAllTxs.new),
              allPegsProvider.overrideWith(FakeAllPegs.new),
            ],
            child: MaterialApp(
              // `--no-test-assets` has no ink shader.
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              navigatorObservers: [routeRecorder],
              home: const Scaffold(body: SizedBox.shrink()),
            ),
          ),
        );
        unawaited(
          Navigator.of(tester.element(find.byType(Scaffold)))
              .push(MaterialPageRoute<void>(builder: (_) => surface)),
        );
        await tester.pumpAndSettle();
      });

  /// The popup's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DPopupWithClose),
    matching: find.byType(SingleChildScrollView),
  );

  void expectDesignHeightUnchanged(WidgetTester tester, Finder actions) {
    expect(ownScrollView, findsOneWidget);
    expect(find.descendant(of: ownScrollView, matching: actions), findsNothing);
    expect(extentOf(tester, ownScrollView), 0);
    // The explorer band sits at the card's bottom edge. The slack is the
    // band's own padding under the two-line link labels.
    expectPinnedToCardBottom(tester, actions.first, slack: 48);
  }

  group('DTxPopup', () {
    final links = find.byType(DPopupLinkButton);

    testWidgets('at the design height the body is unscrolled and the explorer '
        'links sit outside the scroll region', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, const DTxPopup());

      expectDesignHeightUnchanged(tester, links);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and the explorer links are '
        'reachable without scrolling', (tester) async {
      final errors = captureOverflow();

      await pump(tester, floor, const DTxPopup());

      expect(verticalOverflows(errors), isEmpty);
      // Reachable at the floor: the whole pinned row is inside the client
      // area, not merely present in the tree.
      expect(
        tester.getBottomLeft(links.first).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(links.first.hitTestable(), findsOneWidget);
    });
  });

  group('DPegPopup', () {
    final links = find.byType(DPopupLinkButton);

    testWidgets('at the design height the body is unscrolled and the explorer '
        'links sit outside the scroll region', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, const DPegPopup());

      expectDesignHeightUnchanged(tester, links);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and the explorer links are '
        'reachable without scrolling', (tester) async {
      final errors = captureOverflow();

      await pump(tester, floor, const DPegPopup());

      expect(verticalOverflows(errors), isEmpty);
      expect(
        tester.getBottomLeft(links.first).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(links.first.hitTestable(), findsOneWidget);
    });
  });
}
