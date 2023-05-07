import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/providers/asset_selector_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

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
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 24),
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
                          return Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final selectedAssetId =
                                    ref.watch(marketSelectedAssetIdProvider);

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color:
                                        assets[index].assetId == selectedAssetId
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
                            ),
                          );
                        },
                        onPressed: () {
                          ref
                              .read(marketSelectedAssetIdProvider.notifier)
                              .state = assets[index].assetId;
                          if (onAssetSelected != null) {
                            onAssetSelected!();
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
