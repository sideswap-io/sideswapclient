// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/screens/flavor_config.dart';

/// Guards the loading screen against the extraction of its dot animation.
///
/// The dots moved out to [PulsingDots] so the locked screen could show the same
/// mark; this screen has to keep looking exactly as it did. The offset stayed
/// behind at the call site deliberately -- the two screens lay out differently,
/// so neither can own the other's position.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
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

  setUp(() {
    Localization.load(const Locale('en'));
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // The dots repeat forever, so pumpAndSettle would never return.
  Future<void> pumpAnimation(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SafeArea(child: PreLauchAnimation())),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('PreLaunchPage', () {
    testWidgets('still shows the logo, the copy and the dots', (tester) async {
      await pumpAnimation(tester);

      expect(find.byType(PulsingDots), findsOneWidget);
      expect(find.text('Wallet loading...'), findsOneWidget);

      final logo = tester.widget<SvgPicture>(
        find.byWidgetPredicate(
          (widget) =>
              widget is SvgPicture &&
              widget.bytesLoader is SvgAssetLoader &&
              (widget.bytesLoader as SvgAssetLoader).assetName ==
                  'assets/logo.svg',
        ),
      );
      expect(logo.width, 110);
      expect(logo.height, 108);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('the dots stay where this screen has always put them', (
      tester,
    ) async {
      await pumpAnimation(tester);

      // Asserted as a rendered position rather than as the padding value that
      // happens to produce it: the offset may live anywhere, but the dots have
      // to come out in the same place. 582 is where this screen puts them --
      // 180 to the logo, 108 of logo, 30 to the copy, its line box, then the
      // 241 gap.
      expect(tester.getTopLeft(find.byType(PulsingDots)).dy, closeTo(582, 1));

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('the desktop shape drops the copy and raises the dots', (
      tester,
    ) async {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: true,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );
      addTearDown(
        () => FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues(
            enableNetworkSettings: false,
            enableJade: true,
            enableLocalEndpoint: false,
            isDesktop: false,
          ),
        ),
      );

      await pumpAnimation(tester);

      // Desktop carries no "Wallet loading..." line. It pads the logo 20 lower
      // but drops that whole line box, so the dots end up higher, not lower.
      expect(find.text('Wallet loading...'), findsNothing);
      expect(find.byType(PulsingDots), findsOneWidget);
      expect(tester.getTopLeft(find.byType(PulsingDots)).dy, closeTo(549, 1));

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
