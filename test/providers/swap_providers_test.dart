import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

// ============================================================================
// Mocks
// ============================================================================

class MockSatoshiRepository extends Mock implements SatoshiRepository {}

class MockAssetUtils extends Mock implements AssetUtils {}

class MockAmountToString extends Mock implements AmountToString {}

class MockAsset extends Mock implements Asset {}

class MockSideswapWallet extends Mock implements SideswapWallet {}

class MockPegRepository extends Mock implements AbstractPegRepository {}

// ============================================================================
// Fixtures / Helper Functions
// ============================================================================

const bitcoinId = 'bitcoin';
const liquidId = 'liquid';
const tetherId = 'tether';
const otherId = 'other';

// ============================================================================
// Tests
// ============================================================================

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(AmountToStringParameters(amount: 0, precision: 8));
    registerFallbackValue(From_PegOutAmount());
    registerFallbackValue(To());
  });

  group('SwapType providers', () {
    group('swapType', () {
      test('returns pegIn when delivering bitcoin and receiving liquid', () {
        final container = ProviderContainer.test(
          overrides: [
            bitcoinAssetIdProvider.overrideWithValue(bitcoinId),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapDeliverAssetProvider.overrideWith(
              (ref) => const SwapAsset(
                assetId: bitcoinId,
                assetList: [bitcoinId, liquidId],
              ),
            ),
            swapReceiveAssetProvider.overrideWith(
              (ref) =>
                  const SwapAsset(assetId: liquidId, assetList: [liquidId]),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(swapTypeProvider), const SwapType.pegIn());
      });

      test('returns pegOut when delivering liquid and receiving bitcoin', () {
        final container = ProviderContainer.test(
          overrides: [
            bitcoinAssetIdProvider.overrideWithValue(bitcoinId),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapDeliverAssetProvider.overrideWith(
              (ref) => const SwapAsset(
                assetId: liquidId,
                assetList: [liquidId, bitcoinId],
              ),
            ),
            swapReceiveAssetProvider.overrideWith(
              (ref) =>
                  const SwapAsset(assetId: bitcoinId, assetList: [bitcoinId]),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(swapTypeProvider), const SwapType.pegOut());
      });

      test('returns atomic when neither peg in nor peg out', () {
        final container = ProviderContainer.test(
          overrides: [
            bitcoinAssetIdProvider.overrideWithValue(bitcoinId),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapDeliverAssetProvider.overrideWith(
              (ref) => const SwapAsset(
                assetId: tetherId,
                assetList: [tetherId, otherId],
              ),
            ),
            swapReceiveAssetProvider.overrideWith(
              (ref) => const SwapAsset(assetId: otherId, assetList: [otherId]),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(swapTypeProvider), const SwapType.atomic());
      });
    });

    group('swapTypeString', () {
      final cases = [
        (type: const SwapType.atomic(), expected: 'Swap'),
        (type: const SwapType.pegIn(), expected: 'Peg-In'),
        (type: const SwapType.pegOut(), expected: 'Peg-Out'),
      ];

      for (final c in cases) {
        test('returns "${c.expected}" for ${c.type}', () {
          final container = ProviderContainer.test(
            overrides: [swapTypeProvider.overrideWith((ref) => c.type)],
          );
          addTearDown(container.dispose);

          expect(container.read(swapTypeStringProvider), c.expected);
        });
      }
    });

    group('swapAddrType', () {
      final cases = [
        (type: const SwapType.pegOut(), expected: AddrType.bitcoin),
        (type: const SwapType.atomic(), expected: AddrType.elements),
        (type: const SwapType.pegIn(), expected: AddrType.elements),
      ];

      for (final c in cases) {
        test('returns ${c.expected} for ${c.type}', () {
          final container = ProviderContainer.test(
            overrides: [swapTypeProvider.overrideWith((ref) => c.type)],
          );
          addTearDown(container.dispose);

          expect(container.read(swapAddrTypeProvider), c.expected);
        });
      }
    });

    group('addrTypeString', () {
      final cases = [
        (addrType: AddrType.bitcoin, expected: 'Bitcoin'),
        (addrType: AddrType.elements, expected: 'Liquid'),
      ];

      for (final c in cases) {
        test('returns "${c.expected}" for ${c.addrType}', () {
          final container = ProviderContainer.test(
            overrides: [swapAddrTypeProvider.overrideWith((ref) => c.addrType)],
          );
          addTearDown(container.dispose);

          expect(container.read(addrTypeStringProvider), c.expected);
        });
      }
    });
  });

  group('swapDeliverAssetIdList', () {
    test('returns bitcoin and liquid when swapPeg is true', () {
      final container = ProviderContainer.test(
        overrides: [
          swapPegProvider.overrideWithBuild((ref, n) => true),
          liquidAssetIdStateProvider.overrideWithValue(liquidId),
          bitcoinAssetIdProvider.overrideWithValue(bitcoinId),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapDeliverAssetIdListProvider);
      expect(result, containsAll([bitcoinId, liquidId]));
    });

    test(
      'filters assets by instantSwaps and includes liquidAssetId when swapPeg is false',
      () {
        final mockAsset1 = MockAsset();
        final mockAsset2 = MockAsset();
        final mockAsset3 = MockAsset();

        when(() => mockAsset1.instantSwaps).thenReturn(true);
        when(() => mockAsset2.instantSwaps).thenReturn(true);
        when(() => mockAsset3.instantSwaps).thenReturn(false);

        final container = ProviderContainer.test(
          overrides: [
            swapPegProvider.overrideWithBuild((ref, n) => false),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            assetsStateProvider.overrideWithValue({
              liquidId: mockAsset1,
              tetherId: mockAsset2,
              otherId: mockAsset3,
            }),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(swapDeliverAssetIdListProvider);
        expect(result, containsAll([liquidId, tetherId]));
        expect(result, isNot(contains(otherId)));
      },
    );
  });

  group('swapDeliverAsset', () {
    test('creates SwapAsset with swapSendAssetId and assetList', () {
      final container = ProviderContainer.test(
        overrides: [
          swapSendAssetIdProvider.overrideWithBuild((ref, n) => tetherId),
          swapDeliverAssetIdListProvider.overrideWithValue([tetherId, otherId]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapDeliverAssetProvider);
      expect(result.assetId, tetherId);
      expect(result.assetList, containsAll([tetherId, otherId]));
    });
  });

  group('swapReceiveAssetIdList', () {
    test(
      'returns bitcoinAssetId when swapPeg and swapSendAssetId == liquidAssetId',
      () {
        final container = ProviderContainer.test(
          overrides: [
            swapPegProvider.overrideWithBuild((ref, n) => true),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            bitcoinAssetIdProvider.overrideWithValue(bitcoinId),
            swapSendAssetIdProvider.overrideWithBuild((ref, n) => liquidId),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(swapReceiveAssetIdListProvider);
        expect(result.single, bitcoinId);
      },
    );

    test(
      'returns liquidAssetId when swapPeg and swapSendAssetId != liquidAssetId',
      () {
        final container = ProviderContainer.test(
          overrides: [
            swapPegProvider.overrideWithBuild((ref, n) => true),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapSendAssetIdProvider.overrideWithBuild((ref, n) => bitcoinId),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(swapReceiveAssetIdListProvider);
        expect(result.single, liquidId);
      },
    );

    test(
      'returns liquidAssetId when swapSendAssetId != liquidAssetId and not pegSwap',
      () {
        final container = ProviderContainer.test(
          overrides: [
            swapPegProvider.overrideWithBuild((ref, n) => false),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapSendAssetIdProvider.overrideWithBuild((ref, n) => tetherId),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(swapReceiveAssetIdListProvider);
        expect(result.single, liquidId);
      },
    );

    test(
      'returns instantSwaps assets when swapSendAssetId == liquidAssetId and not pegSwap',
      () {
        final mockAsset1 = MockAsset();
        final mockAsset2 = MockAsset();
        final mockAsset3 = MockAsset();

        when(() => mockAsset1.instantSwaps).thenReturn(true);
        when(() => mockAsset2.instantSwaps).thenReturn(true);
        when(() => mockAsset3.instantSwaps).thenReturn(false);

        final container = ProviderContainer.test(
          overrides: [
            swapPegProvider.overrideWithBuild((ref, n) => false),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapSendAssetIdProvider.overrideWithBuild((ref, n) => liquidId),
            assetsStateProvider.overrideWithValue({
              tetherId: mockAsset1,
              otherId: mockAsset2,
              bitcoinId: mockAsset3,
            }),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(swapReceiveAssetIdListProvider);
        expect(result, containsAll([tetherId, otherId]));
        expect(result, isNot(contains(bitcoinId)));
      },
    );
  });

  group('swapReceiveAsset', () {
    test('returns first asset from list when swapPeg is true', () {
      final container = ProviderContainer.test(
        overrides: [
          swapPegProvider.overrideWithBuild((ref, n) => true),
          liquidAssetIdStateProvider.overrideWithValue(liquidId),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(
              assetId: bitcoinId,
              assetList: [bitcoinId, liquidId],
            ),
          ),
          swapReceiveAssetIdListProvider.overrideWithValue([bitcoinId]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapReceiveAssetProvider);
      expect(result.assetId, bitcoinId);
    });

    test('returns first asset when deliverAsset != liquidAssetId', () {
      final container = ProviderContainer.test(
        overrides: [
          swapPegProvider.overrideWithBuild((ref, n) => false),
          liquidAssetIdStateProvider.overrideWithValue(liquidId),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: tetherId, assetList: [tetherId]),
          ),
          swapReceiveAssetIdListProvider.overrideWithValue([liquidId, otherId]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapReceiveAssetProvider);
      expect(result.assetId, liquidId);
    });

    test(
      'returns swapRecvAssetId when deliverAsset == liquidAssetId and not pegSwap',
      () {
        final container = ProviderContainer.test(
          overrides: [
            swapPegProvider.overrideWithBuild((ref, n) => false),
            liquidAssetIdStateProvider.overrideWithValue(liquidId),
            swapDeliverAssetProvider.overrideWith(
              (ref) =>
                  const SwapAsset(assetId: liquidId, assetList: [liquidId]),
            ),
            swapRecvAssetIdProvider.overrideWithBuild((ref, n) => tetherId),
            swapReceiveAssetIdListProvider.overrideWithValue([
              tetherId,
              otherId,
            ]),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(swapReceiveAssetProvider);
        expect(result.assetId, tetherId);
      },
    );
  });

  group('Swap wallet providers', () {
    group('swapSendWallet', () {
      final cases = [
        (type: const SwapType.atomic(), expected: const SwapWallet.local()),
        (type: const SwapType.pegIn(), expected: const SwapWallet.extern()),
        (type: const SwapType.pegOut(), expected: const SwapWallet.local()),
      ];

      for (final c in cases) {
        test('returns ${c.expected} for ${c.type}', () {
          final container = ProviderContainer.test(
            overrides: [swapTypeProvider.overrideWith((ref) => c.type)],
          );
          addTearDown(container.dispose);

          expect(container.read(swapSendWalletProvider), c.expected);
        });
      }
    });

    group('swapRecvWallet', () {
      final cases = [
        (type: const SwapType.atomic(), expected: const SwapWallet.local()),
        (type: const SwapType.pegIn(), expected: const SwapWallet.local()),
        (type: const SwapType.pegOut(), expected: const SwapWallet.extern()),
      ];

      for (final c in cases) {
        test('returns ${c.expected} for ${c.type}', () {
          final container = ProviderContainer.test(
            overrides: [swapTypeProvider.overrideWith((ref) => c.type)],
          );
          addTearDown(container.dispose);

          expect(container.read(swapRecvWalletProvider), c.expected);
        });
      }
    });
  });

  group('SwapPegAddressServerNotifier', () {
    test('starts null and accepts new address via setState', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(swapPegAddressServerProvider), isNull);
      container
          .read(swapPegAddressServerProvider.notifier)
          .setState('peg-addr');
      expect(container.read(swapPegAddressServerProvider), 'peg-addr');
    });
  });

  group('BitcoinCurrentFeeRateNotifier', () {
    test('build returns Option.of(1.0) and setFeeRate updates it', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(bitcoinCurrentFeeRateProvider), const Some(1.0));
      container.read(bitcoinCurrentFeeRateProvider.notifier).setFeeRate(5.0);
      expect(container.read(bitcoinCurrentFeeRateProvider), const Some(5.0));
    });
  });

  group('swapSendSatoshiAmount', () {
    test('returns 0 when sendAmount is empty', () {
      final container = ProviderContainer.test(
        overrides: [swapSendTextAmountProvider.overrideWithValue('')],
      );
      addTearDown(container.dispose);

      expect(container.read(swapSendSatoshiAmountProvider), 0);
    });

    test('calls satoshiRepository to convert amount', () {
      final mockRepo = MockSatoshiRepository();
      when(
        () => mockRepo.satoshiForAmount(
          assetId: any(named: 'assetId'),
          amount: any(named: 'amount'),
        ),
      ).thenReturn(100);

      final container = ProviderContainer.test(
        overrides: [
          swapSendTextAmountProvider.overrideWithValue('0.001'),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: liquidId, assetList: [liquidId]),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapSendSatoshiAmountProvider);

      expect(result, 100);
      verify(
        () => mockRepo.satoshiForAmount(assetId: liquidId, amount: '0.001'),
      ).called(1);
    });
  });

  group('swapRecvSatoshiAmount', () {
    test('returns 0 when recvAmount is empty', () {
      final container = ProviderContainer.test(
        overrides: [swapRecvTextAmountProvider.overrideWithValue('')],
      );
      addTearDown(container.dispose);

      expect(container.read(swapRecvSatoshiAmountProvider), 0);
    });

    test('calls satoshiRepository to convert amount', () {
      final mockRepo = MockSatoshiRepository();
      when(
        () => mockRepo.satoshiForAmount(
          assetId: any(named: 'assetId'),
          amount: any(named: 'amount'),
        ),
      ).thenReturn(200);

      final container = ProviderContainer.test(
        overrides: [
          swapRecvTextAmountProvider.overrideWithValue('0.002'),
          swapReceiveAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: tetherId, assetList: [tetherId]),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapRecvSatoshiAmountProvider);

      expect(result, 200);
      verify(
        () => mockRepo.satoshiForAmount(assetId: tetherId, amount: '0.002'),
      ).called(1);
    });
  });

  group('showInsufficientFunds', () {
    test('returns false when serverError is not empty', () {
      final container = ProviderContainer.test(
        overrides: [
          swapNetworkErrorProvider.overrideWithBuild((ref, n) => 'Some error'),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showInsufficientFundsProvider), false);
    });

    test('returns false when satoshiAmount is 0', () {
      final container = ProviderContainer.test(
        overrides: [
          swapNetworkErrorProvider.overrideWithBuild((ref, n) => ''),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: liquidId, assetList: [liquidId]),
          ),
          assetBalanceProvider.overrideWithValue({liquidId: 1000}),
          swapSendSatoshiAmountProvider.overrideWith((ref) => 0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showInsufficientFundsProvider), false);
    });

    test('returns false when satoshiAmount <= assetBalance', () {
      final container = ProviderContainer.test(
        overrides: [
          swapNetworkErrorProvider.overrideWithBuild((ref, n) => ''),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: liquidId, assetList: [liquidId]),
          ),
          assetBalanceProvider.overrideWithValue({liquidId: 1000}),
          swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showInsufficientFundsProvider), false);
    });

    test('returns true when satoshiAmount > assetBalance', () {
      final container = ProviderContainer.test(
        overrides: [
          swapNetworkErrorProvider.overrideWithBuild((ref, n) => ''),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: liquidId, assetList: [liquidId]),
          ),
          assetBalanceProvider.overrideWithValue({liquidId: 100}),
          swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showInsufficientFundsProvider), true);
    });

    test('returns true when asset balance is null (defaults to 0)', () {
      final container = ProviderContainer.test(
        overrides: [
          swapNetworkErrorProvider.overrideWithBuild((ref, n) => ''),
          swapDeliverAssetProvider.overrideWith(
            (ref) => const SwapAsset(assetId: liquidId, assetList: [liquidId]),
          ),
          assetBalanceProvider.overrideWithValue({}),
          swapSendSatoshiAmountProvider.overrideWith((ref) => 100),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showInsufficientFundsProvider), true);
    });
  });

  // Amount price stream watchers group removed — providers were dead code
  // (satoshiRecvAmountState/satoshiSendAmountState never set externally)

  group('swapPriceText', () {
    test('returns none when pegInServerFeePercent is 0', () {
      final container = ProviderContainer.test(
        overrides: [
          swapTypeProvider.overrideWith((ref) => const SwapType.pegIn()),
          pegInServerFeePercentProvider.overrideWithValue(0),
          pegOutServerFeePercentProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapPriceTextProvider);
      expect(result.isNone(), true);
    });

    test('returns conversion rate text for pegIn with fee percent', () {
      final container = ProviderContainer.test(
        overrides: [
          swapTypeProvider.overrideWith((ref) => const SwapType.pegIn()),
          pegInServerFeePercentProvider.overrideWithValue(2),
          pegOutServerFeePercentProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapPriceTextProvider);
      expect(result.isSome(), true);
      expect(result.getOrElse(() => ''), 'Conversion rate 98.00%');
    });

    test('returns conversion rate text for pegOut with fee percent', () {
      final container = ProviderContainer.test(
        overrides: [
          swapTypeProvider.overrideWith((ref) => const SwapType.pegOut()),
          pegInServerFeePercentProvider.overrideWithValue(0),
          pegOutServerFeePercentProvider.overrideWithValue(3),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(swapPriceTextProvider);
      expect(result.isSome(), true);
      expect(result.getOrElse(() => ''), 'Conversion rate 97.00%');
    });
  });

  group('swapAddressError', () {
    test('returns null when address is empty', () {
      final container = ProviderContainer.test(
        overrides: [swapRecvAddressExternalProvider.overrideWithValue('')],
      );
      addTearDown(container.dispose);

      expect(container.read(swapAddressErrorProvider), null);
    });

    test('returns null when address is valid', () {
      final container = ProviderContainer.test(
        overrides: [
          swapRecvAddressExternalProvider.overrideWithValue('valid_address'),
          isAddrTypeValidProvider(
            'valid_address',
            AddrType.bitcoin,
          ).overrideWith((ref) => true),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(swapAddressErrorProvider), null);
    });

    test('returns error text when address is invalid', () {
      final container = ProviderContainer.test(
        overrides: [
          swapRecvAddressExternalProvider.overrideWithValue('invalid_address'),
          isAddrTypeValidProvider(
            'invalid_address',
            AddrType.bitcoin,
          ).overrideWith((ref) => false),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(swapAddressErrorProvider), 'Wrong address');
    });
  });

  group('showAddressLabel', () {
    test('returns false when address is empty', () {
      final container = ProviderContainer.test(
        overrides: [swapRecvAddressExternalProvider.overrideWithValue('')],
      );
      addTearDown(container.dispose);

      expect(container.read(showAddressLabelProvider), false);
    });

    test('returns true when address is valid', () {
      final container = ProviderContainer.test(
        overrides: [
          swapRecvAddressExternalProvider.overrideWithValue('valid_address'),
          isAddrTypeValidProvider(
            'valid_address',
            AddrType.bitcoin,
          ).overrideWith((ref) => true),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showAddressLabelProvider), true);
    });

    test('returns false when address is invalid', () {
      final container = ProviderContainer.test(
        overrides: [
          swapRecvAddressExternalProvider.overrideWithValue('invalid_address'),
          isAddrTypeValidProvider(
            'invalid_address',
            AddrType.bitcoin,
          ).overrideWith((ref) => false),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(showAddressLabelProvider), false);
    });
  });

  group('swapEnabledState', () {
    test('returns false when swapState is not idle', () {
      final container = ProviderContainer.test(
        overrides: [
          swapStateProvider.overrideWithBuild(
            (ref, n) => const SwapState.sent(),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(swapEnabledStateProvider), false);
    });

    group('atomic swap', () {
      final atomicCases = [
        (
          name: 'returns true when amounts positive and no insufficient funds',
          sendAmt: 100,
          recvAmt: 100,
          insufficientFunds: false,
          expected: true,
        ),
        (
          name: 'returns false when send amount is zero',
          sendAmt: 0,
          recvAmt: 100,
          insufficientFunds: false,
          expected: false,
        ),
        (
          name: 'returns false when recv amount is zero',
          sendAmt: 100,
          recvAmt: 0,
          insufficientFunds: false,
          expected: false,
        ),
        (
          name: 'returns false when insufficient funds',
          sendAmt: 100,
          recvAmt: 100,
          insufficientFunds: true,
          expected: false,
        ),
      ];

      for (final c in atomicCases) {
        test(c.name, () {
          final container = ProviderContainer.test(
            overrides: [
              swapStateProvider.overrideWithBuild(
                (ref, n) => const SwapState.idle(),
              ),
              swapTypeProvider.overrideWith((ref) => const SwapType.atomic()),
              swapSendSatoshiAmountProvider.overrideWith((ref) => c.sendAmt),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => c.recvAmt),
              showInsufficientFundsProvider.overrideWith(
                (ref) => c.insufficientFunds,
              ),
            ],
          );
          addTearDown(container.dispose);

          expect(container.read(swapEnabledStateProvider), c.expected);
        });
      }
    });

    test('returns true for pegIn regardless of other conditions', () {
      final container = ProviderContainer.test(
        overrides: [
          swapStateProvider.overrideWithBuild(
            (ref, n) => const SwapState.idle(),
          ),
          swapTypeProvider.overrideWith((ref) => const SwapType.pegIn()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(swapEnabledStateProvider), true);
    });

    group('pegOut swap', () {
      final pegOutCases = [
        (
          name: 'returns true with valid conditions',
          sendAmt: 100,
          insufficientFunds: false,
          address: 'valid_addr',
          addressError: null,
          expected: true,
        ),
        (
          name: 'returns false when send amount is zero',
          sendAmt: 0,
          insufficientFunds: false,
          address: 'valid_addr',
          addressError: null,
          expected: false,
        ),
        (
          name: 'returns false when insufficient funds',
          sendAmt: 100,
          insufficientFunds: true,
          address: 'valid_addr',
          addressError: null,
          expected: false,
        ),
        (
          name: 'returns false when address is empty',
          sendAmt: 100,
          insufficientFunds: false,
          address: '',
          addressError: null,
          expected: false,
        ),
        (
          name: 'returns false when address has error',
          sendAmt: 100,
          insufficientFunds: false,
          address: 'invalid_addr',
          addressError: 'Wrong address',
          expected: false,
        ),
      ];

      for (final c in pegOutCases) {
        test(c.name, () {
          final container = ProviderContainer.test(
            overrides: [
              swapStateProvider.overrideWithBuild(
                (ref, n) => const SwapState.idle(),
              ),
              swapTypeProvider.overrideWith((ref) => const SwapType.pegOut()),
              swapSendSatoshiAmountProvider.overrideWith((ref) => c.sendAmt),
              showInsufficientFundsProvider.overrideWith(
                (ref) => c.insufficientFunds,
              ),
              swapRecvAddressExternalProvider.overrideWithValue(c.address),
              swapAddressErrorProvider.overrideWith((ref) => c.addressError),
            ],
          );
          addTearDown(container.dispose);

          expect(container.read(swapEnabledStateProvider), c.expected);
        });
      }
    });
  });

  group('swapHelper', () {
    test('setSelectedLeftAsset updates swapSendAssetIdProvider', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final helper = container.read(swapHelperProvider);
      final sub = container.listen(
        swapSendAssetIdProvider,
        (previous, next) {},
      );

      // dirty side-effect providers to prove invalidation
      container.read(swapNetworkErrorProvider.notifier).setState('some error');
      container
          .read(swapStateProvider.notifier)
          .setState(const SwapState.sent());

      helper.setSelectedLeftAsset('new-asset-left');

      expect(sub.read(), 'new-asset-left');

      // side effects from swapReset() → clearNetworkStates()
      expect(container.read(swapNetworkErrorProvider), '');
      expect(container.read(swapStateProvider), const SwapState.idle());
    });

    test('setSelectedRightAsset updates swapRecvAssetIdProvider', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final helper = container.read(swapHelperProvider);
      final sub = container.listen(
        swapRecvAssetIdProvider,
        (previous, next) {},
      );

      // dirty side-effect providers to prove invalidation
      container.read(swapNetworkErrorProvider.notifier).setState('some error');
      container
          .read(swapStateProvider.notifier)
          .setState(const SwapState.sent());

      helper.setSelectedRightAsset('new-asset-right');

      expect(sub.read(), 'new-asset-right');

      // side effects from swapReset() → clearNetworkStates()
      expect(container.read(swapNetworkErrorProvider), '');
      expect(container.read(swapStateProvider), const SwapState.idle());
    });

    group('onPegOutAmountReceived', () {
      test('sets error message when errorMsg result received', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final errorMsg = From_PegOutAmount()..errorMsg = 'Test error message';
        final sub = container.listen(
          swapNetworkErrorProvider,
          (previous, next) {},
        );

        helper.onPegOutAmountReceived(errorMsg);

        expect(sub.read(), 'Test error message');
      });

      test('throws when notSet result received', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final notSetMsg = From_PegOutAmount();

        expect(() => helper.onPegOutAmountReceived(notSetMsg), throwsException);
      });

      test('sets recv amount when isSendEntered is true', () {
        final mockAmountToString = MockAmountToString();
        when(
          () => mockAmountToString.amountToString(any()),
        ).thenReturn('100000');

        final container = ProviderContainer.test(
          overrides: [
            amountToStringProvider.overrideWithValue(mockAmountToString),
          ],
        );
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final pegOutAmount = From_PegOutAmount()
          ..amounts = (From_PegOutAmount_Amounts()
            ..isSendEntered = true
            ..recvAmount = Int64(100000)
            ..sendAmount = Int64(50000));
        final recvSub = container.listen(
          swapRecvTextAmountProvider,
          (previous, next) {},
        );

        helper.onPegOutAmountReceived(pegOutAmount);

        expect(recvSub.read(), '100000');
      });

      test('sets send amount when isSendEntered is false', () {
        final mockAmountToString = MockAmountToString();
        when(
          () => mockAmountToString.amountToString(any()),
        ).thenReturn('50000');

        final container = ProviderContainer.test(
          overrides: [
            amountToStringProvider.overrideWithValue(mockAmountToString),
          ],
        );
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final pegOutAmount = From_PegOutAmount()
          ..amounts = (From_PegOutAmount_Amounts()
            ..isSendEntered = false
            ..recvAmount = Int64(100000)
            ..sendAmount = Int64(50000));
        final sendSub = container.listen(
          swapSendTextAmountProvider,
          (previous, next) {},
        );

        helper.onPegOutAmountReceived(pegOutAmount);

        expect(sendSub.read(), '50000');
      });
    });

    group('setDeliverAsset', () {
      test('updates swapSendAssetIdProvider with new asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final sub = container.listen(
          swapSendAssetIdProvider,
          (previous, next) {},
        );

        // dirty side-effect providers to prove invalidation via clearAmounts()
        container.read(swapNetworkErrorProvider.notifier).setState('net error');
        container
            .read(swapStateProvider.notifier)
            .setState(const SwapState.sent());
        container.read(swapSendTextAmountProvider.notifier).setAmount('1.5');
        container.read(swapRecvTextAmountProvider.notifier).setAmount('2.5');
        container.read(swapPriceSubscribeProvider.notifier).setSend();

        helper.setDeliverAsset('new-deliver-asset');

        expect(sub.read(), 'new-deliver-asset');

        // side effects from clearAmounts() → clearNetworkStates()
        expect(container.read(swapNetworkErrorProvider), '');
        expect(container.read(swapStateProvider), const SwapState.idle());
        // side effects from clearAmounts() directly
        expect(container.read(swapSendTextAmountProvider), '');
        expect(container.read(swapRecvTextAmountProvider), '');
        expect(
          container.read(swapPriceSubscribeProvider),
          const SwapPriceSubscribeState.empty(),
        );
      });
    });

    group('setReceiveAsset', () {
      test('updates swapRecvAssetIdProvider with new asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final sub = container.listen(
          swapRecvAssetIdProvider,
          (previous, next) {},
        );

        // dirty side-effect providers to prove invalidation via clearAmounts()
        container.read(swapNetworkErrorProvider.notifier).setState('net error');
        container
            .read(swapStateProvider.notifier)
            .setState(const SwapState.sent());
        container.read(swapSendTextAmountProvider.notifier).setAmount('1.5');
        container.read(swapRecvTextAmountProvider.notifier).setAmount('2.5');
        container.read(swapPriceSubscribeProvider.notifier).setRecv();

        helper.setReceiveAsset('new-receive-asset');

        expect(sub.read(), 'new-receive-asset');

        // side effects from clearAmounts() → clearNetworkStates()
        expect(container.read(swapNetworkErrorProvider), '');
        expect(container.read(swapStateProvider), const SwapState.idle());
        // side effects from clearAmounts() directly
        expect(container.read(swapSendTextAmountProvider), '');
        expect(container.read(swapRecvTextAmountProvider), '');
        expect(
          container.read(swapPriceSubscribeProvider),
          const SwapPriceSubscribeState.empty(),
        );
      });
    });

    group('toggleAssets', () {
      test('swaps deliver and receive assets', () {
        final container = ProviderContainer.test(
          overrides: [
            swapDeliverAssetProvider.overrideWith(
              (ref) => const SwapAsset(
                assetId: bitcoinId,
                assetList: [bitcoinId, liquidId],
              ),
            ),
            swapReceiveAssetProvider.overrideWith(
              (ref) =>
                  const SwapAsset(assetId: liquidId, assetList: [liquidId]),
            ),
          ],
        );
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final sendSub = container.listen(
          swapSendAssetIdProvider,
          (previous, next) {},
        );
        final recvSub = container.listen(
          swapRecvAssetIdProvider,
          (previous, next) {},
        );
        final recvAddressSub = container.listen(
          swapRecvAddressExternalProvider,
          (previous, next) {},
        );

        // pre-set recvAddress to non-default value
        container
            .read(swapRecvAddressExternalProvider.notifier)
            .setState('some_address');

        helper.toggleAssets();

        expect(sendSub.read(), liquidId);
        expect(recvSub.read(), bitcoinId);
        // verify swapRecvAddressExternalProvider was invalidated
        expect(recvAddressSub.read(), '');
      });
    });

    group('pegStop', () {
      test('calls swapReset and sets pageStatus to registered', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final pageStatusSub = container.listen(
          pageStatusProvider,
          (previous, next) {},
        );

        // dirty side-effect providers to prove invalidation via swapReset()
        container.read(swapNetworkErrorProvider.notifier).setState('net error');
        container
            .read(swapStateProvider.notifier)
            .setState(const SwapState.sent());

        helper.pegStop();

        // verify swapReset() invalidated network/satoshi providers
        expect(container.read(swapNetworkErrorProvider), '');
        expect(container.read(swapStateProvider), const SwapState.idle());

        // verify pageStatus set to registered
        expect(pageStatusSub.read(), Status.registered);
      });
    });

    group('switchToSwaps', () {
      test('invalidates all swap providers and resets state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final pegSub = container.listen(swapPegProvider, (previous, next) {});
        final sendAssetSub = container.listen(
          swapSendAssetIdProvider,
          (previous, next) {},
        );
        final recvAssetSub = container.listen(
          swapRecvAssetIdProvider,
          (previous, next) {},
        );
        final recvAddressSub = container.listen(
          swapRecvAddressExternalProvider,
          (previous, next) {},
        );

        // dirty side-effect providers from swapReset() → clearNetworkStates()
        container.read(swapNetworkErrorProvider.notifier).setState('net error');
        container
            .read(swapStateProvider.notifier)
            .setState(const SwapState.sent());

        // dirty side-effect providers from clearAmounts()
        container.read(swapSendTextAmountProvider.notifier).setAmount('1.5');
        container.read(swapRecvTextAmountProvider.notifier).setAmount('2.5');
        container.read(swapPriceSubscribeProvider.notifier).setSend();

        // dirty providers to be invalidated directly
        container.read(swapPegProvider.notifier).setState(true);
        container.read(swapSendAssetIdProvider.notifier).setState('old-send');
        container.read(swapRecvAssetIdProvider.notifier).setState('old-recv');
        container
            .read(swapRecvAddressExternalProvider.notifier)
            .setState('old-address');

        helper.switchToSwaps();

        // verify direct invalidations returned to defaults
        expect(pegSub.read(), false);
        expect(sendAssetSub.read(), '');
        expect(recvAssetSub.read(), '');
        expect(recvAddressSub.read(), '');

        // verify clearAmounts() invalidations
        expect(container.read(swapSendTextAmountProvider), '');
        expect(container.read(swapRecvTextAmountProvider), '');
        expect(
          container.read(swapPriceSubscribeProvider),
          const SwapPriceSubscribeState.empty(),
        );

        // verify swapReset() invalidations via clearNetworkStates()
        expect(container.read(swapNetworkErrorProvider), '');
        expect(container.read(swapStateProvider), const SwapState.idle());
      });
    });

    group('switchToPegs', () {
      test('sets peg mode, updates send asset, and resets all swap state', () {
        final container = ProviderContainer.test(
          overrides: [bitcoinAssetIdProvider.overrideWithValue(bitcoinId)],
        );
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final pegSub = container.listen(swapPegProvider, (previous, next) {});
        final sendAssetSub = container.listen(
          swapSendAssetIdProvider,
          (previous, next) {},
        );
        final recvAddressSub = container.listen(
          swapRecvAddressExternalProvider,
          (previous, next) {},
        );

        // pre-set side-effect providers to non-defaults
        container
            .read(swapRecvAddressExternalProvider.notifier)
            .setState('some-address');
        container.read(swapSendTextAmountProvider.notifier).setAmount('100');
        container.read(swapRecvTextAmountProvider.notifier).setAmount('200');
        container.read(swapNetworkErrorProvider.notifier).setState('error');
        container
            .read(swapStateProvider.notifier)
            .setState(const SwapState.sent());

        helper.switchToPegs();

        expect(pegSub.read(), true);
        expect(sendAssetSub.read(), bitcoinId);
        expect(recvAddressSub.read(), '');
        expect(container.read(swapSendTextAmountProvider), '');
        expect(container.read(swapRecvTextAmountProvider), '');
        expect(container.read(swapNetworkErrorProvider), '');
        expect(container.read(swapStateProvider), const SwapState.idle());
      });
    });

    group('selectSwap', () {
      test('sets pageStatus to registered and navigates to swap tab', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final pageStatusSub = container.listen(
          pageStatusProvider,
          (previous, next) {},
        );
        final uiArgsSub = container.listen(
          uiStateArgsProvider,
          (previous, next) {},
        );

        helper.selectSwap();

        expect(pageStatusSub.read(), Status.registered);
        final args = uiArgsSub.read();
        expect(args.currentIndex, 3);
        expect(args.navigationItemEnum, WalletMainNavigationItemEnum.swap);
      });
    });

    group('onMaxSendPressed', () {
      test('sets send amount to balance and triggers getPegOutAmount', () {
        final mockUtils = MockAssetUtils();
        final mockAmountToString = MockAmountToString();
        final mockPegRepository = MockPegRepository();

        when(
          () => mockUtils.getPrecisionForAssetId(assetId: liquidId),
        ).thenReturn(8);
        when(
          () => mockAmountToString.amountToString(any()),
        ).thenReturn('1.23456789');
        when(() => mockPegRepository.getPegOutAmount()).thenReturn(null);

        final container = ProviderContainer.test(
          overrides: [
            swapDeliverAssetProvider.overrideWith(
              (ref) =>
                  const SwapAsset(assetId: liquidId, assetList: [liquidId]),
            ),
            assetUtilsProvider.overrideWithValue(mockUtils),
            assetBalanceProvider.overrideWith((ref) => {liquidId: 123456789}),
            amountToStringProvider.overrideWithValue(mockAmountToString),
            pegRepositoryProvider.overrideWith((ref) => mockPegRepository),
          ],
        );
        addTearDown(container.dispose);

        final helper = container.read(swapHelperProvider);
        final sendAmountSub = container.listen(
          swapSendTextAmountProvider,
          (previous, next) {},
        );
        final subscribeStateSub = container.listen(
          swapPriceSubscribeProvider,
          (previous, next) {},
        );

        helper.onMaxSendPressed();

        expect(sendAmountSub.read(), '1.23456789');
        expect(subscribeStateSub.read(), const SwapPriceSubscribeState.send());
        verify(() => mockPegRepository.getPegOutAmount()).called(1);
      });
    });

    group('swapAccept', () {
      test('shows error when sendAmount invalid and type is not pegIn', () {
        fakeAsync((async) {
          final mockWallet = MockSideswapWallet();

          final container = ProviderContainer.test(
            overrides: [
              swapSendSatoshiAmountProvider.overrideWith((ref) => 0),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => 0),
              swapTypeProvider.overrideWith((ref) => const SwapType.atomic()),
              swapSendWalletProvider.overrideWith(
                (ref) => const SwapWallet.local(),
              ),
              swapDeliverAssetProvider.overrideWith(
                (ref) =>
                    const SwapAsset(assetId: liquidId, assetList: [liquidId]),
              ),
              assetBalanceProvider.overrideWith((ref) => {liquidId: 1000}),
              walletProvider.overrideWith((ref) => mockWallet),
              utilsProvider.overrideWith(
                (ref) =>
                    UtilsProvider(ref, presenter: _AlwaysNoOpDialogPresenter()),
              ),
            ],
          );
          addTearDown(container.dispose);

          container.read(swapHelperProvider).swapAccept();
          async.flushMicrotasks();

          verifyNever(() => mockWallet.sendMsg(any()));
        });
      });

      test('shows error when pegOut address is invalid', () {
        fakeAsync((async) {
          final mockWallet = MockSideswapWallet();

          final container = ProviderContainer.test(
            overrides: [
              swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => 100),
              swapTypeProvider.overrideWith((ref) => const SwapType.pegOut()),
              swapSendWalletProvider.overrideWith(
                (ref) => const SwapWallet.local(),
              ),
              swapDeliverAssetProvider.overrideWith(
                (ref) =>
                    const SwapAsset(assetId: liquidId, assetList: [liquidId]),
              ),
              assetBalanceProvider.overrideWith((ref) => {liquidId: 10000}),
              swapAddrTypeProvider.overrideWith((ref) => AddrType.bitcoin),
              swapRecvAddressExternalProvider.overrideWithValue('bad_address'),
              addrTypeStringProvider.overrideWith((ref) => 'Bitcoin'),
              isAddrTypeValidProvider(
                'bad_address',
                AddrType.bitcoin,
              ).overrideWith((ref) => false),
              walletProvider.overrideWith((ref) => mockWallet),
              utilsProvider.overrideWith(
                (ref) =>
                    UtilsProvider(ref, presenter: _AlwaysNoOpDialogPresenter()),
              ),
            ],
          );
          addTearDown(container.dispose);

          container.read(swapHelperProvider).swapAccept();
          async.flushMicrotasks();

          verifyNever(() => mockWallet.sendMsg(any()));
        });
      });

      test('returns early when auth fails', () {
        fakeAsync((async) {
          final mockWallet = MockSideswapWallet();
          when(
            () => mockWallet.isAuthenticated(),
          ).thenAnswer((_) async => false);

          final container = ProviderContainer.test(
            overrides: [
              swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => 100),
              swapTypeProvider.overrideWith((ref) => const SwapType.pegIn()),
              swapSendWalletProvider.overrideWith(
                (ref) => const SwapWallet.extern(),
              ),
              swapDeliverAssetProvider.overrideWith(
                (ref) =>
                    const SwapAsset(assetId: bitcoinId, assetList: [bitcoinId]),
              ),
              assetBalanceProvider.overrideWith((ref) => {}),
              walletProvider.overrideWith((ref) => mockWallet),
            ],
          );
          addTearDown(container.dispose);

          container.read(swapHelperProvider).swapAccept();
          async.flushMicrotasks();

          verifyNever(() => mockWallet.sendMsg(any()));
        });
      });

      test('sends pegInRequest when type is pegIn', () {
        fakeAsync((async) {
          final mockWallet = MockSideswapWallet();
          when(
            () => mockWallet.isAuthenticated(),
          ).thenAnswer((_) async => true);
          when(() => mockWallet.sendMsg(any())).thenReturn(null);

          final container = ProviderContainer.test(
            overrides: [
              swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => 100),
              swapTypeProvider.overrideWith((ref) => const SwapType.pegIn()),
              swapSendWalletProvider.overrideWith(
                (ref) => const SwapWallet.extern(),
              ),
              swapDeliverAssetProvider.overrideWith(
                (ref) =>
                    const SwapAsset(assetId: bitcoinId, assetList: [bitcoinId]),
              ),
              assetBalanceProvider.overrideWith((ref) => {}),
              walletProvider.overrideWith((ref) => mockWallet),
            ],
          );
          addTearDown(container.dispose);

          container.read(swapHelperProvider).swapAccept();
          async.flushMicrotasks();

          final captured = verify(
            () => mockWallet.sendMsg(captureAny()),
          ).captured;
          expect(captured.length, 1);
          final msg = captured.first as To;
          expect(msg.hasPegInRequest(), true);
        });
      });

      test('sends pegOutRequest when type is pegOut and feeRate available', () {
        fakeAsync((async) {
          final mockWallet = MockSideswapWallet();
          when(
            () => mockWallet.isAuthenticated(),
          ).thenAnswer((_) async => true);
          when(() => mockWallet.sendMsg(any())).thenReturn(null);

          final container = ProviderContainer.test(
            overrides: [
              swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => 100),
              swapTypeProvider.overrideWith((ref) => const SwapType.pegOut()),
              swapSendWalletProvider.overrideWith(
                (ref) => const SwapWallet.local(),
              ),
              swapDeliverAssetProvider.overrideWith(
                (ref) =>
                    const SwapAsset(assetId: liquidId, assetList: [liquidId]),
              ),
              assetBalanceProvider.overrideWith((ref) => {liquidId: 10000}),
              swapAddrTypeProvider.overrideWith((ref) => AddrType.bitcoin),
              swapRecvAddressExternalProvider.overrideWithValue(
                'valid_btc_addr',
              ),
              addrTypeStringProvider.overrideWith((ref) => 'Bitcoin'),
              isAddrTypeValidProvider(
                'valid_btc_addr',
                AddrType.bitcoin,
              ).overrideWith((ref) => true),
              bitcoinCurrentFeeRateProvider.overrideWithBuild(
                (ref, n) => Option.of(1.0),
              ),
              swapPriceSubscribeProvider.overrideWithBuild(
                (ref, n) => const SwapPriceSubscribeState.send(),
              ),
              walletProvider.overrideWith((ref) => mockWallet),
            ],
          );
          addTearDown(container.dispose);

          container.read(swapHelperProvider).swapAccept();
          async.flushMicrotasks();

          final captured = verify(
            () => mockWallet.sendMsg(captureAny()),
          ).captured;
          expect(captured.length, 1);
          final msg = captured.first as To;
          expect(msg.hasPegOutRequest(), true);
          expect(msg.pegOutRequest.sendAmount, Int64(500));
          expect(msg.pegOutRequest.recvAmount, Int64(100));
          expect(msg.pegOutRequest.recvAddr, 'valid_btc_addr');
        });
      });

      test('does nothing when pegOut and no feeRate', () {
        fakeAsync((async) {
          final mockWallet = MockSideswapWallet();
          when(
            () => mockWallet.isAuthenticated(),
          ).thenAnswer((_) async => true);

          final container = ProviderContainer.test(
            overrides: [
              swapSendSatoshiAmountProvider.overrideWith((ref) => 500),
              swapRecvSatoshiAmountProvider.overrideWith((ref) => 100),
              swapTypeProvider.overrideWith((ref) => const SwapType.pegOut()),
              swapSendWalletProvider.overrideWith(
                (ref) => const SwapWallet.local(),
              ),
              swapDeliverAssetProvider.overrideWith(
                (ref) =>
                    const SwapAsset(assetId: liquidId, assetList: [liquidId]),
              ),
              assetBalanceProvider.overrideWith((ref) => {liquidId: 10000}),
              swapAddrTypeProvider.overrideWith((ref) => AddrType.bitcoin),
              swapRecvAddressExternalProvider.overrideWithValue(
                'valid_btc_addr',
              ),
              addrTypeStringProvider.overrideWith((ref) => 'Bitcoin'),
              isAddrTypeValidProvider(
                'valid_btc_addr',
                AddrType.bitcoin,
              ).overrideWith((ref) => true),
              bitcoinCurrentFeeRateProvider.overrideWithBuild(
                (ref, n) => Option.none(),
              ),
              walletProvider.overrideWith((ref) => mockWallet),
            ],
          );
          addTearDown(container.dispose);

          container.read(swapHelperProvider).swapAccept();
          async.flushMicrotasks();

          verifyNever(() => mockWallet.sendMsg(any()));
        });
      });
    });
  });
}

class _AlwaysNoOpDialogPresenter implements DialogPresenter {
  @override
  Future<void> showSettingsErrorDialog(
    BuildContext context, {
    required String title,
    String description = '',
    required String buttonText,
    required void Function(BuildContext context) onPressed,
    String secondButtonText = '',
    void Function(BuildContext context)? onSecondPressed,
    SettingsDialogIcon icon = SettingsDialogIcon.error,
    double? width,
  }) async {}

  @override
  Future<void> showErrorDialog(
    BuildContext context,
    String errorDescription, {
    String? buttonText,
  }) async {}

  @override
  Future<void> showInsufficientFundsDialog(
    BuildContext context,
    From_ShowInsufficientFunds msg,
  ) async {}
}
