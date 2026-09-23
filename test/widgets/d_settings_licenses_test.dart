import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/settings/d_settings_licenses.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/licenses_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// Forty packages -- the tallest realistic state, and far past what the 467px
/// list box shows at once.
List<LicensesData> _licenses() => [
  for (var i = 0; i < 40; i++)
    () {
      final entry = LicenseEntryWithLineBreaks([
        'package_$i',
      ], 'Copyright line.\n\nPermission granted.');
      return LicensesData(
        licenseEntry: entry,
        paragraphs: entry.paragraphs.toList(),
      );
    }(),
];

void main() {
  late MockWallet wallet;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
  });

  Future<void> pump(WidgetTester tester, Size view) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
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
              licensesEntriesProvider.overrideWith((ref) => _licenses()),
            ],
            child: MaterialApp(
              // `--no-test-assets` has no ink shader.
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: const Scaffold(body: DSettingsLicenses()),
            ),
          ),
        );
        // The entries arrive through a future, and the `useEffect` that turns
        // them into rows runs on the frame after that.
        await tester.pumpAndSettle();
      });

  /// The content's own scrollable -- this surface takes `ScrollOwner.child`.
  final contentScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(ListView),
  );

  /// The wrapper's scrollable, which must never appear here: a second owner
  /// nested inside the content's swallows the wheel.
  final wrapperScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  final backButton = find.byType(DCustomTextBigButton);

  testWidgets('at the design height the licence list is the only scrollable '
      'and the wrapper adds none', (tester) async {
    // `ExpansionTile`'s `ListTile` sits inside the dialog's decorated
    // container, which the framework warns about in debug builds. It is
    // pre-existing and unrelated to layout at the floor.
    final errors = captureOverflow(alsoDivert: const ['ListTile background']);

    await pump(tester, designHeight);

    expect(contentScrollView, findsOneWidget);
    expect(wrapperScrollView, findsNothing);
    // The list keeps its design height when there is room for it; the 16px
    // is the `Padding` between the box and the list.
    expect(tester.getSize(contentScrollView).height, 467 - 16);
    expect(extentOf(tester, contentScrollView), greaterThan(0));
    expect(
      find.descendant(of: contentScrollView, matching: backButton),
      findsNothing,
    );
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor the list yields the shortfall, nothing overflows '
      'and BACK stays live', (tester) async {
    // `ExpansionTile`'s `ListTile` sits inside the dialog's decorated
    // container, which the framework warns about in debug builds. It is
    // pre-existing and unrelated to layout at the floor.
    final errors = captureOverflow(alsoDivert: const ['ListTile background']);

    await pump(tester, floor);

    expect(wrapperScrollView, findsNothing);
    // The list really did give room back rather than the surface fitting
    // anyway, which is what keeps the no-overflow assertion below meaningful.
    expect(tester.getSize(contentScrollView).height, lessThan(467 - 16));
    expect(verticalOverflows(errors), isEmpty);
    expect(backButton.hitTestable(), findsOneWidget);
    await tapAndDrain(tester, backButton);
    verify(() => wallet.settingsViewAboutUs()).called(1);
  });
}
