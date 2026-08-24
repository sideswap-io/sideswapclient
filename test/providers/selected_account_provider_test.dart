import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap/providers/selected_account_provider.dart';

import '../utils.dart';

void main() {
  group('SelectedAccountTypeNotifier', () {
    group('build', () {
      test('returns REG as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(selectedAccountTypeProvider), Account.REG);
      });
    });

    group('setAccountType', () {
      test('changes state to AMP_ when called', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(selectedAccountTypeProvider.notifier)
            .setAccountType(Account.AMP_);

        expect(
          container.read(selectedAccountTypeProvider),
          Account.AMP_,
        );
      });

      test('changes state back to REG when called again', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(selectedAccountTypeProvider.notifier)
            .setAccountType(Account.AMP_);

        container
            .read(selectedAccountTypeProvider.notifier)
            .setAccountType(Account.REG);

        expect(
          container.read(selectedAccountTypeProvider),
          Account.REG,
        );
      });

      test('notifies listener when state changes', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Account>();
        container.listen(
          selectedAccountTypeProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([
          () => listener(null, Account.REG),
        ]);
        verifyNoMoreInteractions(listener);

        container
            .read(selectedAccountTypeProvider.notifier)
            .setAccountType(Account.AMP_);

        verifyInOrder([
          () => listener(Account.REG, Account.AMP_),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('notifies listener multiple times on sequential state changes', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Account>();
        container.listen(
          selectedAccountTypeProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([
          () => listener(null, Account.REG),
        ]);

        container
            .read(selectedAccountTypeProvider.notifier)
            .setAccountType(Account.AMP_);

        verifyInOrder([
          () => listener(Account.REG, Account.AMP_),
        ]);

        container
            .read(selectedAccountTypeProvider.notifier)
            .setAccountType(Account.REG);

        verifyInOrder([
          () => listener(Account.AMP_, Account.REG),
        ]);

        verifyNoMoreInteractions(listener);
      });

    });
  });
}
