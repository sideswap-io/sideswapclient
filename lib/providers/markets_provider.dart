import 'dart:async';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/markets/widgets/d_preview_order_dialog.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/ui_history_order.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/market_swap_page.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'markets_provider.g.dart';
part 'markets_provider.freezed.dart';

@riverpod
String marketTypeName(Ref ref, MarketType_ type) {
  return switch (type) {
    MarketType_.STABLECOIN => 'Stablecoins'.tr(),
    MarketType_.AMP => 'AMP Listings'.tr(),
    MarketType_.TOKEN => 'Token Market'.tr(),
    MarketType_() => throw UnimplementedError(),
  };
}

@riverpod
MarketType_ assetMarketType(Ref ref, Asset? asset) {
  return switch (asset) {
    final asset? when asset.swapMarket => MarketType_.STABLECOIN,
    final asset? when asset.ampMarket => MarketType_.AMP,
    // if asset is null assume that is token
    _ => MarketType_.TOKEN,
  };
}

@Riverpod(keepAlive: true)
class TradeDirStateNotifier extends _$TradeDirStateNotifier {
  @override
  TradeDir build() {
    return TradeDir.BUY;
  }

  void setSide(TradeDir side) {
    state = side;
  }
}

/// Market list
@Riverpod(keepAlive: true)
class MarketsNotifier extends _$MarketsNotifier {
  @override
  List<MarketInfo> build() {
    return [];
  }

  void setState(List<MarketInfo> markets) {
    state = markets;
  }

  void addMarketInfo(MarketInfo marketInfo) {
    final markets = [...state];
    markets.add(marketInfo);
    state = markets;
  }

  void removeAssetPair(AssetPair assetPair) {
    final markets = [...state];
    markets.removeWhere((e) => e.assetPair == assetPair);
    state = markets;
  }
}

@riverpod
List<MarketInfo> marketInfoByMarketType(Ref ref, MarketType_ marketType) {
  final markets = ref.watch(marketsNotifierProvider);
  return markets.where((e) => e.type == marketType).toList();
}

@riverpod
Option<Asset> baseAssetByMarketInfo(Ref ref, MarketInfo marketInfo) {
  final assetsState = ref.watch(assetsStateProvider);

  final asset = assetsState[marketInfo.assetPair.base];
  return asset == null ? Option.none() : Option.of(asset);
}

@riverpod
Widget baseAssetIconByMarketInfo(Ref ref, MarketInfo marketInfo) {
  final optionAsset = ref.watch(baseAssetByMarketInfoProvider(marketInfo));

  return optionAsset.match(
    () => SizedBox(),
    (asset) =>
        ref.watch(assetImageRepositoryProvider).getSmallImage(asset.assetId),
  );
}

@riverpod
Option<Asset> quoteAssetByMarketInfo(Ref ref, MarketInfo marketInfo) {
  final assetsState = ref.watch(assetsStateProvider);

  final asset = assetsState[marketInfo.assetPair.quote];
  return asset == null ? Option.none() : Option.of(asset);
}

@riverpod
Widget quoteAssetIconByMarketInfo(Ref ref, MarketInfo marketInfo) {
  final optionAsset = ref.watch(quoteAssetByMarketInfoProvider(marketInfo));
  return optionAsset.match(
    () => SizedBox(),
    (asset) =>
        ref.watch(assetImageRepositoryProvider).getSmallImage(asset.assetId),
  );
}

/// Public orders
@riverpod
class MarketPublicOrdersNotifier extends _$MarketPublicOrdersNotifier {
  @override
  Map<AssetPair, List<PublicOrder>> build() {
    ref.listen(marketSubscribedAssetPairNotifierProvider, (_, next) {
      next.match(
        () => () {},
        (assetPair) => () {
          _subscribe(assetPair);
        },
      )();
    });

    ref.onDispose(() {
      _unsubscribe();
    });

    return {};
  }

  void setOrders(AssetPair assetPair, List<PublicOrder> publicOrders) {
    final orders = {...state};
    orders[assetPair] = publicOrders;
    state = orders;
  }

  void orderCreated(PublicOrder publicOrder) {
    final assetPair = publicOrder.assetPair;
    final orders = {...state};
    final ordersByAssetPair = orders[assetPair] ?? [];
    final index = ordersByAssetPair.indexWhere(
      (e) => e.orderId == publicOrder.orderId,
    );
    if (index < 0) {
      ordersByAssetPair.add(publicOrder);
    } else {
      ordersByAssetPair[index] = publicOrder;
    }

    orders[assetPair] = ordersByAssetPair;
    state = orders;
  }

  void removeOrder(OrderId orderId) {
    final orders = {...state};

    for (final key in orders.keys) {
      final ordersByAssetPair = orders[key] ?? [];
      ordersByAssetPair.removeWhere((e) => e.orderId == orderId);
      orders[key] = ordersByAssetPair;
    }

    state = orders;
  }

  void _subscribe(AssetPair assetPair) {
    final msg = To();
    msg.marketSubscribe = assetPair;
    ref.read(walletProvider).sendMsg(msg);
  }

  void _unsubscribe() {
    final msg = To();
    msg.marketUnsubscribe = Empty();
    ref.read(walletProvider).sendMsg(msg);
  }
}

/// Own orders

@Riverpod(keepAlive: true)
class MarketOwnOrdersNotifier extends _$MarketOwnOrdersNotifier {
  @override
  List<OwnOrder> build() {
    return [];
  }

  void setState(List<OwnOrder> ownOrders) {
    state = [...ownOrders];
  }

  void orderCreated(OwnOrder ownOrder) {
    final list = [...state];

    final index = list.indexWhere((e) => e.orderId == ownOrder.orderId);
    if (index < 0) {
      list.add(ownOrder);
    } else {
      list[index] = ownOrder;
    }

    state = list;
  }

  void removeOrder(OrderId orderId) {
    final list = [...state];
    list.removeWhere((e) => e.orderId == orderId);

    state = list;
  }
}

