import 'dart:math';

import 'package:candlesticks/candlesticks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'chart_providers.g.dart';
part 'chart_providers.freezed.dart';

@freezed
class ChartsSubscriptionFlag with _$ChartsSubscriptionFlag {
  const factory ChartsSubscriptionFlag.subscribed() =
      ChartsSubscriptionFlagSubscribed;
  const factory ChartsSubscriptionFlag.unsubscribed() =
      ChartsSubscriptionFlagUnsubscribed;
}

@riverpod
class ChartsSubscriptionFlagNotifier extends _$ChartsSubscriptionFlagNotifier {
  @override
  ChartsSubscriptionFlag build() {
    return ChartsSubscriptionFlag.unsubscribed();
  }

  void subscribe() {
    state = ChartsSubscriptionFlag.subscribed();
  }

  void unsubscribe() {
    state = ChartsSubscriptionFlag.unsubscribed();
  }
}

class Stats {
  double low = 0;
  double high = 0;
  double last = 0;
  double changePercent = 0;
  double volume = 0;
}

@riverpod
class ChartsNotifier extends _$ChartsNotifier {
  @override
  Map<AssetPair, List<Candle>> build() {
    ref.listen(chartsSubscriptionFlagNotifierProvider, (_, next) {
      if (next == ChartsSubscriptionFlagUnsubscribed()) {
        _unsubscribe();
        return;
      }

      final optionAssetPair = ref.read(
        marketSubscribedAssetPairNotifierProvider,
      );

      optionAssetPair.match(
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

  Candle _convertPoint(ChartPoint point) {
    return Candle(
      date: DateTime.parse(point.time),
      close: point.close,
      high: point.high,
      low: point.low,
      open: point.open,
      volume: point.volume,
    );
  }

  void _subscribe(AssetPair assetPair) {
    final msg = To();
    msg.chartsSubscribe = assetPair;
    ref.read(walletProvider).sendMsg(msg);
  }

  void _unsubscribe() {
    final msg = To();
    msg.chartsUnsubscribe = Empty();
    ref.read(walletProvider).sendMsg(msg);
  }

  void setChartsData(From_ChartsSubscribe chartsSubscribe) {
    final charts = {...state};
    charts[chartsSubscribe.assetPair] =
        chartsSubscribe.data.reversed.map(_convertPoint).toList();
    state = charts;
  }

  void updateChartsData(From_ChartsUpdate chartsUpdate) {
    final charts = {...state};
    final chartPoints = charts[chartsUpdate.assetPair] ?? [];
    final newPoint = _convertPoint(chartsUpdate.update);
    chartPoints.removeWhere((e) => e.date == newPoint.date);
    chartPoints.insert(0, newPoint);
    charts[chartsUpdate.assetPair] = chartPoints;
    state = charts;
  }

  Stats getStats(AssetPair assetPair) {
    final charts = {...state};
    final chartPoints = charts[assetPair] ?? [];

    if (chartPoints.isEmpty) {
      return Stats();
    }

    final assetPrecision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: assetPair.quote);

    final stats = Stats();
    stats.last = chartPoints.first.close;
    stats.low = double.infinity;
    stats.high = -double.infinity;
    double oldest = 0;
    int volume = 0;
    for (final point in chartPoints.take(30)) {
      stats.low = min(stats.low, point.low);
      stats.high = max(stats.high, point.high);
      oldest = point.open;
      volume += toIntAmount(point.volume, precision: assetPrecision.toInt());
    }
    stats.changePercent = 100 * (stats.last / oldest - 1);
    stats.volume = toFloat(volume, precision: assetPrecision.toInt());
    return stats;
  }
}

@riverpod
Stats chartsStats(Ref ref) {
  final charts = ref.watch(chartsNotifierProvider);
  final optionAssetPair = ref.watch(marketSubscribedAssetPairNotifierProvider);

  return optionAssetPair.match(
    () => () {
      return Stats();
    },
    (assetPair) => () {
      final chartPoints = charts[assetPair] ?? [];

      if (chartPoints.isEmpty) {
        return Stats();
      }

      final assetPrecision = ref
          .watch(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: assetPair.quote);

      final stats = Stats();
      stats.last = chartPoints.first.close;
      stats.low = double.infinity;
      stats.high = -double.infinity;
      double oldest = 0;
      int volume = 0;
      for (final point in chartPoints.take(30)) {
        stats.low = min(stats.low, point.low);
        stats.high = max(stats.high, point.high);
        oldest = point.open;
        volume += toIntAmount(point.volume, precision: assetPrecision.toInt());
      }
      stats.changePercent = 100 * (stats.last / oldest - 1);
      stats.volume = toFloat(volume, precision: assetPrecision.toInt());
      return stats;
    },
  )();
}

abstract class AbstractChartStatsRepository {
  int priceAssetPrecision();
  String? priceAssetId();
  int floatAmount();
  String floatAmountString();
  int totalAmount();
  String totalAmountString();
  double marketCap();
  String marketCapString();
  double statsLow();
  double statsHigh();
  double statsLast();
  double statsChangePercent();
  double statsVolume();
  String statsLowString();
  String statsHighString();
  String statsLastString();
  String statsChangePercentString();
  String statsVolumeString();
  String freeFloatString();
  String totalFloatString();
  bool pricedInLiquid = false;
}

class ChartStatsRepository implements AbstractChartStatsRepository {
  final Asset asset;
  final Asset? priceAsset;
  final AmountToString amountProvider;
  final AssetDetailsData? issuerDetails;
  final Stats stats;
  @override
  final bool pricedInLiquid;

  ChartStatsRepository({
    required this.asset,
    required this.priceAsset,
    required this.amountProvider,
    required this.stats,
    required this.pricedInLiquid,
    this.issuerDetails,
  });

  @override
  int priceAssetPrecision() {
    return priceAsset?.precision ?? 8;
  }

  @override
  String? priceAssetId() {
    return priceAsset?.assetId;
  }

  @override
  int floatAmount() {
    return (issuerDetails?.stats?.issuedAmount ?? 0) -
        (issuerDetails?.stats?.burnedAmount ?? 0);
  }

  @override
  String floatAmountString() {
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: floatAmount(),
        precision: asset.precision,
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  int totalAmount() {
    final floatAmount =
        (issuerDetails?.stats?.issuedAmount ?? 0) -
        (issuerDetails?.stats?.burnedAmount ?? 0);
    final offlineAmount = issuerDetails?.stats?.offlineAmount ?? 0;
    return floatAmount + offlineAmount;
  }

  @override
  String totalAmountString() {
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: totalAmount(),
        precision: asset.precision,
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  double marketCap() {
    return toFloat(totalAmount(), precision: asset.precision) * stats.last;
  }

  @override
  String marketCapString() {
    return marketCap().toStringAsFixed(2);
  }

  @override
  double statsLow() {
    return stats.low;
  }

  @override
  String statsLowString() {
    final value = toIntAmount(stats.low, precision: priceAssetPrecision());
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: value,
        precision: priceAssetPrecision(),
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  double statsHigh() {
    return stats.high;
  }

  @override
  String statsHighString() {
    final value = toIntAmount(stats.high, precision: priceAssetPrecision());
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: value,
        precision: priceAssetPrecision(),
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  double statsLast() {
    return stats.last;
  }

  @override
  String statsLastString() {
    final value = toIntAmount(stats.last, precision: priceAssetPrecision());
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: value,
        precision: priceAssetPrecision(),
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  double statsChangePercent() {
    return stats.changePercent;
  }

  @override
  String statsChangePercentString() {
    return '${statsChangePercent().toStringAsFixed(2)}%';
  }

  @override
  double statsVolume() {
    return stats.volume;
  }

  @override
  String statsVolumeString() {
    final value = toIntAmount(statsVolume(), precision: asset.precision);
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: value,
        precision: asset.precision,
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  String freeFloatString() {
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: floatAmount(),
        precision: asset.precision,
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  String totalFloatString() {
    return amountProvider.amountToString(
      AmountToStringParameters(
        amount: totalAmount(),
        precision: asset.precision,
        trailingZeroes: false,
        useNumberFormatter: true,
      ),
    );
  }

  @override
  set pricedInLiquid(bool value) {
    pricedInLiquid = value;
  }
}

@riverpod
AbstractChartStatsRepository chartStatsRepository(Ref ref, Asset asset) {
  final amountProvider = ref.watch(amountToStringProvider);
  final stats = ref.watch(chartsStatsProvider);
  final pricedInLiquid = ref
      .watch(assetUtilsProvider)
      .isPricedInLiquid(asset: asset);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final priceAssetId = pricedInLiquid ? liquidAssetId : asset.assetId;
  final priceAsset = ref.watch(assetsStateProvider)[priceAssetId];
  final issuerDetails = ref.watch(tokenMarketNotifierProvider)[asset.assetId];

  return ChartStatsRepository(
    asset: asset,
    priceAsset: priceAsset,
    amountProvider: amountProvider,
    issuerDetails: issuerDetails,
    stats: stats,
    pricedInLiquid: pricedInLiquid,
  );
}
