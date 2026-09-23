/// `DReceiveAddressDialog` declared no height bound of its own, so at the
/// supported floor its card grew past the window and the outer column
/// overflowed. ADR-0014 decision 8 binds every desktop surface, not only the 18
/// that declare a height, so the card is bounded by the window it is shown in
/// and its body scrolls.
///
/// The address row is the second half of the same defect: a confidential
/// address wraps to more rows than a short one, and the fixed 70 px box in
/// `DQrRecvAddress` clipped the overflow instead of growing.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/main/d_recv_address_dialog.dart';
import 'package:sideswap/desktop/main/widgets/d_qr_recv_address.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// A generated regular-wallet address, at the length a confidential Liquid
/// address reaches. That is the state the dialog is tallest in, and the one
/// the defect was observed in.
class FakeCurrentReceiveAddress extends CurrentReceiveAddress {
  @override
  ReceiveAddress build() => ReceiveAddress(
    account: Account.REG,
    recvAddress:
        'lq1qqw8jy0gpwlz8vc0kxhpsvsl6qz3z0dwswpqm0y9qkm2r0qy4nlt'
        '4jn0w8u9pkx6dm7z2xk3qz0j4h2m5qz8k9v3n6r7t0y2u4i6o8p0a2s4d',
  );
}

void main() {
  setUp(installSurfaceTestEnv);

  Future<void> pump(WidgetTester tester, Size view) async {
    sizeView(tester, view);
    // `toggleRecvAddrType` returns void, so the mock needs no stub; the dialog
    // only calls it, and never reads a result back.
    final wallet = MockWallet();

    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWithValue(wallet),
        currentReceiveAddressProvider.overrideWith(
          FakeCurrentReceiveAddress.new,
        ),
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
          home: const Scaffold(body: DReceiveAddressDialog()),
        ),
      ),
    );
    await tester.pump();
    // Drains the 1500 ms copy-confirmation timeout `useTimeoutFn` starts on
    // mount; a shorter pump leaves it pending past the test body, where it
    // fails the test with a message that has nothing to do with layout.
    await tester.pump(const Duration(milliseconds: 1600));
  }

  /// The dialog's own scroll owner, scoped to the surface rather than taken as
  /// "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DReceiveAddressDialog),
    matching: find.byType(SingleChildScrollView),
  );

  testWidgets('at the design height nothing overflows and the body does not '
      'scroll', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(verticalOverflows(errors), isEmpty);
    expect(ownScrollView, findsOneWidget);
    expect(extentOf(tester, ownScrollView), 0);
  });

  testWidgets('at the floor nothing overflows, the body keeps its full '
      'height, and the card scrolls the shortfall', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);
    final designBody = tester.getRect(find.byType(DQrRecvAddress)).height;

    await resizeTo(tester, floor);

    expect(verticalOverflows(errors), isEmpty);
    // The address block is not squeezed: it keeps the height it has at the
    // design size, and the scroll view takes the difference.
    expect(tester.getRect(find.byType(DQrRecvAddress)).height, designBody);
    expect(extentOf(tester, ownScrollView), greaterThan(0));
  });
}
