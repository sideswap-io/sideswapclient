import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';

const contentKey = Key('content');

void main() {
  // DContentDialogThemeData.standard() reads the theme through a throwaway
  // ProviderContainer whose dispose timer never settles under fake async, so
  // the pump runs inside `runAsync` (prior art: test/widgets/d_settings_test.dart).
  Future<void> pump(
    WidgetTester tester, {
    required Size view,
    required double contentHeight,
    Widget Function(Widget dialog)? wrap,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = view;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final dialog = DContentDialog(
      constraints: const BoxConstraints(maxWidth: 1040, maxHeight: 808),
      title: const Text('Title'),
      content: SizedBox(key: contentKey, height: contentHeight),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: wrap == null ? dialog : wrap(dialog)),
      ),
    );
  });

  // The dialog's own render object is its Align, which fills the window; the
  // decorated box inside it is the dialog the user sees.
  Size dialogSize(WidgetTester tester) => tester.getSize(
    find
        .descendant(
          of: find.byType(DContentDialog),
          matching: find.byType(Container),
        )
        .first,
  );

  testWidgets('a dialog that fits keeps its natural size', (tester) async {
    await pump(tester, view: const Size(1264, 648), contentHeight: 100);

    expect(tester.getSize(find.byKey(contentKey)).height, 100);
    expect(dialogSize(tester).height, lessThan(300));
  });

  testWidgets('a dialog designed taller than the window is bounded to the '
      'window, with the shortfall taken from the content', (tester) async {
    await pump(tester, view: const Size(1264, 648), contentHeight: 712);

    expect(dialogSize(tester).height, lessThanOrEqualTo(648));
    final content = tester.getSize(find.byKey(contentKey)).height;
    expect(content, lessThan(712));
    expect(content, greaterThan(500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a dialog with room takes its design height', (tester) async {
    await pump(tester, view: const Size(1600, 1000), contentHeight: 712);

    expect(tester.getSize(find.byKey(contentKey)).height, 712);
  });

  testWidgets('where nothing bounds the height the dialog stays '
      'content-sized', (tester) async {
    await pump(
      tester,
      view: const Size(1264, 648),
      contentHeight: 100,
      wrap: (dialog) => SingleChildScrollView(child: dialog),
    );

    expect(tester.getSize(find.byKey(contentKey)).height, 100);
    expect(tester.takeException(), isNull);
  });
}
