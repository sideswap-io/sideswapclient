import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/swap_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/markets/market_charts_popup.dart';
import 'package:sideswap/screens/markets/market_select_popup.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';

class SwapMarket extends HookConsumerWidget {
  const SwapMarket({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapMarketCurrentProduct =
        ref.watch(swapMarketCurrentProductProvider);
    final stokrLastSelectedAccountAsset =
        ref.watch(stokrLastSelectedAccountAssetNotifierProvider);
    final callbackHandlers = ref.watch(orderEntryCallbackHandlersProvider);

    useEffect(() {
      if (swapMarketCurrentProduct.accountAsset !=
          stokrLastSelectedAccountAsset) {
        Future.microtask(() {
          callbackHandlers.stokrAssetRestrictedPopup();
          ref
              .read(stokrLastSelectedAccountAssetNotifierProvider.notifier)
              .setLastSelectedAccountAsset(
                  swapMarketCurrentProduct.accountAsset);
        });
      }

      return;
    }, [swapMarketCurrentProduct]);
    return const Column(
      children: [
        SwapMarketTopPanel(),
        SwapMarketBidOfferHeader(),
        Expanded(child: SwapMarketBidOfferList()),
      ],
    );
  }
}

class SwapMarketBidOfferList extends HookConsumerWidget {
  const SwapMarketBidOfferList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = ref.watch(maxSwapOrderLengthProvider);
    final bids = ref.watch(ordersPanelBidsProvider);
    final asks = ref.watch(ordersPanelAsksProvider);

    final swapMarketCurrentProduct =
        ref.watch(swapMarketCurrentProductProvider);

    final asset = ref.watch(assetsStateProvider.select(
        (value) => value[swapMarketCurrentProduct.accountAsset.assetId]));
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);

    final openOrderCallback = useCallback((RequestOrder order) async {
      if (order.own && order.twoStep) {
        ref.read(walletProvider).setOrderRequestView(order);
        return;
      }

      if (order.own) {
        await ref.read(marketsHelperProvider).onModifyPrice(ref, order);
        return;
      }

      final callbackHandler = ref.read(orderEntryCallbackHandlersProvider);

      if (!callbackHandler.stokrConditionsMet()) {
        return;
      }

      if (order.marketType != MarketType.token) {
        ref.read(walletProvider).linkOrder(order.orderId);
        return;
      }

      Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute(
          builder: (context) => TokenMarketOrderDetails(
            requestOrder: order,
          ),
        ),
      );
    }, []);

    return ListView.builder(
      itemCount: length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (index < bids.length) ...[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 3),
                  child: SwapAmountRow(
                    assetPrecision: assetPrecision,
                    requestOrder: bids[index],
                    onTap: openOrderCallback,
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
            ],
            if (index < asks.length) ...[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3, right: 6),
                  child: SwapAmountRow(
                    assetPrecision: assetPrecision,
                    requestOrder: asks[index],
                    type: SwapAmountRowType.ask,
                    onTap: openOrderCallback,
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
            ],
          ],
        );
      },
    );
  }
}

class SwapMarketBidOfferHeader extends StatelessWidget {
  const SwapMarketBidOfferHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.ceruleanFrost,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 15, left: 14, right: 14),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount'.tr(),
                  style: headerStyle,
                ),
                Text(
                  'Bid'.tr(),
                  style: headerStyle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Offer'.tr(),
                  style: headerStyle,
                ),
                Text(
                  'Amount'.tr(),
                  style: headerStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwapMarketTopPanel extends StatelessWidget {
  const SwapMarketTopPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
        color: SideSwapColors.chathamsBlue,
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      child: const Row(
        children: [
          SwapMarketAssetPairButton(),
          Spacer(),
          SwapMarketFilterButton(),
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
            colorFilter: const ColorFilter.mode(
                SideSwapColors.brightTurquoise, BlendMode.srcIn),
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
    final swapMarketCurrentProduct =
        ref.watch(swapMarketCurrentProductProvider);

    final showChartsPopupCallback = useCallback(() {
      Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute(builder: (context) {
          return MarketChartsPopup(
            assetId: swapMarketCurrentProduct.accountAsset.assetId,
          );
        }),
      );
    }, [swapMarketCurrentProduct]);

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
            colorFilter: const ColorFilter.mode(
                SideSwapColors.brightTurquoise, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class SwapMarketFilterButton extends ConsumerWidget {
  const SwapMarketFilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomBigButton(
      width: 34,
      height: 34,
      backgroundColor: SideSwapColors.chathamsBlue,
      onPressed: () {
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.orderFilers);
      },
      child: SizedBox(
        width: 34,
        height: 34,
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/filter2.svg',
                colorFilter: const ColorFilter.mode(
                    SideSwapColors.brightTurquoise, BlendMode.srcIn),
              ),
            ),
            const Align(
                alignment: Alignment.bottomRight,
                child: SwapMarketFilterButtonBadge()),
          ],
        ),
      ),
    );
  }
}

