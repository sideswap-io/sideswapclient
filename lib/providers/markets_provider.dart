import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sideswap/common/helpers.dart' show kCoin;
import 'package:sideswap/desktop/markets/widgets/d_preview_order_dialog.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/ui_history_order.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/market_swap_page.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'markets_provider.freezed.dart';
part 'markets_provider.g.dart';

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
List<MarketInfo> stableMarkets(Ref ref) {
  return ref.watch(marketInfoByMarketTypeProvider(MarketType_.STABLECOIN));
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

@riverpod
class DebouncedMarketPublicOrders extends _$DebouncedMarketPublicOrders {
  final _streamController =
      StreamController<Map<AssetPair, List<PublicOrder>>>();

  @override
  Map<AssetPair, List<PublicOrder>> build() {
    ref.listen(marketPublicOrdersNotifierProvider, (_, next) {
      _streamController.sink.add(next);
    });

    final subscription = _streamController.stream
        .debounceTime(const Duration(milliseconds: 150))
        .listen(_updateState);

    ref.onDispose(() {
      _streamController.close();
      subscription.cancel();
    });

    return <AssetPair, List<PublicOrder>>{};
  }

  void _updateState(Map<AssetPair, List<PublicOrder>> data) {
    state = data;
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
    final marketType = quoteAsset == null
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
Option<UiOwnOrder> marketUiOwnOrderById(Ref ref, OrderId orderId) {
  final uiOwnOrders = ref.watch(marketUiOwnOrdersProvider);
  for (final uiOwnOrder in uiOwnOrders) {
    if (uiOwnOrder.orderId == orderId) {
      return Option.of(uiOwnOrder);
    }
  }

  return Option.none();
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
Option<({int satoshiIndexPrice, Option<Asset> quoteAsset})>
marketSatoshiIndexPrice(Ref ref) {
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
    final satoshi = asset == null
        ? 0
        : satoshiRepository.satoshiForAmount(
            amount: amount.toString(),
            assetId: asset.assetId,
          );

    if (satoshi == 0) {
      return Option.none();
    }

    final quoteAsset = asset == null ? Option<Asset>.none() : Option.of(asset);
    return Option.of((satoshiIndexPrice: satoshi, quoteAsset: quoteAsset));
  });
}

@riverpod
Option<({String indexPrice, Option<Asset> quoteAsset})> marketIndexPrice(
  Ref ref,
) {
  final optionSatoshiIndexPrice = ref.watch(marketSatoshiIndexPriceProvider);

  return optionSatoshiIndexPrice.match(() => Option.none(), (
    satoshiIndexPrice,
  ) {
    if (satoshiIndexPrice.satoshiIndexPrice == 0) {
      return Option.none();
    }

    final price = ref
        .watch(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(
            amount: satoshiIndexPrice.satoshiIndexPrice,
            trailingZeroes: false,
          ),
        );

    return Option.of((
      indexPrice: price,
      quoteAsset: satoshiIndexPrice.quoteAsset,
    ));
  });
}

@riverpod
Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>
marketDecimalIndexPrice(Ref ref) {
  final optionMarketIndexPrice = ref.watch(marketIndexPriceProvider);

  return optionMarketIndexPrice.match(() => Option.none(), (indexPrice) {
    final decimalIndexPrice =
        Decimal.tryParse(indexPrice.indexPrice) ?? Decimal.zero;

    return Option.of((
      decimalIndexPrice: decimalIndexPrice,
      quoteAsset: indexPrice.quoteAsset,
    ));
  });
}

@riverpod
Option<({int satoshiLastPrice, Option<Asset> quoteAsset})>
marketSatoshiLastPrice(Ref ref) {
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
    final satoshi = asset == null
        ? 0
        : satoshiRepository.satoshiForAmount(
            amount: amount.toString(),
            assetId: asset.assetId,
          );

    if (satoshi == 0) {
      return Option.none();
    }

    final quoteAsset = asset == null ? Option<Asset>.none() : Option.of(asset);
    return Option.of((satoshiLastPrice: satoshi, quoteAsset: quoteAsset));
  });
}

