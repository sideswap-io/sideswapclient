import 'package:flutter/material.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/markets/widgets/asset_selector.dart';

class ProductColumns extends StatelessWidget {
  const ProductColumns({
    Key? key,
    this.onAssetSelected,
  }) : super(key: key);

  final VoidCallback? onAssetSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AssetSelector(
              marketType: MarketType.stablecoin,
              onAssetSelected: onAssetSelected,
            ),
          ),
          Expanded(
            child: AssetSelector(
              marketType: MarketType.amp,
              onAssetSelected: onAssetSelected,
            ),
          ),
          Expanded(
            child: AssetSelector(
              marketType: MarketType.token,
              onAssetSelected: onAssetSelected,
            ),
          ),
        ],
      ),
    );
  }
}
