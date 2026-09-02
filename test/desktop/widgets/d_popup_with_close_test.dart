import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';

const popupWidth = 580.0;
const popupHeight = 710.0;
const childKey = Key('child');

void main() {
  // DIconButton resolves its theme through a throwaway ProviderContainer whose
  // dispose timer never settles under fake async, so the pump runs inside
  // `runAsync` (prior art: test/widgets/d_settings_test.dart).
  Future<void> pump(
    WidgetTester tester, {
    required Size view,
    double? height = popupHeight,
    Widget child = const SizedBox.expand(key: childKey),
  }) => tester.runAsync(() async {
    tester.view.physicalSize = view;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DPopupWithCloseContent(
            width: popupWidth,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  });

  Rect popupRect(WidgetTester tester) =>
      tester.getRect(find.byType(DScrollWhenShort));

  testWidgets('a window with room shows the popup at its design height', (
    tester,
  ) async {
    await pump(tester, view: const Size(1600, 1000));

    expect(popupRect(tester).size, const Size(popupWidth, popupHeight));
    expect(tester.getSize(find.byKey(childKey)).height, popupHeight);
  });

  testWidgets('a shorter window gets a popup that fills it and scrolls, '
      'with the close button still in the corner', (tester) async {
    // 1920x1080 @ 150 % laptop: 1280x720 logical, 648 px client height.
    await pump(tester, view: const Size(1264, 648));

    final popup = popupRect(tester);
    expect(popup.size, const Size(popupWidth, 648));
    // The content keeps its design layout...
    expect(tester.getSize(find.byKey(childKey)).height, popupHeight);
    // ...and the shortfall is scrollable rather than clipped.
    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    expect(position.maxScrollExtent, popupHeight - 648);

    final close = tester.getRect(find.byType(DIconButton));
    expect(close.top, popup.top + 20);
    expect(close.right, popup.right - 20);
  });

  testWidgets('a popup without a design height is left as it was: no scroll '
      'wrapper', (tester) async {
    await pump(
      tester,
      view: const Size(1600, 1000),
      height: null,
      child: const SizedBox(key: childKey, width: 200, height: 300),
    );

    expect(find.byType(DScrollWhenShort), findsNothing);
    expect(tester.getSize(find.byKey(childKey)), const Size(200, 300));
    expect(find.byType(DIconButton), findsOneWidget);
  });
}