@riverpod
List<UiOwnOrder> marketUiOwnOrders(Ref ref) {
  final ownOrders = ref.watch(marketOwnOrdersNotifierProvider);
  final amountToString = ref.watch(amountToStringProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final assetImageRepository = ref.watch(assetImageRepositoryProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);
  final assetUtils = ref.watch(assetUtilsProvider);
  final locale = ref.watch(localesNotifierProvider);

  return ownOrders.map((e) {
    final quoteAsset = assetsState[e.assetPair.quote];
    final marketType =
        quoteAsset == null
            ? MarketType_.STABLECOIN
            : ref.read(assetMarketTypeProvider(quoteAsset));
    return UiOwnOrder(
      amountToString: amountToString,
      assetsState: assetsState,
      assetImageRepository: assetImageRepository,
      satoshiRepository: satoshiRepository,
      assetUtils: assetUtils,
      marketType: marketType,
      locale: locale,
      ownOrder: e,
    );
  }).toList();
}

@riverpod
class MarketSubscribedAssetPairNotifier
    extends _$MarketSubscribedAssetPairNotifier {
  @override
  Option<AssetPair> build() {
    return Option.none();
  }

  void setState(AssetPair assetPair) {
    state = Option.of(assetPair);
  }
}

@riverpod
Option<MarketInfo> subscribedMarketInfo(Ref ref) {
  final markets = ref.watch(marketsNotifierProvider);
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );

  return subscribedAssetPair.match(() => Option.none(), (assetPair) {
    final index = markets.indexWhere((e) => e.assetPair == assetPair);
    if (index == -1) {
      return Option.none();
    }

    return Option.of(markets[index]);
  });
}

@riverpod
String subscribedMarketProductName(Ref ref) {
  final optionMarketInfo = ref.watch(subscribedMarketInfoProvider);

  return optionMarketInfo.match(
    () {
      return '';
    },
    (marketInfo) {
      final optionBaseAsset = ref.watch(
        baseAssetByMarketInfoProvider(marketInfo),
      );
      final optionQuoteAsset = ref.watch(
        quoteAssetByMarketInfoProvider(marketInfo),
      );

      return optionBaseAsset.match(
        () => '',
        (baseAsset) => optionQuoteAsset.match(
          () => '',
          (quoteAsset) => '${baseAsset.ticker} / ${quoteAsset.ticker}',
        ),
      );
    },
  );
}

@riverpod
Option<Asset> marketSubscribedBaseAsset(Ref ref) {
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final assetsState = ref.watch(assetsStateProvider);

  return optionSubscribedMarket.match(() => Option.none(), (marketInfo) {
    final asset = assetsState[marketInfo.assetPair.base];
    return asset == null ? Option.none() : Option.of(asset);
  });
}

@riverpod
Option<Asset> marketSubscribedQuoteAsset(Ref ref) {
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final assetsState = ref.watch(assetsStateProvider);

  return optionSubscribedMarket.match(() => Option.none(), (marketInfo) {
    final asset = assetsState[marketInfo.assetPair.quote];
    return asset == null ? Option.none() : Option.of(asset);
  });
}

/// Index price
@riverpod
class MarketPriceNotifier extends _$MarketPriceNotifier {
  @override
  Map<AssetPair, ({double indexPrice, double lastPrice})> build() {
    return {};
  }

  void setState(From_MarketPrice marketPrice) {
    final prices = {...state};
    prices[marketPrice.assetPair] = (
      indexPrice: marketPrice.indPrice,
      lastPrice: marketPrice.lastPrice,
    );
    state = prices;
  }
}

@riverpod
Option<({String indexPrice, Option<Asset> quoteAsset})> marketIndexPrice(
  Ref ref,
) {
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );
  final marketPrices = ref.watch(marketPriceNotifierProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return subscribedAssetPair.match(() => Option.none(), (assetPair) {
    if (marketPrices[assetPair] == null ||
        marketPrices[assetPair]!.indexPrice == .0) {
      return Option.none();
    }

    final amount = marketPrices[assetPair]!.indexPrice;
    final asset = assetsState[assetPair.quote];
    final satoshi =
        asset == null
            ? 0
            : satoshiRepository.satoshiForAmount(
              amount: amount.toString(),
              assetId: asset.assetId,
            );

    if (satoshi == 0) {
      return Option.none();
    }

    final price = ref
        .watch(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(amount: satoshi, trailingZeroes: false),
        );
    final quoteAsset = asset == null ? Option<Asset>.none() : Option.of(asset);
    return Option.of((indexPrice: price, quoteAsset: quoteAsset));
  });
}

@riverpod
Option<({String lastPrice, Option<Asset> quoteAsset})> marketLastPrice(
  Ref ref,
) {
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );
  final marketPrices = ref.watch(marketPriceNotifierProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return subscribedAssetPair.match(() => Option.none(), (assetPair) {
    if (marketPrices[assetPair] == null ||
        marketPrices[assetPair]!.lastPrice == .0) {
      return Option.none();
    }

    final amount = marketPrices[assetPair]!.lastPrice;
    final asset = assetsState[assetPair.quote];
    final satoshi =
        asset == null
            ? 0
            : satoshiRepository.satoshiForAmount(
              amount: amount.toString(),
              assetId: asset.assetId,
            );

    if (satoshi == 0) {
      return Option.none();
    }

    final price = ref
        .watch(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(amount: satoshi, trailingZeroes: false),
        );
    final quoteAsset = asset == null ? Option<Asset>.none() : Option.of(asset);
    return Option.of((lastPrice: price, quoteAsset: quoteAsset));
  });
}

@freezed
sealed class MarketSideState with _$MarketSideState {
  const factory MarketSideState.base() = MarketSideStateBase;
  const factory MarketSideState.quote() = MarketSideStateQuote;
}

@riverpod
class MarketSideStateNotifier extends _$MarketSideStateNotifier {
  @override
  MarketSideState build() {
    return MarketSideState.base();
  }

  void setState(MarketSideState side) {
    state = side;
  }
}

@freezed
sealed class MarketTypeSwitchState with _$MarketTypeSwitchState {
  const factory MarketTypeSwitchState.market() = MarketTypeSwitchStateMarket;
  const factory MarketTypeSwitchState.limit() = MarketTypeSwitchStateLimit;
}

