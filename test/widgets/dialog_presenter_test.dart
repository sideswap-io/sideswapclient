import 'dart:async';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/common/widgets/enter_to_dismiss.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

void configureFlavor({required bool isDesktop}) {
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableNetworkSettings: false,
      enableJade: false,
      enableLocalEndpoint: false,
      isDesktop: isDesktop,
    ),
  );
}

/// A host whose [title] is the rebuild trigger — see the same helper in
/// `enter_to_dismiss_test.dart` for why a new [MaterialApp] makes every route
/// rebuild its page.
///
/// It carries the platform's theme extensions because both dialogs render a
/// `CustomBigButton`, which reads its style extension with a null check on
/// either branch. Prior art: `d_peg_in_out_init_test.dart`.
///
/// The text is scaled down because the test font draws every glyph as a
/// fixed-width block, which overflows the dialogs' fixed 343px body.
Widget host(String title, ProviderContainer container) =>
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          extensions: FlavorConfig.isDesktop
              ? container.read(desktopAppThemeProvider).themeExtensions
              : container.read(mobileAppThemeProvider).themeExtensions,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(0.4)),
          child: child!,
        ),
        home: const Scaffold(body: Placeholder()),
      ),
    );

/// Every dialog this presenter raises with Enter handling, by the name its
/// test reads, so both are exercised through the same cases.
final dialogs = <(String, Future<void> Function(BuildContext))>[
  (
    'the error dialog',
    (context) =>
        FlutterDialogPresenter().showErrorDialog(context, 'went wrong'),
  ),
  (
    'the insufficient-funds dialog',
    (context) => FlutterDialogPresenter().showInsufficientFundsDialog(
      context,
      From_ShowInsufficientFunds(
        assetId: 'lbtc',
        available: Int64.ONE,
        required: Int64.TWO,
      ),
    ),
  ),
];

Future<void> raise(
  WidgetTester tester,
  ProviderContainer container,
  Future<void> Function(BuildContext) show,
) async {
  await tester.pumpWidget(host('first', container));
  unawaited(show(tester.element(find.byType(Placeholder))));
  await tester.pumpAndSettle();
}

/// The node the dialog's key handling is bound to, read out of the tree.
FocusNode dismissNode(WidgetTester tester) => tester
    .widget<KeyboardListener>(
      find.descendant(
        of: find.byType(EnterToDismiss),
        matching: find.byType(KeyboardListener),
      ),
    )
    .focusNode;

void main() {
  late ProviderContainer container;

  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    container = ProviderContainer.test();
  });

  for (final (name, show) in dialogs) {
    testWidgets('on desktop, Enter closes $name', (tester) async {
      configureFlavor(isDesktop: true);
      await raise(tester, container, show);
      expect(
        find.byType(EnterToDismiss),
        findsOneWidget,
        reason: 'precondition: it is up',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.byType(EnterToDismiss), findsNothing);
    });

    testWidgets('on mobile, Enter leaves $name open', (tester) async {
      configureFlavor(isDesktop: false);
      await raise(tester, container, show);
      expect(
        find.byType(EnterToDismiss),
        findsOneWidget,
        reason: 'precondition: it is up',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.byType(EnterToDismiss), findsOneWidget);
    });

    testWidgets('$name keeps one node when its builder runs again', (
      tester,
    ) async {
      configureFlavor(isDesktop: true);
      await raise(tester, container, show);
      final firstWidget = tester.widget<EnterToDismiss>(
        find.byType(EnterToDismiss),
      );
      final firstNode = dismissNode(tester);

      await tester.pumpWidget(host('second', container));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EnterToDismiss>(find.byType(EnterToDismiss)),
        isNot(same(firstWidget)),
        reason: 'precondition: the builder ran again',
      );

      expect(dismissNode(tester), same(firstNode));
    });
  }
}
