// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// Matches an [SvgPicture] by the asset it was built from. Assets do not decode
/// under `--no-test-assets`, so the loader's path is the observable, not pixels.
Finder svgAsset(String assetName) => find.byWidgetPredicate(
  (widget) =>
      widget is SvgPicture &&
      widget.bytesLoader is SvgAssetLoader &&
      (widget.bytesLoader as SvgAssetLoader).assetName == assetName,
);

void main() {
  late MockWallet wallet;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // SideSwapScaffold and CustomBigButton both read FlavorConfig during build.
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

  // `Localization` is a process-wide singleton, so it is reloaded per test --
  // never setUpAll, which would leak under a randomised ordering seed.
  // Every key this screen uses is its own English string, so `.tr()` echoes it.
  setUp(() {
    Localization.load(const Locale('en'));
    wallet = MockWallet();
    // The default biometric path: a cancelled prompt makes unlockWallet fall
    // off its end with no state transition at all, which is what an unstubbed
    // completion models here.
    when(() => wallet.unlockWallet()).thenAnswer((_) async {});
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  /// Mounts the screen against a real [ServerLoginNotifier] seeded to
  /// [loginState], so a test can drive genuine transitions through it -- which
  /// is what makes an invalidate back to `logout` observable.
  Future<ProviderContainer> pumpLocked(
    WidgetTester tester, {
    bool usePin = false,
    ServerLoginState loginState = const ServerLoginState.logout(),
  }) async {
    // The screen stacks fixed paddings that assume a phone, not the 800x600
    // default test surface; a short surface overflows before anything is
    // asserted. 360x800 logical is an ordinary handset.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWith((ref) => wallet),
        pinAvailableProvider.overrideWithValue(usePin),
      ],
    );
    container.read(serverLoginProvider.notifier).setServerLoginState(loginState);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          // CustomBigButton force-unwraps this extension on the mobile branch.
          // NoSplash avoids Material's InkSparkle fragment shader, whose asset
          // is unavailable under `--no-test-assets` when a button is tapped.
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            extensions: [CustomBigButtonStyle()],
          ),
          home: const WalletLocked(),
        ),
      ),
    );
    return container;
  }

  group('WalletLocked, biometric wallet', () {
    testWidgets('at rest it shows the fingerprint, the copy and UNLOCK', (
      tester,
    ) async {
      await pumpLocked(tester);

      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
      expect(find.text('Touch to unlock'), findsOneWidget);
      expect(find.byType(PulsingDots), findsNothing);

      final button = tester.widget<CustomBigButton>(
        find.widgetWithText(CustomBigButton, 'UNLOCK'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('the logo is always on screen', (tester) async {
      await pumpLocked(tester);

      expect(svgAsset('assets/logo.svg'), findsOneWidget);
    });

    testWidgets('no failure message is shown before anything has failed', (
      tester,
    ) async {
      await pumpLocked(tester);

      expect(
        find.textContaining('Could not unlock your wallet'),
        findsNothing,
      );
    });
  });

  group('WalletLocked, unlocking', () {
    // The dots repeat forever, so pumpAndSettle would never return: every pump
    // in this group is an explicit duration.
    testWidgets('the icon, the copy and UNLOCK are gone and the dots stand in', (
      tester,
    ) async {
      await pumpLocked(
        tester,
        loginState: const ServerLoginState.loginProcessing(),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PulsingDots), findsOneWidget);
      expect(find.byIcon(Icons.fingerprint), findsNothing);
      expect(find.text('Touch to unlock'), findsNothing);
      expect(find.byType(CustomBigButton), findsNothing);
      // Decision 1: the logo stays.
      expect(svgAsset('assets/logo.svg'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('a tap anywhere on the screen starts no second unlock', (
      tester,
    ) async {
      await pumpLocked(
        tester,
        loginState: const ServerLoginState.loginProcessing(),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tapAt(tester.getCenter(find.byType(WalletLocked)));
      await tester.pump(const Duration(milliseconds: 50));

      verifyNever(() => wallet.unlockWallet());

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('a PIN wallet is shown the same dots', (tester) async {
      await pumpLocked(
        tester,
        usePin: true,
        loginState: const ServerLoginState.loginProcessing(),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PulsingDots), findsOneWidget);
      expect(svgAsset('assets/locker2.svg'), findsNothing);
      expect(find.text('Unlock your wallet'), findsNothing);
      expect(find.byType(CustomBigButton), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('losing the affordances does not move the dots up the screen', (
      tester,
    ) async {
      await pumpLocked(
        tester,
        loginState: const ServerLoginState.loginProcessing(),
      );
      await tester.pump(const Duration(milliseconds: 100));
      final dotsTop = tester.getTopLeft(find.byType(PulsingDots)).dy;
      await tester.pumpWidget(const SizedBox.shrink());

      await pumpLocked(tester);
      final iconTop = tester.getTopLeft(find.byIcon(Icons.fingerprint)).dy;

      // Not the cross-screen AC -- that one is device-verified. This guards the
      // within-screen trap: the dots stand in for the icon and the copy, so a
      // processing branch that gave its gap a different size would move them
      // relative to the affordances they replaced.
      expect(dotsTop, greaterThan(iconTop));
    });
  });

  group('WalletLocked, PIN wallet', () {
    testWidgets('is never told to touch a fingerprint', (tester) async {
      await pumpLocked(tester, usePin: true);

      expect(find.byIcon(Icons.fingerprint), findsNothing);
      expect(find.text('Touch to unlock'), findsNothing);
    });

    testWidgets('shows the padlock and says how this wallet unlocks', (
      tester,
    ) async {
      await pumpLocked(tester, usePin: true);

      expect(svgAsset('assets/locker2.svg'), findsOneWidget);
      expect(find.text('Unlock your wallet'), findsOneWidget);

    });

    testWidgets('the padlock occupies the box the fingerprint did', (
      tester,
    ) async {
      await pumpLocked(tester);
      final fingerprint = tester.getSize(find.byIcon(Icons.fingerprint));

      await pumpLocked(tester, usePin: true);
      final padlock = tester.getSize(svgAsset('assets/locker2.svg'));

      // Asserted against the icon it replaces rather than against a literal:
      // what matters is that switching credential cannot shift the copy, the
      // message and the button below it.
      expect(padlock.height, fingerprint.height);
    });

    testWidgets('the button raises the unlock dialog, again after a dismissal', (
      tester,
    ) async {
      await pumpLocked(tester, usePin: true);

      await tester.tap(find.widgetWithText(CustomBigButton, 'UNLOCK'));
      await tester.pump();
      // A dismissed dialog lands the user back here with nothing latched, so
      // the same button has to work a second time.
      await tester.tap(find.widgetWithText(CustomBigButton, 'UNLOCK'));
      await tester.pump();

      verify(() => wallet.unlockWallet()).called(2);
    });
  });

  group('WalletLocked, a failed unlock', () {
    testWidgets('brings back the icon, the copy and the button, message below', (
      tester,
    ) async {
      final container = await pumpLocked(tester);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();

      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
      expect(find.text('Touch to unlock'), findsOneWidget);
      expect(find.widgetWithText(CustomBigButton, 'UNLOCK'), findsOneWidget);
      expect(find.byType(PulsingDots), findsNothing);

      final message = tester.widget<Text>(find.text('bad mnemonic'));
      expect(message.style?.color, SideSwapColors.bitterSweet);
      expect(message.textAlign, TextAlign.center);

      // The button that came back is live: it starts a fresh attempt.
      await tester.tap(find.widgetWithText(CustomBigButton, 'UNLOCK'));
      await tester.pump();
      verify(() => wallet.unlockWallet()).called(1);
    });

    testWidgets('a null message shows the translated fallback', (tester) async {
      final container = await pumpLocked(tester);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error());
      await tester.pump();

      expect(
        find.text('Could not unlock your wallet. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets('an empty message shows the same fallback, not a blank line', (
      tester,
    ) async {
      final container = await pumpLocked(tester);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: ''));
      await tester.pump();

      expect(
        find.text('Could not unlock your wallet. Please try again.'),
        findsOneWidget,
      );
      expect(find.text(''), findsNothing);
    });

    testWidgets('a long message stays on the screen and keeps the button', (
      tester,
    ) async {
      final container = await pumpLocked(tester);

      // The client chooses this string, so no length can be assumed. The screen
      // must survive one far longer than the space left under the copy.
      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(
            ServerLoginState.error(message: 'unable to open wallet. ' * 40),
          );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.widgetWithText(CustomBigButton, 'UNLOCK'), findsOneWidget);

      final message = tester.widget<Text>(
        find.textContaining('unable to open wallet.'),
      );
      expect(message.maxLines, 3);
      expect(message.overflow, TextOverflow.ellipsis);
    });

    testWidgets('a PIN wallet shows the message the same way', (tester) async {
      final container = await pumpLocked(tester, usePin: true);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();

      expect(find.text('bad mnemonic'), findsOneWidget);
      expect(svgAsset('assets/locker2.svg'), findsOneWidget);
      expect(find.text('Unlock your wallet'), findsOneWidget);
      expect(find.widgetWithText(CustomBigButton, 'UNLOCK'), findsOneWidget);
    });

    testWidgets('the message survives the provider being invalidated', (
      tester,
    ) async {
      final container = await pumpLocked(tester);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();

      // What the root handler's invalidate looks like from here: the provider
      // goes back to its build() value. The message is the screen's own now.
      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.logout());
      await tester.pump();

      expect(find.text('bad mnemonic'), findsOneWidget);
    });

    testWidgets('a screen mounted onto an existing failure shows it', (
      tester,
    ) async {
      await pumpLocked(
        tester,
        loginState: const ServerLoginState.error(message: 'bad mnemonic'),
      );

      // The cold-start path mounts this screen with an unlock already in
      // flight, so the failure can predate the screen. ref.listen has no
      // fireImmediately; the capture is seeded from the first build.
      expect(find.text('bad mnemonic'), findsOneWidget);
    });

    testWidgets('starting a new unlock clears the message', (tester) async {
      final container = await pumpLocked(tester);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.loginProcessing());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('bad mnemonic'), findsNothing);
      expect(find.byType(PulsingDots), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('a cancelled biometric prompt leaves the screen as it was', (
      tester,
    ) async {
      await pumpLocked(tester);

      // Cancelling is silent by construction: unlockWallet falls off the end
      // with no state transition at all. The screen renders state, not taps.
      await tester.tap(find.widgetWithText(CustomBigButton, 'UNLOCK'));
      await tester.pump();

      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
      expect(find.text('Touch to unlock'), findsOneWidget);
      expect(find.byType(PulsingDots), findsNothing);
      expect(
        find.textContaining('Could not unlock your wallet'),
        findsNothing,
      );
      final button = tester.widget<CustomBigButton>(
        find.widgetWithText(CustomBigButton, 'UNLOCK'),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}