@riverpod
class MarketTypeSwitchStateNotifier extends _$MarketTypeSwitchStateNotifier {
  @override
  MarketTypeSwitchState build() {
    return MarketTypeSwitchState.limit();
  }

  void setState(MarketTypeSwitchState value) {
    state = value;
  }
}

class OrderAmount {
  final Decimal amount;
  final int satoshi;
  final String assetId;
  final AssetPair assetPair;

  OrderAmount({
    required this.amount,
    required this.satoshi,
    required this.assetId,
    required this.assetPair,
  });

  String asString() {
    return amount.toString();
  }

  double asDouble() {
    return amount.toDouble();
  }

  int asSatoshi() {
    return satoshi;
  }

  (Decimal, int, String, AssetPair) _equality() => (
    amount,
    satoshi,
    assetId,
    assetPair,
  );

  @override
  bool operator ==(covariant OrderAmount other) {
    if (identical(this, other)) {
      return true;
    }
    return other._equality() == _equality();
  }

  @override
  int get hashCode {
    return _equality().hashCode;
  }
}

@riverpod
class MarketOrderAmountControllerNotifier
    extends _$MarketOrderAmountControllerNotifier {
  @override
  String build() {
    // cleanup when asset pair changed or order submit success
    ref.watch(marketSubscribedAssetPairNotifierProvider);
    ref.watch(orderSubmitSuccessProvider);
    ref.watch(marketTypeSwitchStateNotifierProvider);

    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
OrderAmount marketOrderAmount(Ref ref) {
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );
  final amountString = ref.watch(marketOrderAmountControllerNotifierProvider);
  final marketSideState = ref.watch(marketSideStateNotifierProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return subscribedAssetPair.match(
    () => () {
      return OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: '',
        assetPair: AssetPair(),
      );
    },
    (assetPair) => () {
      final assetId =
          marketSideState == MarketSideStateBase()
              ? assetPair.base
              : assetPair.quote;
      final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
      final amountSatoshi = satoshiRepository.satoshiForAmount(
        amount: amountDecimal.toString(),
        assetId: assetId,
      );

      return OrderAmount(
        amount: amountDecimal,
        satoshi: amountSatoshi,
        assetId: assetId,
        assetPair: assetPair,
      );
    },
  )();
}

@riverpod
bool marketOrderTradeButtonEnabled(Ref ref) {
  final optionQuoteSuccess = ref.watch(marketQuoteSuccessProvider);
  final marketOrderAmount = ref.watch(marketOrderAmountProvider);

  return optionQuoteSuccess.match(
    () => false,
    (quoteSuccess) => marketOrderAmount.amount != Decimal.zero,
  );
}

@riverpod
class MarketQuoteNotifier extends _$MarketQuoteNotifier {
  @override
  Option<From_Quote> build() {
    ref.onDispose(() {
      _stopQuotes();
    });

    ref.listen(marketTypeSwitchStateNotifierProvider, (_, __) {
      _stopQuotes();
    });

    ref.listen(marketSubscribedAssetPairNotifierProvider, (_, __) {
      _startQuotes();
    });

    ref.listen(marketOrderAmountProvider, (_, next) {
      /// * Calling stop quotes here cause issue for app links on app startup!
      _startQuotes();
    });

    ref.listen(marketSideStateNotifierProvider, (_, __) {
      _stopQuotes();
    });

    ref.listen(tradeDirStateNotifierProvider, (_, __) {
      _stopQuotes();
    });

    return Option.none();
  }

  void setQuote(From_Quote quote) {
    state = Option.of(quote);
  }

  void _startQuotes() {
    final optionSubscribedAssetPair = ref.read(
      marketSubscribedAssetPairNotifierProvider,
    );
    final marketOrderAmount = ref.read(marketOrderAmountProvider);
    final marketSideState = ref.read(marketSideStateNotifierProvider);
    final tradeDir = ref.read(tradeDirStateNotifierProvider);

    optionSubscribedAssetPair.match(
      () => () {
        _stopQuotes();
      },
      (assetPair) => () {
        if (state.isSome()) {
          _stopQuotes();
        }

        final assetId =
            marketSideState == MarketSideStateBase()
                ? assetPair.base
                : assetPair.quote;
        if (marketOrderAmount.assetPair != assetPair ||
            marketOrderAmount.assetId != assetId) {
          return;
        }

        if (marketOrderAmount.asSatoshi() == 0) {
          return;
        }

        final amount = Int64(marketOrderAmount.asSatoshi());
        final msg = To();
        msg.startQuotes = To_StartQuotes(
          assetPair: assetPair,
          assetType:
              marketSideState == MarketSideStateBase()
                  ? AssetType.BASE
                  : AssetType.QUOTE,
          amount: amount,
          tradeDir: tradeDir,
        );

        ref.read(walletProvider).sendMsg(msg);
      },
    )();
  }

  void _stopQuotes() {
    final msg = To();
    msg.stopQuotes = Empty();
    ref.read(walletProvider).sendMsg(msg);
    state = Option.none();
  }
}

@freezed
sealed class QuoteError with _$QuoteError {
  const factory QuoteError({
    @Default('') String error,
    @Default(0) int orderId,
  }) = _QuoteError;
}

@riverpod
Option<QuoteError> marketQuoteError(Ref ref) {
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrderId.match(
    () =>
        optionQuote.match(
          () => () {
            return Option<QuoteError>.none();
          },
          (quote) => () {
            if (!quote.hasError()) {
              return Option<QuoteError>.none();
            }

            return Option.of(
              QuoteError(error: quote.error, orderId: quote.orderId.toInt()),
            );
          },
        )(),
    (_) => Option.none(),
  );
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

@riverpod
Option<QuoteLowBalance> marketQuoteLowBalanceError(Ref ref) {
  final optionAssetPair = ref.watch(marketSubscribedAssetPairNotifierProvider);
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrderId.match(
    () => optionAssetPair.match(
      () => Option<QuoteLowBalance>.none(),
      (assetPair) =>
          optionQuote.match(
            () => () {
              return Option<QuoteLowBalance>.none();
            },
            (quote) => () {
              if (!quote.hasLowBalance()) {
                return Option<QuoteLowBalance>.none();
              }

              if (quote.assetPair != assetPair) {
                return Option<QuoteLowBalance>.none();
              }

              return optionSubscribedMarket.match(
                () => Option<QuoteLowBalance>.none(),
                (marketInfo) => Option.of(
                  QuoteLowBalance(
                    amountToString,
                    quote.lowBalance,
                    quote.assetPair,
                    quote.assetType,
                    quote.tradeDir,
                    marketInfo.feeAsset,
                    assetsState,
                    quote.orderId.toInt(),
                  ),
                ),
              );
            },
          )(),
    ),
    (_) => Option.none(),
  );
}

class QuoteSuccess extends ConvertAmount {
  final From_Quote_Success _quoteSuccess;
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
    this.orderId,
  ) : _timestamp = DateTime.timestamp();

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
        AssetType.BASE => convertAmountForAsset(
          baseAmount + totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount + totalFee, quoteAsset),
      },
      _ => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
    },
    false => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
      _ => switch (feeAssetType) {
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

  String get receiveAmount => switch (feeAssetType == assetType) {
    true => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
        _ => convertAmountForAsset(baseAmount, baseAsset),
      },
      _ => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount - totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount - totalFee, quoteAsset),
      },
    },
    false => switch (tradeDir) {
      TradeDir.SELL => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(
          baseAmount - totalFee,
          baseAsset,
        ),
        _ => convertAmountForAsset(quoteAmount - totalFee, quoteAsset),
      },
      _ => switch (feeAssetType) {
        AssetType.BASE => convertAmountForAsset(quoteAmount, quoteAsset),
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

@riverpod
Option<QuoteSuccess> marketQuoteSuccess(Ref ref) {
  final optionAssetPair = ref.watch(marketSubscribedAssetPairNotifierProvider);
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrderId.match(
    () => optionAssetPair.match(
      () => Option.none(),
      (assetPair) =>
          optionQuote.match(
            () => () {
              return Option<QuoteSuccess>.none();
            },
            (quote) => () {
              if (!quote.hasSuccess()) {
                return Option<QuoteSuccess>.none();
              }

              if (quote.assetPair != assetPair) {
                return Option<QuoteSuccess>.none();
              }

              return optionSubscribedMarket.match(
                () => Option<QuoteSuccess>.none(),
                (marketInfo) => Option.of(
                  QuoteSuccess(
                    amountToString,
                    quote.success,
                    quote.assetPair,
                    quote.assetType,
                    quote.tradeDir,
                    marketInfo.feeAsset,
                    assetsState,
                    quote.orderId.toInt(),
                  ),
                ),
              );
            },
          )(),
    ),
    (_) => Option.none(),
  );
}

class QuoteUnregisteredGaid {
  final From_Quote_UnregisteredGaid quoteUnregisteredGaid;

  QuoteUnregisteredGaid({required this.quoteUnregisteredGaid});

  String get domainAgent => quoteUnregisteredGaid.domainAgent;
}

@riverpod
Option<QuoteUnregisteredGaid> marketQuoteUnregisteredGaid(Ref ref) {
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrderId.match(
    () =>
        optionQuote.match(
          () => () {
            return Option<QuoteUnregisteredGaid>.none();
          },
          (quote) => () {
            if (!quote.hasUnregisteredGaid()) {
              return Option<QuoteUnregisteredGaid>.none();
            }

            return Option.of(
              QuoteUnregisteredGaid(
                quoteUnregisteredGaid: quote.unregisteredGaid,
              ),
            );
          },
        )(),
    (_) => Option.none(),
  );
}

@Riverpod(keepAlive: true)
class MarketPreviewOrderQuoteNotifier
    extends _$MarketPreviewOrderQuoteNotifier {
  @override
  Option<QuoteSuccess> build() {
    return Option.none();
  }

  void setState(QuoteSuccess quoteSuccess) {
    state = Option.of(quoteSuccess);
  }
}

@riverpod
class MarketPreviewOrderTtl extends _$MarketPreviewOrderTtl {
  @override
  int build() {
    ref.watch(marketPreviewOrderQuoteNotifierProvider);

    final timer = Timer.periodic(Duration(seconds: 1), (_) => updateState());
    ref.onDispose(() => timer.cancel());

    return updateState();
  }

  int updateState() {
    final optionQuoteSuccess = ref.read(
      marketPreviewOrderQuoteNotifierProvider,
    );

    state =
        optionQuoteSuccess.match(
          () => () {
            return 0;
          },
          (quoteSuccess) => () {
            final timestamp = quoteSuccess.timestamp;
            final seconds = (quoteSuccess.ttlMilliseconds / 1000).round();
            final futuredTimestamp = timestamp.add(Duration(seconds: seconds));
            final now = DateTime.timestamp();
            final diff = futuredTimestamp.difference(now);
            return diff.inSeconds < 0 ? 0 : diff.inSeconds;
          },
        )();

    return state;
  }
}

@riverpod
class MarketAcceptQuoteNotifier extends _$MarketAcceptQuoteNotifier {
  @override
  Option<From_AcceptQuote> build() {
    return Option.none();
  }

  void setState(From_AcceptQuote acceptQuote) {
    state = Option.of(acceptQuote);
  }
}

@riverpod
Option<String> marketAcceptQuoteSuccess(Ref ref) {
  final optionAcceptQuote = ref.watch(marketAcceptQuoteNotifierProvider);

  return optionAcceptQuote.match(
    () => () {
      return Option<String>.none();
    },
    (acceptQuote) => () {
      if (acceptQuote.hasSuccess()) {
        return Option.of(acceptQuote.success.txid);
      }

      return Option<String>.none();
    },
  )();
}

@riverpod
class MarketAcceptQuoteSuccessShowDialogNotifier
    extends _$MarketAcceptQuoteSuccessShowDialogNotifier {
  @override
  bool build() {
    final optionAccepQuoteSuccess = ref.watch(marketAcceptQuoteSuccessProvider);
    return optionAccepQuoteSuccess.match(() => false, (_) => true);
  }

  void setState(bool value) {
    state = value;
  }
}

@riverpod
Option<String> acceptQuoteError(Ref ref) {
  final optionAcceptQuote = ref.watch(marketAcceptQuoteNotifierProvider);

  return optionAcceptQuote.match(
    () => () {
      return Option<String>.none();
    },
    (acceptQuote) => () {
      if (acceptQuote.hasError()) {
        return Option.of(acceptQuote.error);
      }

      return Option<String>.none();
    },
  )();
}

/// Limit order

@freezed
sealed class LimitTtlFlag with _$LimitTtlFlag {
  const LimitTtlFlag._();

  const factory LimitTtlFlag.oneHour() = LimitTtlFlagOneHour;
  const factory LimitTtlFlag.sixHours() = LimitTtlFlagSixHours;
  const factory LimitTtlFlag.twelveHours() = LimitTtlFlagTwelveHours;
  const factory LimitTtlFlag.twentyFourHours() = LimitTtlFlagTwentyFourHours;
  const factory LimitTtlFlag.threeDays() = LimitTtlFlagThreeDays;
  const factory LimitTtlFlag.oneWeek() = LimitTtlFlagOneWeek;
  const factory LimitTtlFlag.oneMonth() = LimitTtlFlagOneMonth;
  const factory LimitTtlFlag.unlimited() = LimitTtlFlagUnlimited;

  Int64? seconds() {
    return switch (this) {
      LimitTtlFlagOneHour() => Int64(3600),
      LimitTtlFlagSixHours() => Int64(21600),
      LimitTtlFlagTwelveHours() => Int64(43200),
      LimitTtlFlagTwentyFourHours() => Int64(86400),
      LimitTtlFlagThreeDays() => Int64(259200),
      LimitTtlFlagOneWeek() => Int64(604800),
      LimitTtlFlagOneMonth() => Int64(2592000), // 30 days
      LimitTtlFlagUnlimited() => null,
    };
  }

  String description() {
    return switch (this) {
      LimitTtlFlagOneHour() => '1h',
      LimitTtlFlagSixHours() => '6h',
      LimitTtlFlagTwelveHours() => '12h',
      LimitTtlFlagTwentyFourHours() => '24h',
      LimitTtlFlagThreeDays() => '1d',
      LimitTtlFlagOneWeek() => '7d',
      LimitTtlFlagOneMonth() => '30d',
      LimitTtlFlagUnlimited() => 'Unlimited',
    };
  }
}

@riverpod
class LimitTtlFlagNotifier extends _$LimitTtlFlagNotifier {
  @override
  LimitTtlFlag build() {
    return LimitTtlFlag.unlimited();
  }

  void setState(LimitTtlFlag value) {
    state = value;
  }
}

@riverpod
class LimitOrderAmountControllerNotifier
    extends _$LimitOrderAmountControllerNotifier {
  @override
  String build() {
    // cleanup when asset pair changed or order submit success
    ref.watch(marketSubscribedAssetPairNotifierProvider);
    ref.watch(orderSubmitSuccessProvider);
    ref.watch(marketTypeSwitchStateNotifierProvider);

    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
OrderAmount limitOrderAmount(Ref ref) {
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );
  final amountString = ref.watch(limitOrderAmountControllerNotifierProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return subscribedAssetPair.match(
    () => () {
      return OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: '',
        assetPair: AssetPair(),
      );
    },
    (assetPair) => () {
      final assetId = assetPair.base;
      final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
      final amountSatoshi = satoshiRepository.satoshiForAmount(
        amount: amountDecimal.toString(),
        assetId: assetId,
      );

      return OrderAmount(
        amount: amountDecimal,
        satoshi: amountSatoshi,
        assetId: assetId,
        assetPair: assetPair,
      );
    },
  )();
}

@riverpod
class LimitOrderPriceAmountControllerNotifier
    extends _$LimitOrderPriceAmountControllerNotifier {
  @override
  String build() {
    // cleanup when asset pair changed or order submit success
    ref.watch(marketSubscribedAssetPairNotifierProvider);
    ref.watch(orderSubmitSuccessProvider);
    ref.watch(marketTypeSwitchStateNotifierProvider);

    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
OrderAmount limitPriceAmount(Ref ref) {
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );
  final amountString = ref.watch(
    limitOrderPriceAmountControllerNotifierProvider,
  );
  final marketSideState = ref.watch(marketSideStateNotifierProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return subscribedAssetPair.match(
    () => () {
      return OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: '',
        assetPair: AssetPair(),
      );
    },
    (assetPair) => () {
      final assetId =
          marketSideState == MarketSideStateBase()
              ? assetPair.quote
              : assetPair.base;
      final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
      final amountSatoshi = satoshiRepository.satoshiForAmount(
        amount: amountDecimal.toString(),
        assetId: assetId,
      );

      return OrderAmount(
        amount: amountDecimal,
        satoshi: amountSatoshi,
        assetId: assetId,
        assetPair: assetPair,
      );
    },
  )();
}

@riverpod
bool limitOrderTradeButtonEnabled(Ref ref) {
  final insufficientAmount = ref.watch(limitInsufficientAmountProvider);
  final insufficientPrice = ref.watch(limitInsufficientPriceProvider);
  if (insufficientAmount || insufficientPrice) {
    return false;
  }

  final optionOrderSubmit = ref.watch(orderSubmitNotifierProvider);
  if (optionOrderSubmit.isSome()) {
    return false;
  }

  final limitAmount = ref.watch(limitOrderAmountProvider);
  final limitPrice = ref.watch(limitPriceAmountProvider);

  if (limitAmount.amount == Decimal.zero || limitPrice.amount == Decimal.zero) {
    return false;
  }

  return true;
}

@riverpod
class OrderSubmitNotifier extends _$OrderSubmitNotifier {
  @override
  Option<From_OrderSubmit> build() {
    return Option.none();
  }

  void setState(From_OrderSubmit orderSubmit) {
    state = Option.of(orderSubmit);
  }
}

@riverpod
Option<UiOwnOrder> orderSubmitSuccess(Ref ref) {
  final optionOrderSubmit = ref.watch(orderSubmitNotifierProvider);
  final uiOwnOrders = ref.watch(marketUiOwnOrdersProvider);

  return optionOrderSubmit.match(
    () => () {
      return Option<UiOwnOrder>.none();
    },
    (orderSubmit) => () {
      if (orderSubmit.hasSubmitSucceed()) {
        final uiOwnOrder = uiOwnOrders.firstWhereOrNull(
          (e) => e.ownOrder.orderId == orderSubmit.submitSucceed.orderId,
        );
        if (uiOwnOrder == null) {
          return Option<UiOwnOrder>.none();
        }

        return Option.of(
          uiOwnOrder.copyWith(ownOrder: orderSubmit.submitSucceed),
        );
      }

      return Option<UiOwnOrder>.none();
    },
  )();
}

@riverpod
Option<String> orderSubmitError(Ref ref) {
  final optionOrderSubmit = ref.watch(orderSubmitNotifierProvider);
  return optionOrderSubmit.match(
    () => () {
      return Option<String>.none();
    },
    (orderSubmit) => () {
      if (orderSubmit.hasError() && orderSubmit.error.isNotEmpty) {
        return Option.of(orderSubmit.error);
      }

      return Option<String>.none();
    },
  )();
}

@riverpod
Option<String> orderSubmitUnregisteredGaid(Ref ref) {
  final optionOrderSubmit = ref.watch(orderSubmitNotifierProvider);
  return optionOrderSubmit.match(
    () => () {
      return Option<String>.none();
    },
    (orderSubmit) => () {
      if (orderSubmit.hasUnregisteredGaid()) {
        return Option.of(orderSubmit.unregisteredGaid.domainAgent);
      }

      return Option<String>.none();
    },
  )();
}

@riverpod
class MarketEditOrderErrorNotifier extends _$MarketEditOrderErrorNotifier {
  @override
  Option<String> build() {
    return Option.none();
  }

  void setState(String errorMsg) {
    state = Option.of(errorMsg);
  }
}

/// Edit order

class MarketEditDetailsOfflineOrderException implements Exception {
  final String message;

  const MarketEditDetailsOfflineOrderException(this.message);

  @override
  String toString() => message;
}

@Riverpod(keepAlive: true)
class MarketEditDetailsOrderNotifier extends _$MarketEditDetailsOrderNotifier {
  @override
  Option<UiOwnOrder> build() {
    return Option.none();
  }

  void setState(UiOwnOrder uiOwnOrder) {
    if (uiOwnOrder.offlineSwapType == OfflineSwapType.twoStep()) {
      throw MarketEditDetailsOfflineOrderException(
        'Offline order cant be edited',
      );
    }

    state = Option.of(uiOwnOrder);
  }
}

@riverpod
class MarketEditOrderAmountControllerNotifier
    extends _$MarketEditOrderAmountControllerNotifier {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
Option<OrderAmount> marketEditOrderAmount(Ref ref) {
  final optionOrder = ref.watch(marketEditDetailsOrderNotifierProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return optionOrder.match(
    () => () {
      return Option<OrderAmount>.none();
    },
    (order) => () {
      final assetId = order.assetPair.base;

      final amountString = ref.watch(
        marketEditOrderAmountControllerNotifierProvider,
      );
      final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
      final amountSatoshi = satoshiRepository.satoshiForAmount(
        amount: amountDecimal.toString(),
        assetId: assetId,
      );

      return Option.of(
        OrderAmount(
          amount: amountDecimal,
          satoshi: amountSatoshi,
          assetId: assetId,
          assetPair: order.assetPair,
        ),
      );
    },
  )();
}

@riverpod
class MarketEditOrderPriceControllerNotifier
    extends _$MarketEditOrderPriceControllerNotifier {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
Option<OrderAmount> marketEditOrderPrice(Ref ref) {
  final optionOrder = ref.watch(marketEditDetailsOrderNotifierProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return optionOrder.match(
    () => () {
      return Option<OrderAmount>.none();
    },
    (order) => () {
      final assetId = order.assetPair.quote;

      final amountString = ref.watch(
        marketEditOrderPriceControllerNotifierProvider,
      );
      final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
      final amountSatoshi = satoshiRepository.satoshiForAmount(
        amount: amountDecimal.toString(),
        assetId: assetId,
      );

      return Option.of(
        OrderAmount(
          amount: amountDecimal,
          satoshi: amountSatoshi,
          assetId: assetId,
          assetPair: order.assetPair,
        ),
      );
    },
  )();
}

@riverpod
bool marketEditOrderAcceptEnabled(Ref ref) {
  final optionAmount = ref.watch(marketEditOrderAmountProvider);
  final optionPrice = ref.watch(marketEditOrderPriceProvider);

  return optionAmount.match(
    () => () {
      return false;
    },
    (amount) => () {
      if (amount.asSatoshi() == 0) {
        return false;
      }

      return optionPrice.match(
        () => () {
          return false;
        },
        (price) => () {
          if (price.asSatoshi() == 0) {
            return false;
          }

          return true;
        },
      )();
    },
  )();
}

@freezed
class OrderType with _$OrderType {
  const factory OrderType.public() = OrderTypePublic;
  const factory OrderType.private() = OrderTypePrivate;
}

@riverpod
class MarketLimitOrderTypeNotifier extends _$MarketLimitOrderTypeNotifier {
  @override
  OrderType build() {
    return OrderType.public();
  }

  void setState(OrderType orderType) {
    state = orderType;
  }
}

@freezed
class OfflineSwapType with _$OfflineSwapType {
  const factory OfflineSwapType.empty() = OfflineSwapTypeEmpty;
  const factory OfflineSwapType.twoStep() = OfflineSwapTypeTwoStep;
}

@riverpod
class MarketLimitOfflineSwap extends _$MarketLimitOfflineSwap {
  @override
  OfflineSwapType build() {
    final isJadeWallet = ref.watch(isJadeWalletProvider);
    final isMobile = !FlavorConfig.isDesktop;

    return switch (isJadeWallet || isMobile) {
      true => OfflineSwapType.twoStep(),
      false => OfflineSwapType.empty(),
    };
  }

  void setState(OfflineSwapType offlineSwapType) {
    state = offlineSwapType;
  }
}

@riverpod
String addressToShareByOrder(Ref ref, UiOwnOrder order) {
  const swapAddress = 'https://app.sideswap.io/swap/?';
  return switch (order.orderType) {
    OrderTypePrivate() =>
      '${swapAddress}order_id=${order.orderId.id}&private_id=${order.privateId}',
    _ => '${swapAddress}order_id=${order.orderId.id}',
  };
}

@riverpod
class MarketHistoryTotal extends _$MarketHistoryTotal {
  @override
  int build() {
    return 0;
  }

  void setState(int total) {
    state = total;
  }
}

@riverpod
class MarketHistoryOrderNotifier extends _$MarketHistoryOrderNotifier {
  @override
  List<HistoryOrder> build() {
    // also listen on total items, they will be always available when ui will watch on history order provider
    ref.listen(marketHistoryTotalProvider, (_, __) {});
    return [];
  }

  void loadHistory(From_LoadHistory loadHistory) {
    final newList = [...state];

    for (final historyOrder in loadHistory.list) {
      final index = newList.indexWhere((e) => e.id == historyOrder.id);

      if (index < 0) {
        newList.add(historyOrder);
        continue;
      }

      newList[index] = historyOrder;
    }

    state = newList;
  }

  void historyUpdated(From_HistoryUpdated historyUpdated) {
    final newList = [...state];

    final index = newList.indexWhere((e) => e.id == historyUpdated.order.id);

    if (index < 0) {
      newList.add(historyUpdated.order);
    } else {
      newList[index] = historyUpdated.order;
    }

    state = newList;
  }
}

@riverpod
List<UiHistoryOrder> marketUiHistoryOrders(Ref ref) {
  final amountToString = ref.read(amountToStringProvider);
  final assetsState = ref.read(assetsStateProvider);
  final assetImageRepository = ref.watch(assetImageRepositoryProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);
  final assetUtils = ref.watch(assetUtilsProvider);

  final historyOrders = ref.watch(marketHistoryOrderNotifierProvider);
  return historyOrders
      .map(
        (e) => UiHistoryOrder(
          amountToString: amountToString,
          assetsState: assetsState,
          assetImageRepository: assetImageRepository,
          satoshiRepository: satoshiRepository,
          assetUtils: assetUtils,
          historyOrder: e,
        ),
      )
      .toList();
}

@riverpod
String orderExpireDescription(Ref ref, Option<UiOwnOrder> optionOrder) {
  final timer = Timer.periodic(
    Duration(seconds: 1),
    (_) => ref.invalidateSelf(),
  );

  ref.onDispose(() => timer.cancel());

  return optionOrder.match(() => '', (order) => order.expireDescription);
}

@riverpod
class IndexPriceButtonAsyncNotifier extends _$IndexPriceButtonAsyncNotifier {
  @override
  AsyncValue<String> build() {
    return const AsyncValue<String>.loading();
  }

  void setIndexPrice(String value) async {
    state = AsyncValue.data(value);
  }
}

@Riverpod(keepAlive: true)
class MarketStartOrderNotifier extends _$MarketStartOrderNotifier {
  @override
  Option<int> build() {
    return Option.none();
  }

  void setState(int orderId) {
    state = Option.of(orderId);
  }
}

@freezed
sealed class StartOrderError with _$StartOrderError {
  const factory StartOrderError({
    @Default('') String error,
    @Default(0) int orderId,
  }) = _StartOrderError;
}

@riverpod
class MarketStartOrderErrorNotifier extends _$MarketStartOrderErrorNotifier {
  @override
  Option<StartOrderError> build() {
    return Option.none();
  }

  void setState(StartOrderError value) {
    state = Option.of(value);
  }
}

@riverpod
Option<QuoteSuccess> marketStartOrderQuoteSuccess(Ref ref) {
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);

  return optionQuote.match(
    () {
      return Option.none();
    },
    (quote) {
      if (!quote.hasSuccess()) {
        return Option.none();
      }

      if (optionStartOrderId.toNullable() != quote.orderId.toInt()) {
        return Option.none();
      }

      return Option.of(
        QuoteSuccess(
          amountToString,
          quote.success,
          quote.assetPair,
          quote.assetType,
          quote.tradeDir,
          quote.assetType,
          assetsState,
          quote.orderId.toInt(),
        ),
      );
    },
  );
}

@riverpod
Option<QuoteLowBalance> marketStartOrderLowBalanceError(Ref ref) {
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);

  return optionQuote.match(
    () {
      return Option.none();
    },
    (quote) {
      if (!quote.hasLowBalance()) {
        return Option.none();
      }

      if (optionStartOrderId.toNullable() != quote.orderId.toInt()) {
        return Option.none();
      }

      return Option.of(
        QuoteLowBalance(
          amountToString,
          quote.lowBalance,
          quote.assetPair,
          quote.assetType,
          quote.tradeDir,
          quote.assetType,
          assetsState,
          quote.orderId.toInt(),
        ),
      );
    },
  );
}

@riverpod
Option<QuoteError> marketStartOrderQuoteError(Ref ref) {
  final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);
  final optionQuoteError = ref.watch(marketQuoteErrorProvider);

  return optionQuoteError.match(
    () {
      return Option.none();
    },
    (quoteError) {
      if (optionStartOrderId.toNullable() != quoteError.orderId) {
        return Option.none();
      }

      return optionQuoteError;
    },
  );
}

@riverpod
class MarketOneTimeAuthorized extends _$MarketOneTimeAuthorized {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }

  Future<bool> authorize() async {
    if (state) {
      return true;
    }

    ref.read(authInProgressStateNotifierProvider.notifier).setState(true);
    final authSucceed = await ref.read(walletProvider).isAuthenticated();
    ref.invalidate(authInProgressStateNotifierProvider);
    state = authSucceed;

    return state;
  }
}

abstract class AbstractMarketTradeRepository {
  Future<void> makeSwapTrade({
    required BuildContext context,
    required Option<QuoteSuccess> optionQuoteSuccess,
  });
}

class MarketTradeRepository implements AbstractMarketTradeRepository {
  final Ref ref;

  MarketTradeRepository({required this.ref});

  @override
  Future<void> makeSwapTrade({
    required BuildContext context,
    required Option<QuoteSuccess> optionQuoteSuccess,
  }) async {
    await optionQuoteSuccess.match(
      () => () {},
      (quoteSuccess) => () async {
        var authorized = ref.read(marketOneTimeAuthorizedProvider);

        if (!ref.read(marketOneTimeAuthorizedProvider)) {
          authorized =
              await ref
                  .read(marketOneTimeAuthorizedProvider.notifier)
                  .authorize();
        }

        if (!authorized) {
          return;
        }

        if (context.mounted) {
          ref
              .read(marketPreviewOrderQuoteNotifierProvider.notifier)
              .setState(quoteSuccess);

          if (FlavorConfig.isDesktop) {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return DPreviewOrderDialog();
              },
              routeSettings: RouteSettings(name: desktopOrderPreviewRouteName),
              useRootNavigator: false,
            );
          } else {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return MobileOrderPreviewDialog();
              },
              routeSettings: RouteSettings(name: mobileOrderPreviewRouteName),
              useRootNavigator: false,
            );
          }

          final isJadeWallet = ref.read(isJadeWalletProvider);

          if (isJadeWallet) {
            // cleanup on jade sign dialog close
            return;
          }

          ref.invalidate(marketPreviewOrderQuoteNotifierProvider);
        }
      },
    )();
  }
}

