import 'dart:async';
import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'quote_event_providers.g.dart';
part 'quote_event_providers.freezed.dart';

@riverpod
class QuoteEventNotifier extends _$QuoteEventNotifier {
  Int64 _currentQuoteId = Int64(0);

  @override
  Option<From_Quote> build() {
    ref.onCancel(() {
      stopQuotes();
    });

    _currentQuoteId = randomId();

    return Option.none();
  }

  void setQuote(From_Quote quote) {
    if (quote.clientSubId == _currentQuoteId || !quote.hasClientSubId()) {
      state = Option.of(quote);
    }
  }

  void startQuotes({
    required AssetPair assetPair,
    required AssetType assetType,
    required int amount,
    required TradeDir tradeDir,
    bool instantSwap = false,
  }) {
    _currentQuoteId = randomId();

    state = Option.none();

    final msg = To();
    msg.startQuotes = To_StartQuotes(
      assetPair: assetPair,
      assetType: assetType,
      amount: Int64(amount),
      tradeDir: tradeDir,
      instantSwap: instantSwap,
      clientSubId: _currentQuoteId,
    );

    ref.read(walletProvider).sendMsg(msg);
  }

  void stopQuotes() {
    final msg = To();
    msg.stopQuotes = Empty();
    ref.read(walletProvider).sendMsg(msg);
    _currentQuoteId = randomId();
    ref.invalidateSelf();
  }

  /// generates a random Int64 whose value falls between [min] (inclusive) and [max] (exclusive)
  Int64 randomId({int min = 0, int? max}) {
    // -- force default even if `null` is explicitly passed
    max ??= Int64.MAX_VALUE.toInt();

    if (min > max) {
      throw ArgumentError(
        'Value passed for `min` ($min) must be less than value passed for `max` ($max)',
      );
    }

    final rng = math.Random();
    var multiplier = rng.nextDouble();

    return Int64((multiplier * (max - min)).toInt() + min);
  }
}

@freezed
sealed class QuoteError with _$QuoteError {
  const factory QuoteError({
    @Default('') String error,
    @Default(0) int orderId,
  }) = _QuoteError;
}

class ConvertAmount {
  final AmountToString amountToString;

  ConvertAmount(this.amountToString);

  String convertAmountForAsset(
    int amount,
    Option<Asset> optionAsset, {
    bool trailingZeroes = true,
  }) {
    return optionAsset.match(
      () => () {
        return '';
      },
      (asset) => () {
        final amountStr = amountToString.amountToString(
          AmountToStringParameters(
            amount: amount,
            precision: asset.precision,
            trailingZeroes: trailingZeroes,
          ),
        );
        return amountStr;
      },
    )();
  }
}

class QuoteLowBalance extends ConvertAmount {
  final From_Quote_LowBalance _quoteLowBalance;
  final AssetPair assetPair;
  final AssetType assetType;
  final TradeDir tradeDir;
  final AssetType feeAsset;
  final Map<String, Asset> assetsState;
  final int orderId;

  QuoteLowBalance(
    super.amountToString,
    this._quoteLowBalance,
    this.assetPair,
    this.assetType,
    this.tradeDir,
    this.feeAsset,
    this.assetsState,
    this.orderId,
  );

  From_Quote_LowBalance get quoteLowBalance => _quoteLowBalance;

  Option<Asset> get baseAsset {
    final asset = assetsState[assetPair.base];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  Option<Asset> get quoteAsset {
    final asset = assetsState[assetPair.quote];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  int get baseAmount => _quoteLowBalance.baseAmount.toInt();
  int get quoteAmount => _quoteLowBalance.quoteAmount.toInt();
  int get serverFee => _quoteLowBalance.serverFee.toInt();
  int get fixedFee => _quoteLowBalance.fixedFee.toInt();
  int get totalFee =>
      (_quoteLowBalance.serverFee + _quoteLowBalance.fixedFee).toInt();
  int get available => _quoteLowBalance.available.toInt();

  String get availableAmount {
    return convertAmountForAsset(available, deliverAsset);
  }

  Option<Asset> get deliverAsset => switch (assetType) {
    AssetType.BASE => switch (tradeDir) {
      TradeDir.SELL => baseAsset,
      _ => quoteAsset,
    },
    _ => switch (tradeDir) {
      TradeDir.SELL => quoteAsset,
      _ => baseAsset,
    },
  };

  String get deliverAmount => switch (feeAsset == assetType) {
    true => switch (tradeDir) {
      TradeDir.SELL => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount + totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount + totalFee, quoteAsset),
      },
      _ => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
    },
    false => switch (tradeDir) {
      TradeDir.SELL => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
      _ => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount + totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount + totalFee, quoteAsset),
      },
    },
  };

  Option<Asset> get receiveAsset => switch (assetType) {
    AssetType.BASE => switch (tradeDir) {
      TradeDir.SELL => quoteAsset,
      _ => baseAsset,
    },
    _ => switch (tradeDir) {
      TradeDir.SELL => baseAsset,
      _ => quoteAsset,
    },
  };

  String get receiveAmount => switch (feeAsset == assetType) {
    true => switch (tradeDir) {
      TradeDir.SELL => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
      _ => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount - totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount - totalFee, quoteAsset),
      },
    },
    false => switch (tradeDir) {
      TradeDir.SELL => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount - totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount - totalFee, quoteAsset),
      },
      _ => switch (feeAsset) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
    },
  };
}

