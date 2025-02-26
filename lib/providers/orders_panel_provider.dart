import 'dart:math';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';

import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/math_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'orders_panel_provider.freezed.dart';
part 'orders_panel_provider.g.dart';

@freezed
class RequestOrderSortFlag with _$RequestOrderSortFlag {
  const factory RequestOrderSortFlag.all() = RequestOrderSortFlagAll;
  const factory RequestOrderSortFlag.online() = RequestOrderSortFlagOnline;
  const factory RequestOrderSortFlag.offline() = RequestOrderSortFlagOffline;
}

@riverpod
class RequestOrderSortFlagNotifier extends _$RequestOrderSortFlagNotifier {
  @override
  RequestOrderSortFlag build() {
    return const RequestOrderSortFlagAll();
  }

  void setSortFlag(RequestOrderSortFlag sortFlag) {
    state = sortFlag;
  }
}

@freezed
sealed class InternalUiOrderType with _$InternalUiOrderType {
  const factory InternalUiOrderType.public() = InternalUiOrderTypePublic;
  const factory InternalUiOrderType.own() = InternalUiOrderTypeOwn;
}

class InternalUiOrder {
  final Ref ref;
  final InternalUiOrderType orderType;
  final Option<PublicOrder> order;
  final double amountPercent;
  final AbstractSatoshiRepository satoshiRepository;

  InternalUiOrder({
    required this.ref,
    required this.orderType,
    required this.satoshiRepository,
    this.order = const Option.none(),
    this.amountPercent = 0,
  });

  OrderId? get orderId => order.toNullable()?.orderId;
  AssetPair? get assetPair => order.toNullable()?.assetPair;
  TradeDir? get tradeDir => order.toNullable()?.tradeDir;
  int get amount => order.toNullable()?.amount.toInt() ?? 0;
  int get amountPrecision => ref
      .read(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: assetPair?.base);
  String get amountString {
    return ref
        .read(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(
            amount: order.toNullable()?.amount.toInt() ?? 0,
            precision: amountPrecision,
            trailingZeroes: false,
          ),
        );
  }

  double get price => order.toNullable()?.price ?? 0;
  int get pricePrecision => ref
      .read(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: assetPair?.quote);
  String get priceString {
    var priceDecimal =
        Decimal.tryParse((order.toNullable()?.price ?? '0').toString()) ??
        Decimal.zero;
    if (!FlavorConfig.isDesktop) {
      return ref
          .read(amountToStringProvider)
          .amountToMobileFormatted(
            amount: priceDecimal,
            precision: pricePrecision,
          );
    }

    final priceSatoshi = satoshiRepository.satoshiForAmount(
      amount: priceDecimal.toString(),
      assetId: order.toNullable()?.assetPair.quote,
    );
    return ref
        .read(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(
            amount: priceSatoshi,
            precision: pricePrecision,
            trailingZeroes: false,
          ),
        );
  }

  InternalUiOrder copyWith({
    InternalUiOrderType? orderType,
    Option<PublicOrder>? order,
    double? amountPercent,
  }) {
    return InternalUiOrder(
      ref: ref,
      orderType: orderType ?? this.orderType,
      satoshiRepository: satoshiRepository,
      order: order ?? this.order,
      amountPercent: amountPercent ?? this.amountPercent,
    );
  }

  @override
  String toString() =>
      'InternalUiOrder(orderType: $orderType, order: $order, amountPercent: $amountPercent)';

  @override
  bool operator ==(covariant InternalUiOrder other) {
    if (identical(this, other)) return true;

    return other.ref == ref &&
        other.orderType == orderType &&
        other.order == order &&
        other.amountPercent == amountPercent;
  }

  @override
  int get hashCode => ref.hashCode ^ orderType.hashCode ^ order.hashCode;
}

@riverpod
Iterable<InternalUiOrder> internalUiOrders(Ref ref) {
  final optionAssetPair = ref.watch(marketSubscribedAssetPairNotifierProvider);
  final publicOrderMap = ref.watch(marketPublicOrdersNotifierProvider);
  final uiOwnOrders = ref.watch(marketOwnOrdersNotifierProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return optionAssetPair.match(() => [], (assetPair) {
    final List<InternalUiOrder> internalOrders = [];
    final publicOrders = publicOrderMap[assetPair] ?? [];
    for (final publicOrder in publicOrders) {
      internalOrders.add(
        InternalUiOrder(
          ref: ref,
          satoshiRepository: satoshiRepository,
          orderType: InternalUiOrderType.public(),
          order: Option.of(publicOrder),
        ),
      );
    }

    for (final uiOwnOrder in uiOwnOrders) {
      final index = internalOrders.indexWhere(
        (e) => e.orderId == uiOwnOrder.orderId,
      );
      if (index >= 0) {
        internalOrders[index] = internalOrders[index].copyWith(
          orderType: InternalUiOrderType.own(),
        );
      }
    }

    return internalOrders;
  });
}

@riverpod
Decimal maxOrderAmount(Ref ref) {
  final bids = ref.watch(ordersBidsProvider);
  final asks = ref.watch(ordersAsksProvider);

  final maxBidsAmount = bids.fold(
    0,
    (previous, element) => previous + element.amount,
  );
  final maxAsksAmount = asks.fold(
    0,
    (previous, element) => previous + element.amount,
  );
  return Decimal.fromInt(max(maxBidsAmount, maxAsksAmount));
}

@riverpod
Iterable<InternalUiOrder> ordersBids(Ref ref) {
  final internalOrders = ref.watch(internalUiOrdersProvider);
  return internalOrders
      .where((e) => e.tradeDir == TradeDir.BUY)
      .sorted((a, b) => b.price.compareTo(a.price));
}

@riverpod
Iterable<InternalUiOrder> ordersAsks(Ref ref) {
  final internalOrders = ref.watch(internalUiOrdersProvider);
  return internalOrders
      .where((e) => e.tradeDir == TradeDir.SELL)
      .sorted((a, b) => a.price.compareTo(b.price));
}

@riverpod
Decimal mapRange(
  Ref ref,
  double value,
  double inMin,
  double inMax,
  double outMin,
  double outMax,
) {
  return Decimal.tryParse(
        ((value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin)
            .toString(),
      ) ??
      Decimal.zero;
}

@riverpod
Iterable<InternalUiOrder> ordersPanelBids(Ref ref) {
  final bids = ref.watch(ordersBidsProvider);
  final maxAmount = ref.watch(maxOrderAmountProvider);
  final mathHelper = ref.watch(mathHelperProvider);

  return bids.map((e) {
    final amount = Decimal.fromInt(e.amount);
    var percent =
        ((amount * Decimal.fromInt(100)) / maxAmount)
            .toDecimal(scaleOnInfinitePrecision: 4)
            .toDouble();
    percent = mathHelper.mapRange(percent, 0, 100, 0, 1).toDouble();
    return e.copyWith(amountPercent: percent);
  }).toList();
}

@riverpod
Iterable<InternalUiOrder> ordersPanelAsks(Ref ref) {
  final asks = ref.watch(ordersAsksProvider);
  final maxAmount = ref.watch(maxOrderAmountProvider);
  final mathHelper = ref.watch(mathHelperProvider);

  return asks.map((e) {
    final amount = Decimal.fromInt(e.amount);
    var percent =
        ((amount * Decimal.fromInt(100)) / maxAmount)
            .toDecimal(scaleOnInfinitePrecision: 4)
            .toDouble();
    percent = mathHelper.mapRange(percent, 0, 100, 0, 1).toDouble();
    return e.copyWith(amountPercent: percent);
  }).toList();
}
