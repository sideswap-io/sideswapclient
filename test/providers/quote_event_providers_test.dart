import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

void main() {
  group('QuoteEventNotifier', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    test('initial state is Option.none', () {
      final container = createContainer(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final quoteEventNotifier = container.read(quoteEventNotifierProvider);
      expect(quoteEventNotifier, Option.none());
    });

    test('setQuote updates the state', () {
      final container = createContainer(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final quoteEventNotifier = container.read(
        quoteEventNotifierProvider.notifier,
      );
      final quote = From_Quote();
      quote.success = From_Quote_Success();

      quoteEventNotifier.setQuote(quote);
      expect(container.read(quoteEventNotifierProvider), Option.of(quote));
    });

    test('startQuotes sends a startQuotes message', () {
      final container = createContainer(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final quoteEventNotifier = container.read(
        quoteEventNotifierProvider.notifier,
      );
      final assetPair = AssetPair(base: 'base', quote: 'quote');
      const assetType = AssetType.BASE;
      const amount = 100;
      const tradeDir = TradeDir.BUY;

      quoteEventNotifier.startQuotes(
        assetPair: assetPair,
        assetType: assetType,
        amount: amount,
        tradeDir: tradeDir,
      );

      final expectedMsg = To();
      expectedMsg.startQuotes = To_StartQuotes(
        assetPair: assetPair,
        assetType: assetType,
        amount: Int64(amount),
        tradeDir: tradeDir,
      );

      verify(() => mockWallet.sendMsg(expectedMsg)).called(1);
    });

    test('stopQuotes sends a stopQuotes message and invalidates self', () {
      final container = createContainer(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final quoteEventNotifier = container.read(
        quoteEventNotifierProvider.notifier,
      );

      quoteEventNotifier.stopQuotes();

      final expectedMsg = To();
      expectedMsg.stopQuotes = Empty();

      verify(() => mockWallet.sendMsg(expectedMsg)).called(1);
      // Check that invalidateSelf was called (indirectly by checking state)
      expect(container.read(quoteEventNotifierProvider), Option.none());
    });
  });

  group('QuoteError', () {
    test('QuoteError has default values', () {
      const quoteError = QuoteError();
      expect(quoteError.error, '');
      expect(quoteError.orderId, 0);
    });

    test('QuoteError can be created with custom values', () {
      const quoteError = QuoteError(error: 'test error', orderId: 123);
      expect(quoteError.error, 'test error');
      expect(quoteError.orderId, 123);
    });
  });

  group('AcceptQuoteNotifier', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    test('initial state is Option.none', () {
      final container = createContainer(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final acceptQuoteNotifier = container.read(acceptQuoteNotifierProvider);
      expect(acceptQuoteNotifier, Option.none());
    });

    test('setState updates the state', () {
      final container = createContainer(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final acceptQuoteNotifier = container.read(
        acceptQuoteNotifierProvider.notifier,
      );
      final acceptQuote = From_AcceptQuote();
      acceptQuote.success = From_AcceptQuote_Success();

      acceptQuoteNotifier.setState(acceptQuote);
      expect(
        container.read(acceptQuoteNotifierProvider),
        Option.of(acceptQuote),
      );
    });
  });
}
