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
  switch (type) {
    case MarketType.stablecoin:
      return 'Stablecoins'.tr();
    case MarketType.amp:
      return 'AMP Listings'.tr();
    case MarketType.token:
      return 'Token Market'.tr();
  }
}

MarketType assetMarketType(Asset? asset) {
  return switch (asset) {
    final asset? => () {
        if (asset.swapMarket == true) {
          return MarketType.stablecoin;
        }
        if (asset.ampMarket == true) {
          return MarketType.amp;
        }
        if (asset.unregistered == false) {
          return MarketType.token;
        }
        return MarketType.stablecoin;
      }(),
    // if asset is null assume that is stablecoin
    _ => MarketType.stablecoin,
  };
}

int Function(RequestOrder a, RequestOrder b) compareRequestOrder(int sign) {
  return ((a, b) => sign * a.price.compareTo(b.price));
}
