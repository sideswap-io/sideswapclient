import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/pin_setup.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_text_field.dart';

import '../helpers/fake_configuration.dart';

SideswapSettings _settings() =>
    SideswapSettings.empty(mnemonicEncrypted: Uint8List(0));

/// An attempt that is already overdue. The wait itself is proven with a fake
/// clock in `test/providers/pin_setup_provider_test.dart`; here only the
/// rendering of the state is under test.
class _OverdueAttempt extends PinSetupAttempt {
  @override
  PinSetupAttemptState build() =>
      const PinSetupAttemptState.outstanding(overdue: true);
}

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        configurationProvider.overrideWith(() => FakeConfiguration(_settings())),
        ...overrides,
      ],
      // The app bar reads `CustomBackButtonStyle` out of the theme, so the
      // screen needs the app's own extension set.
      child: Consumer(
        builder: (context, ref, _) {
          final theme = ref.watch(mobileAppThemeProvider);

          return MaterialApp(
            theme: ThemeData(extensions: theme.themeExtensions),
            home: const PinSetup(),
          );
        },
      ),
    ),
  );

  return ProviderScope.containerOf(tester.element(find.byType(PinSetup)));
}

List<PinTextField> _fields(WidgetTester tester) =>
    tester.widgetList<PinTextField>(find.byType(PinTextField)).toList();

PinKeyboard _keyboard(WidgetTester tester) =>
    tester.widget<PinKeyboard>(find.byType(PinKeyboard));

void main() {
  setUp(() {
    Localization.load(const Locale('en'));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: true,
        enableJade: false,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

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
  });

  testWidgets('the confirm field opens once the first PIN is long enough', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    await tester.pump();

    expect(_fields(tester).last.enabled, isTrue);
  });

  testWidgets('an outstanding attempt closes both fields and the keyboard', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container.read(pinSetupAttemptProvider.notifier).open();
    await tester.pump();

    final fields = _fields(tester);
    expect(fields.first.enabled, isFalse);
    expect(fields.last.enabled, isFalse);
    expect(_keyboard(tester).enabled, isFalse);

    container.read(pinSetupAttemptProvider.notifier).release();
    await tester.pump();
  });

  testWidgets('an overdue attempt says to restart, and stays closed', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      overrides: [pinSetupAttemptProvider.overrideWith(_OverdueAttempt.new)],
    );

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    await tester.pump();

    expect(find.text(pinSetupTakingLongerKey), findsOneWidget);
    expect(_fields(tester).first.enabled, isFalse);
    expect(_fields(tester).last.enabled, isFalse);
    expect(_keyboard(tester).enabled, isFalse);

    // The message is a recovery instruction, not a failure, so it leaves the
    // field's error box and its border alone -- the same reading the desktop
    // screen takes.
    expect(_fields(tester).last.error, isFalse);
    expect(_fields(tester).last.errorMessage, isEmpty);
  });

  testWidgets('a message opens nothing and closes nothing', (tester) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container.read(secondPinProvider.notifier).setSecondPin('654321');
    container
        .read(pinFieldStateProvider.notifier)
        .setPinFieldState(const PinFieldState.second());
    container
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.error(message: 'wrong'));
    await tester.pump();

    final fields = _fields(tester);
    expect(fields.first.enabled, isTrue);
    expect(fields.last.enabled, isTrue);
    expect(fields.last.error, isTrue);
    expect(_keyboard(tester).enabled, isTrue);
    expect(find.text('wrong'), findsOneWidget);
  });

  testWidgets('the confirm field keeps focus and the caret at the end', (
    tester,
  ) async {
    final container = await _pump(tester);

    container.read(firstPinProvider.notifier).setFirstPin('123456');
    container.read(secondPinProvider.notifier).setSecondPin('654321');
    container
        .read(pinFieldStateProvider.notifier)
        .setPinFieldState(const PinFieldState.second());
    await tester.pump();

    // The busy-to-message transition, which is where desktop loses focus and
    // needs a trigger. Mobile's field never takes `enabled`, so it keeps focus
    // on its own -- asserted here rather than assumed.
    container.read(pinSetupAttemptProvider.notifier).open();
    await tester.pump();
    container.read(pinSetupAttemptProvider.notifier).release();
    container
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.error(message: 'wrong'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField).last);
    expect(field.focusNode?.hasFocus, isTrue);
    expect(field.controller?.selection.isCollapsed, isTrue);
    expect(field.controller?.selection.baseOffset, '654321'.length);
  });
}
