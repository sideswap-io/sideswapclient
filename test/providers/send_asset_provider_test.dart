import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../utils.dart';

void main() {
  group('SendAssetIdNotifier', () {
    group('build', () {
      test('returns liquidAssetId on initialization', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(sendAssetIdProvider),
          'liquid-asset-id',
        );
      });

      test('returns empty string when liquidAssetId is empty', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue(''),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(sendAssetIdProvider),
          '',
        );
      });

      test('sets up listener to eiCreateTransactionProvider', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        // Initial state is btc (liquidAssetId)
        verifyInOrder([() => listener(null, 'btc')]);
        verifyNoMoreInteractions(listener);

        // Trigger eiCreateTransactionProvider update with valid balance
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'eth',
              address: '0x123',
              amount: '100',
            ));

        verifyInOrder([() => listener('btc', 'eth')]);
        verifyNoMoreInteractions(listener);
      });

      test('listener does not trigger on initial non-data provider value', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        // Should only fire once on initialization
        verifyInOrder([() => listener(null, 'btc')]);
        verifyNoMoreInteractions(listener);
      });
    });

    group('setSendAsset', () {
      test('updates state to assetId when balance is non-zero', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(sendAssetIdProvider.notifier);
        notifier.setSendAsset('eth');

        expect(container.read(sendAssetIdProvider), 'eth');
      });

      test('falls back to liquidAssetId when balance is zero', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 0,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');

        expect(container.read(sendAssetIdProvider), 'btc');
      });

      test('falls back to liquidAssetId when asset has no balance entry', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(sendAssetIdProvider.notifier)
            .setSendAsset('non-existent');

        expect(container.read(sendAssetIdProvider), 'btc');
      });

      test('sets state correctly for multiple assets with varying balances',
          () {
        final cases = [
          (assetId: 'eth', balance: 1000, expected: 'eth'),
          (assetId: 'usdt', balance: 0, expected: 'btc'),
          (assetId: 'xau', balance: 5000, expected: 'xau'),
          (assetId: 'missing', balance: 0 as int?, expected: 'btc'),
        ];

        for (final c in cases) {
          final balances = <String, int>{'btc': 2000};
          if (c.balance != null) {
            balances[c.assetId] = c.balance!;
          }

          final container = ProviderContainer.test(
            overrides: [
              liquidAssetIdStateProvider.overrideWithValue('btc'),
              assetBalanceProvider.overrideWithValue(balances),
            ],
          );
          addTearDown(container.dispose);

          container
              .read(sendAssetIdProvider.notifier)
              .setSendAsset(c.assetId);

          expect(
            container.read(sendAssetIdProvider),
            c.expected,
            reason: 'Failed for assetId: ${c.assetId}, balance: ${c.balance}',
          );
        }
      });

      test('listener receives correct state changes from setSendAsset', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'usdt': 0,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        // Initial state
        verifyInOrder([() => listener(null, 'btc')]);
        verifyNoMoreInteractions(listener);

        // Set to eth (has balance)
        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');
        verifyInOrder([() => listener('btc', 'eth')]);
        verifyNoMoreInteractions(listener);

        // Set to usdt (zero balance, should fall back to btc)
        container.read(sendAssetIdProvider.notifier).setSendAsset('usdt');
        verifyInOrder([() => listener('eth', 'btc')]);
        verifyNoMoreInteractions(listener);
      });

      test('does not change state when setting to same asset', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        // Set to eth first
        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');
        verifyInOrder([
          () => listener(null, 'btc'),
          () => listener('btc', 'eth'),
        ]);

        // Set to eth again - should not trigger listener again
        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');
        verifyNoMoreInteractions(listener);
      });
    });

    group('listener integration', () {
      test('listener responds to eiCreateTransactionProvider changes', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 5000,
              'usdt': 3000,
              'btc': 1000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 'btc')]);

        // Send transaction data triggers setSendAsset internally
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'eth',
              address: '0xabc',
              amount: '50',
            ));

        verifyInOrder([() => listener('btc', 'eth')]);
        verifyNoMoreInteractions(listener);
      });

      test('listener ignores non-data eiCreateTransactionProvider updates', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 'btc')]);

        // Set to data state first
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'eth',
              address: '0x123',
              amount: '100',
            ));

        verifyInOrder([() => listener('btc', 'eth')]);
        verifyNoMoreInteractions(listener);

        // Set back to empty - should not trigger setSendAsset
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionEmpty());

        verifyNoMoreInteractions(listener);
      });

      test(
          'listener responds with fallback when transaction data has zero balance',
          () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'xau': 0,
              'btc': 2000,
              'eth': 500,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 'btc')]);

        // First set to eth so state is not btc
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'eth',
              address: '0xabc',
              amount: '25',
            ));
        verifyInOrder([() => listener('btc', 'eth')]);

        // Send transaction data with zero balance asset - should fall back to btc
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'xau',
              address: '0xdef',
              amount: '25',
            ));

        // Should fall back to btc because xau has zero balance
        verifyInOrder([() => listener('eth', 'btc')]);
        verifyNoMoreInteractions(listener);
      });
    });

    group('edge cases', () {
      test('handles large asset IDs', () {
        const largeAssetId =
            '0000000000000000000000000000000000000000000000000000000000000000';

        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              largeAssetId: 9999999,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(sendAssetIdProvider.notifier)
            .setSendAsset(largeAssetId);

        expect(container.read(sendAssetIdProvider), largeAssetId);
      });

      test('handles empty liquidAssetId fallback correctly', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue(''),
            assetBalanceProvider.overrideWithValue({
              'eth': 0,
            }),
          ],
        );
        addTearDown(container.dispose);

        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');

        expect(container.read(sendAssetIdProvider), '');
      });

      test('handles sequential rapid state changes', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'usdt': 2000,
              'xau': 500,
              'btc': 3000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(sendAssetIdProvider.notifier);

        // Rapid sequence of updates
        notifier.setSendAsset('eth');
        expect(container.read(sendAssetIdProvider), 'eth');

        notifier.setSendAsset('usdt');
        expect(container.read(sendAssetIdProvider), 'usdt');

        notifier.setSendAsset('xau');
        expect(container.read(sendAssetIdProvider), 'xau');

        notifier.setSendAsset('btc');
        expect(container.read(sendAssetIdProvider), 'btc');
      });

      test('maintains state across multiple container operations', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');
        var state = container.read(sendAssetIdProvider);
        expect(state, 'eth');

        // Read again to verify persistence
        state = container.read(sendAssetIdProvider);
        expect(state, 'eth');

        // Update notifier state
        container.read(sendAssetIdProvider.notifier).setSendAsset('btc');
        state = container.read(sendAssetIdProvider);
        expect(state, 'btc');
      });

      test('handles multiple sequential transaction updates', () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'usdt': 2000,
              'xau': 500,
              'btc': 3000,
            }),
          ],
        );
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          sendAssetIdProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 'btc')]);

        // First transaction
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'eth',
              address: '0x1',
              amount: '100',
            ));
        verifyInOrder([() => listener('btc', 'eth')]);

        // Second transaction
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'usdt',
              address: '0x2',
              amount: '200',
            ));
        verifyInOrder([() => listener('eth', 'usdt')]);

        // Back to empty
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionEmpty());
        verifyNoMoreInteractions(listener);

        // Third transaction
        container
            .read(eiCreateTransactionProvider.notifier)
            .setState(EICreateTransactionData(
              assetId: 'xau',
              address: '0x3',
              amount: '50',
            ));
        verifyInOrder([() => listener('usdt', 'xau')]);

        verifyNoMoreInteractions(listener);
      });

      test(
          'switches to fallback when asset balance changes to zero after selection',
          () {
        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 1000,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(container.dispose);

        // Select eth
        container.read(sendAssetIdProvider.notifier).setSendAsset('eth');
        expect(container.read(sendAssetIdProvider), 'eth');

        // Override balance provider to zero eth
        final newContainer = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('btc'),
            assetBalanceProvider.overrideWithValue({
              'eth': 0,
              'btc': 2000,
            }),
          ],
        );
        addTearDown(newContainer.dispose);

        // Try to set to eth again - should fall back
        newContainer
            .read(sendAssetIdProvider.notifier)
            .setSendAsset('eth');
        expect(newContainer.read(sendAssetIdProvider), 'btc');
      });
    });
  });
}
