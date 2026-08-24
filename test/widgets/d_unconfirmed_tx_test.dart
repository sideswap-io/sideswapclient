// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_unconfirmed_tx.dart';
import 'package:sideswap/desktop/widgets/d_tx_blinded_url_icon_button.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

TransItem _pegIn({required String txidSend, required String txidRecv}) {
  final item = TransItem()
    ..id = '$txidSend/0'
    ..createdAt = Int64(DateTime(2026, 8, 5, 4, 38).millisecondsSinceEpoch);
  item.peg = Peg()
    ..isPegIn = true
    ..txidSend = txidSend
    ..txidRecv = txidRecv;
  return item;
}

void main() {
  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random seed.
  setUp(() {
    Localization.load(const Locale('en'));
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  Future<DTxBlindedUrlIconButton> pumpItem(
    WidgetTester tester,
    TransItem transItem,
  ) => tester.runAsync(() async {
    tester.view.physicalSize = const Size(1600, 400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: DUnconfirmedTxItem(
              transItem: transItem,
              flexes: const [183, 97, 205, 205, 105, 46],
            ),
          ),
        ),
      ),
    );

    return tester.widget<DTxBlindedUrlIconButton>(
      find.byType(DTxBlindedUrlIconButton),
    );
  }).then((button) => button!);

  group('DUnconfirmedTxItem link button', () {
    testWidgets('links to the peg receive txid, not the empty tx txid', (
      tester,
    ) async {
      final button = await pumpItem(
        tester,
        _pegIn(txidSend: 'btc-txid', txidRecv: 'lbtc-txid'),
      );

      // A peg TransItem carries no `tx`, so `transItem.tx.txid` is always empty
      // -- the link has to come from the peg itself.
      expect(button.txid, 'lbtc-txid');
      expect(button.isLiquid, isTrue);
      expect(button.unblinded, isTrue);
    });

    testWidgets('passes an empty txid for a peg that has not completed', (
      tester,
    ) async {
      final button = await pumpItem(
        tester,
        _pegIn(txidSend: 'btc-txid', txidRecv: ''),
      );

      // Empty is correct here -- there is no receive transaction yet.
      // DTxBlindedUrlIconButton disables itself on an empty txid so that no
      // empty txid ever reaches the rust client.
      expect(button.txid, isEmpty);
    });
  });
}
