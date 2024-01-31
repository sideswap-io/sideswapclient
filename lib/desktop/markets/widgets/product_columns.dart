import 'package:flutter/material.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/markets/widgets/asset_selector.dart';

class ProductColumns extends StatelessWidget {
  const ProductColumns({
    super.key,
    this.onAssetSelected,
  });

  final VoidCallback? onAssetSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: AssetSelector(
              marketType: MarketType.stablecoin,
              onAssetSelected: onAssetSelected,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: AssetSelector(
              marketType: MarketType.amp,
              onAssetSelected: onAssetSelected,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
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
