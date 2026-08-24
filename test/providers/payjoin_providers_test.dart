import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeductFeeFromOutputEnabledNotifier', () {
    group('build', () {
      test('returns false when outputsCreatorProvider returns Left', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });

      test('returns false when outputsData is null', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });

      test('returns false when receivers is null', () {
        final outputsData = OutputsData(receivers: null);
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });

      test('returns false when payjoinFeeAsset is null', () {
        final outputsData = OutputsData(receivers: []);
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinFeeAssetProvider.overrideWithValue(null),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });

      test('returns false when selectedInputs is not empty and maxBalance is 0', () {
        final asset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);
        final input = UtxosItem(assetId: 'asset1', amount: 500);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinFeeAssetProvider.overrideWithValue(asset),
            selectedInputsProvider.overrideWithValue([input]),
            maxAvailableBalanceWithInputsForAssetProvider('asset1')
                .overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });

      test(
          'returns true when selectedInputs is not empty and maxBalance > 0',
          () {
        final asset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);
        final input = UtxosItem(assetId: 'asset1', amount: 500);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinFeeAssetProvider.overrideWithValue(asset),
            selectedInputsProvider.overrideWithValue([input]),
            maxAvailableBalanceWithInputsForAssetProvider('asset1')
                .overrideWithValue(1500),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), true);
      });

      test('returns false when selectedInputs is empty and maxBalance is 0', () {
        final asset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinFeeAssetProvider.overrideWithValue(asset),
            selectedInputsProvider.overrideWithValue([]),
            availableBalanceForAssetIdProvider('asset1').overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });

      test(
          'returns true when selectedInputs is empty and maxBalance > 0',
          () {
        final asset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinFeeAssetProvider.overrideWithValue(asset),
            selectedInputsProvider.overrideWithValue([]),
            availableBalanceForAssetIdProvider('asset1').overrideWithValue(2000),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), true);
      });
    });

    group('setState', () {
      test('updates state value', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputEnabledProvider), false);
        container.read(deductFeeFromOutputEnabledProvider.notifier).setState(true);
        expect(container.read(deductFeeFromOutputEnabledProvider), true);
      });

      test('can toggle state multiple times', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(deductFeeFromOutputEnabledProvider.notifier).setState(true);
        expect(container.read(deductFeeFromOutputEnabledProvider), true);
        container.read(deductFeeFromOutputEnabledProvider.notifier).setState(false);
        expect(container.read(deductFeeFromOutputEnabledProvider), false);
      });
    });
  });

  group('PayjoinRadioButtonIndexNotifier', () {
    group('build', () {
      test('initial state is 0', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(payjoinRadioButtonIndexProvider), 0);
      });
    });

    group('setState', () {
      test('updates state to new value', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container.read(payjoinRadioButtonIndexProvider.notifier).setState(5);
        expect(container.read(payjoinRadioButtonIndexProvider), 5);
      });

      test('can update state multiple times', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container.read(payjoinRadioButtonIndexProvider.notifier).setState(1);
        expect(container.read(payjoinRadioButtonIndexProvider), 1);
        container.read(payjoinRadioButtonIndexProvider.notifier).setState(3);
        expect(container.read(payjoinRadioButtonIndexProvider), 3);
      });
    });
  });

  group('DeductFeeFromOutputNotifier', () {
    group('build', () {
      test('returns false when outputsCreatorProvider returns Left', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test('returns false when outputsData is null', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test('returns false when receivers is null', () {
        final outputsData = OutputsData(receivers: null);
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test(
          'returns false when payjoinFeeAsset is null (pattern match default case)',
          () {
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(0),
            selectedInputsProvider.overrideWithValue([]),
            payjoinFeeAssetProvider.overrideWithValue(null),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test(
          'returns false when payjoinFeeAsset assetId does not match receiver assetId',
          () {
        final feeAsset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset2', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(0),
            selectedInputsProvider.overrideWithValue([]),
            payjoinFeeAssetProvider.overrideWithValue(feeAsset),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test(
          'returns true when payjoinFeeAsset matches receiver and maxBalance equals outputSatoshi with selectedInputs',
          () {
        final feeAsset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1500);
        final outputsData = OutputsData(receivers: [receiver]);
        final input = UtxosItem(assetId: 'asset1', amount: 500);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(0),
            selectedInputsProvider.overrideWithValue([input]),
            payjoinFeeAssetProvider.overrideWithValue(feeAsset),
            maxAvailableBalanceWithInputsForAssetProvider('asset1')
                .overrideWithValue(1500),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), true);
      });

      test(
          'returns false when payjoinFeeAsset matches receiver but maxBalance does not equal outputSatoshi with selectedInputs',
          () {
        final feeAsset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1500);
        final outputsData = OutputsData(receivers: [receiver]);
        final input = UtxosItem(assetId: 'asset1', amount: 500);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(0),
            selectedInputsProvider.overrideWithValue([input]),
            payjoinFeeAssetProvider.overrideWithValue(feeAsset),
            maxAvailableBalanceWithInputsForAssetProvider('asset1')
                .overrideWithValue(2000),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test(
          'returns true when payjoinFeeAsset matches receiver and maxBalance equals outputSatoshi without selectedInputs',
          () {
        final feeAsset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 2000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(0),
            selectedInputsProvider.overrideWithValue([]),
            payjoinFeeAssetProvider.overrideWithValue(feeAsset),
            availableBalanceForAssetIdProvider('asset1').overrideWithValue(2000),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), true);
      });

      test(
          'returns false when payjoinFeeAsset matches receiver but maxBalance does not equal outputSatoshi without selectedInputs',
          () {
        final feeAsset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 2000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(0),
            selectedInputsProvider.overrideWithValue([]),
            payjoinFeeAssetProvider.overrideWithValue(feeAsset),
            availableBalanceForAssetIdProvider('asset1').overrideWithValue(1500),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
      });

      test('uses payjoinRadioButtonIndexProvider to select correct receiver', () {
        final feeAsset = Asset(assetId: 'asset2');
        final receiver1 = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final receiver2 = OutputsReceiver(assetId: 'asset2', satoshi: 2000);
        final outputsData = OutputsData(receivers: [receiver1, receiver2]);

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            payjoinRadioButtonIndexProvider.overrideWithValue(1),
            selectedInputsProvider.overrideWithValue([]),
            payjoinFeeAssetProvider.overrideWithValue(feeAsset),
            availableBalanceForAssetIdProvider('asset2').overrideWithValue(2000),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), true);
      });
    });

    group('setState', () {
      test('updates state value', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(deductFeeFromOutputProvider), false);
        container.read(deductFeeFromOutputProvider.notifier).setState(true);
        expect(container.read(deductFeeFromOutputProvider), true);
      });

      test('can toggle state multiple times', () {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(deductFeeFromOutputProvider.notifier).setState(true);
        expect(container.read(deductFeeFromOutputProvider), true);
        container.read(deductFeeFromOutputProvider.notifier).setState(false);
        expect(container.read(deductFeeFromOutputProvider), false);
      });
    });
  });

  group('liquidHaveBalance', () {
    test('returns true when selectedInputs is not empty and maxBalance > 0', () {
      final input = UtxosItem(assetId: 'lbtc', amount: 1000);
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([input]),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          maxAvailableBalanceWithInputsForAssetProvider('lbtc')
              .overrideWithValue(1500),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(liquidHaveBalanceProvider), true);
    });

    test('returns false when selectedInputs is not empty and maxBalance is 0', () {
      final input = UtxosItem(assetId: 'lbtc', amount: 0);
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([input]),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          maxAvailableBalanceWithInputsForAssetProvider('lbtc')
              .overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(liquidHaveBalanceProvider), false);
    });

    test('returns true when selectedInputs is empty and maxBalance > 0', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([]),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          availableBalanceForAssetIdProvider('lbtc').overrideWithValue(2000),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(liquidHaveBalanceProvider), true);
    });

    test('returns false when selectedInputs is empty and maxBalance is 0', () {
      final container = ProviderContainer.test(
        overrides: [
          selectedInputsProvider.overrideWithValue([]),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          availableBalanceForAssetIdProvider('lbtc').overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(liquidHaveBalanceProvider), false);
    });
  });

  group('PayjoinFeeAssetNotifier', () {
    group('build', () {
      test('returns null when payjoinFeeAssets is empty', () {
        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider.overrideWithValue([]),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(payjoinFeeAssetProvider), null);
      });

      test('returns lbtc when liquidHaveBalance is true', () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final otherAsset = Asset(assetId: 'asset1');

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, otherAsset]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(true),
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'lbtc');
      });

      test('returns lbtc when outputsData is null', () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final otherAsset = Asset(assetId: 'asset1');

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, otherAsset]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'lbtc');
      });

      test('returns lbtc when receivers is null', () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final outputsData = OutputsData(receivers: null);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'lbtc');
      });

      test('returns lbtc when any receiver is lbtc', () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final otherAsset = Asset(assetId: 'asset1');
        final receiver1 = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final receiver2 = OutputsReceiver(assetId: 'lbtc', satoshi: 500);
        final outputsData = OutputsData(receivers: [receiver1, receiver2]);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, otherAsset]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'lbtc');
      });

      test(
          'returns payjoin asset found in outputs when lbtc not in receivers',
          () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final payjoinAsset = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset1', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, payjoinAsset]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'asset1');
      });

      test(
          'returns first asset with balance when payjoin asset not in outputs and selectedInputs is not empty',
          () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final asset1 = Asset(assetId: 'asset1');
        final asset2 = Asset(assetId: 'asset2');
        final receiver = OutputsReceiver(assetId: 'asset3', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);
        final input = UtxosItem(assetId: 'asset1', amount: 1000);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider.overrideWithValue(
                [lbtcAsset, asset1, asset2]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            selectedInputsProvider.overrideWithValue([input]),
            maxAvailableBalanceWithInputsForAssetProvider('asset1')
                .overrideWithValue(1000),
            maxAvailableBalanceWithInputsForAssetProvider('asset2')
                .overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'asset1');
      });

      test(
          'returns lbtc when no payjoin asset has balance and selectedInputs is not empty',
          () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final asset1 = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset3', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);
        final input = UtxosItem(assetId: 'asset1', amount: 0);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, asset1]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            selectedInputsProvider.overrideWithValue([input]),
            maxAvailableBalanceWithInputsForAssetProvider('asset1')
                .overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'lbtc');
      });

      test(
          'returns first asset with balance when payjoin asset not in outputs and selectedInputs is empty',
          () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final asset1 = Asset(assetId: 'asset1');
        final asset2 = Asset(assetId: 'asset2');
        final receiver = OutputsReceiver(assetId: 'asset3', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider.overrideWithValue(
                [lbtcAsset, asset1, asset2]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            selectedInputsProvider.overrideWithValue([]),
            availableBalanceForAssetIdProvider('asset1').overrideWithValue(500),
            availableBalanceForAssetIdProvider('asset2').overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'asset1');
      });

      test(
          'returns lbtc when no payjoin asset has balance and selectedInputs is empty',
          () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final asset1 = Asset(assetId: 'asset1');
        final receiver = OutputsReceiver(assetId: 'asset3', satoshi: 1000);
        final outputsData = OutputsData(receivers: [receiver]);

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, asset1]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(false),
            outputsCreatorProvider.overrideWithValue(Right(outputsData)),
            selectedInputsProvider.overrideWithValue([]),
            availableBalanceForAssetIdProvider('asset1').overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(payjoinFeeAssetProvider);
        expect(result?.assetId, 'lbtc');
      });
    });

    group('setState', () {
      test('updates state when asset is in payjoinFeeAssets', () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final asset1 = Asset(assetId: 'asset1');

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, asset1]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(true),
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(payjoinFeeAssetProvider.notifier).setState(asset1);
        expect(container.read(payjoinFeeAssetProvider)?.assetId, 'asset1');
      });

      test('ignores setState when asset is not in payjoinFeeAssets', () {
        final lbtcAsset = Asset(assetId: 'lbtc');
        final asset1 = Asset(assetId: 'asset1');
        final asset2 = Asset(assetId: 'asset2');

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider
                .overrideWithValue([lbtcAsset, asset1]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(true),
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        final initialValue = container.read(payjoinFeeAssetProvider);
        container.read(payjoinFeeAssetProvider.notifier).setState(asset2);
        expect(container.read(payjoinFeeAssetProvider), initialValue);
      });

      test('ignores setState when asset is null (assetId cannot be null)', () {
        final lbtcAsset = Asset(assetId: 'lbtc');

        final container = ProviderContainer.test(
          overrides: [
            payjoinFeeAssetsProvider.overrideWithValue([lbtcAsset]),
            liquidAssetIdStateProvider.overrideWithValue('lbtc'),
            liquidHaveBalanceProvider.overrideWithValue(true),
            outputsCreatorProvider.overrideWithValue(
              left(const OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );
        addTearDown(container.dispose);

        final initialValue = container.read(payjoinFeeAssetProvider);
        container.read(payjoinFeeAssetProvider.notifier).setState(null);
        expect(container.read(payjoinFeeAssetProvider), initialValue);
      });
    });
  });

  group('payjoinAssets', () {
    test('returns all payjoin assets and lbtc', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset1 = Asset(assetId: 'asset1', payjoin: true);
      final payjoinAsset2 = Asset(assetId: 'asset2', payjoin: true);
      final nonPayjoinAsset = Asset(assetId: 'asset3', payjoin: false);

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset1,
            'asset2': payjoinAsset2,
            'asset3': nonPayjoinAsset,
          }),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinAssetsProvider);
      expect(result.map((e) => e.assetId), containsAll(['asset1', 'asset2']));
      expect(result.map((e) => e.assetId), contains('lbtc'));
      expect(result.map((e) => e.assetId), isNot(contains('asset3')));
    });

    test('removes assets that are not payjoin and not liquid', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset = Asset(assetId: 'asset1', payjoin: true);
      final nonPayjoinAsset = Asset(assetId: 'asset2', payjoin: false);

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset,
            'asset2': nonPayjoinAsset,
          }),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinAssetsProvider);
      expect(result.map((e) => e.assetId), isNot(contains('asset2')));
    });

    test('includes liquid asset even if payjoin is false', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset = Asset(assetId: 'asset1', payjoin: true);

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset,
          }),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinAssetsProvider);
      expect(result.map((e) => e.assetId), contains('lbtc'));
    });
  });

  group('payjoinFeeAssets', () {
    test('returns payjoin assets that are in account assets and lbtc', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset1 = Asset(assetId: 'asset1', payjoin: true);
      final payjoinAsset2 = Asset(assetId: 'asset2', payjoin: true);

      final accountAsset1 = AccountAsset(Account.REG, 'asset1');
      final accountAsset2 = AccountAsset(Account.REG, 'asset2');

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset1,
            'asset2': payjoinAsset2,
          }),
          allVisibleAccountAssetsProvider.overrideWithValue([
            accountAsset1,
            accountAsset2,
          ]),
          payjoinAssetsProvider.overrideWithValue([
            payjoinAsset1,
            payjoinAsset2,
          ]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinFeeAssetsProvider);
      expect(result.map((e) => e.assetId), containsAll(['asset1', 'asset2']));
      expect(result.map((e) => e.assetId), contains('lbtc'));
    });

    test('filters out payjoin assets not in account assets', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset1 = Asset(assetId: 'asset1', payjoin: true);
      final payjoinAsset2 = Asset(assetId: 'asset2', payjoin: true);

      final accountAsset1 = AccountAsset(Account.REG, 'asset1');

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset1,
            'asset2': payjoinAsset2,
          }),
          allVisibleAccountAssetsProvider.overrideWithValue([
            accountAsset1,
          ]),
          payjoinAssetsProvider.overrideWithValue([
            payjoinAsset1,
            payjoinAsset2,
          ]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinFeeAssetsProvider);
      expect(result.map((e) => e.assetId), contains('asset1'));
      expect(result.map((e) => e.assetId), isNot(contains('asset2')));
    });

    test('always includes lbtc even if not in payjoin assets', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset = Asset(assetId: 'asset1', payjoin: true);

      final accountAsset = AccountAsset(Account.REG, 'asset1');

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset,
          }),
          allVisibleAccountAssetsProvider.overrideWithValue([
            accountAsset,
          ]),
          payjoinAssetsProvider.overrideWithValue([
            payjoinAsset,
          ]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinFeeAssetsProvider);
      expect(result.map((e) => e.assetId), contains('lbtc'));
    });

    test('filters out account assets that are not REG account', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);
      final payjoinAsset1 = Asset(assetId: 'asset1', payjoin: true);
      final payjoinAsset2 = Asset(assetId: 'asset2', payjoin: true);

      final accountAsset1 = AccountAsset(Account.REG, 'asset1');
      final accountAsset2 = AccountAsset(Account.AMP_, 'asset2');

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
            'asset1': payjoinAsset1,
            'asset2': payjoinAsset2,
          }),
          allVisibleAccountAssetsProvider.overrideWithValue([
            accountAsset1,
            accountAsset2,
          ]),
          payjoinAssetsProvider.overrideWithValue([
            payjoinAsset1,
            payjoinAsset2,
          ]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinFeeAssetsProvider);
      expect(result.map((e) => e.assetId), contains('asset1'));
      expect(result.map((e) => e.assetId), isNot(contains('asset2')));
    });

    test('handles empty payjoin assets list', () {
      final lbtcAsset = Asset(assetId: 'lbtc', payjoin: false);

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          assetsStateProvider.overrideWithValue({
            'lbtc': lbtcAsset,
          }),
          allVisibleAccountAssetsProvider.overrideWithValue([]),
          payjoinAssetsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinFeeAssetsProvider);
      expect(result.map((e) => e.assetId), contains('lbtc'));
    });

    test('handles null liquidAsset in assetsState', () {
      final payjoinAsset = Asset(assetId: 'asset1', payjoin: true);
      final accountAsset = AccountAsset(Account.REG, 'asset1');

      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('missing-lbtc'),
          assetsStateProvider.overrideWithValue({
            'asset1': payjoinAsset,
          }),
          allVisibleAccountAssetsProvider.overrideWithValue([
            accountAsset,
          ]),
          payjoinAssetsProvider.overrideWithValue([
            payjoinAsset,
          ]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(payjoinFeeAssetsProvider);
      expect(result.map((e) => e.assetId), contains('asset1'));
    });
  });
}
