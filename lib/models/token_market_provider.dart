import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/balances_provider.dart';

import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

final tokenMarketProvider = ChangeNotifierProvider<TokenMarketProvider>(
    (ref) => TokenMarketProvider(read: ref.read));

class AssetDetailsStats {
  int issuedAmount;
  int burnedAmount;
  bool hasBlindedIssuances;

  AssetDetailsStats({
    required this.issuedAmount,
    required this.burnedAmount,
    required this.hasBlindedIssuances,
  });

  AssetDetailsStats copyWith({
    int? issuedAmount,
    int? burnedAmount,
    bool? hasBlindedIssuances,
  }) {
    return AssetDetailsStats(
      issuedAmount: issuedAmount ?? this.issuedAmount,
      burnedAmount: burnedAmount ?? this.burnedAmount,
      hasBlindedIssuances: hasBlindedIssuances ?? this.hasBlindedIssuances,
    );
  }

  @override
  String toString() =>
      'AssetDetailsStats(issuedAmount: $issuedAmount, burnedAmount: $burnedAmount, hasBlindedIssuances: $hasBlindedIssuances)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssetDetailsStats &&
        other.issuedAmount == issuedAmount &&
        other.burnedAmount == burnedAmount &&
        other.hasBlindedIssuances == hasBlindedIssuances;
  }

  @override
  int get hashCode =>
      issuedAmount.hashCode ^
      burnedAmount.hashCode ^
      hasBlindedIssuances.hashCode;
}

class AssetDetailsData {
  String assetId;
  AssetDetailsStats? stats;
  AssetDetailsData({
    required this.assetId,
    this.stats,
  });

  AssetDetailsData copyWith({
    String? assetId,
    AssetDetailsStats? stats,
  }) {
    return AssetDetailsData(
      assetId: assetId ?? this.assetId,
      stats: stats ?? this.stats,
    );
  }

  @override
  String toString() => 'AssetDetailsData(assetId: $assetId, stats: $stats)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssetDetailsData &&
        other.assetId == assetId &&
        other.stats == stats;
  }

  @override
  int get hashCode => assetId.hashCode ^ stats.hashCode;
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
  Reader read;

  TokenMarketProvider({
    required this.read,
  });

  final tokenMarketOrders = <RequestOrder>[];
  final assetDetails = <String, AssetDetailsData>{};

  void updateTokenMarketOrders(List<RequestOrder> requestOrders) {
    final newOrders = requestOrders
        .where((e) => !e.private && e.tokenMarket && !e.isExpired())
        .toList();

    tokenMarketOrders.clear();
    tokenMarketOrders.addAll(newOrders);

    notifyListeners();
  }

  bool _isBalanceAvailable(RequestOrder requestOrder) {
    final balanceAmount =
        read(balancesProvider).balances[requestOrder.assetId] ?? 0;
    return balanceAmount >= requestOrder.assetAmount;
  }

  Iterable<TokenMarketDropdownValue> getDropdownValues() {
    final dropdownValues = <TokenMarketDropdownValue>[];
    dropdownValues
        .add(TokenMarketDropdownValue(assetId: '', name: 'All assets'.tr()));

    for (var order in tokenMarketOrders) {
      final value = TokenMarketDropdownValue(
          name: read(walletProvider).assets[order.assetId]?.ticker ?? '',
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
    msg.assetDetails = To_AssetDetails();
    msg.assetDetails.assetId = assetId;
    read(walletProvider).sendMsg(msg);
  }

  void insertAssetDetails(AssetDetailsData assetDetailsData) {
    assetDetails[assetDetailsData.assetId] = assetDetailsData;
    notifyListeners();
  }
}
