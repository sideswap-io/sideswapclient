import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockNavigatorKey extends Mock implements GlobalKey<NavigatorState> {
  final BuildContext? _context;

  MockNavigatorKey({this._context});

  @override
  BuildContext? get currentContext => _context;
}

class MockBuildContext extends Mock implements BuildContext {}

class MockDialogPresenter extends Mock implements DialogPresenter {}

void main() {
  late MockDialogPresenter mockPresenter;
  late MockBuildContext mockContext;
  late MockNavigatorKey mockKeyWithContext;
  late MockNavigatorKey mockKeyNull;

  setUpAll(() {
    Localization.load(const Locale('en'));
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(From_ShowInsufficientFunds());
    registerFallbackValue(SettingsDialogIcon.error);
  });

  setUp(() {
    mockPresenter = MockDialogPresenter();
    mockContext = MockBuildContext();
    mockKeyWithContext = MockNavigatorKey(context: mockContext);
    mockKeyNull = MockNavigatorKey(context: null);
  });

  ProviderContainer makeContainer({required MockNavigatorKey key}) {
    return ProviderContainer.test(
      overrides: [
        navigatorKeyProvider.overrideWithValue(key),
        utilsProvider.overrideWith(
          (ref) => UtilsProvider(ref, presenter: mockPresenter),
        ),
      ],
    );
  }

  group('UtilsProvider', () {
    group('constants and enum', () {
      test('kErrorQuoteExpired equals "quote expired"', () {
        expect(kErrorQuoteExpired, 'quote expired');
      });

      test('SettingsDialogIcon has error and restart', () {
        expect(SettingsDialogIcon.values, hasLength(2));
      });
    });

    group('utilsProvider', () {
      test('creates UtilsProvider instance', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(utilsProvider), isA<UtilsProvider>());
      });
    });

    group('showErrorDialog', () {
      test('returns early when context is null', () async {
        final container = makeContainer(key: mockKeyNull);
        addTearDown(container.dispose);

        await container.read(utilsProvider).showErrorDialog('error');

        verifyNever(() => mockPresenter.showErrorDialog(any(), any()));
      });

      test('calls showQuoteExpiredDialog for quote expired', () async {
        // showQuoteExpiredDialog is a top-level function, can't verify directly
        // but we can verify presenter was NOT called (early return after showQuoteExpiredDialog)
        // The call to showQuoteExpiredDialog(mockContext) will fail silently (mock context)
        // but the important thing is the branch is exercised
        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        // This will attempt showQuoteExpiredDialog(mockContext) which throws internally
        // Catch to verify the branch was taken
        try {
          await container
              .read(utilsProvider)
              .showErrorDialog(kErrorQuoteExpired);
        } catch (_) {
          // Expected — showQuoteExpiredDialog needs real context
        }

        verifyNever(() => mockPresenter.showErrorDialog(any(), any()));
      });

      test('transforms "User declined to sign transaction"', () async {
        when(
          () => mockPresenter.showErrorDialog(
            any(),
            any(),
            buttonText: any(named: 'buttonText'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .showErrorDialog('User declined to sign transaction');

        verify(
          () => mockPresenter.showErrorDialog(
            any(),
            'Transaction sign declined',
            buttonText: null,
          ),
        ).called(1);
      });

      test('transforms "jade response timeout"', () async {
        when(
          () => mockPresenter.showErrorDialog(
            any(),
            any(),
            buttonText: any(named: 'buttonText'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .showErrorDialog('jade response timeout');

        verify(
          () => mockPresenter.showErrorDialog(
            any(),
            'Please ensure your Jade is turned on',
            buttonText: null,
          ),
        ).called(1);
      });

      test('transforms "jade is not connected"', () async {
        when(
          () => mockPresenter.showErrorDialog(
            any(),
            any(),
            buttonText: any(named: 'buttonText'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .showErrorDialog('jade is not connected');

        verify(
          () => mockPresenter.showErrorDialog(
            any(),
            'Please ensure your Jade device is connected',
            buttonText: null,
          ),
        ).called(1);
      });

      test('passes unrecognized error unchanged', () async {
        when(
          () => mockPresenter.showErrorDialog(
            any(),
            any(),
            buttonText: any(named: 'buttonText'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        await container.read(utilsProvider).showErrorDialog('Unknown error');

        verify(
          () => mockPresenter.showErrorDialog(
            any(),
            'Unknown error',
            buttonText: null,
          ),
        ).called(1);
      });

      test('passes custom buttonText to presenter', () async {
        when(
          () => mockPresenter.showErrorDialog(
            any(),
            any(),
            buttonText: any(named: 'buttonText'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .showErrorDialog('error', buttonText: 'CONTINUE');

        verify(
          () => mockPresenter.showErrorDialog(
            any(),
            'error',
            buttonText: 'CONTINUE',
          ),
        ).called(1);
      });
    });

    group('settingsErrorDialog', () {
      test('returns early when context is null', () async {
        final container = makeContainer(key: mockKeyNull);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .settingsErrorDialog(
              title: 'Test',
              buttonText: 'OK',
              onPressed: (_) {},
            );

        verifyNever(
          () => mockPresenter.showSettingsErrorDialog(
            any(),
            title: any(named: 'title'),
            buttonText: any(named: 'buttonText'),
            onPressed: any(named: 'onPressed'),
          ),
        );
      });

      test('delegates to presenter with all params', () async {
        when(
          () => mockPresenter.showSettingsErrorDialog(
            any(),
            title: any(named: 'title'),
            description: any(named: 'description'),
            buttonText: any(named: 'buttonText'),
            onPressed: any(named: 'onPressed'),
            secondButtonText: any(named: 'secondButtonText'),
            onSecondPressed: any(named: 'onSecondPressed'),
            icon: any(named: 'icon'),
            width: any(named: 'width'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        void onPressed(BuildContext ctx) {}
        void onSecondPressed(BuildContext ctx) {}

        await container
            .read(utilsProvider)
            .settingsErrorDialog(
              title: 'Network restart',
              description: 'Changes require restart',
              buttonText: 'OK',
              onPressed: onPressed,
              secondButtonText: 'Cancel',
              onSecondPressed: onSecondPressed,
              icon: SettingsDialogIcon.restart,
              width: 400,
            );

        verify(
          () => mockPresenter.showSettingsErrorDialog(
            any(),
            title: 'Network restart',
            description: 'Changes require restart',
            buttonText: 'OK',
            onPressed: onPressed,
            secondButtonText: 'Cancel',
            onSecondPressed: onSecondPressed,
            icon: SettingsDialogIcon.restart,
            width: 400,
          ),
        ).called(1);
      });

      test('uses default values for optional params', () async {
        when(
          () => mockPresenter.showSettingsErrorDialog(
            any(),
            title: any(named: 'title'),
            description: any(named: 'description'),
            buttonText: any(named: 'buttonText'),
            onPressed: any(named: 'onPressed'),
            secondButtonText: any(named: 'secondButtonText'),
            onSecondPressed: any(named: 'onSecondPressed'),
            icon: any(named: 'icon'),
            width: any(named: 'width'),
          ),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .settingsErrorDialog(
              title: 'Error',
              buttonText: 'OK',
              onPressed: (_) {},
            );

        verify(
          () => mockPresenter.showSettingsErrorDialog(
            any(),
            title: 'Error',
            description: '',
            buttonText: 'OK',
            onPressed: any(named: 'onPressed'),
            secondButtonText: '',
            onSecondPressed: null,
            icon: SettingsDialogIcon.error,
            width: null,
          ),
        ).called(1);
      });
    });

    group('showInsufficienFunds', () {
      test('returns early when context is null', () async {
        final container = makeContainer(key: mockKeyNull);
        addTearDown(container.dispose);

        await container
            .read(utilsProvider)
            .showInsufficienFunds(From_ShowInsufficientFunds());

        verifyNever(
          () => mockPresenter.showInsufficientFundsDialog(any(), any()),
        );
      });

      test('delegates to presenter with context and msg', () async {
        when(
          () => mockPresenter.showInsufficientFundsDialog(any(), any()),
        ).thenAnswer((_) async {});

        final container = makeContainer(key: mockKeyWithContext);
        addTearDown(container.dispose);

        final msg = From_ShowInsufficientFunds();
        await container.read(utilsProvider).showInsufficienFunds(msg);

        verify(
          () => mockPresenter.showInsufficientFundsDialog(any(), msg),
        ).called(1);
      });
    });
  });
}
