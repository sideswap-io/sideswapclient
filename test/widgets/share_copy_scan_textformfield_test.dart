// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';

/// Pumps the field under a rebuild trigger that never touches the focus node:
/// changing the returned notifier's value rebuilds the widget and nothing else.
///
/// [onScanTap] mirrors `whom_to_pay_text_field.dart:25` — the one production
/// caller that supplies no node supplies a suffix callback, so the fallback
/// node reaches `ShareCopyScanSuffixIcon` there. Left null with every other
/// suffix callback, the suffix subtree is never built (`emptySuffix` is true),
/// which is the cheaper harness for everything that does not depend on it.
Future<ValueNotifier<String>> pumpField(
  WidgetTester tester, {
  FocusNode? focusNode,
  VoidCallback? onScanTap,
  VoidCallback? onCopyTap,
  VoidCallback? onPasteTap,
  ShareTapCallback? onShareTap,
}) async {
  final hint = ValueNotifier<String>('a');
  addTearDown(hint.dispose);

  // Each build wraps the callbacks in fresh closures, the way every production
  // caller does — `whom_to_pay_text_field.dart:24` allocates its `onScanTap`
  // inside `build`. Handing the same closure objects to every rebuild would
  // hide any regression that keys off callback identity.
  final scan = onScanTap;
  final copy = onCopyTap;
  final paste = onPasteTap;
  final share = onShareTap;

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<String>(
            valueListenable: hint,
            builder: (context, value, _) => ShareCopyScanTextFormField(
              focusNode: focusNode,
              onScanTap: scan == null ? null : () => scan(),
              onCopyTap: copy == null ? null : () => copy(),
              onPasteTap: paste == null ? null : () => paste(),
              onShareTap: share == null ? null : (context) => share(context),
              hintText: value,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return hint;
}

/// `spaceBetween * 2 + iconWidth` from
/// `share_copy_scan_textformfield.dart:71` — the width one suffix button
/// occupies. The rendered suffix is this many pixels per non-null callback.
const gestureAreaWidth = 32.0;

/// The width the suffix area declares for itself. Read off the `Row` rather
/// than off the suffix icon, because `InputDecoration` imposes its own 48x48
/// minimum on the icon slot; the `Row` sits inside the `SizedBox` carrying the
/// declared width, so it reports that width and nothing else.
///
/// That is also its limit: it says how many buttons were counted, never which
/// ones were built. Pair it with [suffixButtons].
double suffixWidth(WidgetTester tester) => tester
    .getSize(
      find.descendant(
        of: find.byType(ShareCopyScanSuffixIcon),
        matching: find.byType(Row),
      ),
    )
    .width;

/// How many suffix buttons actually rendered — one `InkWell` per button. This
/// is the half [suffixWidth] cannot see: the `Row` reports its declared width
/// whatever its children are, so a button gated on the wrong callback keeps the
/// width right while building the wrong thing.
int suffixButtons(WidgetTester tester) => tester
    .widgetList<InkWell>(
      find.descendant(
        of: find.byType(ShareCopyScanSuffixIcon),
        matching: find.byType(InkWell),
      ),
    )
    .length;

/// The rebuilt widget's own [ShareCopyScanTextFormField.hintText] — proof the
/// rebuild trigger actually fired, so the assertions after it cannot pass
/// vacuously.
String renderedHint(WidgetTester tester) => tester
    .widget<ShareCopyScanTextFormField>(find.byType(ShareCopyScanTextFormField))
    .hintText!;

FocusNode fieldNode(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).focusNode!;

/// `ChangeNotifier.addListener` asserts the notifier has not been disposed,
/// which makes it the discriminator for "was this node freed?" — there is no
/// public `debugDisposed` on `FocusNode`. Same shape as
/// `test/widgets/d_hover_button_test.dart:42`.
final isNotDisposed = returnsNormally;
final isDisposed = throwsAssertionError;

/// Unmounting leaves a pending riverpod dispose timer behind; draining it here
/// keeps the pending-timer check from failing the test.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
}

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
      ),
    );
  });

  testWidgets(
    'survives a caller that starts supplying a focus node after mount',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      // Both pumps put the same widget type at the same position with no key,
      // so the element — and with it the hook state — is reused rather than
      // rebuilt from scratch. That reuse is the only reason the nullness flip
      // is observable at all.
      await pumpField(tester);
      await pumpField(tester, focusNode: supplied);

      // The fallback hook must be called on every build, not only when the
      // caller supplies nothing: `flutter_hooks` identifies hooks by call
      // order, so a hook inside a `??` throws the moment nullness flips.
      //
      expect(tester.takeException(), isNull);

      // The field is rewired to the new node because `defaultFocusNode` is
      // recomputed on every build. This is a claim about the `TextField` only,
      // not about the widget adopting the node wholesale: the `useCallback`
      // that captures the node still has no key list and keeps the first one.
      // That is #216's job, and this file must not read as if it were done.
      expect(fieldNode(tester), same(supplied));
    },
  );

  testWidgets(
    'wires the caller-supplied node to the field and never disposes it',
    (tester) async {
      final supplied = FocusNode();
      addTearDown(supplied.dispose);

      await pumpField(tester, focusNode: supplied);

      expect(fieldNode(tester), same(supplied));

      await unmount(tester);

      expect(() => supplied.addListener(() {}), isNotDisposed);
    },
  );

  testWidgets(
    'keeps one internal fallback node, and its focus, across a rebuild',
    (tester) async {
      final hint = await pumpField(tester);

      final node1 = fieldNode(tester);
      node1.requestFocus();
      await tester.pump();
      expect(
        node1.hasFocus,
        isTrue,
        reason: 'precondition: the field is focused',
      );

      hint.value = 'b';
      await tester.pump();
      expect(renderedHint(tester), 'b', reason: 'precondition: it rebuilt');

      final node2 = fieldNode(tester);
      expect(
        identical(node1, node2),
        isTrue,
        reason: 'the fallback node must survive a rebuild',
      );
      expect(node2.hasFocus, isTrue, reason: 'focus must survive a rebuild');
    },
  );

  testWidgets('disposes the internal fallback node it created', (tester) async {
    await pumpField(tester);
    final internal = fieldNode(tester);

    await unmount(tester);

    expect(() => internal.addListener(() {}), isDisposed);
  });

  testWidgets(
    'keeps its fallback node stable while rendering the suffix icons',
    (tester) async {
      // What `WhomToPayTextField` actually ships: no node supplied, and a
      // suffix callback, so the fallback node is the one handed to
      // `ShareCopyScanSuffixIcon`.
      final hint = await pumpField(tester, onScanTap: () {});

      expect(find.byType(ShareCopyScanSuffixIcon), findsOneWidget);
      final node1 = fieldNode(tester);
      expect(
        tester
            .widget<ShareCopyScanSuffixIcon>(
              find.byType(ShareCopyScanSuffixIcon),
            )
            .defaultFocusNode,
        same(node1),
      );

      hint.value = 'b';
      await tester.pump();
      expect(renderedHint(tester), 'b', reason: 'precondition: it rebuilt');

      expect(identical(fieldNode(tester), node1), isTrue);
    },
  );

  group('suffix width follows the callbacks of the current build', () {
    testWidgets('renders no suffix at all when every callback is null', (
      tester,
    ) async {
      await pumpField(tester);

      expect(find.byType(ShareCopyScanSuffixIcon), findsNothing);
    });

    testWidgets('is one gesture area wide for one callback', (tester) async {
      await pumpField(tester, onScanTap: () {});

      expect(suffixWidth(tester), gestureAreaWidth);
      expect(suffixButtons(tester), 1);
    });

    testWidgets('is two gesture areas wide for two callbacks', (tester) async {
      await pumpField(tester, onScanTap: () {}, onCopyTap: () {});

      expect(suffixWidth(tester), 2 * gestureAreaWidth);
      expect(suffixButtons(tester), 2);
    });

    testWidgets('is four gesture areas wide for four callbacks', (
      tester,
    ) async {
      await pumpField(
        tester,
        onScanTap: () {},
        onCopyTap: () {},
        onPasteTap: () {},
        onShareTap: (_) {},
      );

      expect(suffixWidth(tester), 4 * gestureAreaWidth);
      expect(suffixButtons(tester), 4);

      // Which four. The width alone tells one button from another not at all,
      // and copy and scan are both SVGs, so those two are counted together.
      final suffix = find.byType(ShareCopyScanSuffixIcon);
      expect(
        find.descendant(of: suffix, matching: find.byIcon(Icons.content_paste)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: suffix, matching: find.byIcon(Icons.share)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: suffix, matching: find.byType(SvgPicture)),
        findsNWidgets(2),
      );
    });

    // The two rebuild cases pump twice for element reuse, the same way the
    // focus-node case above does; the node-identity assertion is what proves
    // the callback set changed on a rebuild rather than on a remount.
    testWidgets('widens when a rebuild supplies one more callback', (
      tester,
    ) async {
      await pumpField(tester, onScanTap: () {});

      expect(
        suffixWidth(tester),
        gestureAreaWidth,
        reason: 'precondition: one callback on the first build',
      );
      final node = fieldNode(tester);

      await pumpField(tester, onScanTap: () {}, onCopyTap: () {});

      expect(suffixWidth(tester), 2 * gestureAreaWidth);
      expect(suffixButtons(tester), 2);
      expect(
        identical(fieldNode(tester), node),
        isTrue,
        reason: 'the width must follow the rebuild, not a remount',
      );
    });

    testWidgets('drops the suffix when a rebuild withdraws every callback', (
      tester,
    ) async {
      await pumpField(tester, onScanTap: () {});

      expect(
        find.byType(ShareCopyScanSuffixIcon),
        findsOneWidget,
        reason: 'precondition: one callback on the first build',
      );
      final node = fieldNode(tester);

      await pumpField(tester);

      expect(find.byType(ShareCopyScanSuffixIcon), findsNothing);
      expect(identical(fieldNode(tester), node), isTrue);
    });

    // The field itself can no longer hand the suffix icon a zero width — an
    // empty callback set is caught by `emptySuffix` first. The guard stays
    // because `ShareCopyScanSuffixIcon` is public and its width is a required
    // parameter, so this covers the guard through that public constructor.
    testWidgets('the suffix icon renders nothing when handed a zero width', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ShareCopyScanSuffixIcon(
                suffixWidth: 0,
                onCopyTap: null,
                gestureAreaWidth: gestureAreaWidth,
                onTapSuffixCallback: ({VoidCallback? onTap}) => null,
                iconWidth: 24,
                onPasteTap: null,
                onScanTap: null,
                shareEnabled: true,
                onShareTap: null,
                defaultFocusNode: node,
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(ShareCopyScanSuffixIcon)), Size.zero);
    });

    testWidgets('never accumulates across rebuilds of an unchanged set', (
      tester,
    ) async {
      final hint = await pumpField(tester, onScanTap: () {}, onCopyTap: () {});

      expect(suffixWidth(tester), 2 * gestureAreaWidth);

      for (final value in ['b', 'c', 'd']) {
        hint.value = value;
        await tester.pump();
        expect(renderedHint(tester), value, reason: 'precondition: it rebuilt');
        expect(
          suffixWidth(tester),
          2 * gestureAreaWidth,
          reason: 'the count is recomputed per build, never added to',
        );
        expect(suffixButtons(tester), 2);
      }
    });
  });
}
