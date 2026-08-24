import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../utils.dart';

// Suppress logging to prevent async errors from path_provider
class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Suppress all logging
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Suppress logging to prevent async errors from path_provider
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });
  group('PageStatusNotifier', () {
    group('build', () {
      test('initializes state to Status.walletLoading', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(pageStatusProvider), Status.walletLoading);
      });

      test('notifier survives due to keepAlive: true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        // Read the notifier twice - it should be the same instance
        final notifier1 = container.read(pageStatusProvider.notifier);
        final notifier2 = container.read(pageStatusProvider.notifier);
        expect(identical(notifier1, notifier2), true);
      });

      test('listener receives initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Status>();
        container.listen(pageStatusProvider, listener.call, fireImmediately: true);

        // Initial state should be logged: listener(null, walletLoading)
        verifyInOrder([() => listener(null, Status.walletLoading)]);
        verifyNoMoreInteractions(listener);
      });
    });

    group('setStatus', () {
      test('updates state to provided status', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(pageStatusProvider.notifier);
        notifier.setStatus(Status.registered);

        expect(container.read(pageStatusProvider), Status.registered);
      });

      test('notifies listeners with previous and next status', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Status>();
        container.listen(pageStatusProvider, listener.call, fireImmediately: true);

        // Clear the initial call
        clearInteractions(listener);

        final notifier = container.read(pageStatusProvider.notifier);
        notifier.setStatus(Status.reviewLicense);

        verifyInOrder([() => listener(Status.walletLoading, Status.reviewLicense)]);
        verifyNoMoreInteractions(listener);
      });

      test('handles multiple sequential state changes', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Status>();
        container.listen(pageStatusProvider, listener.call, fireImmediately: true);
        clearInteractions(listener);

        final notifier = container.read(pageStatusProvider.notifier);

        notifier.setStatus(Status.noWallet);
        notifier.setStatus(Status.selectEnv);
        notifier.setStatus(Status.lockedWalet);

        verifyInOrder([
          () => listener(Status.walletLoading, Status.noWallet),
          () => listener(Status.noWallet, Status.selectEnv),
          () => listener(Status.selectEnv, Status.lockedWalet),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('can transition to any Status enum value', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(pageStatusProvider.notifier);

        // Test transitions to various status values
        final testStatuses = [
          Status.networkAccessOnboarding,
          Status.pinSetup,
          Status.transactions,
          Status.assetDetails,
          Status.swapTxDetails,
          Status.settingsPage,
          Status.paymentPage,
          Status.marketSwap,
        ];

        for (final status in testStatuses) {
          notifier.setStatus(status);
          expect(container.read(pageStatusProvider), status);
        }
      });

      test('listener is called for every actual state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Status>();
        container.listen(pageStatusProvider, listener.call, fireImmediately: true);
        clearInteractions(listener);

        final notifier = container.read(pageStatusProvider.notifier);

        // Multiple state changes
        notifier.setStatus(Status.transactions);
        notifier.setStatus(Status.settingsPage);
        notifier.setStatus(Status.assetDetails);

        verifyInOrder([
          () => listener.call(Status.walletLoading, Status.transactions),
          () => listener.call(Status.transactions, Status.settingsPage),
          () => listener.call(Status.settingsPage, Status.assetDetails),
        ]);
        verifyNoMoreInteractions(listener);
      });
    });

    group('Status enum', () {
      test('contains all expected wallet flow statuses', () {
        expect(Status.values, contains(Status.walletLoading));
        expect(Status.values, contains(Status.noWallet));
        expect(Status.values, contains(Status.pinSetup));
        expect(Status.values, contains(Status.transactions));
      });

      test('contains all expected transaction statuses', () {
        expect(Status.values, contains(Status.assetReceive));
        expect(Status.values, contains(Status.swapWaitPegTx));
        expect(Status.values, contains(Status.txDetails));
      });

      test('contains all expected settings statuses', () {
        expect(Status.values, contains(Status.settingsPage));
        expect(Status.values, contains(Status.settingsSecurity));
        expect(Status.values, contains(Status.settingsCurrency));
      });
    });
  });
}