@riverpod
AbstractMarketTradeRepository marketTradeRepository(Ref ref) {
  return MarketTradeRepository(ref: ref);
}

@Riverpod(keepAlive: true)
class MarketMinimalAmountsNotfier extends _$MarketMinimalAmountsNotfier {
  @override
  Map<String, int> build() {
    return {};
  }

  void setState(From_MinMarketAmounts minMarketAmounts) {
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    final tetherAssetId = ref.read(tetherAssetIdStateProvider);
    final eurxAssetId = ref.read(eurxAssetIdStateProvider);

    final minAmounts = <String, int>{
      liquidAssetId: minMarketAmounts.lbtc.toInt(),
      tetherAssetId: minMarketAmounts.usdt.toInt(),
      eurxAssetId: minMarketAmounts.eurx.toInt(),
    };
    state = minAmounts;
  }
}

@riverpod
Option<Asset> limitFeeAsset(Ref ref) {
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

  return optionSubscribedMarket.match(
    () => Option.none(),
    (marketInfo) => optionBaseAsset.match(
      () => Option.none(),
      (baseAsset) => optionQuoteAsset.match(
        () {
          return Option.none();
        },
        (quoteAsset) {
          final feeAsset =
              marketInfo.feeAsset == AssetType.BASE ? baseAsset : quoteAsset;
          return Option.of(feeAsset);
        },
      ),
    ),
  );
}