@riverpod
Option<({String lastPrice, Option<Asset> quoteAsset})> marketLastPrice(
  Ref ref,
) {
  final optionSatoshiLastPrice = ref.watch(marketSatoshiLastPriceProvider);

  return optionSatoshiLastPrice.match(() => Option.none(), (satoshiLastPrice) {
    if (satoshiLastPrice.satoshiLastPrice == 0) {
      return Option.none();
    }

    final price = ref
        .watch(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(
            amount: satoshiLastPrice.satoshiLastPrice,
            trailingZeroes: false,
          ),
        );

    return Option.of((
      lastPrice: price,
      quoteAsset: satoshiLastPrice.quoteAsset,
    ));
  });
}

@riverpod
Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>
marketDecimalLastPrice(Ref ref) {
  final optionMarketLastPrice = ref.watch(marketLastPriceProvider);

  return optionMarketLastPrice.match(() => Option.none(), (lastPrice) {
    final decimalLastPrice =
        Decimal.tryParse(lastPrice.lastPrice) ?? Decimal.zero;

    return Option.of((
      decimalLastPrice: decimalLastPrice,
      quoteAsset: lastPrice.quoteAsset,
    ));
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

  (Decimal, int, String, AssetPair) _equality() =>
      (amount, satoshi, assetId, assetPair);

  @override
  bool operator ==(covariant OrderAmount other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.satoshi == satoshi &&
        other.assetId == assetId &&
        other.assetPair == assetPair;
  }

  @override
  int get hashCode {
    return _equality().hashCode;
  }

  OrderAmount copyWith({
    Decimal? amount,
    int? satoshi,
    String? assetId,
    AssetPair? assetPair,
  }) {
    return OrderAmount(
      amount: amount ?? this.amount,
      satoshi: satoshi ?? this.satoshi,
      assetId: assetId ?? this.assetId,
      assetPair: assetPair ?? this.assetPair,
    );
  }

  @override
  String toString() {
    return 'OrderAmount(amount: $amount, satoshi: $satoshi, assetId: $assetId, assetPair: $assetPair)';
  }
}

@riverpod
class MarketOrderAmountControllerNotifier
    extends _$MarketOrderAmountControllerNotifier {
  @override
  String build() {
    // cleanup when asset pair changed or order submit success
    ref.watch(marketSubscribedAssetPairNotifierProvider);
    ref.watch(orderSubmitSuccessNotifierProvider);
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
      final assetId = marketSideState == MarketSideStateBase()
          ? assetPair.base
          : assetPair.quote;

      if (amountString.isEmpty) {
        return OrderAmount(
          amount: Decimal.zero,
          satoshi: 0,
          assetId: assetId,
          assetPair: assetPair,
        );
      }

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
    ref.listen(marketTypeSwitchStateNotifierProvider, (_, _) {
      _stopQuotes();
    });

    ref.listen(marketSubscribedAssetPairNotifierProvider, (_, _) {
      _startQuotes();
    });

    ref.listen(marketOrderAmountProvider, (_, next) {
      /// * Calling stop quotes here cause issue for app links on app startup!
      _startQuotes();
    });

    ref.listen(marketSideStateNotifierProvider, (_, _) {
      _stopQuotes();
    });

    ref.listen(tradeDirStateNotifierProvider, (_, _) {
      _stopQuotes();
    });

    return ref.watch(quoteEventNotifierProvider);
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
        final optionStartOrderId = ref.read(marketStartOrderNotifierProvider);

        if (state.isSome() && optionStartOrderId.isNone()) {
          _stopQuotes();
        }

        final assetId = marketSideState == MarketSideStateBase()
            ? assetPair.base
            : assetPair.quote;
        if (marketOrderAmount.assetPair != assetPair ||
            marketOrderAmount.assetId != assetId) {
          return;
        }

        if (marketOrderAmount.asSatoshi() == 0) {
          return;
        }

        ref
            .read(quoteEventNotifierProvider.notifier)
            .startQuotes(
              assetPair: assetPair,
              assetType: marketSideState == MarketSideStateBase()
                  ? AssetType.BASE
                  : AssetType.QUOTE,
              amount: marketOrderAmount.asSatoshi(),
              tradeDir: tradeDir,
            );
      },
    )();
  }

  void _stopQuotes() {
    ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
  }
}

