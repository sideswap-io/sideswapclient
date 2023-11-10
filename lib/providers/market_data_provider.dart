import 'dart:math';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

final marketDataProvider = ChangeNotifierProvider<MarketDataNotifier>((ref) {
  return MarketDataNotifier(ref);
});

class Stats {
  double low = 0;
  double high = 0;
  double last = 0;
  double changePercent = 0;
  double volume = 0;
}

Candle convertPoint(ChartPoint point) {
  return Candle(
    date: DateTime.parse(point.time),
    close: point.close,
    high: point.high,
    low: point.low,
    open: point.open,
    volume: point.volume,
  );
}

class MarketDataNotifier with ChangeNotifier {
  final Ref ref;

  MarketDataNotifier(this.ref);

  String? marketDataAssetId;
  var marketData = <Candle>[];

  void marketDataSubscribe(String assetId) {
    marketDataUnsubscribe();

    final msg = To();
    msg.marketDataSubscribe = To_MarketDataSubscribe();
    msg.marketDataSubscribe.assetId = assetId;
    ref.read(walletProvider).sendMsg(msg);

    marketDataAssetId = assetId;
    notifyListeners();
  }

  void marketDataUnsubscribe() {
    if (marketDataAssetId != null) {
      final msg = To();
      msg.marketDataUnsubscribe = Empty();
      ref.read(walletProvider).sendMsg(msg);

      marketDataAssetId = null;
      marketData.clear();
      notifyListeners();
    }
  }

  void marketDataResponse(From_MarketDataSubscribe msg) {
    if (msg.assetId == marketDataAssetId) {
      // Candlesticks wants the newest points at 0, reverse response here
      marketData = msg.data.reversed.map(convertPoint).toList();
      notifyListeners();
    }
  }

  void marketDataUpdate(From_MarketDataUpdate msg) {
    if (msg.assetId == marketDataAssetId) {
      final newPoint = convertPoint(msg.update);
      marketData.removeWhere((e) => e.date == newPoint.date);
      // Only last point updates normally
      // Candlesticks wants the newest points at 0
      marketData.insert(0, newPoint);
      notifyListeners();
    }
  }

  Stats getStats() {
    if (marketDataAssetId == null || marketData.isEmpty) {
      return Stats();
    }

    final assetPrecision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: marketDataAssetId);

    final stats = Stats();
    stats.last = marketData.first.close;
    stats.low = double.infinity;
    stats.high = -double.infinity;
    double oldest = 0;
    int volume = 0;
    for (final point in marketData.take(30)) {
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
