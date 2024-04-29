import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

enum MarketType {
  stablecoin,
  amp,
  token,
}

const sellColor = SideSwapColors.bitterSweet;
const buyColor = SideSwapColors.turquoise;

String marketTypeName(MarketType type) {
  return switch (type) {
    MarketType.stablecoin => 'Stablecoins'.tr(),
    MarketType.amp => 'AMP Listings'.tr(),
    MarketType.token => 'Token Market'.tr(),
  };
}

MarketType assetMarketType(Asset? asset) {
  return switch (asset) {
    final asset? when asset.swapMarket => MarketType.stablecoin,
    final asset? when asset.ampMarket => MarketType.amp,
    final asset? when !asset.unregistered => MarketType.token,
    // if asset is null assume that is stablecoin
    _ => MarketType.stablecoin,
  };
}

int Function(RequestOrder a, RequestOrder b) compareRequestOrder(int sign) {
  return ((a, b) => sign * a.price.compareTo(b.price));
}
