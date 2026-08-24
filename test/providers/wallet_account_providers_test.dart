import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DefaultAccountsState', () {
    group('build', () {
      test('returns empty set initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(defaultAccountsStateProvider), isEmpty);
      });
    });

    group('insertAccountAsset', () {
      test('adds single account asset to empty state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final accountAsset = AccountAsset(Account.REG, 'asset1');
        final notifier = container.read(defaultAccountsStateProvider.notifier);
        notifier.insertAccountAsset(accountAsset: accountAsset);

        expect(container.read(defaultAccountsStateProvider), contains(accountAsset));
      });

      test('adds multiple account assets', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset1 = AccountAsset(Account.REG, 'asset1');
        final asset2 = AccountAsset(Account.AMP_, 'asset2');
        final notifier = container.read(defaultAccountsStateProvider.notifier);

        notifier.insertAccountAsset(accountAsset: asset1);
        notifier.insertAccountAsset(accountAsset: asset2);

        final state = container.read(defaultAccountsStateProvider);
        expect(state, containsAll([asset1, asset2]));
        expect(state, hasLength(2));
      });

      test('does not add duplicate account asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final accountAsset = AccountAsset(Account.REG, 'asset1');
        final notifier = container.read(defaultAccountsStateProvider.notifier);

        notifier.insertAccountAsset(accountAsset: accountAsset);
        notifier.insertAccountAsset(accountAsset: accountAsset);

        expect(container.read(defaultAccountsStateProvider), hasLength(1));
      });

      test('listener receives state changes on insertAccountAsset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<Set<AccountAsset>>();
        container.listen(
          defaultAccountsStateProvider,
          listener.call,
          fireImmediately: true,
        );

        final accountAsset = AccountAsset(Account.REG, 'asset1');
        final notifier = container.read(defaultAccountsStateProvider.notifier);

        verifyInOrder([() => listener(null, <AccountAsset>{})]);

        notifier.insertAccountAsset(accountAsset: accountAsset);

        verifyInOrder([() => listener(<AccountAsset>{}, any(that: contains(accountAsset)))]);
        verifyNoMoreInteractions(listener);
      });
    });
  });

  group('predefinedAccountAssets', () {
    test('returns account assets with liquid asset id for REG and AMP', () {
      const liquidAssetId = 'liquid-asset-id';
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(predefinedAccountAssetsProvider);

      expect(result, hasLength(2));
      expect(
        result,
        containsAll([
          AccountAsset(Account.REG, liquidAssetId),
          AccountAsset(Account.AMP_, liquidAssetId),
        ]),
      );
    });

    test('returns account assets with empty liquid asset id', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(''),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(predefinedAccountAssetsProvider);

      expect(result, hasLength(2));
      expect(
        result,
        containsAll([
          AccountAsset(Account.REG, ''),
          AccountAsset(Account.AMP_, ''),
        ]),
      );
    });
  });

  group('predefinedAssets', () {
    test('returns empty iterable when predefined assets have null assetIds', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(''),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(predefinedAssetsProvider);

      expect(result, isEmpty);
    });

    test(
      'returns assets only for valid predefined account assets',
      () {
        const assetId = 'valid-asset-id';
        final asset = Asset(
          assetId: assetId,
          name: 'Test Asset',
          ticker: 'TEST',
          precision: 8,
          swapMarket: true,
          ampMarket: false,
          alwaysShow: false,
        );

        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue(assetId),
            assetsStateProvider.overrideWithValue({assetId: asset}),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(predefinedAssetsProvider);

        // Both REG and AMP predefined assets have same assetId, so after set deduplication, we get 1
        expect(result, hasLength(1));
        expect(result.map((e) => e.assetId), everyElement(assetId));
      },
    );

    test('filters out null assets from the result', () {
      const assetId = 'valid-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Test Asset',
        ticker: 'TEST',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(assetId),
          assetsStateProvider.overrideWithValue({
            assetId: asset,
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(predefinedAssetsProvider);

      expect(result, isNotEmpty);
    });

    test('returns unique assets without duplicates', () {
      const assetId = 'asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Test Asset',
        ticker: 'TEST',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(assetId),
          assetsStateProvider.overrideWithValue({assetId: asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(predefinedAssetsProvider).toList();

      // Even though we have 2 predefined account assets, they both have same assetId
      // so we should get only 1 unique asset
      expect(result, hasLength(1));
    });
  });

  group('allAlwaysShowAccountAssets', () {
    test('returns predefined account assets', () {
      const liquidAssetId = 'liquid-asset-id';
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAccountAssetsProvider);

      expect(
        result,
        containsAll([
          AccountAsset(Account.REG, liquidAssetId),
          AccountAsset(Account.AMP_, liquidAssetId),
        ]),
      );
    });

    test(
      'includes always show assets from swapMarket',
      () {
        const liquidAssetId = 'liquid-asset-id';
        const swapAssetId = 'swap-asset-id';
        final swapAsset = Asset(
          assetId: swapAssetId,
          name: 'Swap Asset',
          ticker: 'SWAP',
          precision: 8,
          swapMarket: true,
          ampMarket: false,
          alwaysShow: true,
        );

        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
            accountAssetTransactionsProvider.overrideWithValue({}),
            assetsStateProvider.overrideWithValue({swapAssetId: swapAsset}),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(allAlwaysShowAccountAssetsProvider);

        expect(
          result,
          contains(AccountAsset(Account.REG, swapAssetId)),
        );
      },
    );

    test(
      'includes always show assets from ampMarket',
      () {
        const liquidAssetId = 'liquid-asset-id';
        const ampAssetId = 'amp-asset-id';
        final ampAsset = Asset(
          assetId: ampAssetId,
          name: 'AMP Asset',
          ticker: 'AMP',
          precision: 8,
          swapMarket: false,
          ampMarket: true,
          alwaysShow: true,
        );

        final container = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
            accountAssetTransactionsProvider.overrideWithValue({}),
            assetsStateProvider.overrideWithValue({ampAssetId: ampAsset}),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(allAlwaysShowAccountAssetsProvider);

        expect(
          result,
          contains(AccountAsset(Account.AMP_, ampAssetId)),
        );
      },
    );

    test('skips assets that are not always show when market flags are false', () {
      const liquidAssetId = 'liquid-asset-id';
      const hiddenAssetId = 'hidden-asset-id';
      final hiddenAsset = Asset(
        assetId: hiddenAssetId,
        name: 'Hidden Asset',
        ticker: 'HIDE',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({hiddenAssetId: hiddenAsset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAccountAssetsProvider);

      expect(
        result,
        isNot(contains(AccountAsset(Account.REG, hiddenAssetId))),
      );
    });

    test('includes remaining account assets with transactions', () {
      const liquidAssetId = 'liquid-asset-id';
      const transactionAssetId = 'transaction-asset-id';
      final accountAsset = AccountAsset(Account.REG, transactionAssetId);

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({accountAsset: []}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAccountAssetsProvider);

      expect(result, contains(accountAsset));
    });

    test('maintains order with predefined assets first', () {
      const liquidAssetId = 'liquid-asset-id';
      const transactionAssetId = 'transaction-asset-id';
      final accountAsset = AccountAsset(Account.REG, transactionAssetId);

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({accountAsset: []}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAccountAssetsProvider);

      // Predefined assets should come first
      expect(
        result.take(2),
        containsAll([
          AccountAsset(Account.REG, liquidAssetId),
          AccountAsset(Account.AMP_, liquidAssetId),
        ]),
      );
    });
  });

  group('allAlwaysShowAssets', () {
    test('returns empty iterable when no assets', () {
      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({}),
          assetTransactionsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAssetsProvider);

      expect(result, isEmpty);
    });

    test('includes predefined assets', () {
      const assetId = 'asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Test Asset',
        ticker: 'TEST',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([asset]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetTransactionsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAssetsProvider);

      expect(result, contains(asset));
    });

    test('includes assets with alwaysShow flag true', () {
      const assetId = 'always-show-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Always Show Asset',
        ticker: 'SHOW',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: true,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetTransactionsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAssetsProvider);

      expect(result, contains(asset));
    });

    test('skips duplicate assets that are already in predefined', () {
      const assetId = 'asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Test Asset',
        ticker: 'TEST',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: true,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([asset]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetTransactionsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAssetsProvider).toList();

      // Should only have 1 copy, not 2
      final matches = result.where((a) => a.assetId == assetId);
      expect(matches, hasLength(1));
    });

    test('includes remaining assets from transactions', () {
      const transactionAssetId = 'transaction-asset-id';
      final asset = Asset(
        assetId: transactionAssetId,
        name: 'Transaction Asset',
        ticker: 'TRANS',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({transactionAssetId: asset}),
          assetTransactionsProvider.overrideWithValue({transactionAssetId: []}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAssetsProvider);

      expect(result, contains(asset));
    });

    test('handles missing assets in assetsStateProvider', () {
      const missingAssetId = 'missing-asset-id';

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({}),
          assetTransactionsProvider.overrideWithValue({missingAssetId: []}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAlwaysShowAssetsProvider);

      // Should skip missing assets
      expect(result, isEmpty);
    });
  });

  group('allVisibleAccountAssets', () {
    test('returns empty list when no accounts', () {
      final container = ProviderContainer.test(
        overrides: [
          allAlwaysShowAccountAssetsProvider.overrideWithValue([]),
          defaultAccountsStateProvider.overrideWithValue({}),
          balancesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAccountAssetsProvider);

      expect(result, isEmpty);
    });

    test('includes default accounts even with zero balance', () {
      final accountAsset = AccountAsset(Account.REG, 'asset1');
      final container = ProviderContainer.test(
        overrides: [
          allAlwaysShowAccountAssetsProvider.overrideWithValue([accountAsset]),
          defaultAccountsStateProvider.overrideWithValue({accountAsset}),
          balancesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAccountAssetsProvider);

      expect(result, contains(accountAsset));
    });

    test('includes accounts with positive balance', () {
      final accountAsset = AccountAsset(Account.REG, 'asset1');
      final container = ProviderContainer.test(
        overrides: [
          allAlwaysShowAccountAssetsProvider.overrideWithValue([accountAsset]),
          defaultAccountsStateProvider.overrideWithValue({}),
          balancesProvider.overrideWithValue({accountAsset: 100}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAccountAssetsProvider);

      expect(result, contains(accountAsset));
    });

    test('excludes accounts with zero balance that are not default', () {
      final defaultAccountAsset = AccountAsset(Account.REG, 'default-asset');
      final zeroBalanceAccountAsset = AccountAsset(Account.REG, 'zero-asset');

      final container = ProviderContainer.test(
        overrides: [
          allAlwaysShowAccountAssetsProvider.overrideWithValue(
            [defaultAccountAsset, zeroBalanceAccountAsset],
          ),
          defaultAccountsStateProvider.overrideWithValue({defaultAccountAsset}),
          balancesProvider.overrideWithValue({zeroBalanceAccountAsset: 0}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAccountAssetsProvider);

      expect(result, contains(defaultAccountAsset));
      expect(result, isNot(contains(zeroBalanceAccountAsset)));
    });

    test('includes multiple account types with balances', () {
      final regAsset = AccountAsset(Account.REG, 'reg-asset');
      final ampAsset = AccountAsset(Account.AMP_, 'amp-asset');

      final container = ProviderContainer.test(
        overrides: [
          allAlwaysShowAccountAssetsProvider.overrideWithValue([regAsset, ampAsset]),
          defaultAccountsStateProvider.overrideWithValue({}),
          balancesProvider.overrideWithValue({
            regAsset: 100,
            ampAsset: 200,
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAccountAssetsProvider);

      expect(result, containsAll([regAsset, ampAsset]));
    });
  });

  group('regularVisibleAccountAssets', () {
    test('returns empty list when no visible accounts', () {
      final container = ProviderContainer.test(
        overrides: [
          allVisibleAccountAssetsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(regularVisibleAccountAssetsProvider);

      expect(result, isEmpty);
    });

    test('filters to only REG account type', () {
      final regAsset = AccountAsset(Account.REG, 'reg-asset');
      final ampAsset = AccountAsset(Account.AMP_, 'amp-asset');

      final container = ProviderContainer.test(
        overrides: [
          allVisibleAccountAssetsProvider.overrideWithValue([regAsset, ampAsset]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(regularVisibleAccountAssetsProvider);

      expect(result, contains(regAsset));
      expect(result, isNot(contains(ampAsset)));
    });

    test('returns list with multiple REG assets', () {
      final reg1 = AccountAsset(Account.REG, 'reg-asset1');
      final reg2 = AccountAsset(Account.REG, 'reg-asset2');

      final container = ProviderContainer.test(
        overrides: [
          allVisibleAccountAssetsProvider.overrideWithValue([reg1, reg2]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(regularVisibleAccountAssetsProvider);

      expect(result, containsAll([reg1, reg2]));
      expect(result, hasLength(2));
    });
  });

  group('ampVisibleAccountAssets', () {
    test('returns empty list when no visible accounts', () {
      final container = ProviderContainer.test(
        overrides: [
          allVisibleAccountAssetsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampVisibleAccountAssetsProvider);

      expect(result, isEmpty);
    });

    test('filters to only AMP account type', () {
      final regAsset = AccountAsset(Account.REG, 'reg-asset');
      final ampAsset = AccountAsset(Account.AMP_, 'amp-asset');

      final container = ProviderContainer.test(
        overrides: [
          allVisibleAccountAssetsProvider.overrideWithValue([regAsset, ampAsset]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampVisibleAccountAssetsProvider);

      expect(result, contains(ampAsset));
      expect(result, isNot(contains(regAsset)));
    });

    test('returns list with multiple AMP assets', () {
      final amp1 = AccountAsset(Account.AMP_, 'amp-asset1');
      final amp2 = AccountAsset(Account.AMP_, 'amp-asset2');

      final container = ProviderContainer.test(
        overrides: [
          allVisibleAccountAssetsProvider.overrideWithValue([amp1, amp2]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampVisibleAccountAssetsProvider);

      expect(result, containsAll([amp1, amp2]));
      expect(result, hasLength(2));
    });
  });

  group('allAccountAssets', () {
    test('returns predefined account assets initially', () {
      const liquidAssetId = 'liquid-asset-id';
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAccountAssetsProvider);

      expect(
        result,
        containsAll([
          AccountAsset(Account.REG, liquidAssetId),
          AccountAsset(Account.AMP_, liquidAssetId),
        ]),
      );
    });

    test('includes swapMarket assets with REG account', () {
      const liquidAssetId = 'liquid-asset-id';
      const swapAssetId = 'swap-asset-id';
      final swapAsset = Asset(
        assetId: swapAssetId,
        name: 'Swap Asset',
        ticker: 'SWAP',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({swapAssetId: swapAsset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAccountAssetsProvider);

      expect(
        result,
        contains(AccountAsset(Account.REG, swapAssetId)),
      );
    });

    test('includes ampMarket assets with AMP account', () {
      const liquidAssetId = 'liquid-asset-id';
      const ampAssetId = 'amp-asset-id';
      final ampAsset = Asset(
        assetId: ampAssetId,
        name: 'AMP Asset',
        ticker: 'AMP',
        precision: 8,
        swapMarket: false,
        ampMarket: true,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({ampAssetId: ampAsset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAccountAssetsProvider);

      expect(
        result,
        contains(AccountAsset(Account.AMP_, ampAssetId)),
      );
    });

    test('includes non-market assets with REG account by default', () {
      const liquidAssetId = 'liquid-asset-id';
      const otherAssetId = 'other-asset-id';
      final otherAsset = Asset(
        assetId: otherAssetId,
        name: 'Other Asset',
        ticker: 'OTHER',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({otherAssetId: otherAsset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAccountAssetsProvider);

      expect(
        result,
        contains(AccountAsset(Account.REG, otherAssetId)),
      );
    });

    test('includes remaining account assets from transactions', () {
      const liquidAssetId = 'liquid-asset-id';
      const transactionAssetId = 'transaction-asset-id';
      final accountAsset = AccountAsset(Account.REG, transactionAssetId);

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({accountAsset: []}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAccountAssetsProvider);

      expect(result, contains(accountAsset));
    });

    test('avoids duplicate account assets', () {
      const liquidAssetId = 'liquid-asset-id';
      const assetId = 'asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Test Asset',
        ticker: 'TEST',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          accountAssetTransactionsProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({assetId: asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allAccountAssetsProvider);

      // Should not have duplicates even if same asset appears in multiple places
      final matches = result
          .where((aa) => aa.assetId == assetId && aa.account == Account.REG);
      expect(matches, hasLength(1));
    });
  });

  group('regularAccountAssets', () {
    test('returns empty list when no account assets', () {
      final container = ProviderContainer.test(
        overrides: [
          allAccountAssetsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(regularAccountAssetsProvider);

      expect(result, isEmpty);
    });

    test('filters to only REG account type', () {
      final regAsset = AccountAsset(Account.REG, 'reg-asset');
      final ampAsset = AccountAsset(Account.AMP_, 'amp-asset');

      final container = ProviderContainer.test(
        overrides: [
          allAccountAssetsProvider.overrideWithValue([regAsset, ampAsset]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(regularAccountAssetsProvider);

      expect(result, contains(regAsset));
      expect(result, isNot(contains(ampAsset)));
    });

    test('returns list with multiple REG assets', () {
      final reg1 = AccountAsset(Account.REG, 'reg-asset1');
      final reg2 = AccountAsset(Account.REG, 'reg-asset2');

      final container = ProviderContainer.test(
        overrides: [
          allAccountAssetsProvider.overrideWithValue([reg1, reg2]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(regularAccountAssetsProvider);

      expect(result, containsAll([reg1, reg2]));
      expect(result, hasLength(2));
    });
  });

  group('ampAccountAssets', () {
    test('returns empty list when no account assets', () {
      final container = ProviderContainer.test(
        overrides: [
          allAccountAssetsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampAccountAssetsProvider);

      expect(result, isEmpty);
    });

    test('filters to only AMP account type', () {
      final regAsset = AccountAsset(Account.REG, 'reg-asset');
      final ampAsset = AccountAsset(Account.AMP_, 'amp-asset');

      final container = ProviderContainer.test(
        overrides: [
          allAccountAssetsProvider.overrideWithValue([regAsset, ampAsset]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampAccountAssetsProvider);

      expect(result, contains(ampAsset));
      expect(result, isNot(contains(regAsset)));
    });

    test('returns list with multiple AMP assets', () {
      final amp1 = AccountAsset(Account.AMP_, 'amp-asset1');
      final amp2 = AccountAsset(Account.AMP_, 'amp-asset2');

      final container = ProviderContainer.test(
        overrides: [
          allAccountAssetsProvider.overrideWithValue([amp1, amp2]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampAccountAssetsProvider);

      expect(result, containsAll([amp1, amp2]));
      expect(result, hasLength(2));
    });
  });

  group('marketTypeForAccountAsset', () {
    test('returns STABLECOIN for swapMarket asset', () {
      const assetId = 'swap-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Stablecoin',
        ticker: 'USDT',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );
      final accountAsset = AccountAsset(Account.REG, assetId);

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({assetId: asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(
        marketTypeForAccountAssetProvider(accountAsset),
      );

      expect(result, MarketType_.STABLECOIN);
    });

    test('returns AMP for ampMarket asset', () {
      const assetId = 'amp-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'AMP Asset',
        ticker: 'AMP',
        precision: 8,
        swapMarket: false,
        ampMarket: true,
        alwaysShow: false,
      );
      final accountAsset = AccountAsset(Account.AMP_, assetId);

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({assetId: asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(
        marketTypeForAccountAssetProvider(accountAsset),
      );

      expect(result, MarketType_.AMP);
    });

    test('returns TOKEN for non-market asset', () {
      const assetId = 'token-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Token Asset',
        ticker: 'TOKEN',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );
      final accountAsset = AccountAsset(Account.REG, assetId);

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({assetId: asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(
        marketTypeForAccountAssetProvider(accountAsset),
      );

      expect(result, MarketType_.TOKEN);
    });

    test('handles null accountAsset', () {
      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(
        marketTypeForAccountAssetProvider(null),
      );

      expect(result, MarketType_.TOKEN);
    });

    test('handles missing asset in assetsStateProvider', () {
      final accountAsset = AccountAsset(Account.REG, 'nonexistent-asset-id');

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(
        marketTypeForAccountAssetProvider(accountAsset),
      );

      expect(result, MarketType_.TOKEN);
    });
  });

  group('accountAssetFromAsset', () {
    test('returns AMP account for ampMarket asset', () {
      const assetId = 'amp-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'AMP Asset',
        ticker: 'AMP',
        precision: 8,
        swapMarket: false,
        ampMarket: true,
        alwaysShow: false,
      );

      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        accountAssetFromAssetProvider(asset),
      );

      expect(result.account, Account.AMP_);
      expect(result.assetId, assetId);
    });

    test('returns REG account for non-ampMarket asset', () {
      const assetId = 'regular-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Regular Asset',
        ticker: 'REG',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        accountAssetFromAssetProvider(asset),
      );

      expect(result.account, Account.REG);
      expect(result.assetId, assetId);
    });

    test('handles null asset', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        accountAssetFromAssetProvider(null),
      );

      expect(result.account, Account.REG);
      expect(result.assetId, isNull);
    });

    test('handles asset with both swapMarket and ampMarket true', () {
      const assetId = 'dual-market-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Dual Market Asset',
        ticker: 'DUAL',
        precision: 8,
        swapMarket: true,
        ampMarket: true,
        alwaysShow: false,
      );

      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        accountAssetFromAssetProvider(asset),
      );

      // Should prefer AMP when both are true due to switch pattern
      expect(result.account, Account.AMP_);
      expect(result.assetId, assetId);
    });
  });

  group('allVisibleAssets', () {
    test('returns empty iterable when no assets', () {
      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({}),
          assetBalanceProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      expect(result, isEmpty);
    });

    test('includes predefined assets', () {
      const assetId = 'predefined-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Predefined Asset',
        ticker: 'PRED',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([asset]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetBalanceProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      expect(result, contains(asset));
    });

    test('includes assets with balance greater than zero', () {
      const assetId = 'balance-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Balance Asset',
        ticker: 'BAL',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetBalanceProvider.overrideWithValue({assetId: 100}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      expect(result, contains(asset));
    });

    test('includes assets with alwaysShow flag', () {
      const assetId = 'always-show-asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Always Show Asset',
        ticker: 'SHOW',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: true,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetBalanceProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      expect(result, contains(asset));
    });

    test('excludes assets with zero balance and no alwaysShow flag', () {
      const hiddenAssetId = 'hidden-asset-id';
      final hiddenAsset = Asset(
        assetId: hiddenAssetId,
        name: 'Hidden Asset',
        ticker: 'HIDE',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({hiddenAssetId: hiddenAsset}),
          assetBalanceProvider.overrideWithValue({hiddenAssetId: 0}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      expect(result, isNot(contains(hiddenAsset)));
    });

    test('handles multiple visible assets with mixed conditions', () {
      const predefinedAssetId = 'predefined-asset-id';
      const balanceAssetId = 'balance-asset-id';
      const alwaysShowAssetId = 'always-show-asset-id';

      final predefinedAsset = Asset(
        assetId: predefinedAssetId,
        name: 'Predefined',
        ticker: 'PRED',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );
      final balanceAsset = Asset(
        assetId: balanceAssetId,
        name: 'Balance',
        ticker: 'BAL',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: false,
      );
      final alwaysShowAsset = Asset(
        assetId: alwaysShowAssetId,
        name: 'Always Show',
        ticker: 'SHOW',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
        alwaysShow: true,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([predefinedAsset]),
          assetsStateProvider.overrideWithValue({
            predefinedAssetId: predefinedAsset,
            balanceAssetId: balanceAsset,
            alwaysShowAssetId: alwaysShowAsset,
          }),
          assetBalanceProvider.overrideWithValue({
            balanceAssetId: 100,
            alwaysShowAssetId: 0,
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      expect(result, containsAll([predefinedAsset, balanceAsset, alwaysShowAsset]));
    });

    test('returns unique assets without duplicates', () {
      const assetId = 'asset-id';
      final asset = Asset(
        assetId: assetId,
        name: 'Asset',
        ticker: 'ASS',
        precision: 8,
        swapMarket: true,
        ampMarket: false,
        alwaysShow: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([asset]),
          assetsStateProvider.overrideWithValue({assetId: asset}),
          assetBalanceProvider.overrideWithValue({assetId: 100}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider).toList();

      // Should only appear once even if it matches multiple conditions
      final matches = result.where((a) => a.assetId == assetId);
      expect(matches, hasLength(1));
    });

    test('handles missing assets in assetsStateProvider', () {
      final container = ProviderContainer.test(
        overrides: [
          predefinedAssetsProvider.overrideWithValue([]),
          assetsStateProvider.overrideWithValue({}),
          assetBalanceProvider.overrideWithValue({'missing-id': 100}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(allVisibleAssetsProvider);

      // Should skip missing assets
      expect(result, isEmpty);
    });
  });
}
