import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class AssetDetailsStats {
  int issuedAmount;
  int burnedAmount;
  int offlineAmount;
  bool hasBlindedIssuances;

  AssetDetailsStats({
    required this.issuedAmount,
    required this.burnedAmount,
    required this.offlineAmount,
    required this.hasBlindedIssuances,
  });
}

class AssetChartStats {
  double low;
  double high;
  double last;

  AssetChartStats({
    required this.low,
    required this.high,
    required this.last,
  });
}

class AssetDetailsData {
  String assetId;
  AssetDetailsStats? stats;
  String? chartUrl;
  AssetChartStats? chartStats;
  AssetDetailsData({
    required this.assetId,
    this.stats,
    this.chartUrl,
    this.chartStats,
  });
}

class TokenMarketDropdownValue {
  String name;
  String assetId;
  TokenMarketDropdownValue({
    required this.name,
    required this.assetId,
  });

  TokenMarketDropdownValue copyWith({
    String? name,
    String? assetId,
  }) {
    return TokenMarketDropdownValue(
      name: name ?? this.name,
      assetId: assetId ?? this.assetId,
    );
  }

  @override
  String toString() =>
      'TokenMarketDropdownValues(name: $name, assetId: $assetId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenMarketDropdownValue &&
        other.name == name &&
        other.assetId == assetId;
  }

  @override
  int get hashCode => name.hashCode ^ assetId.hashCode;
}

final tokenMarketProvider =
    AutoDisposeProvider<TokenMarketProvider>((ref) => TokenMarketProvider(ref));

class TokenMarketProvider extends ChangeNotifier {
  final Ref ref;

  TokenMarketProvider(this.ref);

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

final tokenMarketAssetDetailsProvider = AutoDisposeNotifierProvider<
    TokenMarketAssetDetailsProvider,
    Map<String, AssetDetailsData>>(TokenMarketAssetDetailsProvider.new);

class TokenMarketAssetDetailsProvider
    extends AutoDisposeNotifier<Map<String, AssetDetailsData>> {
  @override
  Map<String, AssetDetailsData> build() {
    ref.keepAlive();
    return {};
  }

  void insertAssetDetails(AssetDetailsData assetDetailsData) {
    final tokenMarketAssetDetails = {...state};
    tokenMarketAssetDetails[assetDetailsData.assetId] = assetDetailsData;
    state = tokenMarketAssetDetails;
  }
}