@riverpod
String limitMinimumFeeAmount(Ref ref) {
  final minimalAmounts = ref.watch(marketMinimalAmountsNotfierProvider);
  final optionFeeAsset = ref.watch(limitFeeAssetProvider);
  final amountToString = ref.watch(amountToStringProvider);

  return optionFeeAsset.match(
    () {
      return '';
    },
    (feeAsset) {
      final satoshi = minimalAmounts[feeAsset.assetId] ?? 0;
      return amountToString.amountToString(
        AmountToStringParameters(
          amount: satoshi,
          precision: feeAsset.precision,
        ),
      );
    },
  );
}

@riverpod
bool limitInsufficientAmount(Ref ref) {
  final optionFeeAsset = ref.watch(limitFeeAssetProvider);
  final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
  final orderAmount = ref.watch(limitOrderAmountProvider);
  final minimalAmounts = ref.watch(marketMinimalAmountsNotfierProvider);

  if (orderAmount.amount == Decimal.zero) {
    return false;
  }

  return optionFeeAsset.match(
    () {
      return false;
    },
    (feeAsset) {
      return optionBaseAsset.match(
        () {
          return false;
        },
        (baseAsset) {
          final minimalAmount = minimalAmounts[feeAsset.assetId] ?? 0;
          if (feeAsset.assetId == baseAsset.assetId &&
              feeAsset.assetId == orderAmount.assetId &&
              orderAmount.satoshi < minimalAmount) {
            return true;
          }

          return false;
        },
      );
    },
  );
}

