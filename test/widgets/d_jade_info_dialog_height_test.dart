import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/d_jade_info_dialog.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';

import '../helpers/dialog_height_harness.dart';
import '../helpers/fake_configuration.dart';

/// The dialog's tallest realistic state: a signing status *and* a live
/// time-to-live, which is the only branch that adds the second text row
/// (`d_jade_info_dialog.dart:114-140`).
///
/// `JadeStatusMasterBlindingKey()` is deliberately avoided -- it trips the
/// `useEffect` at `:30-50`, whose `Future.microtask` reaches
/// `pageStatusProvider.notifier` and really does run under `runAsync`.
class _SigningJadeStatus extends JadeStatusNotifier {
  @override
  JadeStatus build() => const JadeStatusSignOfflineSwap();
}

/// A live TTL. The real `OrderTtlNotifier` derives its state from a quote, and
/// the real `OrderSignTtl` runs a `Timer.periodic` that fake async never
/// settles, so both are replaced at the provider boundary.
class _LiveOrderTtl extends OrderTtlNotifier {
  @override
  OrderTtlState build() =>
      OrderTtlState.data(seconds: 60, timestamp: DateTime.utc(2026));
}

class _FixedOrderSignTtl extends OrderSignTtl {
  @override
  int build() => 42;
}

void main() {
  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random
  // seed.
  setUp(() {
    Localization.load(const Locale('en'));
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  Future<void> pump(WidgetTester tester, {required Size view}) => pumpSurface(
    tester,
    view: view,
    overrides: [
      configurationProvider.overrideWith(
        () => FakeConfiguration(
          SideswapSettings.empty(mnemonicEncrypted: Uint8List.fromList([])),
        ),
      ),
      jadeStatusProvider.overrideWith(_SigningJadeStatus.new),
      orderTtlProvider.overrideWith(_LiveOrderTtl.new),
      orderSignTtlProvider.overrideWith(_FixedOrderSignTtl.new),
    ],
    child: const DJadeInfoDialog(),
  );

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  group('DJadeInfoDialog height bound', () {
    testWidgets('declares a height bound at its measured natural height, and '
        'no width bound', (tester) async {
      captureErrors();
      await pump(tester, view: unbounded);

      final constraints = tester
          .widget<DContentDialog>(find.byType(DContentDialog))
          .constraints;
      expect(constraints.maxHeight, 124);
      // The dialog is deliberately full-width; the height bound must not
      // smuggle a width bound in with it.
      expect(constraints.maxWidth, double.infinity);
      expect(constraints.minWidth, 200);
      expect(constraints.minHeight, 100);
      expect(naturalHeight(tester), 124);
    });

    testWidgets('at the design height its scroll owner has zero extent', (
      tester,
    ) async {
      captureErrors();
      await pump(tester, view: designHeight);

      expect(ownScrollView, findsOneWidget);
      // `extentOf` is the strict form: it throws on a second `Scrollable`
      // inside the dialog, so it also asserts the dialog gained none.
      expect(extentOf(tester, ownScrollView), 0);
      // The layout is unchanged: both status rows still render.
      expect(find.text('Sign offline swap transaction'), findsOneWidget);
      expect(find.text('42 s.'), findsOneWidget);
    });

    testWidgets('at the floor there is no vertical overflow and the status is '
        'reachable', (tester) async {
      final errors = captureErrors();

      await pump(tester, view: floor);

      // This dialog has no `actions` slot and no control at all: it is a
      // spinner with a status line behind `PopScope(canPop: false)`
      // (`d_jade_info_dialog.dart:51-52`). What the floor has to guarantee is
      // that the status stays on screen rather than being clipped away.
      expect(
        find.text('Sign offline swap transaction').hitTestable(),
        findsOneWidget,
      );
      expect(find.text('42 s.'), findsOneWidget);
      expect(extentOf(tester, ownScrollView), 0);
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
