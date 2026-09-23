import 'dart:io';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';

import 'test_utils.dart';

/// The two client areas ADR-0014 pins every desktop surface against.
///
/// Width first, height second, the way [Size] takes them: the ADR writes the
/// floor as "620 x 1072" height-first, and a test that copies that order gets a
/// window *taller* than the design case, where nothing overflows and every
/// assertion passes vacuously.
const floor = Size(1072, 620);

/// The design window's client area: 1088x880 outer, less 40px of Windows
/// chrome. Surfaces are laid out for this and must be unchanged at it.
const designHeight = Size(1072, 840);

/// Collects overflow errors for the rest of the test, so the absence of a
/// vertical one can be asserted explicitly.
///
/// `ignoreOverflow()` from test/helpers/ignore_overflow.dart would swallow the
/// very overflow these tests assert the absence of. Only overflow is diverted
/// here; every other framework error still reaches the handler the tester
/// installed and still fails the test.
///
/// Call this from inside the test body: the widget tester replaces
/// [FlutterError.onError] when the test starts, so a `setUp` would be
/// overwritten before the first pump.
///
/// [alsoDivert] names further framework messages to drop, for a surface whose
/// existing widgets emit a debug-only warning unrelated to what is under test.
/// Each entry has to be justified at its call site; the default diverts nothing
/// but overflow.
List<String> captureOverflow({List<String> alsoDivert = const []}) {
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.exceptionAsString();
    if (text.contains('overflowed')) {
      errors.add(text);
      return;
    }
    if (alsoDivert.any(text.contains)) {
      return;
    }
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);
  return errors;
}

/// The vertical overflows among [errors]. Horizontal overflow is a block-font
/// artefact of `--no-test-assets` and is not what these tests are about.
Iterable<String> verticalOverflows(List<String> errors) => errors.where(
  (e) => e.contains('overflowed') && e.contains('on the bottom'),
);

/// The [ScrollPosition] of the [Scrollable] under [scrollView].
///
/// [scrollView] must be found through a public finder scoped to the surface's
/// own wrapper -- never "the one `Scrollable` in the tree", since several of
/// these surfaces legitimately contain a bounded inner list as well.
///
/// `.first` takes [scrollView]'s own `Scrollable`: finders walk the tree
/// depth-first from [scrollView], so the outermost match is the one it
/// created, and anything further down (a text field's, an inner list's)
/// follows it.
ScrollPosition scrollPositionOf(WidgetTester tester, Finder scrollView) => tester
    .state<ScrollableState>(
      find.descendant(of: scrollView, matching: find.byType(Scrollable)).first,
    )
    .position;

/// The scroll extent of the [Scrollable] under [scrollView]. Scoped by
/// [scrollPositionOf].
double extentOf(WidgetTester tester, Finder scrollView) =>
    scrollPositionOf(tester, scrollView).maxScrollExtent;

/// The current scroll offset of the [Scrollable] under [scrollView]. Scoped by
/// [scrollPositionOf].
///
/// This is the value a `PageStorage` above the scrollable stores. A scrollable
/// writes it at scroll end and never in `dispose`, so a test must settle the
/// position -- `ScrollPosition.jumpTo` does -- before it expects the store to
/// hold anything.
double offsetOf(WidgetTester tester, Finder scrollView) =>
    scrollPositionOf(tester, scrollView).pixels;

/// Taps [finder] and drains the 100ms press animation timer `DHoverButton`
/// starts on tap.
///
/// Without the trailing pump the timer outlives the widget tree and the binding
/// fails the test on `!timersPending` -- which looks like a layout failure and
/// is not one. Prior art: test/widgets/d_settings_test.dart.
///
/// It also runs inside [WidgetTester.runAsync], because the rebuild the tap
/// triggers resolves the desktop focus theme through a throwaway
/// `ProviderContainer` whose zero-duration dispose timer never settles under
/// fake async.
Future<void> tapAndDrain(WidgetTester tester, Finder finder) =>
    tester.runAsync(() async {
      await tester.tap(finder);
      await tester.pump(const Duration(milliseconds: 200));
    });

/// Resizes the test view to [view] and lays the current tree out again.
///
/// Use this rather than a second `pumpWidget` when a test needs two sizes of
/// the same surface: re-pumping the app reuses the `Navigator`, so a surface
/// pushed on a route stays put while the page under it goes offstage, where
/// finders skip it.
Future<void> resizeTo(WidgetTester tester, Size view) =>
    tester.runAsync(() async {
      tester.view.physicalSize = view;
      // Set here as well as in [sizeView], so [view] is logical pixels
      // whichever of the two ran last.
      tester.view.devicePixelRatio = 1.0;
      await tester.pump();
    });

