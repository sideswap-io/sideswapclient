import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/swap_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/market_charts_popup.dart';
import 'package:sideswap/screens/markets/market_select_popup.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';

class SwapMarket extends ConsumerStatefulWidget {
  const SwapMarket({super.key});

  @override
  SwapMarketState createState() => SwapMarketState();
}

class SwapMarketState extends ConsumerState<SwapMarket> {
  ScrollController scrollController = ScrollController();

  final headerStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: SideSwapColors.brightTurquoise,
  );

  final indexPriceStyleDescription = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  void afterBuild(BuildContext context) async {
    subscribeToMarket();
  }

  void subscribeToMarket() {
    final swapMarketCurrentProduct = ref.read(swapMarketCurrentProductProvider);

    ref
        .read(marketsProvider)
        .subscribeIndexPrice(swapMarketCurrentProduct.accountAsset.assetId);
    ref
        .read(marketsProvider)
        .subscribeSwapMarket(swapMarketCurrentProduct.accountAsset.assetId);
  }

  void openOrder(RequestOrder order) async {
    if (order.own && order.twoStep) {
      ref.read(walletProvider).setOrderRequestView(order);
      return;
    }

    if (order.own) {
      await ref.read(marketsProvider).onModifyPrice(ref, order);
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

    // TODO: mockups points here to SwapMarketOrderDetails
    // but that screen display wrong side data
    // consider how to back from Status.orderPopup
    // to markets page
  }

  void showProductsPopup() {
    Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(builder: (context) {
        return MarketSelectPopup(
          onAssetSelected: () {
            subscribeToMarket();
          },
        );
      }),
    );
  }

  void showChartsPopup() {
    Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final swapMarketCurrentProduct =
                ref.watch(swapMarketCurrentProductProvider);
            return MarketChartsPopup(
              assetId: swapMarketCurrentProduct.accountAsset.assetId,
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final swapMarketCurrentProduct =
          ref.watch(swapMarketCurrentProductProvider);

      final asset = ref.watch(assetsStateProvider.select(
          (value) => value[swapMarketCurrentProduct.accountAsset.assetId]));
      final assetPrecision = ref
          .watch(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: asset?.assetId);
      final length = ref.watch(maxSwapOrderLengthProvider);
      final bidOffers = ref.watch(swapMarketBidOffersProvider);
      final askOffers = ref.watch(swapMarketAskOffersProvider);

      final indexPrice = ref
          .watch(indexPriceForAssetProvider(
              swapMarketCurrentProduct.accountAsset.assetId))
          .getIndexPriceStr();
      final lastPrice = ref.watch(lastStringIndexPriceForAssetProvider(
          swapMarketCurrentProduct.accountAsset.assetId));

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 12,
                  child: GestureDetector(
                    onTap: showProductsPopup,
                    child: ColoredContainer(
                      height: 54.0,
                      backgroundColor: SideSwapColors.chathamsBlue,
                      borderColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Product'.tr(),
                            style: headerStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                swapMarketCurrentProduct.displayName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SvgPicture.asset(
                                'assets/arrow_down.svg',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 11,
                  child: ColoredContainer(
                    backgroundColor: SideSwapColors.chathamsBlue,
                    borderColor: Colors.transparent,
                    height: 54.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          asset?.swapMarket == true
                              ? 'Index price'.tr()
                              : 'Last price'.tr(),
                          style: headerStyle,
                        ),
                        Text(
                          asset?.swapMarket == true ? indexPrice : lastPrice,
                          style: indexPriceStyleDescription,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: showChartsPopup,
                    child: ColoredContainer(
                      height: 54.0,
                      backgroundColor: SideSwapColors.chathamsBlue,
                      borderColor: Colors.transparent,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/chart.svg',
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Chart'.tr(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Divider(
              thickness: 1,
              height: 1,
              color: SideSwapColors.jellyBean,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 14, right: 14),
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
          ),
          Expanded(
            child: RawScrollbar(
              thumbVisibility: true,
              thickness: 3,
              radius: const Radius.circular(2),
              controller: scrollController,
              thumbColor: SideSwapColors.ceruleanFrost,
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (index < bidOffers.length) ...[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6, right: 3),
                            child: SwapAmountRow(
                              assetPrecision: assetPrecision,
                              requestOrder: bidOffers[index],
                              onTap: openOrder,
                            ),
                          ),
                        ),
                      ] else ...[
                        const Spacer(),
                      ],
                      if (index < askOffers.length) ...[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3, right: 6),
                            child: SwapAmountRow(
                              assetPrecision: assetPrecision,
                              requestOrder: askOffers[index],
                              type: SwapAmountRowType.ask,
                              onTap: openOrder,
                            ),
                          ),
                        ),
                      ] else ...[
                        const Spacer(),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
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
