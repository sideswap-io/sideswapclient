import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

// Mock implementations
class MockWallet extends Mock implements SideswapWallet {}


class MockSatoshiRepository extends Mock implements AbstractSatoshiRepository {}

class MockAmountToString extends Mock implements AmountToString {}

class MockJadeLockRepository extends Mock
    implements AbstractJadeLockRepository {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void _registerFallbackValues() {
  registerFallbackValue(To());
  registerFallbackValue(AssetPair());
  registerFallbackValue(AssetType.BASE);
  registerFallbackValue(TradeDir.SELL);
}

// Test helpers
Asset createTestAsset({
  required String assetId,
  required String ticker,
  int precision = 8,
  String? name,
}) {
  final asset = Asset()
    ..assetId = assetId
    ..ticker = ticker
    ..precision = precision
    ..name = name ?? ticker;
  return asset;
}

MarketInfo createTestMarketInfo({
  required Asset baseAsset,
  required Asset quoteAsset,
}) {
  final assetPair = AssetPair()
    ..base = baseAsset.assetId
    ..quote = quoteAsset.assetId;

  final marketInfo = MarketInfo()
    ..assetPair = assetPair
    ..feeAsset = AssetType.BASE;

  return marketInfo;
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    _registerFallbackValues();
    registerFallbackValue(AmountToStringParameters(amount: 0));
  });

  final testAssetBtc = createTestAsset(assetId: 'btc', ticker: 'BTC', precision: 8);
  final testAssetUsdt = createTestAsset(assetId: 'usdt', ticker: 'USDT', precision: 8);
  final testAssetEusd = createTestAsset(assetId: 'eusd', ticker: 'eUSD', precision: 8);

  group('ExchangeSide', () {
    test('returns none when stableMarkets is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSideProvider), Option.none());
    });

    test('returns none when top asset is not available', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSideProvider), Option.none());
    });

    test('returns none when bottom asset is not available', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSideProvider), Option.none());
    });

    test('returns buy side when base asset is top and quote is bottom', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      final side = container.read(exchangeSideProvider);
      expect(side, isA<Some<ExchangeSide>>());
      final buySide = (side as Some<ExchangeSide>).value;
      expect(buySide, isA<ExchangeSideBuy>());
      expect((buySide as ExchangeSideBuy).asset.assetId, testAssetUsdt.assetId);
    });

    test('returns sell side when market pair is not found', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetEusd)),
        ],
      );
      addTearDown(container.dispose);

      final side = container.read(exchangeSideProvider);
      expect(side, isA<Some<ExchangeSide>>());
      final sellSide = (side as Some<ExchangeSide>).value;
      expect(sellSide, isA<ExchangeSideSell>());
      expect((sellSide as ExchangeSideSell).asset.assetId, testAssetBtc.assetId);
    });
  });

  group('ExchangeCurrentEditAsset', () {
    test('initial state is none', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(exchangeCurrentEditAssetProvider), Option.none());
    });

    test('setState updates the state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(exchangeCurrentEditAssetProvider.notifier)
          .setState(Option.of(testAssetBtc));

      expect(
        container.read(exchangeCurrentEditAssetProvider),
        Option.of(testAssetBtc),
      );
    });
  });

  group('exchangeAssetPair', () {
    test('returns none when side is not available', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAssetPairProvider), Option.none());
    });

    test('returns none when top asset is not available', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeTopAssetProvider.overrideWithValue(Option.none()),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAssetPairProvider), Option.none());
    });

    test('returns none when bottom asset is not available', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAssetPairProvider), Option.none());
    });

    test('returns correct asset pair for buy side', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      final assetPair = container.read(exchangeAssetPairProvider);
      expect(assetPair, isA<Some<AssetPair>>());
      final buyPair = (assetPair as Some<AssetPair>).value;
      expect(buyPair.base, 'btc');
      expect(buyPair.quote, 'usdt');
    });

    test('returns correct asset pair for sell side', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
        ],
      );
      addTearDown(container.dispose);

      final assetPair = container.read(exchangeAssetPairProvider);
      expect(assetPair, isA<Some<AssetPair>>());
      final sellPair = (assetPair as Some<AssetPair>).value;
      expect(sellPair.base, 'btc');
      expect(sellPair.quote, 'usdt');
    });

    test('returns none when market info is not found', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetEusd)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAssetPairProvider), Option.none());
    });
  });

  group('exchangeMarketInfo', () {
    test('returns none when asset pair is not available', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeMarketInfoProvider), Option.none());
    });

    test('returns market info when found', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeMarketInfoProvider);
      expect(result, Option.of(marketInfo));
    });

    test('returns none when market info is not found', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetEusd)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeMarketInfoProvider), Option.none());
    });
  });

  group('exchangeTopAssetList', () {
    test('returns empty list when markets are empty', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeTopAssetListProvider), []);
    });

    test('filters assets with empty ticker', () {
      final assetWithoutTicker = createTestAsset(assetId: 'empty', ticker: '');
      final marketInfo = createTestMarketInfo(
        baseAsset: assetWithoutTicker,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          assetFromAssetIdProvider('empty').overrideWithValue(Option.of(assetWithoutTicker)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeTopAssetListProvider), [testAssetUsdt]);
    });

    test('returns sorted list of unique assets', () {
      final marketInfo1 = createTestMarketInfo(
        baseAsset: testAssetUsdt,
        quoteAsset: testAssetBtc,
      );
      final marketInfo2 = createTestMarketInfo(
        baseAsset: testAssetEusd,
        quoteAsset: testAssetBtc,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo1, marketInfo2]),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
          assetFromAssetIdProvider('eusd').overrideWithValue(Option.of(testAssetEusd)),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeTopAssetListProvider);
      final tickers = result.map((a) => a.ticker).toList();
      expect(tickers, ['BTC', 'USDT', 'eUSD']);
    });
  });

  group('ExchangeTopAsset', () {
    test('initial state returns first asset from list', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
          liquidAssetIdStateProvider.overrideWithValue('unknown'),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeTopAssetProvider), Option.none());
    });

    test('setState updates state when asset is in list', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
          liquidAssetIdStateProvider.overrideWithValue('btc'),
        ],
      );
      addTearDown(container.dispose);

      container
          .read(exchangeTopAssetProvider.notifier)
          .setState(testAssetUsdt);

      expect(
        container.read(exchangeTopAssetProvider),
        Option.of(testAssetUsdt),
      );
    });

    test('setState ignores asset not in list', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final unknownAsset = createTestAsset(assetId: 'unknown', ticker: 'UNK');
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
          liquidAssetIdStateProvider.overrideWithValue('btc'),
        ],
      );
      addTearDown(container.dispose);

      final initial = container.read(exchangeTopAssetProvider);
      container.read(exchangeTopAssetProvider.notifier).setState(unknownAsset);

      expect(container.read(exchangeTopAssetProvider), initial);
    });
  });

  group('exchangeBottomAssetList', () {
    test('returns empty list when markets are empty', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomAssetListProvider), []);
    });

    test('returns empty list when top asset is not available', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomAssetListProvider), []);
    });

    test('returns quote assets when top asset is base', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeBottomAssetListProvider),
        [testAssetUsdt],
      );
    });

    test('returns base assets when top asset is quote', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeBottomAssetListProvider),
        [testAssetBtc],
      );
    });

    test('returns sorted unique assets', () {
      final marketInfo1 = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final marketInfo2 = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetEusd,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo1, marketInfo2]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
          assetFromAssetIdProvider('eusd').overrideWithValue(Option.of(testAssetEusd)),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeBottomAssetListProvider);
      final tickers = result.map((a) => a.ticker).toList();
      expect(tickers, ['USDT', 'eUSD']);
    });

    test('handles market with missing base asset', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          // Do not override assetFromAssetIdProvider('btc') - it will return Option.none
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeBottomAssetListProvider);
      // Should return empty list since the market's base asset is not available
      expect(result, []);
    });
  });

  group('ExchangeBottomAsset', () {
    test('initial state returns first asset from list', () {
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          tetherAssetIdStateProvider.overrideWithValue('unknown'),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomAssetProvider), Option.none());
    });

    test('setState updates state when asset is in list', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
          tetherAssetIdStateProvider.overrideWithValue('usdt'),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAssetProvider.notifier)
          .setState(testAssetUsdt);

      expect(
        container.read(exchangeBottomAssetProvider),
        Option.of(testAssetUsdt),
      );
    });

    test('setState falls back to first asset when not in list', () {
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final unknownAsset = createTestAsset(assetId: 'unknown', ticker: 'UNK');
      final container = ProviderContainer.test(
        overrides: [
          stableMarketsProvider.overrideWithValue([marketInfo]),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('btc').overrideWithValue(Option.of(testAssetBtc)),
          assetFromAssetIdProvider('usdt').overrideWithValue(Option.of(testAssetUsdt)),
          tetherAssetIdStateProvider.overrideWithValue('usdt'),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAssetProvider.notifier)
          .setState(unknownAsset);

      expect(
        container.read(exchangeBottomAssetProvider),
        Option.of(testAssetUsdt),
      );
    });
  });

  group('ExchangeTopAmount', () {
    test('initial state is empty string', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeTopAmountProvider), '');
    });

    test('setState updates state', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeTopAmountProvider.notifier).setState('100');
      expect(container.read(exchangeTopAmountProvider), '100');
    });

    test('setState with empty string invalidates self', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeTopAmountProvider.notifier).setState('100');
      expect(container.read(exchangeTopAmountProvider), '100');

      container.read(exchangeTopAmountProvider.notifier).setState('');
      expect(container.read(exchangeTopAmountProvider), '');
    });
  });

  group('exchangeTopSatoshiAmount', () {
    test('returns 0 when top asset is not available', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockSatoshiRepo.satoshiForAmount(
            assetId: any(named: 'assetId'),
            amount: any(named: 'amount'),
          )).thenReturn(0);

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeTopSatoshiAmountProvider), 0);
    });

    test('returns satoshi amount when asset is available', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockSatoshiRepo.satoshiForAmount(
            assetId: 'btc',
            amount: '0.5',
          )).thenReturn(50000000);

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeTopAmountProvider.overrideWithValue('0.5'),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeTopSatoshiAmountProvider),
        50000000,
      );
    });
  });


  group('ExchangeBottomAmount', () {
    test('initial state is empty string', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomAmountProvider), '');
    });

    test('setState updates state', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider.notifier).setState('500');
      expect(container.read(exchangeBottomAmountProvider), '500');
    });

    test('setState with empty string invalidates self', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider.notifier).setState('500');
      expect(container.read(exchangeBottomAmountProvider), '500');

      container.read(exchangeBottomAmountProvider.notifier).setState('');
      expect(container.read(exchangeBottomAmountProvider), '');
    });
  });

  group('exchangeBottomSatoshiAmount', () {
    test('returns 0 when bottom asset is not available', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockSatoshiRepo.satoshiForAmount(
            assetId: any(named: 'assetId'),
            amount: any(named: 'amount'),
          )).thenReturn(0);

      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomSatoshiAmountProvider), 0);
    });

    test('returns satoshi amount when asset is available', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockSatoshiRepo.satoshiForAmount(
            assetId: 'usdt',
            amount: '500',
          )).thenReturn(500000000);

      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeBottomAmountProvider.overrideWithValue('500'),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeBottomSatoshiAmountProvider),
        500000000,
      );
    });
  });


  group('ExchangeQuoteNotifier', () {
    test('initial state is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          quoteEventProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteProvider), Option.none());
    });
  });

  group('exchangeSwapButtonText', () {
    test('returns Swap text when not jade wallet', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSwapButtonTextProvider), 'Swap');
    });

    test('returns Unlock text when jade wallet is locked', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          jadeLockStateProvider.overrideWithValue(const JadeLockStateLocked()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSwapButtonTextProvider), 'Unlock');
    });

    test('returns Swap text when jade wallet is unlocked', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          jadeLockStateProvider.overrideWithValue(const JadeLockStateUnlocked()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSwapButtonTextProvider), 'Swap');
    });
  });

  group('exchangeQuoteError', () {
    test('returns none when quote and accept quote error are none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeQuoteProvider.overrideWithValue(Option.none()),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteErrorProvider), Option.none());
    });

    test('returns accept quote error when quote is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeQuoteProvider.overrideWithValue(Option.none()),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.of('Accept error')),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeQuoteErrorProvider);
      expect(result, isA<Some<QuoteError>>());
      expect((result as Some<QuoteError>).value.error, 'Accept error');
    });

    test('returns none when quote has no error', () {
      final quote = From_Quote()
        ..assetPair = (AssetPair()..base = 'btc'..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL;

      final container = ProviderContainer.test(
        overrides: [
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteErrorProvider), Option.none());
    });

    test('returns none when quote has indPrice', () {
      final indPrice = From_Quote_IndPrice()..priceTaker = 1.4;
      final quote = From_Quote()
        ..assetPair = (AssetPair()..base = 'btc'..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..error = 'Some error'
        ..indPrice = indPrice;

      final container = ProviderContainer.test(
        overrides: [
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteErrorProvider), Option.none());
    });

    test('returns quote error when quote has error and no indPrice', () {
      final quote = From_Quote()
        ..assetPair = (AssetPair()..base = 'btc'..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..error = 'Quote error message'
        ..orderId = Int64(42);

      final container = ProviderContainer.test(
        overrides: [
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeQuoteErrorProvider);
      expect(result, isA<Some<QuoteError>>());
      final quoteError = (result as Some<QuoteError>).value;
      expect(quoteError.error, 'Quote error message');
      expect(quoteError.orderId, 42);
    });

  });

  group('instantSwapTopDropdownError', () {
    test('returns none when both errors are none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(instantSwapTopDropdownErrorProvider), Option.none());
    });

    test('returns low balance error when available', () {
      final quote = From_Quote_LowBalance()..priceTaker = 1.5;

      final container = ProviderContainer.test(
        overrides: [
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.of(
            QuoteLowBalance(
              MockAmountToString(),
              quote,
              AssetPair()..base = 'btc'..quote = 'usdt',
              AssetType.BASE,
              TradeDir.SELL,
              AssetType.BASE,
              {},
              1,
            ),
          )),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(instantSwapTopDropdownErrorProvider),
        Option.of('Low balance'),
      );
    });
  });

  group('exchangeSwapButtonEnabled', () {
    test('returns false when accept quote is in progress', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAccepQuoteStateProvider.overrideWithValue(
            ExchangeAcceptQuoteState.inProgress(),
          ),
          exchangeQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSwapButtonEnabledProvider), false);
    });

    test('returns false when no quote success', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAccepQuoteStateProvider.overrideWithValue(
            ExchangeAcceptQuoteState.empty(),
          ),
          exchangeQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSwapButtonEnabledProvider), false);
    });

    test('returns true when quote success is available and not in progress', () {
      final quote = From_Quote_Success()..priceTaker = 1.5;

      final container = ProviderContainer.test(
        overrides: [
          exchangeAccepQuoteStateProvider.overrideWithValue(
            ExchangeAcceptQuoteState.empty(),
          ),
          exchangeQuoteSuccessProvider.overrideWithValue(Option.of(
            QuoteSuccess(
              MockAmountToString(),
              quote,
              AssetPair()..base = 'btc'..quote = 'usdt',
              AssetType.BASE,
              TradeDir.SELL,
              AssetType.BASE,
              {},
              1,
            ),
          )),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeSwapButtonEnabledProvider), true);
    });
  });

  group('ExchangeAccepQuoteStateNotifier', () {
    test('initial state is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeAccepQuoteStateProvider),
        isA<ExchangeAcceptQuoteStateEmpty>(),
      );
    });

    test('setState updates state', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeAccepQuoteStateProvider.notifier)
          .setState(ExchangeAcceptQuoteState.inProgress());

      expect(
        container.read(exchangeAccepQuoteStateProvider),
        isA<ExchangeAcceptQuoteStateInProgress>(),
      );
    });

  });

  group('ExchangeAcceptQuoteSuccess', () {
    test('returns none when accept quote is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAcceptQuoteSuccessProvider), Option.none());
    });

    test('returns txid when accept quote has success', () {
      final acceptQuote = From_AcceptQuote()
        ..success = (From_AcceptQuote_Success()..txid = 'txid123');

      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeAcceptQuoteSuccessProvider),
        Option.of('txid123'),
      );
    });

    test('returns none when accept quote has no success', () {
      final acceptQuote = From_AcceptQuote();
      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAcceptQuoteSuccessProvider), Option.none());
    });
  });

  group('ExchangeAcceptQuoteError', () {
    test('returns none when accept quote is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeAcceptQuoteErrorProvider), Option.none());
    });

    test('returns error message when accept quote has error', () {
      final acceptQuote = From_AcceptQuote()..error = 'Accept error';

      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(exchangeAcceptQuoteErrorProvider),
        Option.of('Accept error'),
      );
    });

    test('returns none when acceptQuote has no error', () {
      final acceptQuote = From_AcceptQuote();

      final container = ProviderContainer.test(
        overrides: [
          exchangeAcceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(exchangeAcceptQuoteErrorProvider), isA<None>());
    });
  });

  group('InstantSwapStateNotifier', () {
    test('initial state is empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(
        container.read(instantSwapStateProvider),
        isA<InstantSwapStateEmpty>(),
      );
    });

    test('setState updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(instantSwapStateProvider.notifier)
          .setState(InstantSwapState.inProgress());

      expect(
        container.read(instantSwapStateProvider),
        isA<InstantSwapStateInProgress>(),
      );
    });
  });

  group('InstantSwapQuoteSuccessNotifier', () {
    test('initial state is none', () {
      final container = ProviderContainer.test(
        overrides: [
          instantSwapStateProvider.overrideWithValue(InstantSwapState.empty()),
          exchangeQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(instantSwapQuoteSuccessProvider), Option.none());
    });

    test('setState updates state', () {
      final quote = From_Quote_Success()..priceTaker = 1.5;

      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quote,
        AssetPair()..base = 'btc'..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          instantSwapStateProvider.overrideWithValue(InstantSwapState.empty()),
          exchangeQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(instantSwapQuoteSuccessProvider.notifier)
          .setState(quoteSuccess);

      expect(
        container.read(instantSwapQuoteSuccessProvider),
        Option.of(quoteSuccess),
      );
    });
  });

  for (final provider in [
    (instantSwapDisabledAmountProvider, 'instantSwapDisabledAmount'),
    (instantSwapDisabledDropdownProvider, 'instantSwapDisabledDropdown'),
  ]) {
    group(provider.$2, () {
      for (final (state, expected) in [
        (InstantSwapState.inProgress(), true),
        (InstantSwapState.empty(), false),
      ]) {
        test('returns $expected when state is $state', () {
          final container = ProviderContainer.test(
            overrides: [instantSwapStateProvider.overrideWithValue(state)],
          );
          addTearDown(container.dispose);
          expect(container.read(provider.$1), expected);
        });
      }
    });
  }


  group('ExchangeQuoteNotifier methods', () {
    test('requestIndPriceQuote does nothing when side is none', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier)
          .requestIndPriceQuote(Option.none(), Option.of(AssetPair()
            ..base = 'btc'
            ..quote = 'usdt'));

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('requestIndPriceQuote does nothing when assetPair is none', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier)
          .requestIndPriceQuote(Option.of(ExchangeSide.buy(testAssetUsdt)), Option.none());

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('startSellQuotes does nothing when satoshiAmount is zero', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.sell(testAssetBtc))),
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startSellQuotes(0);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('startSellQuotes does nothing when side is none', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startSellQuotes(1000000);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('startSellQuotes does nothing when assetPair is none', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.sell(testAssetBtc))),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startSellQuotes(1000000);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('startBuyQuotes does nothing when satoshiAmount is zero', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startBuyQuotes(0);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('startBuyQuotes does nothing when side is none', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startBuyQuotes(1000000);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('startBuyQuotes does nothing when assetPair is none', () {
      final mockWallet = MockWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startBuyQuotes(1000000);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('requestIndPriceQuote sends startQuotes msg with BASE assetType for buy side', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).requestIndPriceQuote(
        Option.of(ExchangeSide.buy(testAssetUsdt)),
        Option.of(assetPair),
      );

      final startQuotesMsgs = captured.where((m) => m.hasStartQuotes()).toList();
      expect(startQuotesMsgs.length, 1);
      expect(startQuotesMsgs.first.startQuotes.assetType, AssetType.BASE);
      expect(startQuotesMsgs.first.startQuotes.tradeDir, TradeDir.SELL);
      expect(startQuotesMsgs.first.startQuotes.amount.toInt(), 0);
      expect(startQuotesMsgs.first.startQuotes.instantSwap, true);
    });

    test('requestIndPriceQuote sends startQuotes msg with QUOTE assetType for sell side', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).requestIndPriceQuote(
        Option.of(ExchangeSide.sell(testAssetBtc)),
        Option.of(assetPair),
      );

      final startQuotesMsgs = captured.where((m) => m.hasStartQuotes()).toList();
      expect(startQuotesMsgs.length, 1);
      expect(startQuotesMsgs.first.startQuotes.assetType, AssetType.QUOTE);
      expect(startQuotesMsgs.first.startQuotes.tradeDir, TradeDir.SELL);
      expect(startQuotesMsgs.first.startQuotes.amount.toInt(), 0);
      expect(startQuotesMsgs.first.startQuotes.instantSwap, true);
    });

    test('startSellQuotes sends startQuotes msg with BASE assetType for buy side', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startSellQuotes(1000000);

      final startQuotesMsgs = captured.where((m) => m.hasStartQuotes()).toList();
      expect(startQuotesMsgs.length, 1);
      expect(startQuotesMsgs.first.startQuotes.assetType, AssetType.BASE);
      expect(startQuotesMsgs.first.startQuotes.tradeDir, TradeDir.SELL);
      expect(startQuotesMsgs.first.startQuotes.amount.toInt(), 1000000);
      expect(startQuotesMsgs.first.startQuotes.instantSwap, true);
    });

    test('startSellQuotes sends startQuotes msg with QUOTE assetType for sell side', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.sell(testAssetBtc))),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startSellQuotes(500000);

      final startQuotesMsgs = captured.where((m) => m.hasStartQuotes()).toList();
      expect(startQuotesMsgs.length, 1);
      expect(startQuotesMsgs.first.startQuotes.assetType, AssetType.QUOTE);
      expect(startQuotesMsgs.first.startQuotes.tradeDir, TradeDir.SELL);
      expect(startQuotesMsgs.first.startQuotes.amount.toInt(), 500000);
      expect(startQuotesMsgs.first.startQuotes.instantSwap, true);
    });

    test('startBuyQuotes sends startQuotes msg with QUOTE assetType for buy side', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.buy(testAssetUsdt))),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startBuyQuotes(2000000);

      final startQuotesMsgs = captured.where((m) => m.hasStartQuotes()).toList();
      expect(startQuotesMsgs.length, 1);
      expect(startQuotesMsgs.first.startQuotes.assetType, AssetType.QUOTE);
      expect(startQuotesMsgs.first.startQuotes.tradeDir, TradeDir.BUY);
      expect(startQuotesMsgs.first.startQuotes.amount.toInt(), 2000000);
      expect(startQuotesMsgs.first.startQuotes.instantSwap, true);
    });

    test('startBuyQuotes sends startQuotes msg with BASE assetType for sell side', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(Option.of(ExchangeSide.sell(testAssetBtc))),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startBuyQuotes(750000);

      final startQuotesMsgs = captured.where((m) => m.hasStartQuotes()).toList();
      expect(startQuotesMsgs.length, 1);
      expect(startQuotesMsgs.first.startQuotes.assetType, AssetType.BASE);
      expect(startQuotesMsgs.first.startQuotes.tradeDir, TradeDir.BUY);
      expect(startQuotesMsgs.first.startQuotes.amount.toInt(), 750000);
      expect(startQuotesMsgs.first.startQuotes.instantSwap, true);
    });

    test('stopQuotes sends stopQuotes msg via wallet', () {
      final mockWallet = MockWallet();
      final captured = <To>[];
      when(() => mockWallet.sendMsg(any())).thenAnswer((inv) {
        captured.add(inv.positionalArguments.first as To);
      });

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).stopQuotes();

      final stopQuotesMsgs = captured.where((m) => m.hasStopQuotes()).toList();
      expect(stopQuotesMsgs.length, 1);
    });
  });

  group('exchangeQuoteSuccess basic', () {
    test('returns none when asset pair is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeQuoteProvider.overrideWithValue(
            Option.of(From_Quote()..success = From_Quote_Success()),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteSuccessProvider), Option.none());
    });

    test('returns none when quote is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteSuccessProvider), Option.none());
    });

    test('returns none when quote has no success', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeQuoteProvider.overrideWithValue(
            Option.of(From_Quote()),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteSuccessProvider), Option.none());
    });
  });

  group('exchangeLowBalanceError matching', () {
    test('returns none when asset pair is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeQuoteProvider.overrideWithValue(
            Option.of(From_Quote()
              ..lowBalance = From_Quote_LowBalance()),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeLowBalanceErrorProvider), Option.none());
    });

    test('returns none when quote is none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeLowBalanceErrorProvider), Option.none());
    });

    test('returns none when quote has no low balance', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeQuoteProvider.overrideWithValue(
            Option.of(From_Quote()),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeLowBalanceErrorProvider), Option.none());
    });
  });

  group('ExchangeIndexPrice listener', () {
    test('returns none when quote is none', () {
      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(MockAmountToString()),
          assetsStateProvider.overrideWithValue({}),
          satoshiRepositoryProvider.overrideWithValue(MockSatoshiRepository()),
          exchangeQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeIndexPriceProvider), Option.none());
    });

    test('returns none when quote has no priceTaker in any form', () {
      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(MockAmountToString()),
          assetsStateProvider.overrideWithValue({}),
          satoshiRepositoryProvider.overrideWithValue(MockSatoshiRepository()),
          exchangeQuoteProvider.overrideWithValue(
            Option.of(From_Quote()),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeIndexPriceProvider), Option.none());
    });
  });

  group('instantSwapTopDropdownError with quoteError', () {
    test('returns none when both errors are none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(instantSwapTopDropdownErrorProvider), Option.none());
    });

    test('returns quote error when low balance is none', () {
      final quoteError = QuoteError(error: 'Test error');

      final container = ProviderContainer.test(
        overrides: [
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.of(quoteError)),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(instantSwapTopDropdownErrorProvider);
      expect(result, isA<Some<String>>());
    });
  });

  group('ExchangeTopAmount listeners', () {
    test('listener triggers when exchangeLowBalanceErrorProvider provides matching asset', () {
      final lowBalance = From_Quote_LowBalance();
      final quoteLowBalance = QuoteLowBalance(
        MockAmountToString(),
        lowBalance,
        AssetPair()..base = 'btc'..quote = 'usdt',
        AssetType.BASE,
        TradeDir.BUY,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.of(quoteLowBalance)),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeTopAmountProvider);
      expect(result, isEmpty);
    });

    test('listener triggers when instantSwapQuoteSuccessProvider provides matching asset', () {
      final quoteSuccessData = From_Quote_Success();
      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quoteSuccessData,
        AssetPair()..base = 'btc'..quote = 'usdt',
        AssetType.BASE,
        TradeDir.BUY,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.of(quoteSuccess)),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeTopAmountProvider);
      expect(result, isEmpty);
    });

    test('listener responds to exchangeQuoteErrorProvider when error is present and different currentEditAsset', () {
      final quoteError = QuoteError(error: 'Test error');

      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.of(quoteError)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeTopAmountProvider);
      expect(result, '');
    });

    test('listener handles exchangeLowBalanceErrorProvider with none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeTopAmountProvider);
      expect(result, '');
    });
  });

  group('ExchangeBottomAmount listeners', () {
    test('listener triggers when exchangeLowBalanceErrorProvider provides matching asset', () {
      final lowBalance = From_Quote_LowBalance();
      final quoteLowBalance = QuoteLowBalance(
        MockAmountToString(),
        lowBalance,
        AssetPair()..base = 'btc'..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.of(quoteLowBalance)),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeBottomAmountProvider);
      expect(result, isEmpty);
    });

    test('listener triggers when instantSwapQuoteSuccessProvider provides matching asset', () {
      final quoteSuccessData = From_Quote_Success();
      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quoteSuccessData,
        AssetPair()..base = 'btc'..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.of(quoteSuccess)),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeBottomAmountProvider);
      expect(result, isEmpty);
    });

    test('listener responds to exchangeQuoteErrorProvider when error is present and same currentEditAsset', () {
      final quoteError = QuoteError(error: 'Test error');

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.of(quoteError)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeBottomAmountProvider);
      expect(result, '');
    });

    test('listener handles instantSwapQuoteSuccessProvider with none', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(exchangeBottomAmountProvider);
      expect(result, '');
    });
  });

  group('ExchangeTopAmount acceptQuoteState listener via upstream mutation', () {
    test('invalidates when state transitions inProgress -> empty', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          // don't override exchangeAccepQuoteStateProvider — use real notifier
        ],
      );
      addTearDown(container.dispose);

      // Build the provider to register listeners
      container.read(exchangeTopAmountProvider.notifier).setState('50');
      expect(container.read(exchangeTopAmountProvider), '50');

      // Transition inProgress → empty triggers invalidateSelf
      container
          .read(exchangeAccepQuoteStateProvider.notifier)
          .setState(ExchangeAcceptQuoteState.inProgress());
      container
          .read(exchangeAccepQuoteStateProvider.notifier)
          .setState(ExchangeAcceptQuoteState.empty());

      // After invalidateSelf, provider rebuilds to ''
      expect(container.read(exchangeTopAmountProvider), '');
    });
  });

  group('ExchangeBottomAmount acceptQuoteState listener via upstream mutation', () {
    test('invalidates when state transitions inProgress -> empty', () {
      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          // don't override exchangeAccepQuoteStateProvider — use real notifier
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider.notifier).setState('500');
      expect(container.read(exchangeBottomAmountProvider), '500');

      container
          .read(exchangeAccepQuoteStateProvider.notifier)
          .setState(ExchangeAcceptQuoteState.inProgress());
      container
          .read(exchangeAccepQuoteStateProvider.notifier)
          .setState(ExchangeAcceptQuoteState.empty());

      expect(container.read(exchangeBottomAmountProvider), '');
    });
  });

  group('ExchangeTopAmount lowBalance listener fires after quoteEvent mutation', () {
    test('sets state to deliverAmount when deliverAsset matches top and tradeDir BUY', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('1.23');
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final assetsState = {
        'btc': testAssetBtc,
        'usdt': testAssetUsdt,
      };

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          // For exchangeLowBalanceErrorProvider to compute:
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue(assetsState),
          walletProvider.overrideWithValue(MockWallet()),
        ],
      );
      addTearDown(container.dispose);

      // Build exchangeTopAmountProvider to register listeners
      expect(container.read(exchangeTopAmountProvider), '');

      // assetType=QUOTE, tradeDir=BUY → deliverAsset = baseAsset = btcAsset = topAsset
      // sendAmount=100 → deliverAmount = amountToString('100', btcAsset) = '1.23'
      final lowBalance = From_Quote_LowBalance()
        ..sendAmount = Int64(100)
        ..priceTaker = 1.5;
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.QUOTE
        ..tradeDir = TradeDir.BUY
        ..lowBalance = lowBalance;
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // exchangeLowBalanceErrorProvider now has Some(QuoteLowBalance with deliverAsset=btc)
      // listener fires in exchangeTopAmountProvider: deliverAsset.assetId == topAsset.assetId && tradeDir==BUY
      // → state = lowBalance.deliverAmount
      expect(container.read(exchangeTopAmountProvider), isNotEmpty);
    });
  });

  group('ExchangeTopAmount instantSwapQuoteSuccess listener fires after mutation', () {
    test('sets state to deliverAmount when deliverAsset matches top and tradeDir BUY', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('0.5');
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final assetsState = {
        'btc': testAssetBtc,
        'usdt': testAssetUsdt,
      };

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          // For exchangeQuoteSuccessProvider to compute (feeds instantSwapQuoteSuccessProvider):
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue(assetsState),
          walletProvider.overrideWithValue(MockWallet()),
          // DON'T override instantSwapQuoteSuccessProvider
        ],
      );
      addTearDown(container.dispose);

      // Build to register listeners
      expect(container.read(exchangeTopAmountProvider), '');
      // Also build instantSwapQuoteSuccessProvider to register its own listener
      expect(container.read(instantSwapQuoteSuccessProvider), Option.none());

      // Inject quote with success where assetType=QUOTE, tradeDir=BUY → deliverAsset=btcAsset=topAsset
      final successData = From_Quote_Success()
        ..sendAmount = Int64(50000000)
        ..priceTaker = 1.5;
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.QUOTE
        ..tradeDir = TradeDir.BUY
        ..success = successData;
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // instantSwapQuoteSuccessProvider gets Some(quoteSuccess) where deliverAsset=btcAsset
      // → listener fires in exchangeTopAmountProvider with deliverAsset.assetId == topAsset.assetId && tradeDir==BUY
      // → state = quoteSuccess.deliverAmount
      expect(container.read(exchangeTopAmountProvider), isNotEmpty);
    });
  });

  group('ExchangeTopAmount quoteError listener fires after mutation', () {
    test('invalidates when error present and topAsset != currentEditAsset', () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final assetsState = {'btc': testAssetBtc, 'usdt': testAssetUsdt};
      final mockAmountToString = MockAmountToString();

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          // currentEditAsset = usdt ≠ topAsset = btc → condition passes
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          // For exchangeQuoteErrorProvider chain:
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.none()),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue(assetsState),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeTopAmountProvider.notifier).setState('100');
      expect(container.read(exchangeTopAmountProvider), '100');

      // Inject quote with error via quoteEventProvider → exchangeQuoteProvider → exchangeQuoteErrorProvider
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..error = 'some error'
        ..orderId = Int64(1);
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // exchangeQuoteErrorProvider becomes Some(QuoteError)
      // listener fires: error.isNotEmpty && topAsset != currentEditAsset → invalidateSelf
      expect(container.read(exchangeTopAmountProvider), '');
    });
  });

  group('ExchangeBottomAmount lowBalance listener fires after quoteEvent mutation', () {
    test('sets state to receiveAmount when receiveAsset matches bottom and tradeDir SELL', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('500.0');
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final assetsState = {
        'btc': testAssetBtc,
        'usdt': testAssetUsdt,
      };

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue(assetsState),
          walletProvider.overrideWithValue(MockWallet()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomAmountProvider), '');

      // assetType=QUOTE, tradeDir=SELL → receiveAsset = baseAsset = btcAsset
      // But we want receiveAsset == bottomAsset == usdtAsset
      // assetType=BASE, tradeDir=SELL → receiveAsset = quoteAsset = usdtAsset = bottomAsset ✓
      final lowBalance = From_Quote_LowBalance()
        ..recvAmount = Int64(50000000)
        ..priceTaker = 1.5;
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..lowBalance = lowBalance;
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // receiveAsset = quoteAsset = usdt = bottomAsset && tradeDir==SELL → state = receiveAmount
      expect(container.read(exchangeBottomAmountProvider), isNotEmpty);
    });
  });

  group('ExchangeBottomAmount instantSwapQuoteSuccess listener fires after mutation', () {
    test('sets state to receiveAmount when receiveAsset matches bottom and tradeDir SELL', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('500.0');
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );
      final assetsState = {
        'btc': testAssetBtc,
        'usdt': testAssetUsdt,
      };

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue(assetsState),
          walletProvider.overrideWithValue(MockWallet()),
          // DON'T override instantSwapQuoteSuccessProvider
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeBottomAmountProvider), '');
      expect(container.read(instantSwapQuoteSuccessProvider), Option.none());

      // assetType=BASE, tradeDir=SELL → receiveAsset = quoteAsset = usdt = bottomAsset ✓
      final successData = From_Quote_Success()
        ..recvAmount = Int64(50000000)
        ..priceTaker = 1.5;
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = successData;
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // instantSwapQuoteSuccessProvider gets Some where receiveAsset=usdt=bottomAsset && SELL
      // → listener fires → state = receiveAmount
      expect(container.read(exchangeBottomAmountProvider), isNotEmpty);
    });
  });

  group('ExchangeBottomAmount quoteError listener fires after mutation', () {
    test('invalidates when error present and topAsset == currentEditAsset', () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final assetsState = {'btc': testAssetBtc, 'usdt': testAssetUsdt};
      final mockAmountToString = MockAmountToString();

      final container = ProviderContainer.test(
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAccepQuoteStateProvider.overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          // currentEditAsset = btc == topAsset → condition passes for bottom invalidate
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.none()),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue(assetsState),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider.notifier).setState('500');
      expect(container.read(exchangeBottomAmountProvider), '500');

      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..error = 'some error'
        ..orderId = Int64(1);
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // exchangeQuoteErrorProvider becomes Some → listener fires:
      // error.isNotEmpty && topAsset == currentEditAsset → invalidateSelf
      expect(container.read(exchangeBottomAmountProvider), '');
    });
  });

  group('ExchangeIndexPrice listener via upstream mutation', () {
    test('sets QuoteIndexPrice from success.priceTaker after quoteEvent mutation', () {
      final mockAmountToString = MockAmountToString();
      final mockSatoshiRepo = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Build ExchangeIndexPrice (registers listener on exchangeQuoteProvider)
      expect(container.read(exchangeIndexPriceProvider), Option.none());

      // Inject a quote with success.priceTaker via quoteEventProvider
      final success = From_Quote_Success()..priceTaker = 1.5;
      final quote = From_Quote()
        ..assetPair = (AssetPair()
          ..base = 'btc'
          ..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = success;

      container.read(quoteEventProvider.notifier).setQuote(quote);

      // exchangeQuoteProvider (ExchangeQuoteNotifier) watches quoteEventProvider,
      // so it updates to Some(quote). The listener in ExchangeIndexPrice fires.
      final result = container.read(exchangeIndexPriceProvider);
      expect(result, isA<Some<QuoteIndexPrice>>());
    });

    test('sets QuoteIndexPrice from lowBalance.priceTaker', () {
      final mockAmountToString = MockAmountToString();
      final mockSatoshiRepo = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeIndexPriceProvider), Option.none());

      final lowBalance = From_Quote_LowBalance()..priceTaker = 2.0;
      final quote = From_Quote()
        ..assetPair = (AssetPair()
          ..base = 'btc'
          ..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..lowBalance = lowBalance;

      container.read(quoteEventProvider.notifier).setQuote(quote);

      final result = container.read(exchangeIndexPriceProvider);
      expect(result, isA<Some<QuoteIndexPrice>>());
    });

    test('sets QuoteIndexPrice from indPrice.priceTaker', () {
      final mockAmountToString = MockAmountToString();
      final mockSatoshiRepo = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeIndexPriceProvider), Option.none());

      final indPrice = From_Quote_IndPrice()..priceTaker = 3.0;
      final quote = From_Quote()
        ..assetPair = (AssetPair()
          ..base = 'btc'
          ..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..indPrice = indPrice;

      container.read(quoteEventProvider.notifier).setQuote(quote);

      final result = container.read(exchangeIndexPriceProvider);
      expect(result, isA<Some<QuoteIndexPrice>>());
    });

    test('sets state to none when quote has no priceTaker', () {
      final mockAmountToString = MockAmountToString();
      final mockSatoshiRepo = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeIndexPriceProvider), Option.none());

      // Quote with no priceTaker → listener sets state = Option.none()
      final quote = From_Quote()
        ..assetPair = (AssetPair()
          ..base = 'btc'
          ..quote = 'usdt')
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL;

      container.read(quoteEventProvider.notifier).setQuote(quote);

      expect(container.read(exchangeIndexPriceProvider), Option.none());
    });
  });

  group('exchangeLowBalanceError assetPair mismatch', () {
    test('returns none when quote assetPair differs from exchangeAssetPair', () {
      final differentPair = AssetPair()
        ..base = 'other'
        ..quote = 'asset';
      final quote = From_Quote()
        ..assetPair = differentPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..lowBalance = From_Quote_LowBalance();

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(
            Option.of(createTestMarketInfo(
              baseAsset: testAssetBtc,
              quoteAsset: testAssetUsdt,
            )),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeLowBalanceErrorProvider), Option.none());
    });

    test('returns none when marketInfo is none', () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..lowBalance = From_Quote_LowBalance();

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeLowBalanceErrorProvider), Option.none());
    });

    test('returns QuoteLowBalance when assetPair matches', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..lowBalance = From_Quote_LowBalance();
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeLowBalanceErrorProvider), isA<Some<QuoteLowBalance>>());
    });
  });

  group('exchangeQuoteSuccess matching', () {
    test('returns none when assetPair mismatches', () {
      final differentPair = AssetPair()
        ..base = 'other'
        ..quote = 'asset';
      final quote = From_Quote()
        ..assetPair = differentPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = From_Quote_Success();

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(
            Option.of(createTestMarketInfo(
              baseAsset: testAssetBtc,
              quoteAsset: testAssetUsdt,
            )),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteSuccessProvider), Option.none());
    });

    test('returns none when marketInfo is none', () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = From_Quote_Success();

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteSuccessProvider), Option.none());
    });

    test('returns none when quote has no success but assetPair and marketInfo match', () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final quote = From_Quote()..assetPair = assetPair;

      final marketInfo = MarketInfo()
        ..assetPair = assetPair
        ..feeAsset = AssetType.BASE;

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(exchangeQuoteSuccessProvider), isA<None>());
    });

    test('returns QuoteSuccess when assetPair matches', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = From_Quote_Success();
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeQuoteProvider.overrideWithValue(Option.of(quote)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(exchangeQuoteSuccessProvider), isA<Some<QuoteSuccess>>());
    });
  });

  group('ExchangeAccepQuoteStateNotifier error listener', () {
    test('resets to empty when acceptQuoteError fires via upstream mutation', () {
      final container = ProviderContainer.test(
        overrides: [
          // Don't override exchangeAcceptQuoteErrorProvider - let it compute
          // from acceptQuoteProvider (AcceptQuoteNotifier)
        ],
      );
      addTearDown(container.dispose);

      // Build & advance to inProgress
      container.read(exchangeAccepQuoteStateProvider);
      container
          .read(exchangeAccepQuoteStateProvider.notifier)
          .setState(ExchangeAcceptQuoteState.inProgress());
      expect(
        container.read(exchangeAccepQuoteStateProvider),
        isA<ExchangeAcceptQuoteStateInProgress>(),
      );

      // Mutate acceptQuoteProvider → exchangeAcceptQuoteProvider → exchangeAcceptQuoteErrorProvider
      // → listener fires → state resets to empty
      final acceptQuote = From_AcceptQuote()..error = 'some error';
      container.read(acceptQuoteProvider.notifier).setState(acceptQuote);

      expect(
        container.read(exchangeAccepQuoteStateProvider),
        isA<ExchangeAcceptQuoteStateEmpty>(),
      );
    });
  });

  group('InstantSwapQuoteSuccessNotifier listener', () {
    test('updates state when exchangeQuoteSuccess fires with Some and state is empty', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          // Don't override exchangeQuoteSuccessProvider or instantSwapStateProvider
        ],
      );
      addTearDown(container.dispose);

      // Build InstantSwapQuoteSuccessNotifier (registers listener)
      expect(container.read(instantSwapQuoteSuccessProvider), Option.none());

      // Confirm state is empty
      expect(
        container.read(instantSwapStateProvider),
        isA<InstantSwapStateEmpty>(),
      );

      // Inject a success quote via quoteEventProvider → exchangeQuoteProvider → exchangeQuoteSuccessProvider
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = From_Quote_Success();
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // exchangeQuoteSuccessProvider now has Some(QuoteSuccess)
      // listener fires → setState called → instantSwapQuoteSuccessProvider updated
      final result = container.read(instantSwapQuoteSuccessProvider);
      expect(result, isA<Some<QuoteSuccess>>());
    });

    test('does not update state when exchangeQuoteSuccess fires with Some and state is inProgress', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Set a known value first
      final successData = From_Quote_Success()..priceTaker = 9.9;
      final initialSuccess = QuoteSuccess(
        mockAmountToString,
        successData,
        assetPair,
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        99,
      );
      container.read(instantSwapQuoteSuccessProvider.notifier).setState(initialSuccess);

      // Set instantSwapState to inProgress
      container
          .read(instantSwapStateProvider.notifier)
          .setState(InstantSwapState.inProgress());

      // Now fire a new quote success
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = From_Quote_Success();
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // State should remain as initialSuccess (not updated)
      final result = container.read(instantSwapQuoteSuccessProvider);
      expect(result, isA<Some<QuoteSuccess>>());
      expect((result as Some<QuoteSuccess>).value.orderId, 99);
    });

    test('invalidates self when exchangeQuoteSuccess fires with None', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = createTestMarketInfo(
        baseAsset: testAssetBtc,
        quoteAsset: testAssetUsdt,
      );

      final container = ProviderContainer.test(
        overrides: [
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          walletProvider.overrideWithValue(MockWallet()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Build InstantSwapQuoteSuccessNotifier first to register listener
      expect(container.read(instantSwapQuoteSuccessProvider), Option.none());

      // Inject a success so state becomes Some
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..success = From_Quote_Success();
      container.read(quoteEventProvider.notifier).setQuote(quote);
      expect(container.read(instantSwapQuoteSuccessProvider), isA<Some<QuoteSuccess>>());

      // Now clear quoteEvent → exchangeQuoteProvider becomes None → exchangeQuoteSuccess becomes None
      // → listener fires next=None → invalidateSelf → state resets to Option.none()
      container.read(quoteEventProvider.notifier).stopQuotes();

      expect(container.read(instantSwapQuoteSuccessProvider), Option.none());
    });
  });

  group('ExchangeQuoteNotifier startSellQuotes happy path', () {
    test('calls startQuotes via quoteEventProvider when sell side', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(
            Option.of(ExchangeSide.sell(testAssetBtc)),
          ),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startSellQuotes(100000);

      // Verify sendMsg was called (startQuotes calls wallet.sendMsg)
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('calls startQuotes via quoteEventProvider when buy side', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(
            Option.of(ExchangeSide.buy(testAssetUsdt)),
          ),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).startBuyQuotes(100000);

      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('stopQuotes calls wallet.sendMsg with stopQuotes msg', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeSideProvider.overrideWithValue(
            Option.of(ExchangeSide.sell(testAssetBtc)),
          ),
          exchangeAssetPairProvider.overrideWithValue(
            Option.of(AssetPair()
              ..base = 'btc'
              ..quote = 'usdt'),
          ),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).stopQuotes();

      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('requestIndPriceQuote calls startQuotes for sell side', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeSideProvider.overrideWithValue(
            Option.of(ExchangeSide.sell(testAssetBtc)),
          ),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).requestIndPriceQuote(
        Option.of(ExchangeSide.sell(testAssetBtc)),
        Option.of(assetPair),
      );

      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('requestIndPriceQuote calls startQuotes for buy side', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeSideProvider.overrideWithValue(
            Option.of(ExchangeSide.buy(testAssetUsdt)),
          ),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeQuoteProvider.notifier).requestIndPriceQuote(
        Option.of(ExchangeSide.buy(testAssetUsdt)),
        Option.of(assetPair),
      );

      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });
  });

  group('acceptQuote branches', () {
    test('does nothing when optionQuoteSuccess is None', () {
      final mockWallet = MockWallet();
      final mockJadeLock = MockJadeLockRepository();

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          jadeLockRepositoryProvider.overrideWithValue(mockJadeLock),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container
          .read(exchangeQuoteProvider.notifier)
          .acceptQuote(optionQuoteSuccess: Option.none());

      verifyNever(() => mockJadeLock.isUnlocked());
      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('calls refreshJadeLockState when jade is locked', () {
      final mockWallet = MockWallet();
      final mockJadeLock = MockJadeLockRepository();
      when(() => mockJadeLock.isUnlocked()).thenReturn(false);
      when(() => mockJadeLock.refreshJadeLockState()).thenReturn(null);

      final quoteSuccessData = From_Quote_Success()
        ..priceTaker = 1.5
        ..quoteId = Int64(123);
      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quoteSuccessData,
        AssetPair()
          ..base = 'btc'
          ..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          jadeLockRepositoryProvider.overrideWithValue(mockJadeLock),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container
          .read(exchangeQuoteProvider.notifier)
          .acceptQuote(optionQuoteSuccess: Option.of(quoteSuccess));

      verify(() => mockJadeLock.isUnlocked()).called(1);
      verify(() => mockJadeLock.refreshJadeLockState()).called(1);
      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('sends acceptQuote msg when jade unlocked and already authorized (non-jade)', () async {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final mockJadeLock = MockJadeLockRepository();
      when(() => mockJadeLock.isUnlocked()).thenReturn(true);

      final quoteSuccessData = From_Quote_Success()
        ..priceTaker = 1.5
        ..quoteId = Int64(456);
      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quoteSuccessData,
        AssetPair()
          ..base = 'btc'
          ..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          jadeLockRepositoryProvider.overrideWithValue(mockJadeLock),
          isJadeWalletProvider.overrideWithValue(false),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Pre-authorize
      container
          .read(jadeOneTimeAuthorizationProvider.notifier)
          .setState(true);

      container
          .read(exchangeQuoteProvider.notifier)
          .acceptQuote(optionQuoteSuccess: Option.of(quoteSuccess));

      // Allow microtasks to run
      await Future.microtask(() {});

      // sendMsg should be called for acceptQuote
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('invalidates instantSwapState when authorization fails', () async {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      when(() => mockWallet.isAuthenticated()).thenAnswer((_) async => false);

      final mockJadeLock = MockJadeLockRepository();
      when(() => mockJadeLock.isUnlocked()).thenReturn(true);

      final quoteSuccessData = From_Quote_Success()
        ..priceTaker = 1.5
        ..quoteId = Int64(789);
      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quoteSuccessData,
        AssetPair()
          ..base = 'btc'
          ..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          jadeLockRepositoryProvider.overrideWithValue(mockJadeLock),
          isJadeWalletProvider.overrideWithValue(false),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // jadeOneTimeAuthorization = false (default), isAuthenticated returns false
      container
          .read(exchangeQuoteProvider.notifier)
          .acceptQuote(optionQuoteSuccess: Option.of(quoteSuccess));

      // Allow async to complete
      await Future.delayed(const Duration(milliseconds: 50));

      // instantSwapState should be back to empty after failed authorization
      expect(
        container.read(instantSwapStateProvider),
        isA<InstantSwapStateEmpty>(),
      );
    });

    test('does not stopQuotes when isJadeWallet is true', () async {
      final mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      final mockJadeLock = MockJadeLockRepository();
      when(() => mockJadeLock.isUnlocked()).thenReturn(true);

      final quoteSuccessData = From_Quote_Success()
        ..priceTaker = 1.5
        ..quoteId = Int64(111);
      final quoteSuccess = QuoteSuccess(
        MockAmountToString(),
        quoteSuccessData,
        AssetPair()
          ..base = 'btc'
          ..quote = 'usdt',
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          jadeLockRepositoryProvider.overrideWithValue(mockJadeLock),
          isJadeWalletProvider.overrideWithValue(true),
          exchangeSideProvider.overrideWithValue(Option.none()),
          exchangeAssetPairProvider.overrideWithValue(Option.none()),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Pre-authorize so we proceed past the auth check
      container
          .read(jadeOneTimeAuthorizationProvider.notifier)
          .setState(true);

      container
          .read(exchangeQuoteProvider.notifier)
          .acceptQuote(optionQuoteSuccess: Option.of(quoteSuccess));

      await Future.microtask(() {});

      // With isJadeWallet=true: sendMsg IS called, but stopQuotes should NOT be called
      // stopQuotes calls wallet.sendMsg with stopQuotes msg too, but acceptQuote also calls sendMsg
      // Just verify sendMsg was called (for acceptQuote msg)
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));

      // instantSwapState should still be inProgress (not invalidated by stopQuotes path)
      expect(
        container.read(instantSwapStateProvider),
        isA<InstantSwapStateInProgress>(),
      );
    });
  });

  group('exchangeTopDebounceSatoshiAmount', () {
    test('returns debounced satoshi amount after delay', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockSatoshiRepo.satoshiForAmount(
            assetId: any(named: 'assetId'),
            amount: any(named: 'amount'),
          )).thenReturn(12345);

      fakeAsync((async) {
        final container = ProviderContainer.test(
          overrides: [
            exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
            exchangeTopAmountProvider.overrideWithValue('0.5'),
            satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          ],
        );
        addTearDown(container.dispose);

        // Start the future
        late AsyncValue<int> result;
        container.listen(
          exchangeTopDebounceSatoshiAmountProvider,
          (_, next) => result = next,
          fireImmediately: true,
        );

        // Advance past debounce window (300ms)
        async.elapse(const Duration(milliseconds: 350));
        async.flushMicrotasks();

        expect(result, isA<AsyncData<int>>());
        expect((result as AsyncData<int>).value, 12345);
      });
    });
  });

  group('exchangeBottomDebounceSatoshiAmount', () {
    test('returns debounced satoshi amount after delay', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockSatoshiRepo.satoshiForAmount(
            assetId: any(named: 'assetId'),
            amount: any(named: 'amount'),
          )).thenReturn(67890);

      fakeAsync((async) {
        final container = ProviderContainer.test(
          overrides: [
            exchangeBottomAssetProvider.overrideWithValue(Option.of(testAssetUsdt)),
            exchangeBottomAmountProvider.overrideWithValue('500'),
            satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          ],
        );
        addTearDown(container.dispose);

        late AsyncValue<int> result;
        container.listen(
          exchangeBottomDebounceSatoshiAmountProvider,
          (_, next) => result = next,
          fireImmediately: true,
        );

        async.elapse(const Duration(milliseconds: 350));
        async.flushMicrotasks();

        expect(result, isA<AsyncData<int>>());
        expect((result as AsyncData<int>).value, 67890);
      });
    });
  });

  // Tests for ref.listen callback bodies via upstream mutation
  group('ExchangeTopAmount listener callbacks via upstream mutation', () {
    test('lowBalance listener fires with deliverAsset None (line 275)', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('0');

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = MarketInfo()
        ..assetPair = assetPair
        ..feeAsset = AssetType.BASE;

      final container = ProviderContainer.test(
        retry: null,
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider
              .overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          // Static overrides for other listened providers
          exchangeAccepQuoteStateProvider
              .overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          // DON'T override: exchangeLowBalanceErrorProvider, exchangeQuoteProvider, quoteEventProvider
          // DO override instantSwapQuoteSuccessProvider with static value
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Build: registers listeners, initial lowBalance = None
      container.read(exchangeTopAmountProvider);

      // Mutate upstream: quote with lowBalance, assetsState={} → deliverAsset is None
      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.BUY
        ..lowBalance = From_Quote_LowBalance();
      container.read(quoteEventProvider.notifier).setQuote(quote);

      // Listener fired, deliverAsset.match(() {}, ...) hit line 275
      expect(container.read(exchangeTopAmountProvider), '');
    });

    test('quoteSuccess listener fires with deliverAsset None (line 289)', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('0');

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        retry: null,
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider
              .overrideWithValue(Option.of(testAssetUsdt)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider
              .overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          // Let instantSwapQuoteSuccessProvider and its deps run real
          exchangeQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeTopAmountProvider);

      // Mutate: create QuoteSuccess with empty assetsState → deliverAsset None
      final quoteSuccess = QuoteSuccess(
        mockAmountToString,
        From_Quote_Success(),
        assetPair,
        AssetType.BASE,
        TradeDir.BUY,
        AssetType.BASE,
        {},
        1,
      );
      container
          .read(instantSwapQuoteSuccessProvider.notifier)
          .setState(quoteSuccess);

      expect(container.read(exchangeTopAmountProvider), '');
    });

    test('quoteError listener fires with currentEditAsset None (line 307)',
        () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = MarketInfo()
        ..assetPair = assetPair
        ..feeAsset = AssetType.BASE;

      final container = ProviderContainer.test(
        retry: null,
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider
              .overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          exchangeCurrentEditAssetProvider
              .overrideWithValue(Option.none()), // None → line 307
          exchangeAccepQuoteStateProvider
              .overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          // DON'T override exchangeQuoteErrorProvider — let it compute
          // exchangeQuoteErrorProvider depends on exchangeQuoteProvider + exchangeAcceptQuoteErrorProvider
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeTopAmountProvider);

      // Mutate: quote with error → exchangeQuoteErrorProvider becomes Some
      final quote = From_Quote()
        ..assetPair = assetPair
        ..error = 'test error';
      container.read(quoteEventProvider.notifier).setQuote(quote);

      expect(container.read(exchangeTopAmountProvider), '');
    });
  });

  group('ExchangeBottomAmount listener callbacks via upstream mutation', () {
    test('lowBalance listener fires with receiveAsset None (line 375)', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('0');

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = MarketInfo()
        ..assetPair = assetPair
        ..feeAsset = AssetType.BASE;

      final container = ProviderContainer.test(
        retry: null,
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider
              .overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider
              .overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider);

      final quote = From_Quote()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL
        ..lowBalance = From_Quote_LowBalance();
      container.read(quoteEventProvider.notifier).setQuote(quote);

      expect(container.read(exchangeBottomAmountProvider), '');
    });

    test('quoteSuccess listener fires with receiveAsset None (line 389)', () {
      final mockAmountToString = MockAmountToString();
      when(() => mockAmountToString.amountToString(any())).thenReturn('0');

      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';

      final container = ProviderContainer.test(
        retry: null,
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider
              .overrideWithValue(Option.of(testAssetUsdt)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider
              .overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          exchangeQuoteErrorProvider.overrideWithValue(Option.none()),
          exchangeQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider);

      final quoteSuccess = QuoteSuccess(
        mockAmountToString,
        From_Quote_Success(),
        assetPair,
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );
      container
          .read(instantSwapQuoteSuccessProvider.notifier)
          .setState(quoteSuccess);

      expect(container.read(exchangeBottomAmountProvider), '');
    });

    test('quoteError listener fires with currentEditAsset None (line 407)',
        () {
      final assetPair = AssetPair()
        ..base = 'btc'
        ..quote = 'usdt';
      final marketInfo = MarketInfo()
        ..assetPair = assetPair
        ..feeAsset = AssetType.BASE;

      final container = ProviderContainer.test(
        retry: null,
        overrides: [
          exchangeTopAssetProvider.overrideWithValue(Option.of(testAssetBtc)),
          exchangeBottomAssetProvider
              .overrideWithValue(Option.of(testAssetUsdt)),
          exchangeAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          exchangeMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          exchangeCurrentEditAssetProvider.overrideWithValue(Option.none()),
          exchangeAccepQuoteStateProvider
              .overrideWithValue(ExchangeAcceptQuoteState.empty()),
          exchangeLowBalanceErrorProvider.overrideWithValue(Option.none()),
          instantSwapQuoteSuccessProvider.overrideWithValue(Option.none()),
          exchangeAcceptQuoteErrorProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      container.read(exchangeBottomAmountProvider);

      final quote = From_Quote()
        ..assetPair = assetPair
        ..error = 'test error';
      container.read(quoteEventProvider.notifier).setQuote(quote);

      expect(container.read(exchangeBottomAmountProvider), '');
    });
  });
}

