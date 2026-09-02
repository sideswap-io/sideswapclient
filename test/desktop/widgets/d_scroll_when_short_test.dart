import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';

const designHeight = 700.0;
const childKey = Key('child');

/// A child whose state must survive the parent crossing the design height.
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int taps = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => taps++),
      child: SizedBox.expand(key: childKey),
    );
  }
}

void main() {
  // The default 800x600 test view would clamp the tall parents used below.
  void sizeView(WidgetTester tester) {
    tester.view.physicalSize = const Size(2000, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> pump(
    WidgetTester tester,
    Size parent, {
    Widget child = const SizedBox.expand(key: childKey),
  }) {
    sizeView(tester);
    return tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          // Loose constraints, as from the Center / Row / Container parents
          // the widget is used under.
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(parent),
              child: DScrollWhenShort(height: designHeight, child: child),
            ),
          ),
        ),
      ),
    );
  }

  double maxScrollExtent(WidgetTester tester) => tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position
      .maxScrollExtent;

  testWidgets('lays the child out at the design height when there is room, '
      'with nothing to scroll', (tester) async {
    await pump(tester, const Size(800, 1000));

    expect(tester.getSize(find.byKey(childKey)).height, designHeight);
    expect(tester.getSize(find.byType(DScrollWhenShort)).height, designHeight);
    expect(maxScrollExtent(tester), 0);
  });

  testWidgets('fills a shorter parent and scrolls the difference', (
    tester,
  ) async {
    await pump(tester, const Size(800, 500));

    expect(tester.getSize(find.byType(DScrollWhenShort)).height, 500);
    expect(tester.getSize(find.byKey(childKey)).height, designHeight);
    expect(maxScrollExtent(tester), designHeight - 500);
  });

  testWidgets('takes the design height where the parent height is unbounded', (
    tester,
  ) async {
    sizeView(tester);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: const [
              DScrollWhenShort(
                height: designHeight,
                child: SizedBox.expand(key: childKey),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(childKey)).height, designHeight);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the child state when the parent crosses the design '
      'height', (tester) async {
    await pump(tester, const Size(800, 1000), child: const _Counter());
    await tester.tap(find.byKey(childKey));
    await tester.pump();
    final state = tester.state<_CounterState>(find.byType(_Counter));
    expect(state.taps, 1);

    await pump(tester, const Size(800, 500), child: const _Counter());
    expect(tester.state<_CounterState>(find.byType(_Counter)), same(state));
    expect(state.taps, 1);

    await pump(tester, const Size(800, 1000), child: const _Counter());
    expect(tester.state<_CounterState>(find.byType(_Counter)), same(state));
    expect(state.taps, 1);
  });
}