@riverpod
Option<QuoteError> marketQuoteError(Ref ref) {
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrder.match(
    () => optionQuote.match(
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

@riverpod
Option<QuoteLowBalance> marketQuoteLowBalanceError(Ref ref) {
  final optionAssetPair = ref.watch(marketSubscribedAssetPairNotifierProvider);
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrder.match(
    () => optionAssetPair.match(
      () => Option<QuoteLowBalance>.none(),
      (assetPair) => optionQuote.match(
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

@riverpod
Option<QuoteSuccess> marketQuoteSuccess(Ref ref) {
  final optionAssetPair = ref.watch(marketSubscribedAssetPairNotifierProvider);
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionSubscribedMarket = ref.watch(subscribedMarketInfoProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrder.match(
    () => optionAssetPair.match(
      () => Option.none(),
      (assetPair) => optionQuote.match(
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

@riverpod
Option<QuoteUnregisteredGaid> marketQuoteUnregisteredGaid(Ref ref) {
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);

  return optionStartOrder.match(
    () => optionQuote.match(
      () => () {
        return Option<QuoteUnregisteredGaid>.none();
      },
      (quote) => () {
        if (!quote.hasUnregisteredGaid()) {
          return Option<QuoteUnregisteredGaid>.none();
        }

        return Option.of(
          QuoteUnregisteredGaid(
            orderId: quote.orderId,
            quoteUnregisteredGaid: quote.unregisteredGaid,
          ),
        );
      },
    )(),
    (_) => Option.none(),
  );
}

@riverpod
Option<From_AcceptQuote> marketAcceptQuote(Ref ref) {
  return ref.watch(acceptQuoteNotifierProvider);
}

@riverpod
Option<String> marketAcceptQuoteSuccess(Ref ref) {
  final optionAcceptQuote = ref.watch(marketAcceptQuoteProvider);

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
Option<String> marketAcceptQuoteError(Ref ref) {
  final optionAcceptQuote = ref.watch(marketAcceptQuoteProvider);

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
    ref.watch(orderSubmitSuccessNotifierProvider);
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
      if (amountString.isEmpty) {
        return OrderAmount(
          amount: Decimal.zero,
          satoshi: 0,
          assetId: assetId,
          assetPair: assetPair,
        );
      }

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
class LimitOrderPriceControllerNotifier
    extends _$LimitOrderPriceControllerNotifier {
  @override
  String build() {
    // cleanup when asset pair changed or order submit success
    ref.watch(marketSubscribedAssetPairNotifierProvider);
    ref.watch(orderSubmitSuccessNotifierProvider);
    ref.watch(marketTypeSwitchStateNotifierProvider);

    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
OrderAmount limitOrderPrice(Ref ref) {
  final subscribedAssetPair = ref.watch(
    marketSubscribedAssetPairNotifierProvider,
  );
  final priceString = ref.watch(limitOrderPriceControllerNotifierProvider);
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
      final assetId = marketSideState == MarketSideStateBase()
          ? assetPair.quote
          : assetPair.base;

      if (priceString.isEmpty) {
        return OrderAmount(
          amount: Decimal.zero,
          satoshi: 0,
          assetId: assetId,
          assetPair: assetPair,
        );
      }

      final priceDecimal = Decimal.tryParse(priceString) ?? Decimal.zero;
      final amountSatoshi = satoshiRepository.satoshiForAmount(
        amount: priceDecimal.toString(),
        assetId: assetId,
      );

      return OrderAmount(
        amount: priceDecimal,
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
  final limitPrice = ref.watch(limitOrderPriceProvider);

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
class OrderSubmitSuccessNotifier extends _$OrderSubmitSuccessNotifier {
  @override
  Option<UiOwnOrder> build() {
    return Option.none();
  }

  void setState(UiOwnOrder uiOwnOrder) {
    // set submit success only once
    if (state.toNullable()?.orderId == uiOwnOrder.orderId) {
      return;
    }

    state = Option.of(uiOwnOrder);
  }
}

@riverpod
class OrderSubmitErrorNotifier extends _$OrderSubmitErrorNotifier {
  @override
  Option<String> build() {
    return Option.none();
  }

  void setState(String errorMsg) {
    state = Option.of(errorMsg);
  }
}

@riverpod
class OrderSubmitUnregisteredGaidNotifier
    extends _$OrderSubmitUnregisteredGaidNotifier {
  @override
  Option<String> build() {
    return Option.none();
  }

  void setState(String domainAgent) {
    state = Option.of(domainAgent);
  }
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
    ref.listen(marketHistoryTotalProvider, (_, _) {});
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

  void setIndexPrice(String value) {
    state = AsyncValue.data(value);
  }
}

@Riverpod(keepAlive: true)
class MarketStartOrderNotifier extends _$MarketStartOrderNotifier {
  @override
  Option<From_StartOrder> build() {
    return Option.none();
  }

  void setState(From_StartOrder startOrder) {
    state = Option.of(startOrder);
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
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);
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

      return optionStartOrder.match(() => Option.none(), (startOrder) {
        if (startOrder.orderId.toInt() != quote.orderId.toInt()) {
          return Option.none();
        }

        if (!startOrder.hasSuccess()) {
          return Option.none();
        }

        return Option.of(
          QuoteSuccess(
            amountToString,
            quote.success,
            quote.assetPair,
            quote.assetType,
            quote.tradeDir,
            startOrder.success.feeAsset,
            assetsState,
            quote.orderId.toInt(),
            startOrderSuccess: startOrder.success,
          ),
        );
      });
    },
  );
}

@riverpod
Option<QuoteLowBalance> marketStartOrderLowBalanceError(Ref ref) {
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);
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

      return optionStartOrder.match(() => Option.none(), (startOrder) {
        if (startOrder.orderId.toInt() != quote.orderId.toInt()) {
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
      });
    },
  );
}

@riverpod
Option<QuoteError> marketStartOrderQuoteError(Ref ref) {
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);

  return optionQuote.match(
    () {
      return Option.none();
    },
    (quote) {
      return optionStartOrder.match(() => Option.none(), (startOrder) {
        if (!quote.hasError()) {
          return Option.none();
        }

        if (startOrder.orderId.toInt() != quote.orderId.toInt()) {
          return Option.none();
        }

        return Option.of(
          QuoteError(orderId: quote.orderId.toInt(), error: quote.error),
        );
      });
    },
  );
}

@riverpod
Option<QuoteUnregisteredGaid> marketStartOrderUnregisteredGaid(Ref ref) {
  final optionQuote = ref.watch(marketQuoteNotifierProvider);
  final optionStartOrder = ref.watch(marketStartOrderNotifierProvider);

  return optionQuote.match(() => Option.none(), (quote) {
    return optionStartOrder.match(() => Option.none(), (startOrder) {
      if (!quote.hasUnregisteredGaid()) {
        return Option.none();
      }

      if (startOrder.orderId.toInt() != quote.orderId.toInt()) {
        return Option.none();
      }

      return Option.of(
        QuoteUnregisteredGaid(
          orderId: startOrder.orderId,
          quoteUnregisteredGaid: quote.unregisteredGaid,
        ),
      );
    });
  });
}

abstract class AbstractMarketTradeRepository {
  Future<void> makeSwapTrade({
    required BuildContext context,
    required Option<QuoteSuccess> optionQuoteSuccess,
    Option<PreviewOrderDialogModifiers> optionModifiers = const Option.none(),
  });
}

class MarketTradeRepository implements AbstractMarketTradeRepository {
  final Ref ref;

  MarketTradeRepository({required this.ref});

  @override
  Future<void> makeSwapTrade({
    required BuildContext context,
    required Option<QuoteSuccess> optionQuoteSuccess,
    Option<PreviewOrderDialogModifiers> optionModifiers = const Option.none(),
  }) async {
    optionModifiers.match(
      () => ref.invalidate(previewOrderDialogModifiersNotifierProvider),
      (modifiers) => ref
          .read(previewOrderDialogModifiersNotifierProvider.notifier)
          .setState(modifiers),
    );

    await optionQuoteSuccess.match(
      () => () {},
      (quoteSuccess) => () async {
        ref
            .read(previewOrderQuoteSuccessNotifierProvider.notifier)
            .setState(quoteSuccess);

        if (context.mounted) {
          if (!context.mounted) {
            return;
          }

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

          ref.invalidate(previewOrderQuoteSuccessNotifierProvider);
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
          final feeAsset = marketInfo.feeAsset == AssetType.BASE
              ? baseAsset
              : quoteAsset;
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
  final priceAmount = ref.watch(limitOrderPriceProvider);
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

/// Aggregated volume

@riverpod
MarketOrderAggregateVolumeProvider marketLimitOrderAggregateVolume(Ref ref) {
  final orderAmount = ref.watch(limitOrderAmountProvider);
  final orderPrice = ref.watch(limitOrderPriceProvider);
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

  return optionQuoteAsset.match(
    () => MarketOrderAggregateVolumeProvider(
      amount: orderAmount.amount,
      price: orderPrice.amount,
      precision: 0,
    ),
    (quoteAsset) => MarketOrderAggregateVolumeProvider(
      amount: orderAmount.amount,
      price: orderPrice.amount,
      precision: quoteAsset.precision,
    ),
  );
}

@riverpod
String marketLimitOrderAggregatedVolumeWithTicker(Ref ref) {
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
  final aggregateVolume = ref.watch(marketLimitOrderAggregateVolumeProvider);

  return optionQuoteAsset.match(
    () => aggregateVolume.asString(),
    (quoteAsset) => '${aggregateVolume.asString()} ${quoteAsset.ticker}',
  );
}

@riverpod
bool marketLimitOrderAggregateVolumeTooHigh(Ref ref) {
  final aggregateVolume = ref.watch(marketLimitOrderAggregateVolumeProvider);
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

  return optionQuoteAsset.match(() => true, (quoteAsset) {
    final assetBalance = ref.watch(assetBalanceStringProvider(quoteAsset));

    final balance = double.tryParse(assetBalance) ?? .0;
    return aggregateVolume.asDouble() > balance;
  });
}

class MarketOrderAggregateVolumeProvider {
  final Decimal amount;
  final Decimal price;
  final int precision;

  MarketOrderAggregateVolumeProvider({
    required this.amount,
    required this.price,
    required this.precision,
  });

  String asString() {
    if (precision == 0) {
      return asDecimal().toBigInt().toString();
    }

    return asDecimal().toStringAsFixed(precision);
  }

  Decimal asDecimal() {
    final multipliedInSat = amount * price * Decimal.fromInt(kCoin);
    final power =
        Decimal.tryParse(pow(10, precision).toStringAsFixed(precision)) ??
        Decimal.zero;
    final amountWithPrecision = (multipliedInSat / power).toDecimal();

    if (precision == 0) {
      return amountWithPrecision;
    }

    return (multipliedInSat / power).toDecimal();
  }

  double asDouble() {
    return double.tryParse(asString()) ?? 0.0;
  }

  MarketOrderAggregateVolumeProvider copyWith({
    Decimal? amount,
    Decimal? price,
    int? precision,
  }) {
    return MarketOrderAggregateVolumeProvider(
      amount: amount ?? this.amount,
      price: price ?? this.price,
      precision: precision ?? this.precision,
    );
  }

  @override
  String toString() =>
      'MarketOrderAggregateVolumeProvider(amount: $amount, price: $price, precision: $precision)';

  @override
  bool operator ==(covariant MarketOrderAggregateVolumeProvider other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.price == price &&
        other.precision == precision;
  }

  @override
  int get hashCode => amount.hashCode ^ price.hashCode ^ precision.hashCode;
}

@riverpod
String marketLimitPriceBalance(Ref ref) {
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

  return optionQuoteAsset.match(() => '', (quoteAsset) {
    final assetBalance = ref.watch(assetBalanceStringProvider(quoteAsset));

    return assetBalance;
  });
}

@riverpod
String marketLimitAmountBalance(Ref ref) {
  final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);

  return optionBaseAsset.match(() => '', (baseAsset) {
    final assetBalance = ref.watch(assetBalanceStringProvider(baseAsset));

    return assetBalance;
  });
}
