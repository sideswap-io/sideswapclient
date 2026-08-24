import 'dart:io' show Platform;

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/settings/d_wallet_descriptors.dart';
import 'package:sideswap/models/wallet_descriptors.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';

class _FakeWalletDescriptorsNotifier extends WalletDescriptorsNotifier {
  _FakeWalletDescriptorsNotifier(this._value);

  final WalletDescriptors? _value;

  @override
  WalletDescriptors? build() => _value;
}

class _MockWallet extends Mock implements SideswapWallet {}

/// Forces the focus gate off, standing in for a blurred window (the real
/// `WindowListener` 'blur' event cannot be fired under the test binding).
class _CopyDisabled extends DescriptorCopyEnabled {
  @override
  bool build() => false;
}

const _nativeDescriptor = 'ct(slip77(aa),elwpkh(native/*))';
const _nestedDescriptor = 'ct(slip77(bb),elsh(wpkh(nested/*)))';

const _copyNativeKey = Key('copy_native_segwit_descriptor');
const _copyNestedKey = Key('copy_nested_segwit_descriptor');
const _confirmKey = Key('descriptor_copy_confirm');
const _cancelKey = Key('descriptor_copy_cancel');

void main() {
  // Captures the exact text handed to Clipboard.setData so tests can assert the
  // full descriptor is copied -- and that a gated-off copy writes nothing.
  final clipboardWrites = <String>[];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Back the platform clipboard channel so copyToClipboard's Clipboard write
    // resolves without a missing-plugin error, and record what it writes.
    TestDefaultBinaryMessengerBinding
        .instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboardWrites.add((call.arguments as Map)['text'] as String);
          }
          return null;
        });
  });

  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random seed.
  setUp(() {
    clipboardWrites.clear();
    Localization.load(const Locale('en'));
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // The desktop theme resolves through throwaway ProviderContainers that leave
  // dispose timers on riverpod's scheduler; those never settle under the test
  // binding's fake async, so every pump/tap/key event runs inside `runAsync`.
  Future<void> pumpDialog(
    WidgetTester tester, {
    required WalletDescriptors? descriptors,
    bool copyEnabled = true,
    SideswapWallet? wallet,
    TextDirection textDirection = TextDirection.ltr,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          walletDescriptorsProvider.overrideWith(
            () => _FakeWalletDescriptorsNotifier(descriptors),
          ),
          if (!copyEnabled)
            descriptorCopyEnabledProvider.overrideWith(_CopyDisabled.new),
          if (wallet != null) walletProvider.overrideWithValue(wallet),
        ],
        child: MaterialApp(
          // NoSplash avoids Material's InkSparkle fragment shader, whose asset
          // is unavailable under `--no-test-assets` (tools/coverage.dart) when the
          // dialog's filled actions are tapped; the ripple is not under test.
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Directionality(
            textDirection: textDirection,
            child: const Scaffold(body: DWalletDescriptors()),
          ),
        ),
      ),
    );
  });

  group('DWalletDescriptors', () {
    testWidgets('shows the warning and both descriptor sections', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      expect(find.text('Wallet descriptors'), findsOneWidget);
      expect(
        find.textContaining('Anyone with these descriptors'),
        findsOneWidget,
      );
      expect(find.text('Native segwit'), findsOneWidget);
      expect(find.text('Nested segwit'), findsOneWidget);
      // The previews middle-ellipsise inside the narrow (500px) desktop dialog,
      // so assert the two preview widgets rather than the painted glyphs (which
      // are truncated at this width). Their full-string payload is covered by
      // the dedicated preview test below.
      expect(find.byType(MiddleEllipsisText), findsNWidgets(2));
    });

    testWidgets('omits the sections when descriptors are absent', (
      tester,
    ) async {
      await pumpDialog(tester, descriptors: null);

      expect(
        find.textContaining('Anyone with these descriptors'),
        findsOneWidget,
      );
      expect(find.text('Native segwit'), findsNothing);
      expect(find.text(_nativeDescriptor), findsNothing);
    });

    testWidgets('renders no QR widget and previews the full string', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      // The QR widgets and their keys are gone -- the desktop workflow is
      // copy/paste into LWK-style software, not a camera scan.
      expect(find.byKey(const Key('qr_native_segwit_descriptor')), findsNothing);
      expect(find.byKey(const Key('qr_nested_segwit_descriptor')), findsNothing);

      // Each preview is a MiddleEllipsisText carrying the exact descriptor --
      // the property, not the painted glyphs, is the full-string guarantee.
      final previews = tester
          .widgetList<MiddleEllipsisText>(find.byType(MiddleEllipsisText))
          .map((w) => w.text)
          .toList();
      expect(previews, containsAll([_nativeDescriptor, _nestedDescriptor]));
    });

    testWidgets('the Copy button is right-aligned via a Row(end) wrapper', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      // The button's nearest Row ancestor hands it unbounded width and pins it
      // right -- the copy-mnemonic layout that stops the stretch.
      final row = tester.widget<Row>(
        find
            .ancestor(
              of: find.byKey(_copyNativeKey),
              matching: find.byType(Row),
            )
            .first,
      );
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('descriptor previews render left-to-right under an RTL locale', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
        textDirection: TextDirection.rtl,
      );

      // The preview overrides the ambient RTL to keep descriptor syntax intact.
      // Look it up by the preview widget, not painted text (which truncates at
      // the desktop dialog width).
      final previewContext = tester.element(
        find.byType(MiddleEllipsisText).first,
      );
      expect(Directionality.of(previewContext), TextDirection.ltr);

      // Sanity: an unwrapped node still resolves RTL, proving the ambient took
      // effect and the ltr assertion above is not trivially true.
      final warningContext = tester.element(
        find.textContaining('Anyone with these descriptors'),
      );
      expect(Directionality.of(warningContext), TextDirection.rtl);
    });

    testWidgets('the first copy of a visit prompts a confirmation dialog', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      expect(find.byKey(_confirmKey), findsNothing);

      await tester.runAsync(() async {
        await tester.tap(find.byKey(_copyNativeKey));
        await tester.pumpAndSettle();
      });

      expect(
        find.textContaining('copied to your system clipboard'),
        findsOneWidget,
      );
      expect(find.byKey(_confirmKey), findsOneWidget);

      // Cancelling dismisses the dialog and copies nothing.
      await tester.runAsync(() async {
        await tester.tap(find.byKey(_cancelKey));
        await tester.pumpAndSettle();
      });

      expect(find.byKey(_confirmKey), findsNothing);
    });

    testWidgets('a later copy in the same visit does not re-prompt', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      // First copy: acknowledge the dialog.
      await tester.runAsync(() async {
        await tester.tap(find.byKey(_copyNativeKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_confirmKey));
        await tester.pumpAndSettle();
      });

      expect(find.byKey(_confirmKey), findsNothing);

      // Second copy on the other section: no dialog this time.
      await tester.runAsync(() async {
        await tester.ensureVisible(find.byKey(_copyNestedKey));
        await tester.tap(find.byKey(_copyNestedKey));
        await tester.pumpAndSettle();
      });

      expect(find.byKey(_confirmKey), findsNothing);
    });

    testWidgets('confirming the first copy writes the full descriptor', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      await tester.runAsync(() async {
        await tester.tap(find.byKey(_copyNativeKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_confirmKey));
        await tester.pumpAndSettle();
      });

      // The whole descriptor reaches the clipboard, not a truncated preview.
      expect(clipboardWrites, [_nativeDescriptor]);
    });

    testWidgets(
      'a blur while the confirmation is open aborts the copy',
      (tester) async {
        await pumpDialog(
          tester,
          descriptors: const WalletDescriptors(
            nativeSegwit: _nativeDescriptor,
            nestedSegwit: _nestedDescriptor,
          ),
        );

        // Focused: open the confirmation dialog.
        await tester.runAsync(() async {
          await tester.tap(find.byKey(_copyNativeKey));
          await tester.pumpAndSettle();
        });
        expect(find.byKey(_confirmKey), findsOneWidget);

        // The window loses focus while the confirmation is still open.
        ProviderScope.containerOf(
          tester.element(find.byType(DWalletDescriptors)),
          listen: false,
        ).read(descriptorCopyEnabledProvider.notifier).setEnabled(false);

        // Accepting now must not reach the clipboard -- the focus re-check
        // across the async gap short-circuits the copy.
        await tester.runAsync(() async {
          await tester.tap(find.byKey(_confirmKey));
          await tester.pumpAndSettle();
        });

        expect(clipboardWrites, isEmpty);
      },
    );

    testWidgets('both Copy buttons are disabled while the window is unfocused', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
        copyEnabled: false,
      );

      expect(
        tester.widget<DButton>(find.byKey(_copyNativeKey)).onPressed,
        isNull,
      );
      expect(
        tester.widget<DButton>(find.byKey(_copyNestedKey)).onPressed,
        isNull,
      );
    });

    testWidgets('the Copy buttons are enabled while the window is focused', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
      );

      expect(
        tester.widget<DButton>(find.byKey(_copyNativeKey)).onPressed,
        isNotNull,
      );
      expect(
        tester.widget<DButton>(find.byKey(_copyNestedKey)).onPressed,
        isNotNull,
      );
    });

    testWidgets(
      'Ctrl+C copies the native descriptor and prompts confirmation when focused',
      (tester) async {
        await pumpDialog(
          tester,
          descriptors: const WalletDescriptors(
            nativeSegwit: _nativeDescriptor,
            nestedSegwit: _nestedDescriptor,
          ),
        );

        expect(find.byKey(_confirmKey), findsNothing);

        await tester.runAsync(() async {
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pumpAndSettle();
        });

        // The shortcut routed through the same confirmation gate as the button.
        expect(find.byKey(_confirmKey), findsOneWidget);
      },
      // The Ctrl+C combo is only registered on the Windows branch of the
      // platform-switched shortcut map; the coverage gate runs on Windows.
      skip: !Platform.isWindows,
    );

    testWidgets('Ctrl+C copies nothing while the window is unfocused', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
        copyEnabled: false,
      );

      await tester.runAsync(() async {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pumpAndSettle();
      });

      // The focus gate short-circuits the shortcut Action: no confirmation, so
      // nothing is copied.
      expect(find.byKey(_confirmKey), findsNothing);
    }, skip: !Platform.isWindows);

    testWidgets('the BACK action returns to the settings dialog', (
      tester,
    ) async {
      final wallet = _MockWallet();
      when(() => wallet.goBack()).thenReturn(true);

      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
        wallet: wallet,
      );

      await tester.runAsync(() async {
        await tester.tap(find.text('BACK'));
        await tester.pump();
      });

      verify(() => wallet.goBack()).called(1);
    });

    testWidgets('the close button returns to the settings dialog', (
      tester,
    ) async {
      final wallet = _MockWallet();
      when(() => wallet.goBack()).thenReturn(true);

      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
        wallet: wallet,
      );

      await tester.runAsync(() async {
        await tester.tap(find.byIcon(Icons.close));
        await tester.pump();
      });

      verify(() => wallet.goBack()).called(1);
    });

    testWidgets('a system back gesture returns to the settings dialog', (
      tester,
    ) async {
      final wallet = _MockWallet();
      when(() => wallet.goBack()).thenReturn(true);

      await pumpDialog(
        tester,
        descriptors: const WalletDescriptors(
          nativeSegwit: _nativeDescriptor,
          nestedSegwit: _nestedDescriptor,
        ),
        wallet: wallet,
      );

      // The PopScope blocks the pop (canPop: false) and routes it to goBack.
      await tester.runAsync(() async {
        await tester.binding.handlePopRoute();
        await tester.pump();
      });

      verify(() => wallet.goBack()).called(1);
    });
  });

  group('descriptorCopyEnabledProvider', () {
    test('defaults to enabled and toggles with the window focus events', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Default matches a focused window on first build.
      expect(container.read(descriptorCopyEnabledProvider), isTrue);

      // 'blur' -> disabled.
      container
          .read(descriptorCopyEnabledProvider.notifier)
          .setEnabled(false);
      expect(container.read(descriptorCopyEnabledProvider), isFalse);

      // 'focus' -> re-enabled.
      container.read(descriptorCopyEnabledProvider.notifier).setEnabled(true);
      expect(container.read(descriptorCopyEnabledProvider), isTrue);
    });
  });
}
