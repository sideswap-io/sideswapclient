import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/markets/widgets/orders_view.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/market_charts_popup.dart';
import 'package:sideswap/screens/markets/market_select_popup.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class SwapMarket extends HookConsumerWidget {
  const SwapMarket({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SwapMarketTopPanel(),
        SwapMarketBidOfferHeader(),
        Flexible(child: OrdersScrollView()),
      ],
    );
  }
}

class SwapMarketBidOfferHeader extends StatelessWidget {
  const SwapMarketBidOfferHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.ceruleanFrost,
    );

    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 15, left: 14, right: 14),
      child: Row(
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount'.tr(), style: headerStyle),
                Text('Bid'.tr(), style: headerStyle),
              ],
            ),
          ),
          SizedBox(width: 11),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Offer'.tr(), style: headerStyle),
                Text('Amount'.tr(), style: headerStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwapMarketTopPanel extends StatelessWidget {
  const SwapMarketTopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: SideSwapColors.chathamsBlue,
      ),
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      child: Row(
        children: [
          SwapMarketAssetPairButton(),
          Spacer(),
          SizedBox(width: 8),
          SwapMarketChartButton(),
        ],
      ),
    );
  }
}

class SwapMarketInfoButton extends StatelessWidget {
  const SwapMarketInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      width: 32,
      height: 32,
      backgroundColor: SideSwapColors.chathamsBlue,
      onPressed: () {},
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: SvgPicture.asset(
            'assets/info_circular.svg',
            colorFilter: ColorFilter.mode(
              SideSwapColors.brightTurquoise,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class SwapMarketChartButton extends HookConsumerWidget {
  const SwapMarketChartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showChartsPopupCallback = useCallback(() {
      Future.microtask(() {
        ref.read(chartsSubscriptionFlagNotifierProvider.notifier).subscribe();
      });
      Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute(
          builder: (context) {
            return MarketChartsPopup();
          },
        ),
      );
    });

    return CustomBigButton(
      width: 34,
      height: 34,
      backgroundColor: SideSwapColors.chathamsBlue,
      onPressed: () {
        showChartsPopupCallback();
      },
      child: SizedBox(
        width: 34,
        height: 34,
        child: Center(
          child: SvgPicture.asset(
            'assets/chart2.svg',
            colorFilter: ColorFilter.mode(
              SideSwapColors.brightTurquoise,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class SwapMarketAssetPairButton extends HookConsumerWidget {
  const SwapMarketAssetPairButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketInfo = ref.watch(subscribedMarketInfoProvider);

    return marketInfo.match(() => SizedBox(), (marketInfo) {
      final indexPrice = ref.watch(marketIndexPriceProvider);
      final lastPrice = ref.watch(marketLastPriceProvider);
      final productName = ref.watch(subscribedMarketProductNameProvider);

      final showProductPopupCallback = useCallback(() {
        Navigator.of(context, rootNavigator: true).push<void>(
          MaterialPageRoute(
            builder: (context) {
              return MarketSelectPopup();
            },
          ),
        );
      }, const []);

      return CustomBigButton(
        width: 245,
        height: 56,
        backgroundColor: SideSwapColors.blueSapphire,
        onPressed: () {
          showProductPopupCallback();
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 16),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  indexPrice.match(
                    () => lastPrice.match(
                      () => SizedBox(),
                      (value) => SwapMarketIndexPriceRow(
                        price: value.lastPrice,
                        optionAsset: value.quoteAsset,
                      ),
                    ),
                    (value) => SwapMarketIndexPriceRow(
                      price: value.indexPrice,
                      optionAsset: value.quoteAsset,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SvgPicture.asset(
                'assets/arrow_down.svg',
                colorFilter: ColorFilter.mode(
                  SideSwapColors.brightTurquoise,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SwapMarketIndexPriceRow extends ConsumerWidget {
  const SwapMarketIndexPriceRow({
    required this.price,
    required this.optionAsset,
    super.key,
  });

  final String price;
  final Option<Asset> optionAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          price,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
        ),
        SizedBox(width: 8),
        optionAsset.match(() => SizedBox(), (asset) {
          final icon = ref
              .watch(assetImageRepositoryProvider)
              .getVerySmallImage(asset.assetId);
          return icon;
        }),
        SizedBox(width: 5),
        optionAsset.match(() => SizedBox(), (asset) {
          return Text(
            asset.ticker,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: 14),
          );
        }),
      ],
    );
  }
}
