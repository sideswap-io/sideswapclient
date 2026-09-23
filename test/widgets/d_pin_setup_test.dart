import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_pin_setup.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_text_field.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

SideswapSettings _settings() =>
    SideswapSettings.empty(mnemonicEncrypted: Uint8List(0));

/// An attempt that is already overdue. The wait itself is a `Timer`, and it is
/// proven with a fake clock in `test/providers/pin_setup_provider_test.dart`;
/// here only the rendering of the state is under test.
class MockWallet extends Mock implements SideswapWallet {}

class _OverdueAttempt extends PinSetupAttempt {
  @override
  PinSetupAttemptState build() =>
      const PinSetupAttemptState.outstanding(overdue: true);
}

/// The pump runs inside `runAsync`: every key is a `DButton`, and
/// `DButton.defaultStyleOf` leaves zero-duration riverpod dispose timers that
/// never fire under the fake-async binding.
Future<ProviderContainer> _pump(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  late ProviderContainer container;

  await tester.runAsync(() async {
    sizeView(tester, const Size(1200, 1600));

    final scope = ProviderScope(
      overrides: [
        configurationProvider.overrideWith(
          () => FakeConfiguration(_settings()),
        ),
        ...overrides,
      ],
      child: const MaterialApp(home: Scaffold(body: DPinSetupContent())),
    );

    await tester.pumpWidget(scope);
    container = ProviderScope.containerOf(
      tester.element(find.byType(DPinSetupContent)),
    );
  });

  return container;
}

Future<void> _settle(WidgetTester tester) =>
    tester.runAsync(() => tester.pump());

List<DPinTextField> _fields(WidgetTester tester) =>
    tester.widgetList<DPinTextField>(find.byType(DPinTextField)).toList();

DPinKeyboard _keyboard(WidgetTester tester) =>
    tester.widget<DPinKeyboard>(find.byType(DPinKeyboard));

double _reserveHeight(WidgetTester tester) =>
    tester.getSize(find.byKey(dPinSetupMessageReserveKey)).height;

