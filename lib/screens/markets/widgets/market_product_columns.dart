import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MobileProductColumns extends HookConsumerWidget {
  const MobileProductColumns({super.key, this.onMarketSelected});

  final VoidCallback? onMarketSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final pageStorageKeyData = ref.watch(pageStorageKeyDataProvider);
    final defaultStorageKey = useMemoized(
      () => PageStorageKey(pageStorageKeyData),
    );

    return CustomScrollView(
      controller: scrollController,
      key: defaultStorageKey,
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
              final baseAsset = ref
                  .watch(baseAssetByMarketInfoProvider(marketInfoList[index]))
                  .toNullable();
              final quoteAsset = ref
                  .watch(quoteAssetByMarketInfoProvider(marketInfoList[index]))
                  .toNullable();
              final subscribedAssetPair = ref
                  .watch(marketSubscribedAssetPairNotifierProvider)
                  .toNullable();
              final baseIcon = ref
                  .read(assetImageRepositoryProvider)
                  .getVerySmallImage(baseAsset?.assetId);
              final quoteIcon = ref
                  .read(assetImageRepositoryProvider)
                  .getVerySmallImage(quoteAsset?.assetId);

              return TextButton(
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(0, 20)),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: WidgetStateColor.resolveWith((states) {
                    return switch (states) {
                      Set<WidgetState>()
                          when states.contains(WidgetState.disabled) =>
                        Colors.transparent.withValues(alpha: 0.5),
                      Set<WidgetState>()
                          when states.contains(WidgetState.hovered) =>
                        marketInfoList[index].assetPair == subscribedAssetPair
                            ? SideSwapColors.brightTurquoise
                            : Colors.transparent,
                      Set<WidgetState>()
                          when states.contains(WidgetState.pressed) =>
                        SideSwapColors.brightTurquoise,
                      _ =>
                        marketInfoList[index].assetPair == subscribedAssetPair
                            ? SideSwapColors.brightTurquoise
                            : Colors.transparent,
                    };
                  }),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  ref
                      .read(marketSubscribedAssetPairNotifierProvider.notifier)
                      .setState(marketInfoList[index].assetPair);
                  onMarketSelected?.call();
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 0,
                    top: 8,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      baseIcon,
                      const SizedBox(width: 6),
                      Text(
                        baseAsset?.ticker ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text('/', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      quoteIcon,
                      const SizedBox(width: 6),
                      Text(
                        quoteAsset?.ticker ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
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
