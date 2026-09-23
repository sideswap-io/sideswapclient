import 'dart:async';
import 'dart:convert';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/desktop/settings/d_need_restart_dialog.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';

/// Fails every load the way a missing or unreadable asset does.
///
/// The throw is deliberately synchronous. `flutter_svg`'s `Cache.putIfAbsent`
/// derives futures from an asynchronous load and discards them without an error
/// handler, so an asynchronous failure reaches the test zone's uncaught-error
/// handler and fails the test whatever the widget renders. That leak is #225
/// and is out of scope here. A synchronous throw escapes `putIfAbsent` before
/// it stores the pending entry, and `vector_graphics` catches it in
/// `_loadAssetBytes` — the same `errorBuilder` path a real failure takes.
class _ThrowingAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) => throw FlutterError('no asset for $key');
}

/// Serves one valid SVG for every key, so the success path renders.
///
/// `tools/coverage.dart` runs with `--no-test-assets`, so the real bundle has
/// nothing under `assets/`. Prior art: `test/widgets/swaption_dialogs_test.dart`.
///
/// The viewBox is the one `assets/restart.svg` carries. `vector_graphics`
/// re-derives the painted width from the height, so a square stub would lay
/// the success path out differently from production.
class _ServingAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => ByteData.sublistView(
    utf8.encode(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 35.822"/>',
    ),
  );
}

/// Finds the fitted picture `vector_graphics` builds once a load succeeds.
///
/// `SvgPicture` itself stays in the tree whatever the load does, so its
/// presence proves nothing. Only the success branch wraps the decoded picture
/// in a `FittedBox`; the failure branch holds the `errorBuilder` widget and the
/// pending branch a bare `SizedBox`.
Finder get _renderedSvg => find.descendant(
  of: find.byType(SvgPicture),
  matching: find.byType(FittedBox),
);

/// The copy the restart dialog interpolates, taken from
/// `assets/translations/en.json`.
Translations get _englishCopy => Translations({
  'Network changes will take effect on restart':
      'Network changes will take effect on restart',
  'OK': 'OK',
});

void main() {
  // Rebuilt before each test rather than cleaned up after one: end-of-test
  // cleanup is skipped when an expectation throws (docs/TESTING.md).
  setUp(() {
    Localization.load(const Locale('en'), translations: _englishCopy);
  });

  /// Sets the flavor each group runs under.
  ///
  /// The singleton is late-initialised and `CustomBigButton` reads
  /// `FlavorConfig.isDesktop` while it builds, so it must be set before the
  /// first pump. Each call site gets the flavor it actually ships on.
  void configureFlavor({required bool isDesktop}) {
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: isDesktop,
      ),
    );
  }

  /// Pumps [child] under a fresh [bundle].
  ///
  /// The bundle instance is part of `flutter_svg`'s cache key
  /// (`_AssetByteLoaderCacheKey` compares it with `==`, which `AssetBundle`
  /// leaves as identity), so a per-test instance keeps one test's load out of
  /// the next test's cache.
  Future<void> pump(
    WidgetTester tester, {
    required AssetBundle bundle,
    required Widget child,
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: DefaultAssetBundle(
          bundle: bundle,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            // NoSplash avoids Material's InkSparkle fragment shader, whose
            // asset is unavailable under `--no-test-assets`. CustomBigButton
            // reads its style extension through a null-check, so the test theme
            // must carry one just as the app's does.
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              extensions: [CustomBigButtonStyle()],
            ),
            home: Scaffold(body: child),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('DNeedRestartPopupDialog', () {
    // Raised only from the desktop presenter
    // (lib/desktop/desktop_dialog_presenter.dart:63).
    setUp(() => configureFlavor(isDesktop: true));

    testWidgets('draws a turquoise fallback glyph when the SVG load fails', (
      tester,
    ) async {
      await pump(
        tester,
        bundle: _ThrowingAssetBundle(),
        child: const DNeedRestartPopupDialog(),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.refresh));
      expect(icon.color, SideSwapColors.brightTurquoise);
      expect(icon.size, 44);
      expect(tester.getSize(find.byIcon(Icons.refresh)).height, 44);
    });

    testWidgets('draws the SVG and no fallback glyph when the load succeeds', (
      tester,
    ) async {
      await pump(
        tester,
        bundle: _ServingAssetBundle(),
        child: const DNeedRestartPopupDialog(),
      );

      expect(_renderedSvg, findsOneWidget);
      // The title also carries a close button, so the assertion names the
      // fallback glyph rather than every Icon in the tree.
      expect(find.byIcon(Icons.refresh), findsNothing);
    });
  });

  group('showSettingsErrorDialog with SettingsDialogIcon.restart', () {
    // Raised from the mobile network settings screen
    // (lib/screens/settings/settings_network.dart:399).
    setUp(() => configureFlavor(isDesktop: false));

    /// Opens the settings dialog through the presenter's public entry point.
    Future<void> pumpRestartDialog(
      WidgetTester tester, {
      required AssetBundle bundle,
    }) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await pump(
        tester,
        bundle: bundle,
        navigatorKey: navigatorKey,
        child: const SizedBox.expand(),
      );

      unawaited(
        FlutterDialogPresenter().showSettingsErrorDialog(
          navigatorKey.currentContext!,
          title: 'Restart required',
          buttonText: 'OK',
          onPressed: (_) {},
          icon: SettingsDialogIcon.restart,
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('draws a white fallback glyph when the SVG load fails', (
      tester,
    ) async {
      await pumpRestartDialog(tester, bundle: _ThrowingAssetBundle());

      final icon = tester.widget<Icon>(find.byIcon(Icons.refresh));
      expect(icon.color, Colors.white);
      expect(icon.size, 23);
      expect(tester.getSize(find.byIcon(Icons.refresh)), const Size(23, 23));
    });

    testWidgets('draws the SVG and no fallback glyph when the load succeeds', (
      tester,
    ) async {
      await pumpRestartDialog(tester, bundle: _ServingAssetBundle());

      expect(_renderedSvg, findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsNothing);
    });
  });
}