class SwapMarketFilterButtonBadge extends ConsumerWidget {
  const SwapMarketFilterButtonBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterBadgeCounter = ref.watch(ordersPanelFilterBadgeCounterProvider);

    return switch (filterBadgeCounter) {
      1 => Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: SideSwapColors.chathamsBlue,
              width: 1,
            ),
            color: SideSwapColors.brightTurquoise,
          ),
          child: Center(
            child: Text(
              '$filterBadgeCounter',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: SideSwapColors.chathamsBlue,
                  ),
            ),
          ),
        ),
      _ => const SizedBox(),
    };
  }
}

class SwapMarketAssetPairButton extends HookConsumerWidget {
  const SwapMarketAssetPairButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapMarketCurrentProduct =
        ref.watch(swapMarketCurrentProductProvider);

    final showProductPopupCallback = useCallback(() {
      Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute(builder: (context) {
          return const MarketSelectPopup();
        }),
      );
    }, const []);

    final asset = ref.watch(
        assetsStateProvider)[swapMarketCurrentProduct.accountAsset.assetId];
    final indexPrice = ref
        .watch(indexPriceForAssetProvider(
            swapMarketCurrentProduct.accountAsset.assetId))
        .indexPrice;
    final lastPrice = ref.watch(lastIndexPriceForAssetProvider(
        swapMarketCurrentProduct.accountAsset.assetId));
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
    final indexPriceStr = priceStr(indexPrice, pricedInLiquid);
    final lastPriceStr = priceStr(lastPrice, pricedInLiquid);
    final icon = ref
        .watch(assetImageProvider)
        .getVerySmallImage(swapMarketCurrentProduct.accountAsset.assetId);

    return CustomBigButton(
      width: 245,
      height: 56,
      backgroundColor: SideSwapColors.blueSapphire,
      onPressed: () {
        showProductPopupCallback();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 16),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  swapMarketCurrentProduct.displayName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      indexPrice != 0 ? indexPriceStr : lastPriceStr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    icon,
                    const SizedBox(width: 5),
                    Text(
                      asset?.ticker ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/arrow_down.svg',
              colorFilter: const ColorFilter.mode(
                  SideSwapColors.brightTurquoise, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}

enum SwapAmountRowType {
  bid,
  ask,
}

class SwapAmountRow extends HookConsumerWidget {
  const SwapAmountRow({
    super.key,
    required this.requestOrder,
    required this.assetPrecision,
    this.type = SwapAmountRowType.bid,
    this.onTap,
  });

  final RequestOrder requestOrder;
  final SwapAmountRowType type;
  final int assetPrecision;
  final Function(RequestOrder)? onTap;

  final amountStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountProvider = ref.watch(amountToStringProvider);
    final bitcoinAmountStr = amountProvider.amountToString(
        AmountToStringParameters(amount: requestOrder.bitcoinAmount));
    final assetAmountStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: requestOrder.assetAmount, precision: assetPrecision));
    final amountString = requestOrder.marketType == MarketType.stablecoin
        ? bitcoinAmountStr
        : assetAmountStr;

    final price =
        priceStrForMarket(requestOrder.price, requestOrder.marketType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: CustomPaint(
        painter: SwapAmountRowBackground(
          type: type,
          radius: const Radius.circular(4),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!(requestOrder);
              }
            },
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: Stack(
              children: [
                if (requestOrder.own) ...[
                  Positioned(
                    right: 5,
                    top: 3,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SideSwapColors.turquoise,
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  child: Builder(builder: (context) {
                    var children = [
                      Text(
                        amountString,
                        style: amountStyle,
                      ),
                      Text(
                        price,
                        style: amountStyle.copyWith(
                          color: type == SwapAmountRowType.bid
                              ? SideSwapColors.turquoise
                              : SideSwapColors.bitterSweet,
                        ),
                      ),
                    ];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: type == SwapAmountRowType.bid
                          ? children
                          : children.reversed.toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SwapAmountRowBackground extends CustomPainter {
  final SwapAmountRowType type;
  final Radius radius;

  SwapAmountRowBackground({
    this.type = SwapAmountRowType.bid,
    this.radius = const Radius.circular(0),
  });

  late Color expireColor = type == SwapAmountRowType.bid
      ? SideSwapColors.turquoise
      : SideSwapColors.bitterSweet;
  Color backgroundColor = SideSwapColors.chathamsBlue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    var expirePaint = Paint()..color = expireColor.withOpacity(0.14);
    if (type == SwapAmountRowType.ask) {
      expirePaint = Paint()..color = expireColor.withOpacity(0.14);
    }
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), expirePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
