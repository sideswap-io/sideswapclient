import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/swap_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/market_charts_popup.dart';
import 'package:sideswap/screens/markets/market_select_popup.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

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
    color: Color(0xFF00C5FF),
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
    final marketAssetId = ref.read(swapMarketProvider).currentProduct.assetId;

    ref.read(marketsProvider).subscribeIndexPrice(marketAssetId);
    ref.read(marketsProvider).subscribeSwapMarket(marketAssetId);
  }

  void openOrder(RequestOrder order) async {
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
          selectedAssetId: ref.read(swapMarketProvider).currentProduct.assetId,
          onAssetSelected: (assetId) {
            final swapMarket = ref.read(swapMarketProvider);
            final product = swapMarket.getProductFromAssetId(assetId);
            swapMarket.currentProduct = product;
            subscribeToMarket();
          },
        );
      }),
    );
  }

  void showChartsPopup() {
    Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(builder: (context) {
        return MarketChartsPopup(
          assetId: ref.read(swapMarketProvider).currentProduct.assetId,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final swapMarket = ref.watch(swapMarketProvider);
      final wallet = ref.read(walletProvider);
      final markets = ref.watch(marketsProvider);

      final currentProduct = swapMarket.currentProduct;
      final asset = wallet.assets[currentProduct.assetId]!;
      final indexPrice = markets.getIndexPriceStr(currentProduct.assetId);
      final lastPrice = markets.getLastPriceStr(currentProduct.assetId);
      final length = swapMarket.getMaxSwapOrderLength();
      final bidOffers = swapMarket.bidOffers;
      final askOffers = swapMarket.askOffers;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: GestureDetector(
                    onTap: showProductsPopup,
                    child: ColoredContainer(
                      height: 50.0,
                      backgroundColor: const Color(0xFF135579),
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
                                currentProduct.displayName,
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
                  flex: 10,
                  child: ColoredContainer(
                    backgroundColor: const Color(0xFF135579),
                    borderColor: Colors.transparent,
                    height: 50.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          asset.swapMarket
                              ? 'Index price'.tr()
                              : 'Last price'.tr(),
                          style: headerStyle,
                        ),
                        Text(
                          asset.swapMarket ? indexPrice : lastPrice,
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
                      height: 50.0,
                      backgroundColor: const Color(0xFF135579),
                      borderColor: Colors.transparent,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/chart.svg',
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
              color: Color(0xFF2B6F95),
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
              thumbColor: const Color(0xFF78AECC),
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                              assetPrecision: asset.precision,
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
                              assetPrecision: asset.precision,
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

class SwapAmountRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final amountString = requestOrder.marketType == MarketType.stablecoin
        ? amountStr(requestOrder.bitcoinAmount)
        : amountStr(requestOrder.assetAmount, precision: assetPrecision);
    final price =
        priceStrForMarket(requestOrder.price, requestOrder.marketType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: CustomPaint(
        painter: SwapAmountRowBackground(
          expiresAt: requestOrder.expiresAt,
          createdAt: requestOrder.createdAt,
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
                        color: Color(0xFF2CCCBF),
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
                              ? const Color(0xFF2CCCBF)
                              : const Color(0xFFFF7878),
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
  final int expiresAt;
  final int createdAt;
  final SwapAmountRowType type;
  final Radius radius;
  final bool displayTimer = false;

  SwapAmountRowBackground({
    required this.expiresAt,
    required this.createdAt,
    this.type = SwapAmountRowType.bid,
    this.radius = const Radius.circular(0),
  });

  late Color expireColor = type == SwapAmountRowType.bid
      ? const Color(0xFF2CCCBF)
      : const Color(0xFFFF7878);
  Color backgroundColor = const Color(0xFF135579);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    final rect = Offset.zero & size;

    if (!displayTimer) {
      var expirePaint = Paint()..color = expireColor.withOpacity(0.14);
      if (type == SwapAmountRowType.ask) {
        expirePaint = Paint()..color = expireColor.withOpacity(0.14);
      }
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), expirePaint);
      return;
    }

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), backgroundPaint);

    final expired = DateTime.fromMillisecondsSinceEpoch(expiresAt);
    final created = DateTime.fromMillisecondsSinceEpoch(createdAt);

    final maxSeconds = expired.difference(created).inSeconds;
    final currentSeconds = expired.difference(DateTime.now()).inSeconds;

    var expireWidth = convertToNewRange(
      value: currentSeconds.toDouble(),
      minValue: 0,
      maxValue: maxSeconds.toDouble(),
      newMin: 0,
      newMax: rect.width,
    );

    if (expireWidth < 0) {
      expireWidth = 0;
    }

    if (type == SwapAmountRowType.bid) {
      final expireRect = Rect.fromLTRB(
          rect.right - expireWidth, rect.top, rect.right, rect.bottom);
      final expirePaint = Paint()..color = expireColor.withOpacity(0.14);
      final widthDiff = rect.width - expireWidth;
      if (widthDiff >= radius.x) {
        canvas.drawRRect(
            RRect.fromRectAndCorners(expireRect,
                topRight: radius, bottomRight: radius),
            expirePaint);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(expireRect, radius), expirePaint);
      }
    } else {
      final expireRect = Rect.fromLTRB(
          rect.left, rect.top, rect.left + expireWidth, rect.bottom);
      final expirePaint = Paint()..color = expireColor.withOpacity(0.24);
      final widthDiff = rect.width - expireWidth;
      if (widthDiff >= radius.x) {
        canvas.drawRRect(
            RRect.fromRectAndCorners(expireRect,
                topLeft: radius, bottomLeft: radius),
            expirePaint);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(expireRect, radius), expirePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
