import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

final tokenMarketProvider = ChangeNotifierProvider<TokenMarketProvider>(
    (ref) => TokenMarketProvider(ref));

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

class TokenMarketProvider extends ChangeNotifier {
  final Ref ref;

  TokenMarketProvider(this.ref);

  final tokenMarketOrders = <RequestOrder>[];
  final assetDetails = <String, AssetDetailsData>{};

  void updateTokenMarketOrders(List<RequestOrder> requestOrders) {
    final newOrders = requestOrders
        .where((e) =>
            !e.private && (e.marketType == MarketType.token) && !e.isExpired())
        .toList();

    tokenMarketOrders.clear();
    tokenMarketOrders.addAll(newOrders);

    notifyListeners();
  }

  Iterable<TokenMarketDropdownValue> getDropdownValues() {
    final dropdownValues = <TokenMarketDropdownValue>[];
    dropdownValues
        .add(TokenMarketDropdownValue(assetId: '', name: 'All assets'.tr()));

    for (var order in tokenMarketOrders) {
      final value = TokenMarketDropdownValue(
          name: ref.read(walletProvider).assets[order.assetId]?.ticker ?? '',
          assetId: order.assetId);

      if (!dropdownValues.any((e) => e.assetId == value.assetId)) {
        dropdownValues.add(value);
      }
    }

    return dropdownValues;
  }

  Iterable<RequestOrder> getTokenList(String assetId) {
    if (assetId.isEmpty) {
      return tokenMarketOrders;
    } else {
      return tokenMarketOrders.where((e) => e.assetId == assetId);
    }
  }

  void requestAssetDetails({required String assetId}) {
    final msg = To();
    msg.assetDetails = AssetId();
    msg.assetDetails.assetId = assetId;
    ref.read(walletProvider).sendMsg(msg);
  }

  void insertAssetDetails(AssetDetailsData assetDetailsData) {
    assetDetails[assetDetailsData.assetId] = assetDetailsData;
    notifyListeners();
  }
}
