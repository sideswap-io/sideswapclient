import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_focus.dart';

void main() {
  // `FocusManager` is the binding's process-wide singleton, so the strategy is
  // captured and restored per test rather than set once for the file: a leaked
  // `alwaysTraditional` would change focus rendering in every other widget file
  // under a randomised ordering seed.
  //
  // It has to be forced at all, because `flutter_test` reports
  // `TargetPlatform.android` with no mouse connected, for which the default
  // `automatic` strategy resolves to `FocusHighlightMode.touch` — and the touch
  // mode never shows a focus highlight, so `onShowFocusHighlight` would never
  // fire and `ButtonStates.focused` would be unreachable.
  setUp(() {
    final previous = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = previous);
  });

  DHoverButtonState stateOf(WidgetTester tester) =>
      tester.state<DHoverButtonState>(find.byType(DHoverButton));

  group('DHoverButton', () {
    // The states the builder was last handed. The builder callback is the
    // button's externally observable rendering surface, so every assertion
    // about hover/press/focus is made through it rather than through the
    // state's private booleans.
    late Set<ButtonStates> states;

    setUp(() => states = const {});

    // `ChangeNotifier.addListener` asserts the notifier has not been disposed,
    // which makes it the discriminator for "was this node freed?" — there is no
    // public `debugDisposed` on `FocusNode`.
    final isDisposed = throwsAssertionError;
    final isNotDisposed = returnsNormally;

    Future<void> pumpButton(
      WidgetTester tester, {
      FocusNode? focusNode,
      bool autofocus = false,
      ValueChanged<bool>? onFocusChange,
      VoidCallback? onPressed,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DHoverButton(
              // Without a gesture callback the button reports itself disabled
              // and `FocusableActionDetector` refuses focus outright.
              onPressed: onPressed ?? () {},
              focusNode: focusNode,
              autofocus: autofocus,
              onFocusChange: onFocusChange,
              builder: (context, s) {
                states = s;
                return const SizedBox(width: 40, height: 40);
              },
            ),
          ),
        ),
      );
    }

    testWidgets('adopts a focus node supplied after mount', (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      await pumpButton(tester);
      await pumpButton(tester, focusNode: supplied);

      expect(stateOf(tester).node, same(supplied));
    });

    testWidgets('reports focus through an adopted node', (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);
      final focusChanges = <bool>[];

      await pumpButton(tester, onFocusChange: focusChanges.add);
      stateOf(tester).node.requestFocus();
      await tester.pump();
      expect(
        states,
        contains(ButtonStates.focused),
        reason: 'the internally created node should report focus',
      );

      await pumpButton(
        tester,
        focusNode: supplied,
        onFocusChange: focusChanges.add,
      );
      await tester.pump();
      expect(
        states,
        isNot(contains(ButtonStates.focused)),
        reason: 'the swap unfocuses, and focus is not carried to the new node',
      );

      focusChanges.clear();
      supplied.requestFocus();
      // Two frames: one applies the focus change and reports the highlight,
      // the next rebuilds the builder with the resulting states.
      await tester.pump();
      await tester.pump();
      expect(
        states,
        contains(ButtonStates.focused),
        reason: 'the adopted node must be the one the button answers for',
      );
      expect(focusChanges, contains(true));
    });

    testWidgets('stops answering for a node it was swapped off', (
      tester,
    ) async {
      final nodeA = FocusNode();
      final nodeB = FocusNode();
      addTearDown(nodeA.dispose);
      addTearDown(nodeB.dispose);
      final focusChanges = <bool>[];

      await pumpButton(
        tester,
        focusNode: nodeA,
        onFocusChange: focusChanges.add,
      );
      nodeA.requestFocus();
      await tester.pump();
      await tester.pump();
      expect(states, contains(ButtonStates.focused));

      await pumpButton(
        tester,
        focusNode: nodeB,
        onFocusChange: focusChanges.add,
      );
      await tester.pump();
      focusChanges.clear();

      nodeA.requestFocus();
      await tester.pump();
      await tester.pump();

      expect(stateOf(tester).node, same(nodeB));
      expect(nodeA.hasFocus, isFalse, reason: 'the old node is detached');
      expect(states, isNot(contains(ButtonStates.focused)));
      expect(focusChanges, isEmpty);
    });

    testWidgets('disposes the node it created', (tester) async {
      await pumpButton(tester);
      final internal = stateOf(tester).node;

      await tester.pumpWidget(const SizedBox());

      expect(() => internal.addListener(() {}), isDisposed);
    });

    testWidgets(
      'disposes the node it created even when a node is supplied afterwards',
      (tester) async {
        final supplied = FocusNode();
        addTearDown(supplied.dispose);

        await pumpButton(tester);
        final internal = stateOf(tester).node;
        await pumpButton(tester, focusNode: supplied);
        await tester.pumpWidget(const SizedBox());

        expect(() => internal.addListener(() {}), isDisposed);
        expect(() => supplied.addListener(() {}), isNotDisposed);
      },
    );

    testWidgets(
      'never disposes a node it was given, even after the caller withdraws it',
      (tester) async {
        final supplied = FocusNode();
        addTearDown(supplied.dispose);

        await pumpButton(tester, focusNode: supplied);
        await pumpButton(tester);
        expect(
          stateOf(tester).node,
          isNot(same(supplied)),
          reason:
              'withdrawal mints a fresh internal node, it does not keep the '
              "caller's",
        );

        await tester.pumpWidget(const SizedBox());

        expect(() => supplied.addListener(() {}), isNotDisposed);
      },
    );

    testWidgets('reuses the node it created when a caller withdraws theirs', (
      tester,
    ) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      await pumpButton(tester);
      final internal = stateOf(tester).node;
      await pumpButton(tester, focusNode: supplied);
      await pumpButton(tester);

      expect(
        stateOf(tester).node,
        same(internal),
        reason: 'the state keeps one node of its own for its whole lifetime',
      );

      await tester.pumpWidget(const SizedBox());

      // Exactly once: a second `dispose` on the same node would itself assert
      // during the unmount above and fail this test before reaching here.
      expect(() => internal.addListener(() {}), isDisposed);
      expect(() => supplied.addListener(() {}), isNotDisposed);
    });

    testWidgets('keeps the hover highlight across a node swap', (tester) async {
      final nodeA = FocusNode();
      final nodeB = FocusNode();
      addTearDown(nodeA.dispose);
      addTearDown(nodeB.dispose);

      await pumpButton(tester, focusNode: nodeA);
      final mouse = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(
        mouse.hover(tester.getCenter(find.byType(DHoverButton))),
      );
      await tester.pump();
      await tester.pump();
      expect(states, contains(ButtonStates.hovering));

      // The pointer does not move; only the node changes. The swap must not
      // blank the hover highlight, not even for the one frame it takes the
      // replacement mouse region to report.
      await pumpButton(tester, focusNode: nodeB);
      expect(states, contains(ButtonStates.hovering));
    });

    testWidgets('keeps a gesture in flight across a node swap', (tester) async {
      final nodeA = FocusNode();
      final nodeB = FocusNode();
      addTearDown(nodeA.dispose);
      addTearDown(nodeB.dispose);
      var presses = 0;

      await pumpButton(
        tester,
        focusNode: nodeA,
        onPressed: () => presses++,
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(DHoverButton)),
      );
      await tester.pump();

      await pumpButton(
        tester,
        focusNode: nodeB,
        onPressed: () => presses++,
      );
      await tester.pump();
      await gesture.up();
      await tester.pump();

      // The focus layer is rebuilt on a node swap; the gesture layer must not
      // be, or the press the user is in the middle of making is swallowed.
      expect(presses, 1);
      expect(states, contains(ButtonStates.pressing));
      await tester.pump(const Duration(milliseconds: 150));
      expect(states, isNot(contains(ButtonStates.pressing)));
    });

    testWidgets(
      'keeps its autofocus, focus, hover and press behaviour when its focus '
      'node never changes',
      (tester) async {
        var presses = 0;

        await pumpButton(tester, autofocus: true, onPressed: () => presses++);
        await tester.pump();
        await tester.pump();

        expect(stateOf(tester).node.hasFocus, isTrue, reason: 'autofocus');
        expect(states, contains(ButtonStates.focused));

        final mouse = TestPointer(1, PointerDeviceKind.mouse);
        final centre = tester.getCenter(find.byType(DHoverButton));
        await tester.sendEventToBinding(mouse.hover(centre));
        await tester.pump();
        expect(states, contains(ButtonStates.hovering));

        // Far outside the 40x40 button, which sits at the top-left of the body.
        await tester.sendEventToBinding(mouse.hover(const Offset(600, 600)));
        await tester.pump();
        expect(states, isNot(contains(ButtonStates.hovering)));

        await tester.tap(find.byType(DHoverButton));
        await tester.pump();
        expect(states, contains(ButtonStates.pressing));
        expect(presses, 1);

        // The press state is released behind a real 100 ms delay.
        await tester.pump(const Duration(milliseconds: 150));
        expect(states, isNot(contains(ButtonStates.pressing)));
      },
    );

    // The reset above is guarded on the node having actually changed. This is
    // the branch that keeps the guard honest: a rebuild that leaves the node
    // alone must not clear the highlights the button is currently showing.
    testWidgets('keeps its highlights across a rebuild that leaves the node '
        'alone', (tester) async {
      final stable = FocusNode();
      addTearDown(stable.dispose);

      await pumpButton(tester, focusNode: stable, autofocus: true);
      await tester.pump();
      await tester.pump();
      final mouse = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(
        mouse.hover(tester.getCenter(find.byType(DHoverButton))),
      );
      await tester.pump();
      expect(states, contains(ButtonStates.focused));
      expect(states, contains(ButtonStates.hovering));

      await pumpButton(tester, focusNode: stable, autofocus: true);
      await tester.pump();

      expect(states, contains(ButtonStates.focused));
      expect(states, contains(ButtonStates.hovering));
    });
  });

  // `DButton` forwards `focusNode` through `DBaseButton` to `DHoverButton`
  // without touching it, and every other button in the desktop family forwards
  // it the same way. One consuming button is therefore enough to show the
  // family inherits the fix and needs no call-site changes.
  group('DButton', () {
    // The whole pump runs inside `runAsync` because `DButton.defaultStyleOf`
    // allocates a throwaway `ProviderContainer` per build and never disposes
    // it, leaving riverpod dispose timers that never settle under fake async.
    Future<void> pumpButton(
      WidgetTester tester, {
      FocusNode? focusNode,
      bool autofocus = false,
    }) async {
      await tester.runAsync(
        () => tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: Scaffold(
                body: DButton(
                  onPressed: () {},
                  focusNode: focusNode,
                  autofocus: autofocus,
                  child: const Text('ok'),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('forwards a focus node supplied after mount', (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      await pumpButton(tester);
      await pumpButton(tester, focusNode: supplied);

      expect(stateOf(tester).node, same(supplied));

      // Adoption is only half of the criterion — the control has to answer for
      // the new node. `DFocusBorder.focused` is what the family renders from
      // `ButtonStates.focused`, so it is the observable end of that chain.
      await tester.runAsync(() async {
        supplied.requestFocus();
        await tester.pump();
        await tester.pump();
      });
      expect(supplied.hasFocus, isTrue);
      expect(
        tester.widget<DFocusBorder>(find.byType(DFocusBorder)).focused,
        isTrue,
      );
    });

    testWidgets('keeps a stable focus node focused across rebuilds', (
      tester,
    ) async {
      final stable = FocusNode();
      addTearDown(stable.dispose);

      await pumpButton(tester, focusNode: stable, autofocus: true);
      expect(stable.hasFocus, isTrue);

      await pumpButton(tester, focusNode: stable, autofocus: true);

      expect(stable.hasFocus, isTrue);
      expect(stateOf(tester).node, same(stable));
    });
  });
}
