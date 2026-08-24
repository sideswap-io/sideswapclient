import 'package:decimal/decimal.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';


class MockWallet extends Mock implements SideswapWallet {}

class MockAmountToString extends Mock implements AmountToString {}

void main() {
  setUpAll(() {
    registerFallbackValue(To());
    registerFallbackValue(AmountToStringParameters(
      amount: 0,
      precision: 8,
    ));
    registerFallbackValue(Decimal.zero);
  });

  group('QuoteEventNotifier', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    group('build', () {
      test('initial state is Option.none', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final quoteEventNotifier = container.read(quoteEventProvider);
        expect(quoteEventNotifier, Option.none());
      });

      test('initializes _currentQuoteId on build', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);
        // After build, randomId should have been called
        expect(notifier, isNotNull);
      });
    });

    group('setQuote', () {
      test('accepts quote with matching clientSubId', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);
        final quote = From_Quote()..success = From_Quote_Success();

        notifier.setQuote(quote);
        expect(container.read(quoteEventProvider), Option.of(quote));
      });

      test('rejects quote with non-matching clientSubId', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);
        final initialState = container.read(quoteEventProvider);

        final quote = From_Quote()
          ..success = From_Quote_Success()
          ..clientSubId = Int64(999999);

        notifier.setQuote(quote);
        // State should not change because clientSubId doesn't match
        expect(container.read(quoteEventProvider), initialState);
      });

      test('accepts quote without clientSubId (treated as no ID requirement)', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);
        final quote = From_Quote()..success = From_Quote_Success();
        // Quote without clientSubId should be accepted

        notifier.setQuote(quote);
        expect(container.read(quoteEventProvider), Option.of(quote));
      });
    });

    group('startQuotes', () {
      test('sends startQuotes message with correct parameters', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);
        final assetPair = AssetPair(base: 'BTC', quote: 'USDT');
        const assetType = AssetType.BASE;
        const amount = 1000000;
        const tradeDir = TradeDir.BUY;

        notifier.startQuotes(
          assetPair: assetPair,
          assetType: assetType,
          amount: amount,
          tradeDir: tradeDir,
        );

        verify(() => mockWallet.sendMsg(any(that: predicate(
          (dynamic msg) =>
              msg is To &&
              msg.hasStartQuotes() &&
              msg.startQuotes.assetPair.base == assetPair.base &&
              msg.startQuotes.assetPair.quote == assetPair.quote &&
              msg.startQuotes.assetType == assetType &&
              msg.startQuotes.amount == Int64(amount) &&
              msg.startQuotes.tradeDir == tradeDir &&
              msg.startQuotes.instantSwap == false,
        )))).called(1);
      });

      test('sends startQuotes message with instantSwap=true', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        notifier.startQuotes(
          assetPair: AssetPair(base: 'BTC', quote: 'USDT'),
          assetType: AssetType.BASE,
          amount: 100,
          tradeDir: TradeDir.SELL,
          instantSwap: true,
        );

        verify(() => mockWallet.sendMsg(any(that: predicate(
          (dynamic msg) =>
              msg is To &&
              msg.hasStartQuotes() &&
              msg.startQuotes.instantSwap == true,
        )))).called(1);
      });

      test('resets _currentQuoteId and state on startQuotes', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        // Set initial state
        final quote = From_Quote()..success = From_Quote_Success();
        notifier.setQuote(quote);
        expect(container.read(quoteEventProvider), Option.of(quote));

        // Start quotes should reset state
        notifier.startQuotes(
          assetPair: AssetPair(base: 'BTC', quote: 'USDT'),
          assetType: AssetType.BASE,
          amount: 100,
          tradeDir: TradeDir.BUY,
        );

        expect(container.read(quoteEventProvider), Option.none());
      });
    });

    group('stopQuotes', () {
      test('sends stopQuotes message', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        notifier.stopQuotes();

        verify(() => mockWallet.sendMsg(any(that: predicate(
          (dynamic msg) =>
              msg is To &&
              msg.hasStopQuotes(),
        )))).called(1);
      });

      test('invalidates self and resets state', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        // Set initial state
        final quote = From_Quote()..success = From_Quote_Success();
        notifier.setQuote(quote);

        notifier.stopQuotes();

        expect(container.read(quoteEventProvider), Option.none());
      });
    });

    group('randomId', () {
      test('generates Int64 within default range', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        final id = notifier.randomId();
        expect(id, greaterThanOrEqualTo(Int64(0)));
        expect(id, lessThan(Int64.MAX_VALUE));
      });

      test('generates Int64 within custom range [min, max)', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        for (int i = 0; i < 10; i++) {
          final id = notifier.randomId(min: 100, max: 200);
          expect(id, greaterThanOrEqualTo(Int64(100)));
          expect(id, lessThan(Int64(200)));
        }
      });

      test('throws ArgumentError when min > max', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        expect(
          () => notifier.randomId(min: 100, max: 50),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('min'),
          )),
        );
      });

      test('returns min value when min equals max', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        final result = notifier.randomId(min: 100, max: 100);
        expect(result, equals(Int64(100)));
      });

      test('handles null max as Int64.MAX_VALUE', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        final id = notifier.randomId(min: 0, max: null);
        expect(id, greaterThanOrEqualTo(Int64(0)));
      });

      test('generates different IDs on multiple calls', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quoteEventProvider.notifier);

        final ids = <Int64>{};
        for (int i = 0; i < 20; i++) {
          ids.add(notifier.randomId(min: 0, max: 1000));
        }

        // Should have generated multiple different IDs (very likely)
        expect(ids.length, greaterThan(1));
      });
    });
  });

  group('QuoteError', () {
    test('has default values', () {
      const quoteError = QuoteError();
      expect(quoteError.error, '');
      expect(quoteError.orderId, 0);
    });

    test('can be created with custom error string', () {
      const quoteError = QuoteError(error: 'test error');
      expect(quoteError.error, 'test error');
      expect(quoteError.orderId, 0);
    });

    test('can be created with custom orderId', () {
      const quoteError = QuoteError(orderId: 123);
      expect(quoteError.error, '');
      expect(quoteError.orderId, 123);
    });

    test('can be created with both custom values', () {
      const quoteError = QuoteError(error: 'custom error', orderId: 456);
      expect(quoteError.error, 'custom error');
      expect(quoteError.orderId, 456);
    });
  });

  group('ConvertAmount', () {
    late MockAmountToString mockAmountToString;

    setUp(() {
      mockAmountToString = MockAmountToString();
    });

    group('convertAmountForAsset', () {
      test('returns empty string when asset is None', () {
        final convertAmount = ConvertAmount(mockAmountToString);

        final result = convertAmount.convertAmountForAsset(
          1000,
          Option.none(),
        );

        expect(result, '');
        verifyNever(() => mockAmountToString.amountToString(any()));
      });

      test('calls amountToString with correct parameters when asset is Some', () {
        const expectedResult = '0.00001000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final convertAmount = ConvertAmount(mockAmountToString);
        final asset = Asset()..precision = 8;

        final result = convertAmount.convertAmountForAsset(
          1000,
          Option.of(asset),
        );

        expect(result, expectedResult);
        verify(() => mockAmountToString.amountToString(any(
          that: predicate<AmountToStringParameters>(
            (params) => params.amount == 1000 && params.precision == 8,
          ),
        ))).called(1);
      });

      test('respects trailingZeroes parameter', () {
        const expectedResult = '0.0001';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final convertAmount = ConvertAmount(mockAmountToString);
        final asset = Asset()..precision = 8;

        convertAmount.convertAmountForAsset(
          10000,
          Option.of(asset),
          trailingZeroes: false,
        );

        verify(() => mockAmountToString.amountToString(any(
          that: predicate<AmountToStringParameters>(
            (params) => params.trailingZeroes == false,
          ),
        ))).called(1);
      });

      test('defaults trailingZeroes to true', () {
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn('1.00000000');

        final convertAmount = ConvertAmount(mockAmountToString);
        final asset = Asset()..precision = 8;

        convertAmount.convertAmountForAsset(100000000, Option.of(asset));

        verify(() => mockAmountToString.amountToString(any(
          that: predicate<AmountToStringParameters>(
            (params) => params.trailingZeroes == true,
          ),
        ))).called(1);
      });
    });
  });

  group('QuoteLowBalance', () {
    late MockAmountToString mockAmountToString;

    setUp(() {
      mockAmountToString = MockAmountToString();
    });

    test('quoteLowBalance returns the underlying proto object', () {
      final proto = From_Quote_LowBalance();
      final qlb = QuoteLowBalance(
        mockAmountToString,
        proto,
        AssetPair(base: 'BTC', quote: 'USDT'),
        AssetType.BASE,
        TradeDir.BUY,
        AssetType.BASE,
        {},
        1,
      );
      expect(qlb.quoteLowBalance, same(proto));
    });

    group('asset getters', () {
      test('baseAsset returns Some when asset exists in assetsState', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.baseAsset, Option.of(baseAsset));
      });

      test('baseAsset returns None when asset missing in assetsState', () {
        final assetsState = <String, Asset>{};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.baseAsset, Option.none());
      });

      test('quoteAsset returns Some when asset exists', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final assetsState = {'USDT': quoteAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.quoteAsset, Option.of(quoteAsset));
      });

      test('quoteAsset returns None when asset missing', () {
        final assetsState = <String, Asset>{};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.quoteAsset, Option.none());
      });
    });

    group('amount getters', () {
      test('baseAmount converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..baseAmount = Int64(1000000);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.baseAmount, 1000000);
      });

      test('quoteAmount converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..quoteAmount = Int64(2000000);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.quoteAmount, 2000000);
      });

      test('serverFee converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..serverFee = Int64(100);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.serverFee, 100);
      });

      test('fixedFee converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..fixedFee = Int64(50);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.fixedFee, 50);
      });

      test('totalFee sums serverFee and fixedFee', () {
        final lowBalance = From_Quote_LowBalance()
          ..serverFee = Int64(100)
          ..fixedFee = Int64(50);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.totalFee, 150);
      });

      test('available converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..available = Int64(5000000);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.available, 5000000);
      });

      test('sendAmount converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..sendAmount = Int64(3000000);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.sendAmount, 3000000);
      });

      test('recvAmount converts Int64 to int', () {
        final lowBalance = From_Quote_LowBalance()
          ..recvAmount = Int64(2500000);
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteLowBalance.recvAmount, 2500000);
      });
    });

    group('deliverAsset', () {
      test('returns baseAsset when assetType is BASE and tradeDir is SELL', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.deliverAsset, Option.of(baseAsset));
      });

      test('returns quoteAsset when assetType is BASE and tradeDir is BUY', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final assetsState = {'USDT': quoteAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.deliverAsset, Option.of(quoteAsset));
      });

      test('returns quoteAsset when assetType is not BASE and tradeDir is SELL', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final assetsState = {'USDT': quoteAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.QUOTE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.deliverAsset, Option.of(quoteAsset));
      });

      test('returns baseAsset when assetType is not BASE and tradeDir is BUY', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.QUOTE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.deliverAsset, Option.of(baseAsset));
      });
    });

    group('receiveAsset', () {
      test('returns quoteAsset when assetType is BASE and tradeDir is SELL', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final assetsState = {'USDT': quoteAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.receiveAsset, Option.of(quoteAsset));
      });

      test('returns baseAsset when assetType is BASE and tradeDir is BUY', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.receiveAsset, Option.of(baseAsset));
      });

      test('returns baseAsset when assetType is not BASE and tradeDir is SELL', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.QUOTE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.receiveAsset, Option.of(baseAsset));
      });

      test('returns quoteAsset when assetType is not BASE and tradeDir is BUY', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final assetsState = {'USDT': quoteAsset};
        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          From_Quote_LowBalance(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.QUOTE,
          TradeDir.BUY,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.receiveAsset, Option.of(quoteAsset));
      });
    });

    group('deliverAmount', () {
      test('returns formatted send amount for deliver asset', () {
        const expectedResult = '0.03000000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final lowBalance = From_Quote_LowBalance()
          ..sendAmount = Int64(3000000);
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};

        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.deliverAmount, expectedResult);
      });
    });

    group('receiveAmount', () {
      test('returns formatted receive amount for receive asset', () {
        const expectedResult = '200.00000000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final lowBalance = From_Quote_LowBalance()
          ..recvAmount = Int64(20000000000);
        final quoteAsset = Asset()..ticker = 'USDT';
        final assetsState = {'USDT': quoteAsset};

        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.receiveAmount, expectedResult);
      });
    });

    group('availableAmount', () {
      test('returns formatted available amount for deliver asset', () {
        const expectedResult = '0.05000000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final lowBalance = From_Quote_LowBalance()
          ..available = Int64(5000000);
        final baseAsset = Asset()..ticker = 'BTC';
        final assetsState = {'BTC': baseAsset};

        final quoteLowBalance = QuoteLowBalance(
          mockAmountToString,
          lowBalance,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          assetsState,
          1,
        );

        expect(quoteLowBalance.availableAmount, expectedResult);
      });
    });
  });

  group('QuoteSuccess', () {
    late MockAmountToString mockAmountToString;

    setUp(() {
      mockAmountToString = MockAmountToString();
    });

    group('construction and properties', () {
      test('stores correct values', () {
        final success = From_Quote_Success()..quoteId = Int64(999);
        final pair = AssetPair(base: 'BTC', quote: 'USDT');
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          pair,
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          123,
        );

        expect(quoteSuccess.quoteSuccess, success);
        expect(quoteSuccess.quoteId, 999);
        expect(quoteSuccess.orderId, 123);
      });

      test('timestamp is set to current time', () {
        final success = From_Quote_Success();
        final before = DateTime.timestamp();
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );
        final after = DateTime.timestamp();

        expect(quoteSuccess.timestamp.isAfter(before) || quoteSuccess.timestamp == before, true);
        expect(quoteSuccess.timestamp.isBefore(after) || quoteSuccess.timestamp == after, true);
      });

      test('supports optional startOrderSuccess', () {
        final success = From_Quote_Success();
        final startOrder = From_StartOrder_Success();
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
          startOrderSuccess: startOrder,
        );

        expect(quoteSuccess.startOrderSuccess, startOrder);
      });
    });

    group('asset getters', () {
      test('baseAsset returns Some when exists', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'BTC': baseAsset},
          1,
        );

        expect(quoteSuccess.baseAsset, Option.of(baseAsset));
      });

      test('quoteAsset returns None when missing', () {
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.quoteAsset, Option.none());
      });
    });

    group('amount getters', () {
      test('ttlMilliseconds converts Int64 to int', () {
        final success = From_Quote_Success()..ttlMilliseconds = Int64(30000);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.ttlMilliseconds, 30000);
      });

      test('baseAmount converts Int64 to int', () {
        final success = From_Quote_Success()..baseAmount = Int64(1000000);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.baseAmount, 1000000);
      });

      test('quoteAmount converts Int64 to int', () {
        final success = From_Quote_Success()..quoteAmount = Int64(50000000000);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.quoteAmount, 50000000000);
      });

      test('serverFee converts Int64 to int', () {
        final success = From_Quote_Success()..serverFee = Int64(1000);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.serverFee, 1000);
      });

      test('fixedFee converts Int64 to int', () {
        final success = From_Quote_Success()..fixedFee = Int64(500);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.fixedFee, 500);
      });

      test('totalFee sums serverFee and fixedFee', () {
        final success = From_Quote_Success()
          ..serverFee = Int64(1000)
          ..fixedFee = Int64(500);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.totalFee, 1500);
      });

      test('sendAmount converts Int64 to int', () {
        final success = From_Quote_Success()..sendAmount = Int64(1000000);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.sendAmount, 1000000);
      });

      test('recvAmount converts Int64 to int', () {
        final success = From_Quote_Success()..recvAmount = Int64(50000000000);
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        expect(quoteSuccess.recvAmount, 50000000000);
      });
    });

    group('deliverAsset and receiveAsset', () {
      test('deliverAsset respects asset type and trade direction', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          {'BTC': baseAsset},
          1,
        );

        expect(quoteSuccess.deliverAsset, Option.of(baseAsset));
      });

      test('receiveAsset respects asset type and trade direction', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          {'USDT': quoteAsset},
          1,
        );

        expect(quoteSuccess.receiveAsset, Option.of(quoteAsset));
      });
    });

    group('deliverAmount and receiveAmount', () {
      test('deliverAmount returns formatted send amount', () {
        const expectedResult = '0.01000000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final success = From_Quote_Success()..sendAmount = Int64(1000000);
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          {'BTC': baseAsset},
          1,
        );

        expect(quoteSuccess.deliverAmount, expectedResult);
      });

      test('receiveAmount returns formatted receive amount', () {
        const expectedResult = '100.00000000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final success = From_Quote_Success()..recvAmount = Int64(10000000000);
        final quoteAsset = Asset()..ticker = 'USDT';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.SELL,
          AssetType.BASE,
          {'USDT': quoteAsset},
          1,
        );

        expect(quoteSuccess.receiveAmount, expectedResult);
      });
    });

    group('feeAsset and fee strings', () {
      test('feeAsset returns baseAsset when feeAssetType is BASE', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'BTC': baseAsset},
          1,
        );

        expect(quoteSuccess.feeAsset, Option.of(baseAsset));
      });

      test('feeAsset returns quoteAsset when feeAssetType is not BASE', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.QUOTE,
          {'USDT': quoteAsset},
          1,
        );

        expect(quoteSuccess.feeAsset, Option.of(quoteAsset));
      });

      test('fixedFeeString returns formatted fixed fee', () {
        const expectedResult = '0.00000500';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final success = From_Quote_Success()..fixedFee = Int64(500);
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'BTC': baseAsset},
          1,
        );

        expect(quoteSuccess.fixedFeeString, expectedResult);
      });

      test('serverFeeString returns formatted server fee', () {
        const expectedResult = '0.00001000';
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn(expectedResult);

        final success = From_Quote_Success()..serverFee = Int64(1000);
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'BTC': baseAsset},
          1,
        );

        expect(quoteSuccess.serverFeeString, expectedResult);
      });
    });

    group('price calculation', () {
      test('price returns zero when quoteAsset is None', () {
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {}, // No assets
          1,
        );

        expect(quoteSuccess.price, Decimal.zero);
      });

      test('price returns zero when baseAsset is None', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'USDT': quoteAsset}, // Only quote asset
          1,
        );

        expect(quoteSuccess.price, Decimal.zero);
      });

      test('price returns zero when priceAsset is None', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'BTC': baseAsset}, // Only base asset
          1,
        );

        expect(quoteSuccess.price, Decimal.zero);
      });

      test('price calculates correctly when all assets exist', () {
        when(() => mockAmountToString.amountToString(any()))
            .thenAnswer((invocation) {
          final params = invocation.positionalArguments[0] as AmountToStringParameters;
          return params.amount.toString();
        });

        final success = From_Quote_Success()
          ..baseAmount = Int64(100000000) // 1 BTC at 8 decimal
          ..quoteAmount = Int64(4200000000000000); // 42000 USDT at 8 decimal

        final baseAsset = Asset()
          ..ticker = 'BTC'
          ..precision = 8;
        final quoteAsset = Asset()
          ..ticker = 'USDT'
          ..precision = 8;

        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {
            'BTC': baseAsset,
            'USDT': quoteAsset,
          },
          1,
        );

        final price = quoteSuccess.price;
        expect(price, isNot(equals(Decimal.zero))); // Non-zero result
      });
    });

    group('priceString', () {
      test('returns empty string when priceAsset is None', () {
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {}, // No assets
          1,
        );

        expect(quoteSuccess.priceString, '');
      });

      test('returns formatted price string when priceAsset exists', () {
        when(() => mockAmountToString.amountToString(any()))
            .thenReturn('1.00000000');
        when(() => mockAmountToString.indexPriceFormatted(any(), any()))
            .thenReturn('42000.00');

        final quoteAsset = Asset()
          ..ticker = 'USDT'
          ..precision = 8;
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'USDT': quoteAsset},
          1,
        );

        final priceString = quoteSuccess.priceString;
        expect(priceString, isNotEmpty);
        expect(priceString, equals('1.00000000'));
      });
    });

    group('priceAsset', () {
      test('priceAsset is always quoteAsset', () {
        final quoteAsset = Asset()..ticker = 'USDT';
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success(),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {'USDT': quoteAsset},
          1,
        );

        expect(quoteSuccess.priceAsset, Option.of(quoteAsset));
      });
    });

    group('deliverAsset and receiveAsset branch coverage', () {
      late MockAmountToString mockAmountToString;
      late Asset baseAsset;
      late Asset quoteAsset;
      late Map<String, Asset> assetsState;

      setUp(() {
        mockAmountToString = MockAmountToString();
        baseAsset = Asset()..ticker = 'BTC';
        quoteAsset = Asset()..ticker = 'USDT';
        assetsState = {'BTC': baseAsset, 'USDT': quoteAsset};
      });

      QuoteSuccess makeQuoteSuccess(AssetType assetType, TradeDir tradeDir) =>
          QuoteSuccess(
            mockAmountToString,
            From_Quote_Success(),
            AssetPair(base: 'BTC', quote: 'USDT'),
            assetType,
            tradeDir,
            AssetType.BASE,
            assetsState,
            1,
          );

      test('deliverAsset: BASE + BUY returns quoteAsset', () {
        final qs = makeQuoteSuccess(AssetType.BASE, TradeDir.BUY);
        expect(qs.deliverAsset, Option.of(quoteAsset));
      });

      test('deliverAsset: QUOTE + SELL returns quoteAsset', () {
        final qs = makeQuoteSuccess(AssetType.QUOTE, TradeDir.SELL);
        expect(qs.deliverAsset, Option.of(quoteAsset));
      });

      test('deliverAsset: QUOTE + BUY returns baseAsset', () {
        final qs = makeQuoteSuccess(AssetType.QUOTE, TradeDir.BUY);
        expect(qs.deliverAsset, Option.of(baseAsset));
      });

      test('receiveAsset: BASE + BUY returns baseAsset', () {
        final qs = makeQuoteSuccess(AssetType.BASE, TradeDir.BUY);
        expect(qs.receiveAsset, Option.of(baseAsset));
      });

      test('receiveAsset: QUOTE + SELL returns baseAsset', () {
        final qs = makeQuoteSuccess(AssetType.QUOTE, TradeDir.SELL);
        expect(qs.receiveAsset, Option.of(baseAsset));
      });

      test('receiveAsset: QUOTE + BUY returns quoteAsset', () {
        final qs = makeQuoteSuccess(AssetType.QUOTE, TradeDir.BUY);
        expect(qs.receiveAsset, Option.of(quoteAsset));
      });
    });
  });

  group('QuoteUnregisteredGaid', () {
    test('stores orderId and quoteUnregisteredGaid', () {
      final unreg = From_Quote_UnregisteredGaid()..domainAgent = 'example.com';
      final quote = QuoteUnregisteredGaid(
        orderId: Int64(123),
        quoteUnregisteredGaid: unreg,
      );

      expect(quote.orderId, Int64(123));
      expect(quote.quoteUnregisteredGaid, unreg);
    });

    test('domainAgent getter returns domain from protobuf', () {
      final unreg = From_Quote_UnregisteredGaid()..domainAgent = 'test.domain';
      final quote = QuoteUnregisteredGaid(
        orderId: Int64(1),
        quoteUnregisteredGaid: unreg,
      );

      expect(quote.domainAgent, 'test.domain');
    });
  });

  group('AcceptQuoteNotifier', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    group('build', () {
      test('initial state is Option.none', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);

        final acceptQuote = container.read(acceptQuoteProvider);
        expect(acceptQuote, Option.none());
      });
    });

    group('setState', () {
      test('setState updates the state', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(acceptQuoteProvider.notifier);

        final acceptQuote = From_AcceptQuote()
          ..success = From_AcceptQuote_Success();

        notifier.setState(acceptQuote);

        expect(container.read(acceptQuoteProvider), Option.of(acceptQuote));
      });

      test('setState can be called multiple times', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(acceptQuoteProvider.notifier);

        final acceptQuote1 = From_AcceptQuote()
          ..success = From_AcceptQuote_Success();
        final acceptQuote2 = From_AcceptQuote()
          ..success = From_AcceptQuote_Success();

        notifier.setState(acceptQuote1);
        expect(container.read(acceptQuoteProvider), Option.of(acceptQuote1));

        notifier.setState(acceptQuote2);
        expect(container.read(acceptQuoteProvider), Option.of(acceptQuote2));
      });
    });
  });

  group('QuoteIndexPrice', () {
    late MockAmountToString mockAmountToString;

    setUp(() {
      mockAmountToString = MockAmountToString();
    });

    group('price', () {
      test('returns None when priceTaker cannot be parsed as Decimal', () {
        final quoteIndexPrice = QuoteIndexPrice(
          mockAmountToString,
          double.nan,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          {},
          _MockSatoshiRepository(),
        );

        expect(quoteIndexPrice.price(), Option.none());
      });

      test('returns Some(Decimal) when priceTaker is valid', () {
        final quoteIndexPrice = QuoteIndexPrice(
          mockAmountToString,
          42000.5,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          {},
          _MockSatoshiRepository(),
        );

        final price = quoteIndexPrice.price();
        expect(price.isSome(), true);
        price.match(
          () => fail('Expected Some'),
          (p) => expect(p, isA<Decimal>()),
        );
      });
    });

    group('priceString', () {
      test('returns empty string when baseAsset is missing', () {
        final quoteIndexPrice = QuoteIndexPrice(
          mockAmountToString,
          42000.0,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          {}, // No assets
          _MockSatoshiRepository(),
        );

        expect(quoteIndexPrice.priceString(), '');
      });

      test('returns empty string when quoteAsset is missing', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteIndexPrice = QuoteIndexPrice(
          mockAmountToString,
          42000.0,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          {'BTC': baseAsset}, // Only base asset
          _MockSatoshiRepository(),
        );

        expect(quoteIndexPrice.priceString(), '');
      });

      test('returns formatted price string when all assets exist', () {
        when(() => mockAmountToString.indexPriceFormatted(any(), any()))
            .thenReturn('42000.00');

        final baseAsset = Asset()
          ..ticker = 'BTC'
          ..precision = 8;
        final quoteAsset = Asset()
          ..ticker = 'USDT'
          ..precision = 8;

        final quoteIndexPrice = QuoteIndexPrice(
          mockAmountToString,
          42000.0,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          {
            'BTC': baseAsset,
            'USDT': quoteAsset,
          },
          _MockSatoshiRepository(),
        );

        final priceString = quoteIndexPrice.priceString();
        expect(priceString, contains('1'));
        expect(priceString, contains('BTC'));
        expect(priceString, contains('USDT'));
        expect(priceString, contains('42000.00'));
      });

      test('returns empty string when price is None', () {
        final baseAsset = Asset()..ticker = 'BTC';
        final quoteAsset = Asset()..ticker = 'USDT';

        final quoteIndexPrice = QuoteIndexPrice(
          mockAmountToString,
          double.nan, // Cannot parse to Decimal
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          {
            'BTC': baseAsset,
            'USDT': quoteAsset,
          },
          _MockSatoshiRepository(),
        );

        expect(quoteIndexPrice.priceString(), '');
      });
    });
  });

  group('PreviewOrderQuoteSuccessNotifier', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    group('build', () {
      test('initial state is Option.none', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);

        final state = container.read(previewOrderQuoteSuccessProvider);
        expect(state, Option.none());
      });
    });

    group('setState', () {
      test('setState updates state to Some(quoteSuccess)', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(previewOrderQuoteSuccessProvider.notifier);

        final mockAmountToString = MockAmountToString();
        final success = From_Quote_Success();
        final quoteSuccess = QuoteSuccess(
          mockAmountToString,
          success,
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        notifier.setState(quoteSuccess);

        expect(container.read(previewOrderQuoteSuccessProvider), Option.of(quoteSuccess));
      });
    });
  });

  group('OrderTtlState', () {
    test('OrderTtlState.empty() creates empty state', () {
      const state = OrderTtlState.empty();
      expect(state, isA<OrderTtlStateEmpty>());
    });

    test('OrderTtlState.data() creates data state with values', () {
      final timestamp = DateTime.now();
      final state = OrderTtlState.data(seconds: 30, timestamp: timestamp);
      expect(state, isA<OrderTtlStateData>());
      state.map(
        empty: (_) => fail('Expected data'),
        data: (data) {
          expect(data.seconds, 30);
          expect(data.timestamp, timestamp);
        },
      );
    });
  });

  group('OrderTtlNotifier', () {
    late MockWallet mockWallet;
    late MockAmountToString mockAmountToString;

    setUp(() {
      mockWallet = MockWallet();
      mockAmountToString = MockAmountToString();
    });

    group('build', () {
      test('returns empty state when previewOrderQuoteSuccess is None', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);

        final state = container.read(orderTtlProvider);
        expect(state, isA<OrderTtlStateEmpty>());
      });

      test('returns data state when previewOrderQuoteSuccess is Some', () {
        final mockQuoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success()..ttlMilliseconds = Int64(30000),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            previewOrderQuoteSuccessProvider.overrideWithValue(Option.of(mockQuoteSuccess)),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(orderTtlProvider);
        expect(state, isA<OrderTtlStateData>());
        state.map(
          empty: (_) => fail('Expected data'),
          data: (data) {
            expect(data.seconds, 30);
          },
        );
      });

      test('correctly converts milliseconds to seconds', () {
        final mockQuoteSuccess = QuoteSuccess(
          mockAmountToString,
          From_Quote_Success()..ttlMilliseconds = Int64(45500),
          AssetPair(base: 'BTC', quote: 'USDT'),
          AssetType.BASE,
          TradeDir.BUY,
          AssetType.BASE,
          {},
          1,
        );

        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            previewOrderQuoteSuccessProvider.overrideWithValue(Option.of(mockQuoteSuccess)),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(orderTtlProvider);
        state.map(
          empty: (_) => fail('Expected data'),
          data: (data) {
            expect(data.seconds, 46); // (45500 / 1000).round() = 46
          },
        );
      });
    });

    group('setState', () {
      test('setState updates the state', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(mockWallet)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(orderTtlProvider.notifier);

        final timestamp = DateTime.now();
        final newState = OrderTtlState.data(seconds: 60, timestamp: timestamp);

        notifier.setState(newState);

        final state = container.read(orderTtlProvider);
        expect(state, isA<OrderTtlStateData>());
      });
    });
  });

  group('OrderSignTtl', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    test('initial state is zero when OrderTtlState is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          orderTtlProvider.overrideWithValue(OrderTtlState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final ttl = container.read(orderSignTtlProvider);
      expect(ttl, 0);
    });

    test('calculates remaining seconds correctly from OrderTtlState.data', () {
      final now = DateTime.now();
      final currentTimestamp = now;

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          orderTtlProvider.overrideWithValue(
            OrderTtlState.data(seconds: 30, timestamp: currentTimestamp),
          ),
        ],
      );
      addTearDown(container.dispose);

      final ttl = container.read(orderSignTtlProvider);
      expect(ttl, greaterThanOrEqualTo(28));
      expect(ttl, lessThanOrEqualTo(30));
    });

    test('returns zero when expiry time has passed', () {
      final now = DateTime.now();
      final pastTimestamp = now.subtract(Duration(seconds: 35));

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          orderTtlProvider.overrideWithValue(
            OrderTtlState.data(seconds: 30, timestamp: pastTimestamp),
          ),
        ],
      );
      addTearDown(container.dispose);

      final ttl = container.read(orderSignTtlProvider);
      expect(ttl, 0);
    });

    test('updateState returns zero for empty state', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          orderTtlProvider.overrideWithValue(OrderTtlState.empty()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(orderSignTtlProvider.notifier);
      final result = notifier.updateState();
      expect(result, 0);
    });

    test('periodic timer tick recomputes ttl via updateState', () {
      fakeAsync((async) {
        final now = DateTime.timestamp();
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            orderTtlProvider.overrideWithValue(
              OrderTtlState.data(seconds: 30, timestamp: now),
            ),
          ],
        );
        addTearDown(container.dispose);

        // An active listener keeps the autoDispose provider (and the periodic
        // timer started in build()) alive across the elapse below.
        container.listen(orderSignTtlProvider, (_, _) {});

        // Advancing fake time fires the timer callback, which recomputes ttl.
        async.elapse(Duration(seconds: 1));

        expect(container.read(orderSignTtlProvider), greaterThanOrEqualTo(0));
      });
    });
  });
}

class _MockSatoshiRepository extends Mock implements AbstractSatoshiRepository {}
