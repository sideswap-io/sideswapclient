import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/wallet_descriptors.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';

import '../utils.dart';

void main() {
  const populated = WalletDescriptors(
    nativeSegwit: 'native',
    nestedSegwit: 'nested',
  );

  group('WalletDescriptorsNotifier', () {
    test('is null before any descriptors are set', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<WalletDescriptors?>();

      container.listen<WalletDescriptors?>(
        walletDescriptorsProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, null)]);
      verifyNoMoreInteractions(listener);
      expect(container.read(walletDescriptorsProvider), isNull);
    });

    test('holds both descriptors when both strings are non-empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<WalletDescriptors?>();
      container.listen<WalletDescriptors?>(
        walletDescriptorsProvider,
        listener.call,
        fireImmediately: true,
      );

      container
          .read(walletDescriptorsProvider.notifier)
          .setDescriptors('native', 'nested');

      verifyInOrder([
        () => listener(null, null),
        () => listener(null, populated),
      ]);
      verifyNoMoreInteractions(listener);
      expect(container.read(walletDescriptorsProvider), populated);
    });

    test('stays null when the nested descriptor is empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container
          .read(walletDescriptorsProvider.notifier)
          .setDescriptors('native', '');

      expect(container.read(walletDescriptorsProvider), isNull);
    });

    test('stays null when the native descriptor is empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container
          .read(walletDescriptorsProvider.notifier)
          .setDescriptors('', 'nested');

      expect(container.read(walletDescriptorsProvider), isNull);
    });

    test('clears a previously held value when a later payload is invalid', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<WalletDescriptors?>();
      container.listen<WalletDescriptors?>(
        walletDescriptorsProvider,
        listener.call,
        fireImmediately: true,
      );
      final notifier = container.read(walletDescriptorsProvider.notifier);

      notifier.setDescriptors('native', 'nested');
      notifier.setDescriptors('native', '');

      verifyInOrder([
        () => listener(null, null),
        () => listener(null, populated),
        () => listener(populated, null),
      ]);
      verifyNoMoreInteractions(listener);
      expect(container.read(walletDescriptorsProvider), isNull);
    });

    test('returns to null when invalidated', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(walletDescriptorsProvider.notifier);
      notifier.setDescriptors('native', 'nested');
      expect(container.read(walletDescriptorsProvider), isNotNull);

      container.invalidate(walletDescriptorsProvider);

      expect(container.read(walletDescriptorsProvider), isNull);
    });
  });
}