class QuoteSuccess extends ConvertAmount {
  final From_Quote_Success _quoteSuccess;
  final From_StartOrder_Success? startOrderSuccess;
  final DateTime _timestamp;
  final AssetPair assetPair;
  final AssetType assetType;
  final TradeDir tradeDir;
  final AssetType feeAssetType;
  final Map<String, Asset> assetsState;
  final int orderId;

  QuoteSuccess(
    super.amountToString,
    this._quoteSuccess,
    this.assetPair,
    this.assetType,
    this.tradeDir,
    this.feeAssetType,
    this.assetsState,
    this.orderId, {
    this.startOrderSuccess,
  }) : _timestamp = DateTime.timestamp();

  From_Quote_Success get quoteSuccess => _quoteSuccess;
  int get quoteId => _quoteSuccess.quoteId.toInt();

  DateTime get timestamp => _timestamp;

  Option<Asset> get baseAsset {
    final asset = assetsState[assetPair.base];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  Option<Asset> get quoteAsset {
    final asset = assetsState[assetPair.quote];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  int get ttlMilliseconds => _quoteSuccess.ttlMilliseconds.toInt();
  int get baseAmount => _quoteSuccess.baseAmount.toInt();
  int get quoteAmount => _quoteSuccess.quoteAmount.toInt();
  int get serverFee => _quoteSuccess.serverFee.toInt();
  int get fixedFee => _quoteSuccess.fixedFee.toInt();
  int get totalFee =>
      (_quoteSuccess.serverFee + _quoteSuccess.fixedFee).toInt();

  Option<Asset> get deliverAsset => switch (assetType) {
    AssetType.BASE => switch (tradeDir) {
      TradeDir.SELL => baseAsset,
      _ => quoteAsset,
    },
    _ => switch (tradeDir) {
      TradeDir.SELL => quoteAsset,
      _ => baseAsset,
    },
  };

  String get deliverAmount => switch (feeAssetType == assetType) {
    true => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        //* * sell base asset, no fee here (ie. import private order, if you find that fee is needed here then all deliver amount algo should be changed)
        AssetType.BASE => convertAmountForAsset(baseAmount, baseAsset),
        // sell quote asset, quote + fee
        _ => convertAmountForAsset(quoteAmount + totalFee, quoteAsset),
      },
      _ => switch (feeAssetType) {
        // buy base asset, quote + fee
        AssetType.BASE => convertAmountForAsset(
          quoteAmount + totalFee,
          quoteAsset,
        ),
        // buy base asset, no fee here
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
    },
    false => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        // sell base asset, no fee here
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
      _ => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount + totalFee,
          baseAsset,
        ),
        // buy quote asset, deliver + fee
        _ => convertAmountForAsset(quoteAmount + totalFee, quoteAsset),
      },
    },
  };

  Option<Asset> get receiveAsset => switch (assetType) {
    AssetType.BASE => switch (tradeDir) {
      TradeDir.SELL => quoteAsset,
      _ => baseAsset,
    },
    _ => switch (tradeDir) {
      TradeDir.SELL => baseAsset,
      _ => quoteAsset,
    },
  };

  String get receiveAmount => switch (feeAssetType == assetType) {
    true => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        // sell quote asset, no fee here
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        // sell quote asset, no fee here
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
      _ => switch (feeAssetType) {
        // buy base asset, no fee here
        AssetType.BASE => convertAmountForAsset(baseAmount, baseAsset),
        // buy base asset, quote - fee
        _ => convertAmountForAsset(quoteAmount - totalFee, quoteAsset),
      },
    },
    false => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount - totalFee,
          baseAsset,
        ),
        // sell base asset, quote - fee
        _ => convertAmountForAsset(quoteAmount - totalFee, quoteAsset),
      },
      _ => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        // buy quote asset, no fee here
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
    },
  };

  Option<Asset> get feeAsset => switch (feeAssetType) {
    AssetType.BASE => baseAsset,
    _ => quoteAsset,
  };

  String get fixedFeeString => convertAmountForAsset(fixedFee, feeAsset);
  String get serverFeeString => convertAmountForAsset(serverFee, feeAsset);

  Decimal get price {
    return quoteAsset.match(
      () => Decimal.zero,
      (quoteAsset) => baseAsset.match(
        () => Decimal.zero,
        (baseAsset) => priceAsset.match(() => Decimal.zero, (priceAsset) {
          final quoteAmountString = super.amountToString.amountToString(
            AmountToStringParameters(
              amount: quoteAmount,
              precision: quoteAsset.precision,
            ),
          );
          final baseAmountString = super.amountToString.amountToString(
            AmountToStringParameters(
              amount: baseAmount,
              precision: baseAsset.precision,
            ),
          );

          final quoteDecimal =
              Decimal.tryParse(quoteAmountString) ?? Decimal.zero;
          final baseDecimal =
              Decimal.tryParse(baseAmountString) ?? Decimal.zero;

          final priceDecimal = (quoteDecimal / baseDecimal).toDecimal(
            scaleOnInfinitePrecision: priceAsset.precision,
          );

          return priceDecimal;
        }),
      ),
    );
  }

  String get priceString {
    return priceAsset.match(() => '', (asset) {
      final amount = toIntAmount(price.toDouble(), precision: asset.precision);
      return convertAmountForAsset(amount, priceAsset);
    });
  }

  Option<Asset> get priceAsset => feeAsset;
}

