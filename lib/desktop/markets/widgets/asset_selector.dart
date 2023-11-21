import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/asset_selector_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class AssetSelector extends ConsumerWidget {
  const AssetSelector({
    super.key,
    required this.marketType,
    this.onAssetSelected,
  });

  final MarketType marketType;
  final VoidCallback? onAssetSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          marketTypeName(marketType),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            height: 1,
            color: const Color(0xFF3E82A8),
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final assets =
                  ref.watch(assetSelectorProvider(marketType)).toList();
              return ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      DHoverButton(
                        builder: (context, states) {
                          return Consumer(
                            builder: (context, ref, child) {
                              final selectedAccountAsset = ref.watch(
                                  marketSelectedAccountAssetStateProvider);
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  color: assets[index].assetId ==
                                          selectedAccountAsset.assetId
                                      ? Colors.grey
                                      : (states.isHovering
                                          ? const Color(0xFF12577A)
                                          : null),
                                ),
                                child: Row(
                                  children: [
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final icon = ref
                                            .watch(assetImageProvider)
                                            .getSmallImage(
                                                assets[index].assetId);

                                        return SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: icon,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      assets[index].ticker,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        onPressed: () {
                          ref
                              .read(marketSelectedAccountAssetStateProvider
                                  .notifier)
                              .setSelectedAccountAsset(
                                AccountAsset(
                                    marketType == MarketType.amp
                                        ? AccountType.amp
                                        : AccountType.reg,
                                    assets[index].assetId),
                              );
                          if (onAssetSelected != null) {
                            onAssetSelected!.call();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
