import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/common/widgets/enter_to_dismiss.dart';
import 'package:sideswap/screens/flavor_config.dart';

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

/// A host whose [title] is the rebuild trigger: a new [MaterialApp] builds a
/// new [Navigator], and `NavigatorState.didUpdateWidget` then makes every
/// route rebuild its page — the run that used to allocate a fresh node.
Widget host(String title) => MaterialApp(
  title: title,
  home: const Scaffold(body: Placeholder()),
);

/// Opens a dialog whose body is an [EnterToDismiss], the habitat the widget
/// exists for. The returned notifier drives the dialog's own text, so a test
/// can prove the builder ran again instead of assuming it.
Future<ValueNotifier<String>> openDialog(WidgetTester tester) async {
  final body = ValueNotifier<String>('first');
  addTearDown(body.dispose);

  await tester.pumpWidget(host('first'));
  unawaited(
    showDialog<void>(
      context: tester.element(find.byType(Placeholder)),
      barrierDismissible: FlavorConfig.isDesktop,
      builder: (_) => EnterToDismiss(child: Dialog(child: Text(body.value))),
    ),
  );
  await tester.pumpAndSettle();

  return body;
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
  testWidgets('on desktop, Enter pops the route the dialog sits in', (
    tester,
  ) async {
    configureFlavor(isDesktop: true);
    await openDialog(tester);
    expect(
      find.text('first'),
      findsOneWidget,
      reason: 'precondition: it is up',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('first'), findsNothing);
  });

  testWidgets('on desktop, holding Enter down does not pop again', (
    tester,
  ) async {
    configureFlavor(isDesktop: true);
    await openDialog(tester);
    expect(
      find.text('first'),
      findsOneWidget,
      reason: 'precondition: it is up',
    );

    // The repeats a held key sends are not fresh presses: acting on them would
    // pop the route behind the dialog as well.
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
  });

  testWidgets('on desktop, a key that is not Enter leaves the route alone', (
    tester,
  ) async {
    configureFlavor(isDesktop: true);
    await openDialog(tester);
    expect(
      find.text('first'),
      findsOneWidget,
      reason: 'precondition: it is up',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
  });

  testWidgets('on mobile, Enter leaves the route alone', (tester) async {
    configureFlavor(isDesktop: false);
    await openDialog(tester);
    expect(
      find.text('first'),
      findsOneWidget,
      reason: 'precondition: it is up',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
  });

  testWidgets('the dialog keeps one node when its builder runs again', (
    tester,
  ) async {
    configureFlavor(isDesktop: true);
    final body = await openDialog(tester);
    final first = dismissNode(tester);

    body.value = 'second';
    await tester.pumpWidget(host('second'));
    await tester.pumpAndSettle();
    expect(
      find.text('second'),
      findsOneWidget,
      reason: 'precondition: the builder ran again',
    );

    expect(dismissNode(tester), same(first));
  });

  testWidgets('a barrier dismissal disposes the node', (tester) async {
    configureFlavor(isDesktop: true);
    await openDialog(tester);
    final node = dismissNode(tester);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsNothing, reason: 'precondition: it closed');
    expect(() => node.addListener(() {}), throwsA(isA<FlutterError>()));
  });

  testWidgets('an Esc dismissal disposes the node', (tester) async {
    configureFlavor(isDesktop: true);
    await openDialog(tester);
    final node = dismissNode(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('first'), findsNothing, reason: 'precondition: it closed');
    expect(() => node.addListener(() {}), throwsA(isA<FlutterError>()));
  });
}
