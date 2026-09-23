import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_skip_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_pin_welcome.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo_background.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/dialog_height_harness.dart';
import '../helpers/surface_floor.dart' show installSurfaceTestEnv;

class MockWallet extends Mock implements SideswapWallet {}

void main() {
  final wallet = MockWallet();

  setUp(() {
    reset(wallet);
    installSurfaceTestEnv();
  });

  /// Collects every bottom overflow, so a test can assert the exact set instead
  /// of failing on the first one the way [captureErrors] does.
  ///
  /// `DNewWalletBackupSkipPrompt` throws one bottom overflow that this change
  /// neither causes nor could fix. Its content card is a fixed
  /// `SizedBox(width: 484, height: 232)`
  /// (`lib/desktop/onboarding/d_new_wallet_backup_skip_prompt.dart:39-41`) whose
  /// two paragraphs wrap to 3 and 5 lines under the block-glyph fallback font of
  /// `--no-test-assets`, for 250 px against the 232 px box. Under proportional
  /// metrics the same content measures about 213 px and fits, and the overflow
  /// reproduces at an unbounded view height, so it is a test-font artifact and is
  /// independent of the window height. ADR-0014 decision 13 sanctions filtering
  /// horizontal block-font noise only, so nothing is diverted here: the two
  /// `DNewWalletBackupSkipPrompt` tests assert that this one overflow is the only
  /// one, and a second one -- an illustration block that regressed -- fails them.
  List<String> collectBottomOverflows() {
    final errors = <String>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      final text = details.exceptionAsString();
      if (text.contains('overflowed') && text.contains('on the bottom')) {
        errors.add(text);
        return;
      }
      previous?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = previous;
    });
    return errors;
  }

  group('DPinWelcome illustration gap', () {
    testWidgets('is 24px at the floor', (tester) async {
      captureErrors();

      await pumpSurface(
        tester,
        view: floor,
        overrides: [walletProvider.overrideWithValue(wallet)],
        child: DPinWelcome(onYesPressed: () {}, onNoPressed: () {}),
      );

      final dy = tester.getTopLeft(find.byType(DPinWelcomeLogo)).dy;
      expect(dy, 24.0);
    });

    testWidgets('is 100px at the design height', (tester) async {
      captureErrors();

      await pumpSurface(
        tester,
        view: designHeight,
        overrides: [walletProvider.overrideWithValue(wallet)],
        child: DPinWelcome(onYesPressed: () {}, onNoPressed: () {}),
      );

      final dy = tester.getTopLeft(find.byType(DPinWelcomeLogo)).dy;
      expect(dy, 100.0);
    });
  });

  group('DNewWalletBackupPrompt illustration gap', () {
    testWidgets('is 24px at the floor', (tester) async {
      captureErrors();

      await pumpSurface(
        tester,
        view: floor,
        overrides: [walletProvider.overrideWithValue(wallet)],
        child: const DNewWalletBackupPrompt(),
      );

      final dy = tester.getTopLeft(find.byType(DNewWalletBackupLogo)).dy;
      expect(dy, 24.0);
    });

    testWidgets('is 100px at the design height', (tester) async {
      captureErrors();

      await pumpSurface(
        tester,
        view: designHeight,
        overrides: [walletProvider.overrideWithValue(wallet)],
        child: const DNewWalletBackupPrompt(),
      );

      final dy = tester.getTopLeft(find.byType(DNewWalletBackupLogo)).dy;
      expect(dy, 100.0);
    });
  });

  group('DNewWalletBackupLogoBackground illustration gap', () {
    testWidgets('is 24px at the floor', (tester) async {
      captureErrors();

      await pumpSurface(
        tester,
        view: floor,
        child: const DNewWalletBackupLogoBackground(),
      );

      final dy = tester.getTopLeft(find.byType(DNewWalletBackupLogo)).dy;
      expect(dy, 24.0);
    });

    testWidgets('is 100px at the design height', (tester) async {
      captureErrors();

      await pumpSurface(
        tester,
        view: designHeight,
        child: const DNewWalletBackupLogoBackground(),
      );

      final dy = tester.getTopLeft(find.byType(DNewWalletBackupLogo)).dy;
      expect(dy, 100.0);
    });
  });

  group('DNewWalletBackupSkipPrompt illustration gap', () {
    testWidgets('is 24px at the floor', (tester) async {
      final errors = collectBottomOverflows();

      await pumpSurface(
        tester,
        view: floor,
        overrides: [walletProvider.overrideWithValue(wallet)],
        child: const DNewWalletBackupSkipPrompt(),
      );

      final dy = tester.getTopLeft(find.byType(DNewWalletBackupLogo)).dy;
      expect(dy, 24.0);
      expect(
        verticalOverflows(errors),
        hasLength(1),
        reason:
            'only the pre-existing content-card overflow is expected; a second one '
            'means the illustration block regressed',
      );
    });

    testWidgets('is 100px at the design height', (tester) async {
      final errors = collectBottomOverflows();

      await pumpSurface(
        tester,
        view: designHeight,
        overrides: [walletProvider.overrideWithValue(wallet)],
        child: const DNewWalletBackupSkipPrompt(),
      );

      final dy = tester.getTopLeft(find.byType(DNewWalletBackupLogo)).dy;
      expect(dy, 100.0);
      expect(
        verticalOverflows(errors),
        hasLength(1),
        reason:
            'only the pre-existing content-card overflow is expected; a second one '
            'means the illustration block regressed',
      );
    });
  });
}