/// Records route pushes and pops, so a surface whose primary action navigates
/// has an externally observable effect to assert.
///
/// A surface mounted as an app's `home` sits on the root route, which
/// `Navigator.pop` refuses to remove; such a surface must be pushed on top of
/// something for the pop to be observable at all.
class RouteRecorder extends NavigatorObserver {
  int pops = 0;
  int pushes = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushes++;
  }
}

/// Answers path_provider with a temporary directory for the rest of the test.
///
/// Several desktop surfaces reach it indirectly -- the logger's file output and
/// the asset-image cache both do -- and the resulting `MissingPluginException`
/// arrives *after* the test body, where it fails the test with a message that
/// has nothing to do with layout. Call this from `setUp`.
void stubPathProvider() {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  // One directory for the whole test, created up front: building it inside the
  // handler would leave a new undeleted temp directory behind on every call.
  final directory = Directory.systemTemp.createTempSync('sideswap');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async => directory.path);
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    directory.deleteSync(recursive: true);
  });
}

/// Installs the desktop production flavour these surfaces are laid out for.
///
/// [enableLocalEndpoint] turns on the debug `Use local api server` row, which
/// is the extra row a settings surface must still fit without scrolling.
///
/// Separate from [installSurfaceTestEnv] so a single test can re-declare the
/// flavour mid-body -- the one thing [FlavorConfig] makes cheap to change --
/// without also re-installing the logger and the path_provider stub.
void configureDesktopFlavor({bool enableLocalEndpoint = false}) {
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableNetworkSettings: true,
      enableJade: false,
      enableLocalEndpoint: enableLocalEndpoint,
      isDesktop: true,
    ),
  );
}

/// Installs the process-wide state every desktop surface test needs. Call this
/// from `setUp`.
///
/// `Localization` is a process-wide singleton and [FlavorConfig] a static
/// store, so per docs/TESTING.md both are re-initialised per test -- never in
/// `setUpAll`, which would leak into whatever runs next under a random seed.
///
/// The logger is redirected because these surfaces log, and the default output
/// writes a file through path_provider, which has no implementation under test;
/// the resulting exception lands after the test body, where it reads as a
/// layout failure. [stubPathProvider] answers the plugin for the same reason.
void installSurfaceTestEnv({bool enableLocalEndpoint = false}) {
  Localization.load(const Locale('en'));
  configureDesktopFlavor(enableLocalEndpoint: enableLocalEndpoint);
  logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  stubPathProvider();
}

/// The bottom edge of the popup card [DPopupWithClose] draws.
///
/// Used by [expectPinnedToCardBottom].
double popupCardBottom(WidgetTester tester) => tester
    .getRect(
      find
          .descendant(
            of: find.byType(DPopupWithCloseContent),
            matching: find.byType(ClipRRect),
          )
          .first,
    )
    .bottom;

/// Asserts the control [finder] sits in the band at the card's bottom edge,
/// within [slack] of it.
///
/// The popup lays its body and actions out in a `MainAxisSize.min` column,
/// so a *declared* height taller than
/// body-plus-actions leaves the pinned band floating a body's height above the
/// card's bottom -- the gap the `Spacer()` used to fill before the band moved
/// into `actions`. [slack] is the padding between the control and the bottom of
/// its own band, so it is per-surface and small; a regression of this kind is
/// hundreds of pixels.
///
/// Most callers no longer declare a height, so for them this is a dormant
/// regression guard and re-introducing one is what it exists to catch. It is
/// live for `WalletLocked`, which `SideSwapScaffold` still puts in a popup of
/// a declared 605 px, and there it states where the pinned band actually sits.
void expectPinnedToCardBottom(
  WidgetTester tester,
  Finder finder, {
  required double slack,
}) {
  expect(
    popupCardBottom(tester) - tester.getBottomLeft(finder).dy,
    lessThanOrEqualTo(slack),
  );
}

/// Sizes the test view to [view] at a device pixel ratio of 1, so a [Size] in
/// logical pixels is the client area the surface sees.
void sizeView(WidgetTester tester, Size view) {
  tester.view.physicalSize = view;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}
