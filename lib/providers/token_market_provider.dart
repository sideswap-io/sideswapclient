import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'token_market_provider.g.dart';

class AssetDetailsStats {
  final int issuedAmount;
  final int burnedAmount;
  final int offlineAmount;
  final bool hasBlindedIssuances;

  AssetDetailsStats({
    required this.issuedAmount,
    required this.burnedAmount,
    required this.offlineAmount,
    required this.hasBlindedIssuances,
  });

  AssetDetailsStats copyWith({
    int? issuedAmount,
    int? burnedAmount,
    int? offlineAmount,
    bool? hasBlindedIssuances,
  }) {
    return AssetDetailsStats(
      issuedAmount: issuedAmount ?? this.issuedAmount,
      burnedAmount: burnedAmount ?? this.burnedAmount,
      offlineAmount: offlineAmount ?? this.offlineAmount,
      hasBlindedIssuances: hasBlindedIssuances ?? this.hasBlindedIssuances,
    );
  }

  @override
  String toString() {
    return 'AssetDetailsStats(issuedAmount: $issuedAmount, burnedAmount: $burnedAmount, offlineAmount: $offlineAmount, hasBlindedIssuances: $hasBlindedIssuances)';
  }

  @override
  bool operator ==(covariant AssetDetailsStats other) {
    if (identical(this, other)) return true;

    return other.issuedAmount == issuedAmount &&
        other.burnedAmount == burnedAmount &&
        other.offlineAmount == offlineAmount &&
        other.hasBlindedIssuances == hasBlindedIssuances;
  }

  @override
  int get hashCode {
    return issuedAmount.hashCode ^
        burnedAmount.hashCode ^
        offlineAmount.hashCode ^
        hasBlindedIssuances.hashCode;
  }
}

class AssetChartStats {
  final double low;
  final double high;
  final double last;

  AssetChartStats({required this.low, required this.high, required this.last});

  AssetChartStats copyWith({double? low, double? high, double? last}) {
    return AssetChartStats(
      low: low ?? this.low,
      high: high ?? this.high,
      last: last ?? this.last,
    );
  }

  @override
  String toString() => 'AssetChartStats(low: $low, high: $high, last: $last)';

  @override
  bool operator ==(covariant AssetChartStats other) {
    if (identical(this, other)) return true;

    return other.low == low && other.high == high && other.last == last;
  }

  @override
  int get hashCode => low.hashCode ^ high.hashCode ^ last.hashCode;
}

class AssetDetailsData {
  final String assetId;
  final AssetDetailsStats? stats;
  final String? chartUrl;
  final AssetChartStats? chartStats;

  AssetDetailsData({
    required this.assetId,
    this.stats,
    this.chartUrl,
    this.chartStats,
  });

  AssetDetailsData copyWith({
    String? assetId,
    AssetDetailsStats? stats,
    String? chartUrl,
    AssetChartStats? chartStats,
  }) {
    return AssetDetailsData(
      assetId: assetId ?? this.assetId,
      stats: stats ?? this.stats,
      chartUrl: chartUrl ?? this.chartUrl,
      chartStats: chartStats ?? this.chartStats,
    );
  }

  @override
  String toString() {
    return 'AssetDetailsData(assetId: $assetId, stats: $stats, chartUrl: $chartUrl, chartStats: $chartStats)';
  }

  @override
  bool operator ==(covariant AssetDetailsData other) {
    if (identical(this, other)) return true;

    return other.assetId == assetId &&
        other.stats == stats &&
        other.chartUrl == chartUrl &&
        other.chartStats == chartStats;
  }

  @override
  int get hashCode {
    return assetId.hashCode ^
        stats.hashCode ^
        chartUrl.hashCode ^
        chartStats.hashCode;
  }
}

class TokenMarketDropdownValue {
  final String name;
  final String assetId;

  TokenMarketDropdownValue({required this.name, required this.assetId});

  TokenMarketDropdownValue copyWith({String? name, String? assetId}) {
    return TokenMarketDropdownValue(
      name: name ?? this.name,
      assetId: assetId ?? this.assetId,
    );
  }

  @override
  String toString() =>
      'TokenMarketDropdownValue(name: $name, assetId: $assetId)';

  @override
  bool operator ==(covariant TokenMarketDropdownValue other) {
    if (identical(this, other)) return true;

    return other.name == name && other.assetId == assetId;
  }

  @override
  int get hashCode => name.hashCode ^ assetId.hashCode;
}

@Riverpod(keepAlive: true)
class TokenMarketNotifier extends _$TokenMarketNotifier {
  @override
  Map<String, AssetDetailsData> build() {
    return {};
  }

  void insertAssetDetails(AssetDetailsData assetDetailsData) {
    final tokenMarketAssetDetails = {...state};
    tokenMarketAssetDetails[assetDetailsData.assetId] = assetDetailsData;
    state = tokenMarketAssetDetails;
  }

  void requestAssetDetails({required String? assetId}) {
    if (assetId == null) {
      logger.w("Asset id is null!");
      return;
    }

    final msg = To();
    msg.assetDetails = AssetId();
    msg.assetDetails.assetId = assetId;
    ref.read(walletProvider).sendMsg(msg);
  }
}
