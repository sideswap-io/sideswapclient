import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class ProductColumns extends StatelessWidget {
  const ProductColumns({super.key, this.onMarketSelected});

  final VoidCallback? onMarketSelected;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: ProductSliverGroup(
            marketType: MarketType_.STABLECOIN,
            onMarketSelected: onMarketSelected,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: ProductSliverGroup(
            marketType: MarketType_.AMP,
            onMarketSelected: onMarketSelected,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: ProductSliverGroup(
            marketType: MarketType_.TOKEN,
            onMarketSelected: onMarketSelected,
          ),
        ),
      ],
    );
  }
}

class ProductSliverGroup extends ConsumerWidget {
  const ProductSliverGroup({
    required this.marketType,
    this.onMarketSelected,
    super.key,
  });

  final MarketType_ marketType;
  final VoidCallback? onMarketSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketInfoList = ref.watch(
      marketInfoByMarketTypeProvider(marketType),
    );
    final marketTypeName = ref.watch(marketTypeNameProvider(marketType));

    return switch (marketInfoList.isEmpty) {
      true => SliverToBoxAdapter(child: SizedBox()),
      _ => SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              marketTypeName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(height: 1, color: const Color(0xFF3E82A8)),
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              return DHoverButton(
                builder: (context, states) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final baseAsset =
                          ref
                              .watch(
                                baseAssetByMarketInfoProvider(
                                  marketInfoList[index],
                                ),
                              )
                              .toNullable();
                      final quoteAsset =
                          ref
                              .watch(
                                quoteAssetByMarketInfoProvider(
                                  marketInfoList[index],
                                ),
                              )
                              .toNullable();
                      final subscribedAssetPair =
                          ref
                              .watch(marketSubscribedAssetPairNotifierProvider)
                              .toNullable();

                      return Container(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 0,
                          top: 7,
                          bottom: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color:
                              marketInfoList[index].assetPair ==
                                      subscribedAssetPair
                                  ? SideSwapColors.brightTurquoise
                                  : (states.isHovering
                                      ? SideSwapColors.chathamsBlue
                                      : null),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${baseAsset?.ticker ?? ''} / ${quoteAsset?.ticker ?? ''}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                onPressed: () {
                  ref
                      .read(marketSubscribedAssetPairNotifierProvider.notifier)
                      .setState(marketInfoList[index].assetPair);
                  onMarketSelected?.call();
                },
              );
            },
            itemCount: marketInfoList.length,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    };
  }
}
