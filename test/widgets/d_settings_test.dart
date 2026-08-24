import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_settings_button.dart';
import 'package:sideswap/desktop/settings/d_settings.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';

import '../helpers/fake_configuration.dart';

/// Jade settings so `isJadeWalletProvider` (reads `jadeId.isNotEmpty`) picks the
/// Jade layout, which drops the long `View my recovery phrase` / `PIN
/// protection` rows and adds the late `Jade device` row.
///
/// Built with `SideswapSettings.empty` -- the unnamed `SideswapSettings(...)`
/// factory ignores its arguments and returns all-default fields.
SideswapSettings _jadeSettings() => SideswapSettings.empty(
  mnemonicEncrypted: Uint8List.fromList([]),
  jadeId: 'jade1',
);

/// Software-wallet settings (empty `jadeId`) so `isJadeWalletProvider` picks the
/// software layout -- the one that renders the extra `View my recovery phrase` /
/// `PIN protection` rows.
SideswapSettings _softwareSettings() => SideswapSettings.empty(
  mnemonicEncrypted: Uint8List.fromList([]),
  jadeId: '',
);

/// DSettings with a tiny content cap so the row list overflows it -- exercises
/// the scroll-on-overflow safety net on the real widget without a synthetic row
/// set (no realistic row set reaches the production 664px cap).
class _CappedDSettings extends DSettings {
  const _CappedDSettings();

  @override
  double get maxContentHeight => 200;
}

