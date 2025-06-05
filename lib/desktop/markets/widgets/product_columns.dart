import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class ProductColumns extends HookConsumerWidget {
  const ProductColumns({this.height, this.onMarketSelected, super.key});

  final VoidCallback? onMarketSelected;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Flexible(
          child: ProductGroup(
            height: height,
            marketType: MarketType_.STABLECOIN,
            onMarketSelected: onMarketSelected,
          ),
        ),
        Flexible(
          child: ProductGroup(
            height: height,
            marketType: MarketType_.AMP,
            onMarketSelected: onMarketSelected,
          ),
        ),
        Flexible(
          child: ProductGroup(
            height: height,
            marketType: MarketType_.TOKEN,
            onMarketSelected: onMarketSelected,
          ),
        ),
      ],
    );
  }
}

class ProductGroup extends HookConsumerWidget {
  const ProductGroup({
    this.height,
    required this.marketType,
    this.onMarketSelected,
    super.key,
  });

  final double? height;
  final MarketType_ marketType;
  final VoidCallback? onMarketSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketInfoList = ref.watch(
      marketInfoByMarketTypeProvider(marketType),
    );
    final marketTypeName = ref.watch(marketTypeNameProvider(marketType));

    final scrollController = useScrollController();
    final pageStorageKeyData = ref.watch(pageStorageKeyDataProvider);

    final defaultStorageKey = useMemoized(
      () => PageStorageKey('$pageStorageKeyData + $marketTypeName'),
    );

    return switch (marketInfoList.isEmpty) {
      true => SizedBox(),
      _ => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: CustomScrollView(
                controller: scrollController,
                key: defaultStorageKey,
                slivers: [
                  SliverPersistentHeader(
                    delegate: ProductGroupHeaderDelegate(title: marketTypeName),
                    pinned: true,
                  ),
                  SliverList.builder(
                    itemBuilder: (context, index) {
                      return ProductItem(
                        marketInfo: marketInfoList[index],
                        onMarketSelected: onMarketSelected,
                      );
                    },
                    itemCount: marketInfoList.length,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    };
  }
}

class ProductItem extends ConsumerWidget {
  final MarketInfo marketInfo;
  final VoidCallback? onMarketSelected;
  const ProductItem({
    this.onMarketSelected,
    required this.marketInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DHoverButton(
      builder: (context, states) {
        return Consumer(
          builder: (context, ref, child) {
            final baseAsset =
                ref
                    .watch(baseAssetByMarketInfoProvider(marketInfo))
                    .toNullable();
            final quoteAsset =
                ref
                    .watch(quoteAssetByMarketInfoProvider(marketInfo))
                    .toNullable();
            final subscribedAssetPair =
                ref
                    .watch(marketSubscribedAssetPairNotifierProvider)
                    .toNullable();
            final baseIcon = ref
                .read(assetImageRepositoryProvider)
                .getVerySmallImage(baseAsset?.assetId);
            final quoteIcon = ref
                .read(assetImageRepositoryProvider)
                .getVerySmallImage(quoteAsset?.assetId);

            return Container(
              padding: const EdgeInsets.only(top: 7, bottom: 7),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color:
                    marketInfo.assetPair == subscribedAssetPair
                        ? SideSwapColors.brightTurquoise
                        : (states.isHovering
                            ? SideSwapColors.chathamsBlue
                            : null),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  baseIcon,
                  const SizedBox(width: 6),
                  Text(
                    '${baseAsset?.ticker ?? ''}  /',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  quoteIcon,
                  const SizedBox(width: 6),
                  Text(
                    quoteAsset?.ticker ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            );
          },
        );
      },
      onPressed: () {
        ref
            .read(marketSubscribedAssetPairNotifierProvider.notifier)
            .setState(marketInfo.assetPair);
        onMarketSelected?.call();
      },
    );
  }
}

class ProductGroupHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  ProductGroupHeaderDelegate({required this.title, this.height = 36});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: SideSwapColors.ataneoBlue,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(height: 1, color: const Color(0xFF3E82A8)),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
