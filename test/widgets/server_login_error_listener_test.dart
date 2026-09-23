// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/listeners/server_login_error_listener.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

class MockDialogPresenter extends Mock implements DialogPresenter {}

class MockBuildContext extends Mock implements BuildContext {}

class MockNavigatorKey extends Mock implements GlobalKey<NavigatorState> {
  MockNavigatorKey(this._context);

  final BuildContext? _context;

  @override
  BuildContext? get currentContext => _context;
}

void main() {
  late MockDialogPresenter presenter;

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    Localization.load(const Locale('en'));
    presenter = MockDialogPresenter();
    when(
      () => presenter.showErrorDialog(any(), any(), buttonText: any(named: 'buttonText')),
    ).thenAnswer((_) async {});
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  Future<ProviderContainer> pumpListener(
    WidgetTester tester, {
    required Status status,
  }) async {
    final container = ProviderContainer.test(
      overrides: [
        navigatorKeyProvider.overrideWithValue(
          MockNavigatorKey(MockBuildContext()),
        ),
        utilsProvider.overrideWith(
          (ref) => UtilsProvider(ref, presenter: presenter),
        ),
      ],
    );
    container.read(pageStatusProvider.notifier).setStatus(status);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ServerLoginErrorListener()),
      ),
    );
    return container;
  }

  group('ServerLoginErrorListener, away from the locked screen', () {
    testWidgets('a failed login still shows the modal and goes to noWallet', (
      tester,
    ) async {
      final container = await pumpListener(tester, status: Status.registered);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();
      await tester.pump();

      verify(
        () => presenter.showErrorDialog(
          any(),
          'bad mnemonic',
          buttonText: any(named: 'buttonText'),
        ),
      ).called(1);
      expect(container.read(pageStatusProvider), Status.noWallet);
      expect(container.read(serverLoginProvider), const ServerLoginStateLogout());
    });

    testWidgets('a null-message failure stays as silent as it is today', (
      tester,
    ) async {
      final container = await pumpListener(tester, status: Status.registered);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error());
      await tester.pump();
      await tester.pump();

      // A pre-existing gap, deliberately left alone: widening the pattern to
      // catch a null message would give this path a modal and a navigation it
      // does not have today.
      verifyNever(
        () => presenter.showErrorDialog(
          any(),
          any(),
          buttonText: any(named: 'buttonText'),
        ),
      );
      expect(container.read(pageStatusProvider), Status.registered);
      expect(container.read(serverLoginProvider), const ServerLoginStateError());
    });

    testWidgets('a successful login is left entirely alone', (tester) async {
      final container = await pumpListener(tester, status: Status.registered);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.login());
      await tester.pump();
      await tester.pump();

      verifyNever(
        () => presenter.showErrorDialog(
          any(),
          any(),
          buttonText: any(named: 'buttonText'),
        ),
      );
      expect(container.read(pageStatusProvider), Status.registered);
      expect(container.read(serverLoginProvider), const ServerLoginStateLogin());
    });
  });

  group('ServerLoginErrorListener, on the locked screen', () {
    testWidgets('a failed login opens no modal and does not navigate', (
      tester,
    ) async {
      final container = await pumpListener(tester, status: Status.lockedWalet);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();
      await tester.pump();

      verifyNever(
        () => presenter.showErrorDialog(
          any(),
          any(),
          buttonText: any(named: 'buttonText'),
        ),
      );
      // The wallet has not gone anywhere; the screen owns the failure.
      expect(container.read(pageStatusProvider), Status.lockedWalet);
    });

    testWidgets('it still invalidates, so first launch is not left dead', (
      tester,
    ) async {
      final container = await pumpListener(tester, status: Status.lockedWalet);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));
      await tester.pump();
      await tester.pump();

      // FirstLaunchPage disables all three of its buttons while an error is
      // held, and the provider is keepAlive: retaining it would be worse than
      // the bug being fixed.
      expect(container.read(serverLoginProvider), const ServerLoginStateLogout());
    });

    testWidgets('a null-message failure is invalidated like any other', (
      tester,
    ) async {
      final container = await pumpListener(tester, status: Status.lockedWalet);

      container
          .read(serverLoginProvider.notifier)
          .setServerLoginState(const ServerLoginState.error());
      await tester.pump();
      await tester.pump();

      verifyNever(
        () => presenter.showErrorDialog(
          any(),
          any(),
          buttonText: any(named: 'buttonText'),
        ),
      );
      expect(container.read(pageStatusProvider), Status.lockedWalet);
      expect(container.read(serverLoginProvider), const ServerLoginStateLogout());
    });
  });
}