void main() {
  // `Localization` is a process-wide singleton and `FlavorConfig` a static
  // store, so per docs/TESTING.md both are (re)initialised in setUp -- never
  // setUpAll, which would leak into whatever runs next under a random seed.
  //
  // enableLocalEndpoint: true renders the debug `Use local api server` row --
  // the extra row the content-sizing must still fit without scrolling.
  setUp(() {
    Localization.load(const Locale('en'));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: true,
        enableJade: false,
        enableLocalEndpoint: true,
        isDesktop: true,
      ),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // DSettings renders many DButtons, each resolving its theme through throwaway
  // ProviderContainers that leave dispose timers on riverpod's scheduler; those
  // never settle under fake async, so the pump runs inside `runAsync`.
  //
  // Row heights are font-independent (each `DSettingsButton` is a fixed 44px
  // box), so `textScale` only guards horizontal fit of the block-font titles
  // against their fixed-width buttons -- it never changes the vertical extents
  // these tests assert.
  Future<void> pumpSettings(
    WidgetTester tester, {
    required SideswapSettings settings,
    double textScale = 0.3,
    Size size = const Size(1600, 2000),
    Widget settingsWidget = const DSettings(),
  }) => tester.runAsync(() async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        // Keyed by wallet type so a second pump in the same test (the natural
        // height comparison) replaces the scope and builds a fresh container
        // instead of reusing the first pump's overrides.
        key: ValueKey(settings.jadeId),
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(textScale)),
                child: settingsWidget,
              ),
            ),
          ),
        ),
      ),
    );
  });

  double maxScrollExtent(WidgetTester tester) {
    final scrollable = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );
    return tester.state<ScrollableState>(scrollable).position.maxScrollExtent;
  }

  double topOf(WidgetTester tester, String title) =>
      tester.getTopLeft(find.widgetWithText(DSettingsButton, title)).dy;

  // Count of settings rows whose top falls strictly between two y offsets --
  // used to assert "immediately above" (zero rows between) rather than mere
  // relative order.
  int rowsBetween(WidgetTester tester, double topDy, double bottomDy) {
    var count = 0;
    for (final element in find.byType(DSettingsButton).evaluate()) {
      final dy = (element.renderObject! as RenderBox)
          .localToGlobal(Offset.zero)
          .dy;
      if (dy > topDy && dy < bottomDy) count++;
    }
    return count;
  }

  testWidgets(
    'the worst-case (software + local-endpoint) row set is content-sized -- '
    'zero scroll extent -- while the delete action stays pinned',
    (tester) async {
      // A software wallet (recovery + PIN rows) plus the debug `Use local api
      // server` row is the tallest realistic set; it must still fit the
      // content-sized dialog without a scrollbar (AC).
      await pumpSettings(tester, settings: _softwareSettings());

      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      // Content-sized: the whole row set fits, so nothing scrolls...
      expect(maxScrollExtent(tester), 0);

      // ...and the row set -- including the debug local-endpoint row -- lives
      // inside the (non-scrolling) scroll region.
      for (final title in const ['About us', 'Use local api server']) {
        expect(
          find.descendant(
            of: scrollView,
            matching: find.widgetWithText(DSettingsButton, title),
          ),
          findsOneWidget,
          reason: '"$title" should sit with the other rows',
        );
      }

      // ...while the delete action stays pinned outside the scroll region.
      expect(
        find.descendant(
          of: scrollView,
          matching: find.widgetWithText(DSettingsButton, 'Delete wallet'),
        ),
        findsNothing,
      );
      expect(
        find.widgetWithText(DSettingsButton, 'Delete wallet'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'the normal (no local-endpoint) row set is content-sized with zero scroll '
    'extent',
    (tester) async {
      // The production row set without the debug local-endpoint row must also
      // fit without scrolling (AC lists both sets).
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: true,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );

      await pumpSettings(tester, settings: _softwareSettings());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(maxScrollExtent(tester), 0);
      expect(
        find.widgetWithText(DSettingsButton, 'Use local api server'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'the software and Jade dialogs size to different natural heights with no '
    'flex/overflow exception',
    (tester) async {
      await pumpSettings(tester, settings: _softwareSettings());
      final softwareHeight = tester
          .getSize(find.byType(SingleChildScrollView))
          .height;
      expect(tester.takeException(), isNull);

      await pumpSettings(tester, settings: _jadeSettings());
      final jadeHeight = tester
          .getSize(find.byType(SingleChildScrollView))
          .height;
      expect(tester.takeException(), isNull);

      // The software wallet adds recovery + PIN rows (and drops the single
      // `Jade device` row), so its content column is taller: the dialog shrank
      // to each wallet type's own content rather than a shared fixed height.
      expect(
        softwareHeight,
        greaterThan(jadeHeight),
        reason: 'each wallet type sizes the dialog to its own row set',
      );
    },
  );

  testWidgets(
    'the export entry renders immediately above Network Access for a software '
    'wallet -- directly below PIN protection',
    (tester) async {
      await pumpSettings(tester, settings: _softwareSettings());

      // About us -> PIN protection -> Export -> Network access, in order.
      expect(
        topOf(tester, 'About us'),
        lessThan(topOf(tester, 'PIN protection')),
      );
      expect(
        topOf(tester, 'PIN protection'),
        lessThan(topOf(tester, 'Export watch-only descriptors')),
      );
      expect(
        topOf(tester, 'Export watch-only descriptors'),
        lessThan(topOf(tester, 'Network access')),
      );
      // Immediately above Network: no row sits between Export and Network.
      expect(
        rowsBetween(
          tester,
          topOf(tester, 'Export watch-only descriptors'),
          topOf(tester, 'Network access'),
        ),
        0,
      );
    },
  );

  testWidgets(
    'the export entry renders immediately above Network Access for a Jade '
    'wallet while the Jade device row stays late',
    (tester) async {
      await pumpSettings(tester, settings: _jadeSettings(), textScale: 0.5);

      // No PIN row for Jade, so Export anchors above Network directly.
      expect(
        find.widgetWithText(DSettingsButton, 'PIN protection'),
        findsNothing,
      );
      expect(
        topOf(tester, 'About us'),
        lessThan(topOf(tester, 'Export watch-only descriptors')),
      );
      expect(
        topOf(tester, 'Export watch-only descriptors'),
        lessThan(topOf(tester, 'Network access')),
      );
      // Immediately above Network: no row sits between Export and Network.
      expect(
        rowsBetween(
          tester,
          topOf(tester, 'Export watch-only descriptors'),
          topOf(tester, 'Network access'),
        ),
        0,
      );
      // Export is not tied to `Jade device`: that row keeps its late position,
      // after Network access.
      expect(
        topOf(tester, 'Network access'),
        lessThan(topOf(tester, 'Jade device')),
      );
    },
  );

  testWidgets(
    'a row set taller than the cap scrolls while the delete row stays pinned, '
    'with no flex/overflow exception',
    (tester) async {
      // `_CappedDSettings` shrinks the content cap so the real row list
      // overflows it (no realistic set reaches the production 664px cap),
      // exercising the scroll-on-overflow safety net behaviourally.
      await pumpSettings(
        tester,
        settings: _softwareSettings(),
        settingsWidget: const _CappedDSettings(),
      );

      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      // The over-tall list scrolls instead of throwing a RenderFlex overflow.
      expect(maxScrollExtent(tester), greaterThan(0));
      expect(tester.takeException(), isNull);

      // ...and the delete action stays pinned outside the scroll region.
      expect(
        find.descendant(
          of: scrollView,
          matching: find.widgetWithText(DSettingsButton, 'Delete wallet'),
        ),
        findsNothing,
      );
      expect(
        find.widgetWithText(DSettingsButton, 'Delete wallet'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'the export-descriptors entry is present for a Jade wallet and disabled '
    'while the descriptors are not loaded',
    (tester) async {
      // `_jadeSettings()` logs in a Jade wallet, so this also covers AC "visible
      // for Jade". `walletDescriptorsProvider` defaults to null (not loaded).
      await pumpSettings(tester, settings: _jadeSettings(), textScale: 0.5);

      final exportButton = find.widgetWithText(
        DSettingsButton,
        'Export watch-only descriptors',
      );
      expect(exportButton, findsOneWidget);
      expect(tester.widget<DSettingsButton>(exportButton).disabled, isTrue);
    },
  );

  testWidgets(
    'the export-descriptors entry is present for a software wallet and disabled '
    'while the descriptors are not loaded',
    (tester) async {
      await pumpSettings(tester, settings: _softwareSettings());

      final exportButton = find.widgetWithText(
        DSettingsButton,
        'Export watch-only descriptors',
      );
      expect(exportButton, findsOneWidget);
      expect(tester.widget<DSettingsButton>(exportButton).disabled, isTrue);
    },
  );
}
