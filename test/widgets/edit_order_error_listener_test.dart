import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/listeners/edit_order_error_listener.dart';

/// The listener is a `Stack` child of `DTxAndOrdersPanel`, and that panel is
/// now laid out under a bounded height so it can yield one. A widget that
/// expands to the biggest size its constraints allow would size the panel's
/// `Stack` to the whole bound instead of to the panel, which is what a bare
/// `Container()` does under a bounded parent and does not do under an
/// unbounded one. So the size is the behaviour worth asserting, and it has to
/// be asserted under a bounded parent to be able to fail.
void main() {
  testWidgets('takes no space, so it cannot size the panel it sits behind', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: Stack(children: [EditOrderErrorListener()]),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(EditOrderErrorListener)), Size.zero);
  });
}
