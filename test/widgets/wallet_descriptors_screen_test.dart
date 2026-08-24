// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/models/wallet_descriptors.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';
import 'package:sideswap/screens/background/background_painter.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/wallet_descriptors_screen.dart';

class _FakeWalletDescriptorsNotifier extends WalletDescriptorsNotifier {
  _FakeWalletDescriptorsNotifier(this._value);

  final WalletDescriptors? _value;

  @override
  WalletDescriptors? build() => _value;
}

const _nativeDescriptor = 'ct(slip77(aa),elwpkh(native/*))';
const _nestedDescriptor = 'ct(slip77(bb),elsh(wpkh(nested/*)))';

const _copyNativeKey = Key('copy_native_segwit_descriptor');
const _copyNestedKey = Key('copy_nested_segwit_descriptor');
const _shareNativeKey = Key('share_native_segwit_descriptor');
const _shareNestedKey = Key('share_nested_segwit_descriptor');
const _confirmKey = Key('descriptor_copy_confirm');
const _cancelKey = Key('descriptor_copy_cancel');

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // SideSwapScaffold reads FlavorConfig.isDesktop during build.
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
    // Back the platform clipboard channel so copyToClipboard's Clipboard write
    // resolves without a missing-plugin error under the test binding.
    TestDefaultBinaryMessengerBinding
        .instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          return null;
        });
  });

  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random seed.
  setUp(() {
    Localization.load(const Locale('en'));
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // Captures descriptors handed to the injected share seam so tests can assert
  // the exact shared payload and whether share fired at all. Rebuilt per test.
  late List<String> sharedDescriptors;

  setUp(() {
    sharedDescriptors = [];
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    WalletDescriptors? descriptors = const WalletDescriptors(
      nativeSegwit: _nativeDescriptor,
      nestedSegwit: _nestedDescriptor,
    ),
    TextDirection textDirection = TextDirection.ltr,
  }) => tester.pumpWidget(
    ProviderScope(
      overrides: [
        walletDescriptorsProvider.overrideWith(
          () => _FakeWalletDescriptorsNotifier(descriptors),
        ),
      ],
      child: MaterialApp(
        // CustomAppBar reads the CustomBackButtonStyle theme extension.
        // NoSplash avoids Material's InkSparkle fragment shader, whose asset is
        // unavailable under `--no-test-assets` (tools/coverage.dart) when a button is
        // tapped; the ripple is not under test.
        theme: ThemeData(
          extensions: [CustomBackButtonStyle.standard()],
          splashFactory: NoSplash.splashFactory,
        ),
        // Nested Directionality is a descendant of MaterialApp's own, so it
        // wins for the screen subtree -- lets a test drive an RTL ambient
        // without pulling in flutter_localizations.
        home: Directionality(
          textDirection: textDirection,
          child: WalletDescriptorsScreen(
            shareDescriptor: (descriptor) async {
              sharedDescriptors.add(descriptor);
            },
          ),
        ),
      ),
    ),
  );

  group('WalletDescriptorsScreen', () {
    testWidgets('shows the warning and both descriptor sections', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.text('Wallet descriptors'), findsOneWidget);
      expect(
        find.textContaining('Anyone with these descriptors'),
        findsOneWidget,
      );
      expect(find.text('Native segwit'), findsOneWidget);
      expect(find.text('Nested segwit'), findsOneWidget);
      expect(find.text(_nativeDescriptor), findsOneWidget);
      expect(find.text(_nestedDescriptor), findsOneWidget);
    });

    testWidgets('renders no QR widget on either descriptor section', (
      tester,
    ) async {
      await pumpScreen(tester);

      // The QR widgets and their keys are gone (workflow is copy/paste, not
      // camera scan); nothing carries the old QR keys.
      expect(find.byKey(const Key('qr_native_segwit_descriptor')), findsNothing);
      expect(find.byKey(const Key('qr_nested_segwit_descriptor')), findsNothing);
    });

    testWidgets('each preview is a MiddleEllipsisText carrying the full string', (
      tester,
    ) async {
      await pumpScreen(tester);

      final previews = tester
          .widgetList<MiddleEllipsisText>(find.byType(MiddleEllipsisText))
          .map((w) => w.text)
          .toList();

      // Both descriptors are carried verbatim by a middle-ellipsis preview --
      // the property, not the painted glyphs, is the full-string guarantee.
      expect(previews, containsAll([_nativeDescriptor, _nestedDescriptor]));
    });

    testWidgets('renders nothing but the app bar when descriptors are absent', (
      tester,
    ) async {
      await pumpScreen(tester, descriptors: null);

      expect(find.text('Wallet descriptors'), findsOneWidget);
      expect(find.text('Native segwit'), findsNothing);
      expect(find.text(_nativeDescriptor), findsNothing);
    });

    testWidgets('the first copy of a visit prompts a confirmation dialog', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.byKey(_confirmKey), findsNothing);

      await tester.tap(find.byKey(_copyNativeKey));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('copied to your system clipboard'),
        findsOneWidget,
      );
      expect(find.byKey(_confirmKey), findsOneWidget);

      // Cancelling dismisses the dialog and copies nothing.
      await tester.tap(find.byKey(_cancelKey));
      await tester.pumpAndSettle();

      expect(find.byKey(_confirmKey), findsNothing);
    });

    testWidgets('a later copy in the same visit does not re-prompt', (
      tester,
    ) async {
      await pumpScreen(tester);

      // First copy: acknowledge the dialog.
      await tester.tap(find.byKey(_copyNativeKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_confirmKey));
      await tester.pumpAndSettle();

      // Second copy on the other section: no dialog this time.
      await tester.ensureVisible(find.byKey(_copyNestedKey));
      await tester.tap(find.byKey(_copyNestedKey));
      await tester.pumpAndSettle();

      expect(find.byKey(_confirmKey), findsNothing);
    });

    testWidgets('re-entering the screen re-arms the confirmation dialog', (
      tester,
    ) async {
      await pumpScreen(tester);
      await tester.tap(find.byKey(_copyNativeKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_confirmKey));
      await tester.pumpAndSettle();

      // Leave and re-enter: a fresh screen instance.
      await tester.pumpWidget(const SizedBox.shrink());
      await pumpScreen(tester);

      await tester.ensureVisible(find.byKey(_copyNestedKey));
      await tester.tap(find.byKey(_copyNestedKey));
      await tester.pumpAndSettle();

      expect(find.byKey(_confirmKey), findsOneWidget);
    });

    testWidgets('exposes a Share action for each descriptor section', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.byKey(_shareNativeKey), findsOneWidget);
      expect(find.byKey(_shareNestedKey), findsOneWidget);
    });

    testWidgets(
      'the first share of a visit is preceded by the confirmation dialog',
      (tester) async {
        await pumpScreen(tester);

        expect(find.byKey(_confirmKey), findsNothing);

        await tester.tap(find.byKey(_shareNativeKey));
        await tester.pumpAndSettle();

        // The dialog gates the share before anything leaves the app.
        expect(find.byKey(_confirmKey), findsOneWidget);
        expect(sharedDescriptors, isEmpty);
      },
    );

    testWidgets('cancelling the confirmation shares nothing', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.byKey(_shareNativeKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_cancelKey));
      await tester.pumpAndSettle();

      expect(find.byKey(_confirmKey), findsNothing);
      expect(sharedDescriptors, isEmpty);
    });

    testWidgets(
      'confirming a share hands the exact descriptor to the share seam',
      (tester) async {
        await pumpScreen(tester);

        await tester.tap(find.byKey(_shareNativeKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_confirmKey));
        await tester.pumpAndSettle();

        expect(sharedDescriptors, [_nativeDescriptor]);
      },
    );

    testWidgets('the copy/share acknowledgement is shared across both actions', (
      tester,
    ) async {
      await pumpScreen(tester);

      // Acknowledge via Share first.
      await tester.tap(find.byKey(_shareNativeKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_confirmKey));
      await tester.pumpAndSettle();

      // A subsequent Copy is not re-prompted by the shared gate.
      await tester.ensureVisible(find.byKey(_copyNestedKey));
      await tester.tap(find.byKey(_copyNestedKey));
      await tester.pumpAndSettle();

      expect(find.byKey(_confirmKey), findsNothing);

      // ...and a later Share fires straight through, no dialog.
      await tester.ensureVisible(find.byKey(_shareNestedKey));
      await tester.tap(find.byKey(_shareNestedKey));
      await tester.pumpAndSettle();

      expect(find.byKey(_confirmKey), findsNothing);
      expect(sharedDescriptors, [_nativeDescriptor, _nestedDescriptor]);
    });

    testWidgets('Share and Copy sit in Share-then-Copy order, right-aligned', (
      tester,
    ) async {
      await pumpScreen(tester);

      // The actions block is pinned right by an Align(centerRight) wrapper (a
      // bare WrapAlignment.end had no free space under the start-aligned
      // column).
      final align = tester.widget<Align>(
        find
            .ancestor(
              of: find.byKey(_shareNativeKey),
              matching: find.byType(Align),
            )
            .first,
      );
      expect(align.alignment, Alignment.centerRight);

      // Share precedes Copy in the tree order.
      final share = tester.getTopLeft(find.byKey(_shareNativeKey));
      final copy = tester.getTopLeft(find.byKey(_copyNativeKey));
      expect(share.dx, lessThan(copy.dx));
    });

    testWidgets('action buttons wrap instead of overflowing when narrow', (
      tester,
    ) async {
      // A width too narrow for Share + Copy side by side would overflow a Row;
      // the Wrap must reflow them and raise no layout exception.
      tester.view.physicalSize = const Size(200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpScreen(tester);

      expect(tester.takeException(), isNull);
      expect(find.byKey(_shareNativeKey), findsOneWidget);
      expect(find.byKey(_copyNativeKey), findsOneWidget);
    });

    testWidgets('the confirmation dialog is capped to 580 with filled actions', (
      tester,
    ) async {
      await pumpScreen(tester);
      await tester.tap(find.byKey(_copyNativeKey));
      await tester.pumpAndSettle();

      // The shell is capped via AlertDialog.constraints (a no-op on mobile
      // width; the cap is what desktop needs).
      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.constraints, const BoxConstraints(maxWidth: 580));

      // Cancel and Copy are filled (legible against blumine), not bare
      // TextButtons that would render navy-on-navy.
      expect(find.widgetWithText(FilledButton, 'Cancel'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byKey(_cancelKey)),
        isA<FilledButton>(),
      );
      expect(
        tester.widget<FilledButton>(find.byKey(_confirmKey)),
        isA<FilledButton>(),
      );
    });

    testWidgets('the confirmation dialog actions do not overflow when narrow', (
      tester,
    ) async {
      // Material stacks the two `actions` in an OverflowBar on a narrow width,
      // so two filled buttons reflow rather than overflowing horizontally.
      tester.view.physicalSize = const Size(300, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpScreen(tester);
      await tester.tap(find.byKey(_copyNativeKey));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(_confirmKey), findsOneWidget);
      expect(find.byKey(_cancelKey), findsOneWidget);
    });

    testWidgets('the body fills the viewport so the background reaches the bottom', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpScreen(tester);

      // The SideSwap gradient is painted over the CustomPaint's box, which
      // sizes to the scroll body. When the (now QR-less, short) content lets the
      // body shrink to it, the gradient stops just below the Nested-segwit
      // actions and the bare Scaffold shows through to the bottom edge. The body
      // must fill the viewport so the gradient reaches the bottom of the screen.
      final background = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is BackgroundPainter,
      );
      expect(background, findsOneWidget);
      expect(tester.getSize(background).height, 800);
    });

    testWidgets('descriptor previews render left-to-right under an RTL locale', (
      tester,
    ) async {
      await pumpScreen(tester, textDirection: TextDirection.rtl);

      // The preview overrides the ambient RTL to keep descriptor syntax intact.
      final previewContext = tester.element(find.text(_nativeDescriptor));
      expect(Directionality.of(previewContext), TextDirection.ltr);

      // Sanity: an unwrapped node still resolves RTL, proving the ambient took
      // effect and the ltr assertion above is not trivially true.
      final warningContext = tester.element(
        find.textContaining('Anyone with these descriptors'),
      );
      expect(Directionality.of(warningContext), TextDirection.rtl);
    });
  });
}
