/// ADR-0014 floor sweep follow-up, issue #294.
///
/// `WalletLocked` is routed through `SideSwapScaffold`, whose desktop branch is
/// a `DPopupWithClose(height: 605, scrollOwner: ScrollOwner.child)`. The screen
/// owns no scrollable of its own, so its column had nowhere to put the
/// shortfall and was clipped by 85 px -- the same figure at the design height
/// and at the floor, because the popup's box is 605 px whatever the window
/// height is.
///
/// This is therefore not a floor defect: both client areas are asserted, and
/// both were red before the fix.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

void main() {
  late MockWallet wallet;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    // The biometric path: a cancelled prompt makes unlockWallet fall off its
    // end with no state transition, which is what an unstubbed completion
    // models here. Prior art: test/widgets/wallet_locked_test.dart.
    when(() => wallet.unlockWallet()).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester,
    Size view, {
    ServerLoginState loginState = const ServerLoginState.logout(),
  }) => tester.runAsync(() async {
    sizeView(tester, view);
    final container = ProviderContainer.test(
      overrides: [
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
    container
        .read(serverLoginProvider.notifier)
        .setServerLoginState(loginState);
    final themeData = container.read(desktopAppThemeProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            brightness: themeData.brightness,
            textTheme: themeData.textTheme,
            extensions: themeData.themeExtensions,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    unawaited(
      Navigator.of(tester.element(find.byType(Scaffold))).push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: WalletLocked()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  /// Pumps the surface with overflow diverted, puts the tester's own error
  /// handler back and hands back what was collected.
  ///
  /// [captureOverflow] restores through `addTearDown`, which runs *after* the
  /// test body. A failing `expect` therefore throws while the handler is still
  /// displaced, `flutter_test` aborts on `_pendingExceptionDetails`, and the
  /// next test in the file hangs until the run is killed. Restoring here, the
  /// moment the pump that could overflow is over, leaves every assertion under
  /// the tester's own handler, so a red run reports its failure and moves on.
  /// It also keeps the diversion to the pump alone, so an overflow provoked
  /// later in the test body fails the test rather than being collected.
  Future<List<String>> pumpCollectingOverflow(
    WidgetTester tester,
    Size view, {
    ServerLoginState loginState = const ServerLoginState.logout(),
  }) async {
    final previous = FlutterError.onError;
    final errors = captureOverflow();
    await pump(tester, view, loginState: loginState);
    FlutterError.onError = previous;
    return errors;
  }

  final unlock = find.widgetWithText(CustomBigButton, 'UNLOCK');

  /// The box the logo occupies. `--no-test-assets` decodes no SVG, so the
  /// `SizedBox` the screen wraps it in is the observable, not the picture.
  final logo = find.byWidgetPredicate(
    (widget) =>
        widget is SizedBox && widget.width == 158 && widget.height == 158,
  );

  /// The credential mark. These tests leave `pinAvailableProvider` at its
  /// default, so it is the fingerprint rather than the padlock.
  final credentialIcon = find.byIcon(Icons.fingerprint);

  /// The line of copy that tells the user how this wallet unlocks. The
  /// biometric wording, since these tests leave `pinAvailableProvider` at its
  /// default.
  final label = find.text('Touch to unlock');

  for (final entry in {'design height': designHeight, 'floor': floor}.entries) {
    testWidgets('at the ${entry.key} nothing overflows and UNLOCK is live', (
      tester,
    ) async {
      final errors = await pumpCollectingOverflow(tester, entry.value);

      // Red before the fix at both sizes: `A RenderFlex overflowed by 85
      // pixels on the bottom.` at lib/screens/home/wallet_locked.dart:82.
      expect(verticalOverflows(errors), isEmpty);
      expect(unlock.hitTestable(), findsOneWidget);

      // `hitTestable`, not `findsOneWidget`. The popup declares 605 px at
      // every window size, so a fix that only stops the overflow can push the
      // copy under the fold and still satisfy every plain finder. The manual
      // criterion names the logo, the label and UNLOCK together.
      expect(logo.hitTestable(), findsOneWidget);
      expect(credentialIcon.hitTestable(), findsOneWidget);
      expect(label.hitTestable(), findsOneWidget);

      await tapAndDrain(tester, unlock);
      verify(() => wallet.unlockWallet()).called(1);

      // UNLOCK sits at the bottom of the card, where the `Spacer()` held it.
      expectPinnedToCardBottom(tester, unlock, slack: 16);
    });

    testWidgets('at the ${entry.key} a failed unlock still fits', (tester) async {
      final errors = await pumpCollectingOverflow(
        tester,
        entry.value,
        // The tallest state this screen has, which ADR-0014 decision 13 asks
        // every floor case to be mounted in: the failure message is bounded
        // at three lines and the client chooses its text, so this is the most
        // the gaps are ever asked to give up.
        loginState: ServerLoginState.error(
          message: 'unable to open wallet. ' * 40,
        ),
      );

      expect(verticalOverflows(errors), isEmpty);
      expect(label.hitTestable(), findsOneWidget);
      expect(
        find.textContaining('unable to open wallet.').hitTestable(),
        findsOneWidget,
      );
      expect(unlock.hitTestable(), findsOneWidget);
    });

    testWidgets('at the ${entry.key} the unlocking screen does not overflow', (
      tester,
    ) async {
      final errors = await pumpCollectingOverflow(
        tester,
        entry.value,
        loginState: const ServerLoginState.loginProcessing(),
      );

      // The unlocking arm drops UNLOCK and adds 332 px of padding above the
      // dots, so it needs 592 px of the same 565 px box and was clipped too.
      expect(verticalOverflows(errors), isEmpty);
      expect(find.byType(PulsingDots).hitTestable(), findsOneWidget);

      // The gaps give up the whole shortfall, so the dots would come to rest
      // flush against the popup's bottom edge without a margin of their own.
      // 14 px is the margin UNLOCK carries in the other arm.
      expect(
        popupCardBottom(tester) -
            tester.getRect(find.byType(PulsingDots)).bottom,
        greaterThanOrEqualTo(14),
      );
      expect(logo.hitTestable(), findsOneWidget);
      expect(unlock, findsNothing);
    });
  }
}
