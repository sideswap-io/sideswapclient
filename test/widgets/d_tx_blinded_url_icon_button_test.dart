import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/widgets/d_tx_blinded_url_icon_button.dart';

void main() {
  Future<IconButton> pumpButton(WidgetTester tester, {required String txid}) =>
      tester.runAsync(() async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(body: DTxBlindedUrlIconButton(txid: txid)),
            ),
          ),
        );

        return tester.widget<IconButton>(find.byType(IconButton));
      }).then((button) => button!);

  group('DTxBlindedUrlIconButton', () {
    testWidgets('is disabled when there is no txid to link to', (tester) async {
      // A peg that has not completed yet has no txid. Enabling the button here
      // sends an empty txid to the rust client, which aborts the app.
      final button = await pumpButton(tester, txid: '');

      expect(button.onPressed, isNull);
    });

    testWidgets('is enabled once a txid is known', (tester) async {
      final button = await pumpButton(tester, txid: 'abc123');

      expect(button.onPressed, isNotNull);
    });
  });
}