@riverpod
bool limitInsufficientPrice(Ref ref) {
  final optionFeeAsset = ref.watch(limitFeeAssetProvider);
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
  final minimalAmounts = ref.watch(marketMinimalAmountsNotfierProvider);
  final priceAmount = ref.watch(limitPriceAmountProvider);
  final orderAmount = ref.watch(limitOrderAmountProvider);

  if (priceAmount.amount == Decimal.zero) {
    return false;
  }

  return optionFeeAsset.match(
    () {
      return false;
    },
    (feeAsset) {
      return optionQuoteAsset.match(
        () {
          return false;
        },
        (quoteAsset) {
          if ((orderAmount.amount * priceAmount.amount) == Decimal.zero) {
            return false;
          }

          final satoshiRepository = ref.watch(satoshiRepositoryProvider);

          final multipliedAmount = (orderAmount.amount * priceAmount.amount);
          final multipliedSatoshi = satoshiRepository.satoshiForAmount(
            amount: multipliedAmount.toString(),
            assetId: feeAsset.assetId,
          );

          final minimalAmount = minimalAmounts[feeAsset.assetId] ?? 0;
          if (feeAsset.assetId == quoteAsset.assetId &&
              feeAsset.assetId == priceAmount.assetId &&
              multipliedSatoshi < minimalAmount) {
            return true;
          }

          return false;
        },
      );
    },
  );
}

@riverpod
String marketOrderButtonText(Ref ref) {
  final continueText = 'Continue'.tr().toUpperCase();
  final unlockText = 'Unlock'.tr().toUpperCase();

  final isJadeWallet = ref.watch(isJadeWalletProvider);

  if (!isJadeWallet) {
    return continueText;
  }

  final jadeLockState = ref.watch(jadeLockStateNotifierProvider);
  return switch (jadeLockState) {
    JadeLockStateUnlocked() => continueText,
    _ => unlockText,
  };
}