class QuoteUnregisteredGaid {
  final Int64 orderId;
  final From_Quote_UnregisteredGaid quoteUnregisteredGaid;

  QuoteUnregisteredGaid({
    required this.orderId,
    required this.quoteUnregisteredGaid,
  });

  String get domainAgent => quoteUnregisteredGaid.domainAgent;
}

/// Accept quote

@riverpod
class AcceptQuoteNotifier extends _$AcceptQuoteNotifier {
  @override
  Option<From_AcceptQuote> build() {
    return Option.none();
  }

  void setState(From_AcceptQuote acceptQuote) {
    state = Option.of(acceptQuote);
  }
}

class QuoteIndexPrice extends ConvertAmount {
  final double priceTaker;
  final AssetPair assetPair;
  final AssetType assetType;
  final TradeDir tradeDir;
  final Map<String, Asset> assetsState;
  final AbstractSatoshiRepository satoshiRepository;

  QuoteIndexPrice(
    super.amountToString,
    this.priceTaker,
    this.assetPair,
    this.assetType,
    this.tradeDir,
    this.assetsState,
    this.satoshiRepository,
  );

  Option<Decimal> price() {
    final price = Decimal.tryParse(priceTaker.toString());
    if (price == null) {
      return Option.none();
    }

    return Option.of(price);
  }

  String priceString() {
    final baseAsset = assetsState[assetPair.base];

    if (baseAsset == null) {
      return '';
    }

    final quoteAsset = assetsState[assetPair.quote];

    if (quoteAsset == null) {
      return '';
    }

    final optionPrice = price();

    return optionPrice.match(() => '', (priceDecimal) {
      final price = super.amountToString.indexPriceFormatted(
        priceDecimal,
        quoteAsset.precision,
      );

      return '1 ${baseAsset.ticker} = $price ${quoteAsset.ticker}';
    });
  }
}

@Riverpod(keepAlive: true)
class PreviewOrderQuoteSuccessNotifier
    extends _$PreviewOrderQuoteSuccessNotifier {
  @override
  Option<QuoteSuccess> build() {
    return Option.none();
  }

  void setState(QuoteSuccess quoteSuccess) {
    state = Option.of(quoteSuccess);
  }
}

@freezed
sealed class OrderTtlState with _$OrderTtlState {
  const factory OrderTtlState.empty() = OrderTtlStateEmpty;
  const factory OrderTtlState.data({
    required int seconds,
    required DateTime timestamp,
  }) = OrderTtlStateData;
}

@Riverpod(keepAlive: true)
class OrderTtlNotifier extends _$OrderTtlNotifier {
  @override
  OrderTtlState build() {
    final optionQuoteSuccess = ref.watch(
      previewOrderQuoteSuccessNotifierProvider,
    );

    return optionQuoteSuccess.match(() => OrderTtlState.empty(), (
      quoteSuccess,
    ) {
      final seconds = (quoteSuccess.ttlMilliseconds / 1000).round();
      final timestamp = quoteSuccess.timestamp;
      return OrderTtlState.data(seconds: seconds, timestamp: timestamp);
    });
  }

  void setState(OrderTtlState orderTtlState) {
    state = orderTtlState;
  }
}

@riverpod
class OrderSignTtl extends _$OrderSignTtl {
  @override
  int build() {
    ref.watch(orderTtlNotifierProvider);

    final timer = Timer.periodic(Duration(seconds: 1), (_) => updateState());
    ref.onDispose(() => timer.cancel());

    return updateState();
  }

  int updateState() {
    final orderTtlState = ref.read(orderTtlNotifierProvider);

    state = switch (orderTtlState) {
      OrderTtlStateData() => () {
        final futuredTimestamp = orderTtlState.timestamp.add(
          Duration(seconds: orderTtlState.seconds),
        );
        final now = DateTime.timestamp();
        final diff = futuredTimestamp.difference(now);
        return diff.inSeconds < 0 ? 0 : diff.inSeconds;
      },
      _ => () {
        return 0;
      },
    }();

    return state;
  }
}
