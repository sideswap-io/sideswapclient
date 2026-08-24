import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart'
    show OutputsData, OutputsErrorOutputsDataIsEmpty, OutputsReceiver, outputsReaderProvider;
import 'package:sideswap/providers/portfolio_prices_providers.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Decimal.zero);
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  group('BalancesNotifier', () {
    group('updateBalances', () {
      test('builds empty map initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(balancesProvider), isEmpty);
      });

      test('replaces balances for account when updateBalances is called', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);
        final update = From_BalanceUpdate(
          account: Account.REG,
          balances: [
            Balance(assetId: 'asset1', amount: Int64(100)),
            Balance(assetId: 'asset2', amount: Int64(200)),
          ],
        );

        notifier.updateBalances(update);

        final state = container.read(balancesProvider);
        expect(
          state[AccountAsset(Account.REG, 'asset1')],
          100,
        );
        expect(
          state[AccountAsset(Account.REG, 'asset2')],
          200,
        );
      });

      test('clears old balances for account when new update has zero balance', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [
            Balance(assetId: 'asset1', amount: Int64(100)),
          ],
        ));

        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [
            Balance(assetId: 'asset2', amount: Int64(200)),
          ],
        ));

        final state = container.read(balancesProvider);
        expect(state[AccountAsset(Account.REG, 'asset1')], isNull);
        expect(state[AccountAsset(Account.REG, 'asset2')], 200);
      });

      test('preserves balances for other accounts when one account is updated',
          () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [Balance(assetId: 'asset1', amount: Int64(100))],
        ));
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.AMP_,
          balances: [Balance(assetId: 'asset2', amount: Int64(200))],
        ));

        final state = container.read(balancesProvider);
        expect(state[AccountAsset(Account.REG, 'asset1')], 100);
        expect(state[AccountAsset(Account.AMP_, 'asset2')], 200);
      });

      test('handles multiple updates to same account', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);

        // First update
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [Balance(assetId: 'asset1', amount: Int64(100))],
        ));

        // Second update - adds another asset
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [
            Balance(assetId: 'asset1', amount: Int64(150)),
            Balance(assetId: 'asset3', amount: Int64(75)),
          ],
        ));

        final state = container.read(balancesProvider);
        expect(state[AccountAsset(Account.REG, 'asset1')], 150);
        expect(state[AccountAsset(Account.REG, 'asset3')], 75);
      });

      test('handles large amounts', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);
        final largeAmount = Int64.parseRadix('7FFFFFFFFFFFFFFF', 16); // Max Int64

        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [
            Balance(assetId: 'asset1', amount: largeAmount),
          ],
        ));

        final state = container.read(balancesProvider);
        expect(state[AccountAsset(Account.REG, 'asset1')], largeAmount.toInt());
      });

      test('handles empty balance list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [Balance(assetId: 'asset1', amount: Int64(100))],
        ));

        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [],
        ));

        final state = container.read(balancesProvider);
        expect(state[AccountAsset(Account.REG, 'asset1')], isNull);
      });

      test('preserves multiple account balances independently', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(balancesProvider.notifier);

        notifier.updateBalances(From_BalanceUpdate(
          account: Account.REG,
          balances: [Balance(assetId: 'asset1', amount: Int64(100))],
        ));
        notifier.updateBalances(From_BalanceUpdate(
          account: Account.AMP_,
          balances: [Balance(assetId: 'asset1', amount: Int64(200))],
        ));

        final state = container.read(balancesProvider);
        expect(state[AccountAsset(Account.REG, 'asset1')], 100);
        expect(state[AccountAsset(Account.AMP_, 'asset1')], 200);
      });
    });
  });

  group('assetBalanceProvider', () {
    test('aggregates balances by assetId across accounts', () {
      final initialBalances = {
        AccountAsset(Account.REG, 'asset1'): 100,
        AccountAsset(Account.AMP_, 'asset1'): 50,
        AccountAsset(Account.REG, 'asset2'): 200,
      };
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue(initialBalances),
        ],
      );
      addTearDown(container.dispose);

      final balanceMap = container.read(assetBalanceProvider);
      expect(balanceMap['asset1'], 150);
      expect(balanceMap['asset2'], 200);
    });

    test('skips entries with null assetId', () {
      final initialBalances = {
        AccountAsset(Account.REG, null): 100,
        AccountAsset(Account.REG, 'asset1'): 50,
      };
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue(initialBalances),
        ],
      );
      addTearDown(container.dispose);

      final balanceMap = container.read(assetBalanceProvider);
      expect(balanceMap['asset1'], 50);
      expect(balanceMap.containsKey(null), false);
    });

    test('returns empty map when no balances', () {
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final balanceMap = container.read(assetBalanceProvider);
      expect(balanceMap, isEmpty);
    });

    test('handles multiple assets across multiple accounts', () {
      final initialBalances = {
        AccountAsset(Account.REG, 'asset1'): 100,
        AccountAsset(Account.REG, 'asset2'): 200,
        AccountAsset(Account.AMP_, 'asset1'): 50,
        AccountAsset(Account.AMP_, 'asset2'): 75,
      };
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue(initialBalances),
        ],
      );
      addTearDown(container.dispose);

      final balanceMap = container.read(assetBalanceProvider);
      expect(balanceMap['asset1'], 150);
      expect(balanceMap['asset2'], 275);
    });

    test('sums balances correctly with single balance per asset', () {
      final initialBalances = {
        AccountAsset(Account.REG, 'asset1'): 500,
      };
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue(initialBalances),
        ],
      );
      addTearDown(container.dispose);

      final balanceMap = container.read(assetBalanceProvider);
      expect(balanceMap['asset1'], 500);
      expect(balanceMap.length, 1);
    });
  });

  group('selectedInputsBalanceForAssetProvider', () {
    test('returns 0 when selectedInputs is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue(const []),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(selectedInputsBalanceForAssetProvider('asset1')),
        0,
      );
    });

    test('returns sum of amounts for matching assetId', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
            UtxosItem(assetId: 'asset2', amount: 50),
            UtxosItem(assetId: 'asset1', amount: 30),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(selectedInputsBalanceForAssetProvider('asset1')),
        130,
      );
    });

    test('returns 0 for asset not in selectedInputs', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(selectedInputsBalanceForAssetProvider('asset2')),
        0,
      );
    });

    test('handles null amount values', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
            UtxosItem(assetId: 'asset1', amount: null),
            UtxosItem(assetId: 'asset1', amount: 50),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(selectedInputsBalanceForAssetProvider('asset1')),
        150,
      );
    });

    test('returns 0 when selectedInputs is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(selectedInputsBalanceForAssetProvider('asset1')),
        0,
      );
    });
  });

  group('maxAvailableBalanceWithInputsForAssetProvider', () {
    // These tests verify passthrough delegation to selectedInputsBalanceForAssetProvider.
    test('returns selectedInputsBalanceForAsset value', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 200),
          ]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(maxAvailableBalanceWithInputsForAssetProvider('asset1')),
        200,
      );
    });

    test('returns 0 when no selected inputs for asset', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(maxAvailableBalanceWithInputsForAssetProvider('asset1')),
        0,
      );
    });
  });

  group('balanceWithInputsForAssetProvider', () {
    test('returns selectedInputsBalance minus outputsBalance when inputs selected',
        () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 30),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(balanceWithInputsForAssetProvider('asset1')),
        70,
      );
    });

    test('returns assetBalance minus outputsBalance when no inputs selected',
        () {
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
          selectedInputsProvider.overrideWithValue([]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 20),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(balanceWithInputsForAssetProvider('asset1')),
        80,
      );
    });

    test('returns 0 when balance less than outputs', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 50),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 100),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(balanceWithInputsForAssetProvider('asset1')),
        -50,
      );
    });

    test('returns 0 when balance equals outputs', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 100),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(balanceWithInputsForAssetProvider('asset1')),
        0,
      );
    });
  });

  group('outputsBalanceForAssetProvider', () {
    test('returns 0 when outputs data is Left error', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            const Left(OutputsErrorOutputsDataIsEmpty()),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        0,
      );
    });

    test('returns 0 when receivers is null', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: null)),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        0,
      );
    });

    test('returns 0 when receivers is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        0,
      );
    });

    test('sums satoshi for matching assetId in receivers', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 100),
              const OutputsReceiver(assetId: 'asset2', satoshi: 50),
              const OutputsReceiver(assetId: 'asset1', satoshi: 30),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        130,
      );
    });

    test('returns 0 for asset not in receivers', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 100),
              const OutputsReceiver(assetId: 'asset2', satoshi: 50),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset3')),
        0,
      );
    });

    test('handles receivers with null satoshi', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 100),
              const OutputsReceiver(assetId: 'asset1', satoshi: null),
              const OutputsReceiver(assetId: 'asset1', satoshi: 50),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        150,
      );
    });

    test('handles single receiver', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 999),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        999,
      );
    });

    test('returns 0 with large number of receivers but no match', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 100),
              const OutputsReceiver(assetId: 'asset2', satoshi: 200),
              const OutputsReceiver(assetId: 'asset3', satoshi: 300),
              const OutputsReceiver(assetId: 'asset4', satoshi: 400),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset5')),
        0,
      );
    });

    test('correctly sums when same asset appears multiple times', () {
      final container = ProviderContainer.test(
        overrides: [
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [
              const OutputsReceiver(assetId: 'asset1', satoshi: 10),
              const OutputsReceiver(assetId: 'asset1', satoshi: 20),
              const OutputsReceiver(assetId: 'asset1', satoshi: 30),
              const OutputsReceiver(assetId: 'asset1', satoshi: 40),
            ])),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(outputsBalanceForAssetProvider('asset1')),
        100,
      );
    });
  });

  group('balanceStringWithInputsForAssetProvider', () {
    test('returns formatted balance string with selected inputs', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 150),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [])),
          ),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Asset 1',
              ticker: 'A1',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(balanceStringWithInputsForAssetProvider('asset1'));
      expect(result, '1.50');
    });
  });

  group('balanceStringWithInputsProvider', () {
    test('returns balance string for selected asset', () {
      final container = ProviderContainer.test(
        overrides: [
          sendAssetIdProvider.overrideWithValue('asset1'),
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 200),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [])),
          ),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Asset 1',
              ticker: 'A1',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(balanceStringWithInputsProvider);
      expect(result, '2.00');
    });
  });

  group('availableBalanceForAssetIdProvider', () {
    for (final tc in [
      (desc: 'returns balance for asset when present', balances: {'asset1': 500}, assetId: 'asset1', expected: 500),
      (desc: 'returns 0 when asset not in balance map', balances: <String, int>{}, assetId: 'unknown', expected: 0),
      (desc: 'returns large balance values', balances: {'asset1': 9223372036854775807}, assetId: 'asset1', expected: 9223372036854775807),
    ]) {
      test(tc.desc, () {
        final container = ProviderContainer.test(
          overrides: [
            assetBalanceProvider.overrideWithValue(tc.balances),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(availableBalanceForAssetIdProvider(tc.assetId)),
          tc.expected,
        );
      });
    }
  });

  group('isAmountUsdAvailableProvider', () {
    test('returns true when portfolio has price for asset', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 1.5}),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isAmountUsdAvailableProvider('asset1')), true);
    });

    test('returns false when assetId is null', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(isAmountUsdAvailableProvider(null)), false);
    });

    test('returns false when portfolio has no price for asset', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'other': 1.0}),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(isAmountUsdAvailableProvider('asset1')),
        false,
      );
    });

    test('returns true for zero price (price exists but is 0)', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 0.0}),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isAmountUsdAvailableProvider('asset1')), true);
    });

    test('returns true for multiple assets with prices', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({
            'asset1': 1.5,
            'asset2': 2.0,
            'asset3': 0.5,
          }),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isAmountUsdAvailableProvider('asset2')), true);
      expect(container.read(isAmountUsdAvailableProvider('asset3')), true);
    });

    test('returns false for empty portfolio prices', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isAmountUsdAvailableProvider('asset1')), false);
    });
  });

  group('amountUsdProvider', () {
    test('returns price * amount when portfolio has price', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.5}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 100));
      expect(result, Decimal.parse('250'));
    });

    test('returns correct calculation with decimal amount', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.5}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 50.5));
      expect(result, Decimal.parse('126.25'));
    });

    test('returns zero with zero amount', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.5}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 0));
      expect(result, Decimal.zero);
    });

    test('returns zero when portfolio has very small price', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 0.00001}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 100));
      expect(result, Decimal.parse('0.001'));
    });

    test('handles large amounts correctly', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 1.5}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 1000000));
      expect(result, Decimal.parse('1500000'));
    });

    test('returns negative value for negative amount', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.5}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', -100));
      expect(result, Decimal.parse('-250'));
    });

    test('returns correct value with integer price', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 3.0}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 100));
      expect(result, Decimal.parse('300'));
    });
  });

  group('amountUsdInDefaultCurrencyProvider', () {
    test('returns amountUsd multiplied by rate when rate is set', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.parse('1.5')),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdInDefaultCurrencyProvider('asset1', 100));
      expect(result, Decimal.parse('300.00'));
    });

    test('applies rounding with scale 2', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 3.333}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdInDefaultCurrencyProvider('asset1', 100));
      expect(result, Decimal.parse('333.30'));
    });

    test('returns zero with rate 1 and no portfolio price', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdInDefaultCurrencyProvider('asset1', 100));
      expect(result, Decimal.zero);
    });
  });

  group('defaultCurrencyConversionProvider', () {
    test('returns formatted amount when conversion is non-zero', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          defaultCurrencyTickerProvider.overrideWithValue('USD'),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionProvider('asset1', 100));
      expect(result, '200.00');
    });

    test('returns "0.0" when conversion is zero', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionProvider('asset1', 100));
      expect(result, '0.0');
    });

    test('returns "0.0" when assetId is null and conversion is zero', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionProvider(null, 100));
      expect(result, '0.0');
    });

    test('returns "0.0" when assetId is empty string and conversion is zero', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionProvider('', 100));
      expect(result, '0.0');
    });
  });

  group('defaultCurrencyConversionWithTickerProvider', () {
    test('appends ticker to conversion string', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          defaultCurrencyTickerProvider.overrideWithValue('USD'),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionWithTickerProvider('asset1', 100));
      expect(result, contains('200.00'));
      expect(result, contains('USD'));
    });

    test('handles empty ticker', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          defaultCurrencyTickerProvider.overrideWithValue(''),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionWithTickerProvider('asset1', 100));
      expect(result, isNotEmpty);
    });
  });

  group('defaultCurrencyConversionFromStringProvider', () {
    test('returns formatted conversion when amount string is valid', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          defaultCurrencyTickerProvider.overrideWithValue('USD'),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionFromStringProvider('asset1', '100'));
      expect(result, isNotEmpty);
    });

    test('returns empty string when amount string is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionFromStringProvider('asset1', ''));
      expect(result, '');
    });

    test('returns empty string when amount is 0', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionFromStringProvider('asset1', '0'));
      expect(result, '');
    });

    test('returns empty string when amount cannot be parsed', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(defaultCurrencyConversionFromStringProvider('asset1', 'invalid'));
      expect(result, '');
    });
  });

  group('assetBalanceStringProvider', () {
    test('returns formatted balance string', () {
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 150,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceStringProvider(asset));
      expect(result, isNotEmpty);
    });

    test('returns balance when asset not in balance', () {
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset2',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceStringProvider(asset));
      expect(result, isNotEmpty);
    });
  });

  group('assetBalanceDecimalProvider', () {
    test('converts balance string to decimal', () {
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 150,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceDecimalProvider(asset));
      expect(result, isA<Decimal>());
    });
  });

  group('assetBalanceDoubleProvider', () {
    test('converts decimal balance to double', () {
      final container = ProviderContainer.test(
        overrides: [
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 150,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceDoubleProvider(asset));
      expect(result, isA<double>());
    });
  });

  group('availableBalanceForAssetIdAsStringProvider', () {
    test('returns formatted balance when asset present', () {
      final container = ProviderContainer.test(
        overrides: [
          assetBalanceProvider.overrideWithValue({'asset1': 250}),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Test',
              ticker: 'TST',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(availableBalanceForAssetIdAsStringProvider('asset1'));
      expect(result, isNotEmpty);
    });

    test('returns "0" when assetId is null', () {
      final container = ProviderContainer.test(
        overrides: [
          assetBalanceProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(availableBalanceForAssetIdAsStringProvider(null));
      expect(result, '0');
    });

    test('returns "0" when asset not in state', () {
      final container = ProviderContainer.test(
        overrides: [
          assetBalanceProvider.overrideWithValue({'asset1': 250}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(availableBalanceForAssetIdAsStringProvider('asset1'));
      expect(result, '0');
    });
  });

  group('defaultCurrencyTickerProvider', () {
    test('returns empty string when default conversion rate is null', () {
      final container = ProviderContainer.test(
        overrides: [
          defaultConversionRateProvider.overrideWithValue(null),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(defaultCurrencyTickerProvider), '');
    });

    for (final currency in ['USD', 'EUR', 'GBP']) {
      test('returns $currency when conversion rate name is $currency', () {
        final container = ProviderContainer.test(
          overrides: [
            defaultConversionRateProvider.overrideWithValue(
              ConversionRate(name: currency, rate: Decimal.one),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(defaultCurrencyTickerProvider), currency);
      });
    }
  });

  group('assetBalanceInDefaultCurrencyProvider', () {
    test('returns balance * price * rate when price available', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.parse('1.5')),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      // balance=100 sat, precision=2 → '1.00'; 1.00 * 2.0 * 1.5 = 3.0
      final result = container.read(assetBalanceInDefaultCurrencyProvider(asset));
      expect(result, Decimal.parse('3.0'));
    });

    test('returns zero when price unavailable', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceInDefaultCurrencyProvider(asset));
      expect(result, Decimal.zero);
    });
  });

  group('assetBalanceInDefaultCurrencyStringProvider', () {
    test('returns string with 2 decimal places', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.parse('1.5')),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceInDefaultCurrencyStringProvider(asset));
      expect(result, matches(RegExp(r'^\d+\.\d{2}$')));
    });
  });

  group('assetBalanceWithInputsInDefaultCurrencyProvider', () {
    test('returns balance * price * rate with inputs', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [])),
          ),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Test',
              ticker: 'TST',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      // inputs amount=100 sat, precision=2 → '1.00'; 1.00 * 2.0 * 1.0 = 2.0
      final result = container.read(assetBalanceWithInputsInDefaultCurrencyProvider('asset1'));
      expect(result, Decimal.parse('2.0'));
    });

    test('returns zero when price unavailable', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [])),
          ),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Test',
              ticker: 'TST',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(assetBalanceWithInputsInDefaultCurrencyProvider('asset1'));
      expect(result, Decimal.zero);
    });
  });

  group('assetBalanceWithInputsInDefaultCurrencyStringProvider', () {
    test('returns string with 2 decimal places', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          selectedInputsProvider.overrideWithValue([
            UtxosItem(assetId: 'asset1', amount: 100),
          ]),
          outputsReaderProvider.overrideWithValue(
            Right(OutputsData(receivers: [])),
          ),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Test',
              ticker: 'TST',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(assetBalanceWithInputsInDefaultCurrencyStringProvider('asset1'));
      expect(result, matches(RegExp(r'^\d+\.\d{2}$')));
    });
  });

  group('assetsTotalDefaultCurrencyBalance', () {
    test('sums default currency balance of all assets', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({
            'asset1': 2.0,
            'asset2': 3.0,
          }),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
            AccountAsset(Account.REG, 'asset2'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(
          assetId: 'asset1',
          name: 'Asset 1',
          ticker: 'A1',
          precision: 2,
        ),
        Asset(
          assetId: 'asset2',
          name: 'Asset 2',
          ticker: 'A2',
          precision: 2,
        ),
      ];
      // asset1: 100 sat, precision=2 → '1.00' * 2.0 * 1.0 = 2.0
      // asset2: 100 sat, precision=2 → '1.00' * 3.0 * 1.0 = 3.0; total = 5.0
      final result = container.read(assetsTotalDefaultCurrencyBalanceProvider(assets));
      expect(result, Decimal.parse('5.0'));
    });
  });

  group('assetsTotalDefaultCurrencyBalanceString', () {
    test('returns default currency total as formatted string', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          defaultConversionRateMultiplierProvider.overrideWithValue(Decimal.one),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(
          assetId: 'asset1',
          name: 'Asset 1',
          ticker: 'A1',
          precision: 2,
        ),
      ];
      final result = container.read(assetsTotalDefaultCurrencyBalanceStringProvider(assets));
      expect(result, matches(RegExp(r'^\d+\.\d{2}$')));
    });
  });

  group('assetsTotalLbtcBalance', () {
    test('returns LBTC balance when liquid index price available', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          portfolioPricesProvider.overrideWithValue({
            'lbtc': 1.0,
            'asset1': 2.0,
          }),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(
          assetId: 'asset1',
          name: 'Asset 1',
          ticker: 'A1',
          precision: 2,
        ),
      ];
      final result = container.read(assetsTotalLbtcBalanceProvider(assets));
      expect(result, isNotEmpty);
    });

    test('returns "0.0" when liquid index price unavailable', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          portfolioPricesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(
          assetId: 'asset1',
          name: 'Asset 1',
          ticker: 'A1',
          precision: 2,
        ),
      ];
      final result = container.read(assetsTotalLbtcBalanceProvider(assets));
      expect(result, '0.0');
    });

    test('returns LBTC balance when price is positive', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          portfolioPricesProvider.overrideWithValue({
            'lbtc': 50000.0,
            'asset1': 2.0,
          }),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(
          assetId: 'asset1',
          name: 'Asset 1',
          ticker: 'A1',
          precision: 8,
        ),
      ];
      final result = container.read(assetsTotalLbtcBalanceProvider(assets));
      expect(result, isNotEmpty);
      expect(result, isNot('0.0'));
    });

    test('handles zero LBTC price by returning 0.0', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          portfolioPricesProvider.overrideWithValue({
            'lbtc': 0.0,
            'asset1': 2.0,
          }),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(
          assetId: 'asset1',
          name: 'Asset 1',
          ticker: 'A1',
          precision: 8,
        ),
      ];
      final result = container.read(assetsTotalLbtcBalanceProvider(assets));
      expect(result, '0.0');
    });
  });

  group('amountUsdProvider error branches', () {
    test('returns zero when assetId is null', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.5}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider(null, 100));
      expect(result, Decimal.zero);
    });

    test('returns zero when portfolio missing asset key', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 100));
      expect(result, Decimal.zero);
    });

    test('returns zero when parsed portfolio price is zero', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 0.0}),
          assetsStateProvider.overrideWithValue({
            'asset1': Asset(
              assetId: 'asset1',
              name: 'Test',
              ticker: 'TST',
              precision: 2,
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(amountUsdProvider('asset1', 100));
      expect(result, Decimal.zero);
    });
  });


  group('assetsTotalUsdBalanceStringProvider', () {
    test('returns formatted USD sum for assets with portfolio prices', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(assetId: 'asset1', name: 'Asset 1', ticker: 'A1', precision: 2),
      ];
      final result = container.read(assetsTotalUsdBalanceStringProvider(assets));
      expect(result, matches(RegExp(r'^\d+\.\d{2}$')));
    });

    test('returns "0.00" for assets with no portfolio prices', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final assets = [
        Asset(assetId: 'asset1', name: 'Asset 1', ticker: 'A1', precision: 2),
      ];
      final result = container.read(assetsTotalUsdBalanceStringProvider(assets));
      expect(result, '0.00');
    });
  });

  group('assetBalanceInUsdProvider', () {
    test('returns balance * price when portfolio price available', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 2.0}),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceInUsdProvider(asset));
      expect(result, isA<Decimal>());
      expect(result > Decimal.zero, isTrue);
    });

    test('returns Decimal.zero when no portfolio price (default case)', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceInUsdProvider(asset));
      expect(result, Decimal.zero);
    });
  });

  group('assetBalanceInUsdStringProvider', () {
    test('returns formatted string with 2 decimal places', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({'asset1': 3.0}),
          balancesProvider.overrideWithValue({
            AccountAsset(Account.REG, 'asset1'): 100,
          }),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceInUsdStringProvider(asset));
      expect(result, matches(RegExp(r'^\d+\.\d{2}$')));
    });

    test('returns "0.00" when no portfolio price', () {
      final container = ProviderContainer.test(
        overrides: [
          portfolioPricesProvider.overrideWithValue({}),
          balancesProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Test',
        ticker: 'TST',
        precision: 2,
      );
      final result = container.read(assetBalanceInUsdStringProvider(asset));
      expect(result, '0.00');
    });
  });

}