void main() {
  setUp(installSurfaceTestEnv);

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  testWidgets('idle: the first field is open, the confirm field is not', (
    tester,
  ) async {
    await _pump(tester);

    final fields = _fields(tester);
    expect(fields, hasLength(2));
    expect(fields.first.enabled, isTrue);
    expect(fields.last.enabled, isFalse);
    expect(_keyboard(tester).enabled, isTrue);
    expect(find.text("PIN code doesn't match"), findsNothing);
    expect(_reserveHeight(tester), dPinSetupMessageReserveHeight);
  });

  testWidgets('only the first field takes focus when the screen opens', (
    tester,
  ) async {
    await _pump(tester);

    final fields = _fields(tester);
    expect(fields.first.autofocus, isTrue);
    expect(fields.last.autofocus, isFalse);
  });

  testWidgets('the confirm field opens once the first PIN is long enough', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    await _settle(tester);

    expect(_fields(tester).last.enabled, isTrue);
  });

  testWidgets('an outstanding attempt closes both fields and the keyboard', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container.read(pinSetupAttemptProvider.notifier).open();
    await _settle(tester);

    final fields = _fields(tester);
    expect(fields.first.enabled, isFalse);
    expect(fields.last.enabled, isFalse);
    expect(_keyboard(tester).enabled, isFalse);
    expect(_reserveHeight(tester), dPinSetupMessageReserveHeight);

    container.read(pinSetupAttemptProvider.notifier).release();
  });

  testWidgets('an overdue attempt says to restart, and stays closed', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      overrides: [pinSetupAttemptProvider.overrideWith(_OverdueAttempt.new)],
    );

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    await _settle(tester);

    expect(find.text(pinSetupTakingLongerKey), findsOneWidget);
    expect(_fields(tester).first.enabled, isFalse);
    expect(_fields(tester).last.enabled, isFalse);
    expect(_keyboard(tester).enabled, isFalse);
    expect(_reserveHeight(tester), dPinSetupMessageReserveHeight);
  });

  testWidgets('a message opens nothing and closes nothing', (tester) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.error(message: 'wrong'));
    await _settle(tester);

    final fields = _fields(tester);
    expect(fields.first.enabled, isTrue);
    expect(fields.last.enabled, isTrue);
    expect(fields.last.error, isTrue);
    expect(_keyboard(tester).enabled, isTrue);
    expect(find.text('wrong'), findsOneWidget);
    expect(_reserveHeight(tester), dPinSetupMessageReserveHeight);
  });

  testWidgets(
    'the reserve keeps its height whether or not it holds a message',
    (tester) async {
      final container = await _pump(tester);
      final idle = _reserveHeight(tester);

      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));
      await _settle(tester);

      expect(_reserveHeight(tester), idle);
    },
  );

  testWidgets('the confirm field keeps its height when a message appears', (
    tester,
  ) async {
    final container = await _pump(tester);
    final idle = tester.getSize(find.byType(DPinTextField).last);

    container
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.error(message: 'wrong'));
    await _settle(tester);

    expect(tester.getSize(find.byType(DPinTextField).last), idle);
  });

  testWidgets('the reserve holds the message it is given, unclipped', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      overrides: [pinSetupAttemptProvider.overrideWith(_OverdueAttempt.new)],
    );

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    await _settle(tester);

    // The tallest message the box can be asked to hold, laid out inside it.
    final message = tester.getSize(find.text(pinSetupTakingLongerKey));

    expect(
      message.height + dPinSetupMessageGap,
      lessThanOrEqualTo(dPinSetupMessageReserveHeight),
    );
    expect(message.width, lessThanOrEqualTo(dPinSetupFieldWidth));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a second failure returns focus to the confirm field too', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container.read(secondPinProvider.notifier).setSecondPin('123456');
    container
        .read(pinFieldStateProvider.notifier)
        .setPinFieldState(const PinFieldState.second());

    for (var attempt = 0; attempt < 2; attempt++) {
      // Opening the attempt closes the field, which drops its focus; the
      // failure re-opens it and the message must bring the focus back. The
      // second round is the one a stale message would break.
      container.read(pinSetupAttemptProvider.notifier).open();
      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.idle());
      await _settle(tester);

      container.read(pinSetupAttemptProvider.notifier).release();
      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));
      await _settle(tester);
      await _settle(tester);

      expect(
        tester
            .widget<TextField>(find.byType(TextField).last)
            .focusNode
            ?.hasFocus,
        isTrue,
        reason: 'focus lost on attempt ${attempt + 1}',
      );
    }
  });

  testWidgets('a message after an attempt returns focus to the confirm field', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container.read(secondPinProvider.notifier).setSecondPin('123456');
    container
        .read(pinFieldStateProvider.notifier)
        .setPinFieldState(const PinFieldState.second());
    container.read(pinSetupAttemptProvider.notifier).open();
    await _settle(tester);

    // The server answers with a failure: the attempt goes back and the message
    // appears. The field was disabled a frame ago, so the focus request has to
    // wait for the rebuild that re-enables it.
    container.read(pinSetupAttemptProvider.notifier).release();
    container
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.error(message: 'wrong'));
    await _settle(tester);
    await _settle(tester);

    final field = tester.widget<TextField>(find.byType(TextField).last);
    expect(field.focusNode?.hasFocus, isTrue);
    expect(field.controller?.selection.isCollapsed, isTrue);
    expect(field.controller?.selection.baseOffset, '123456'.length);
  });

  // ADR-0014 decisions 8 and 9: the dialog is 645px tall, above the 620px
  // supported floor, so its body scrolls and BACK stays pinned.
  group('ADR-0014 window floor', () {
    /// The dialog's own scroll owner, not "the one `Scrollable` in the tree" --
    /// the PIN keyboard brings none, but the finder is scoped anyway.
    final ownScrollView = find.descendant(
      of: find.byType(DContentDialog),
      matching: find.byType(SingleChildScrollView),
    );
    // The PIN keyboard's keys are `DCustomTextBigButton`s too, so the pinned
    // action is named by its label.
    final backButton = find.widgetWithText(DCustomTextBigButton, 'BACK');

    late MockWallet wallet;

    setUp(() {
      wallet = MockWallet();
      when(() => wallet.settingsViewPage()).thenReturn(null);
    });

    /// Mounts the whole `DPinSetup`, not just its content: the dialog wrapper
    /// is what owns the scrolling, and the default `FirstLaunchStateTypeEmpty`
    /// is what selects the dialog branch over the scaffold one.
    Future<void> pumpDialog(WidgetTester tester, Size view) =>
        tester.runAsync(() async {
          sizeView(tester, view);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                configurationProvider.overrideWith(
                  () => FakeConfiguration(_settings()),
                ),
                walletProvider.overrideWithValue(wallet),
              ],
              child: MaterialApp(
                // `--no-test-assets` has no ink shader.
                theme: ThemeData(splashFactory: NoSplash.splashFactory),
                home: const Scaffold(body: DPinSetup()),
              ),
            ),
          );
        });

    testWidgets('at the design height the body is unscrolled and BACK sits '
        'outside the scroll region', (tester) async {
      final errors = captureOverflow();

      await pumpDialog(tester, designHeight);

      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(of: ownScrollView, matching: backButton),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor the body scrolls the shortfall, nothing '
        'overflows and BACK stays live', (tester) async {
      final errors = captureOverflow();

      await pumpDialog(tester, floor);

      // The surface really is taller than the floor, which is what keeps the
      // no-overflow assertion below from passing vacuously.
      expect(extentOf(tester, ownScrollView), greaterThan(0));
      expect(verticalOverflows(errors), isEmpty);
      expect(backButton.hitTestable(), findsOneWidget);
      await tapAndDrain(tester, backButton);
      verify(() => wallet.settingsViewPage()).called(1);
    });
  });
}
