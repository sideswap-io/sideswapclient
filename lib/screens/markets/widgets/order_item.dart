import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class OrderItem extends ConsumerStatefulWidget {
  const OrderItem({
    super.key,
    required this.requestOrder,
    this.useTokenMarketView = false,
    this.onTap,
  });

  final RequestOrder requestOrder;
  final bool useTokenMarketView;
  final void Function()? onTap;

  @override
  OrderItemState createState() => OrderItemState();
}

class OrderItemState extends ConsumerState<OrderItem> {
  String createdAt = '';
  String expire = '';
  Timer? expireTimer;

  final descriptionStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: SideSwapColors.brightTurquoise,
  );

  final amountStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  final coloredContainerStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  final Color alternativeBackground = const Color(0xFF196087);

  @override
  void initState() {
    super.initState();

    expire = widget.requestOrder.getExpireDescription();
    createdAt = widget.requestOrder.getCreatedAtFormatted();

    expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        expire = widget.requestOrder.getExpireDescription();
      });
    });
  }

  @override
  void dispose() {
    expireTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final bitcoinAsset =
        ref.watch(assetsStateProvider.select((value) => value[liquidAssetId]));
    final asset = ref.watch(assetsStateProvider
        .select((value) => value[widget.requestOrder.assetId]));
    final isStablecoin = asset?.swapMarket == true;
    final bitcoinIcon =
        ref.watch(assetImageProvider).getSmallImage(liquidAssetId);
    final assetIcon =
        ref.watch(assetImageProvider).getSmallImage(asset?.assetId);
    final assetTicker = asset?.ticker;
    final isToken = widget.requestOrder.marketType == MarketType.token;
    final isAmp = widget.requestOrder.marketType == MarketType.amp;
    final bitcoinTicker = bitcoinAsset?.ticker;

    final sendBitcoins = widget.requestOrder.sendBitcoins;
    final sendAsset = sendBitcoins ? bitcoinAsset : asset;
    final recvAsset = sendBitcoins ? asset : bitcoinAsset;

    final deliverTicker = sendAsset?.ticker ?? '';
    final amountProvider = ref.watch(amountToStringProvider);
    final bitcoinAmountStr = amountProvider.amountToString(
        AmountToStringParameters(amount: widget.requestOrder.bitcoinAmount));
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);
    final assetAmountStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: widget.requestOrder.assetAmount,
            precision: assetPrecision));
    final deliverIcon = sendBitcoins ? bitcoinIcon : assetIcon;
    final buyAmount = sendBitcoins
        ? widget.requestOrder.assetAmount
        : widget.requestOrder.bitcoinAmount;
    final receiveTicker = sendBitcoins ? assetTicker : bitcoinTicker;
    final receivePrecision = recvAsset?.precision;
    final buyAmountStr = amountProvider.amountToString(AmountToStringParameters(
        amount: buyAmount, precision: receivePrecision ?? 8));
    final receiveIcon = sendBitcoins ? assetIcon : bitcoinIcon;
    final totalPrice = sendBitcoins
        ? widget.requestOrder.assetAmount
        : widget.requestOrder.bitcoinAmount;
    final totalPriceStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: totalPrice, precision: receivePrecision ?? 8));
    final priceTicker = isStablecoin ? assetTicker : bitcoinTicker;
    final priceIcon = isStablecoin ? assetIcon : bitcoinIcon;
    final priceAmount = priceStrForMarket(
        widget.requestOrder.price, widget.requestOrder.marketType);
    final dollarConversionRecv = ref
        .watch(dollarConversionFromStringProvider(liquidAssetId, buyAmountStr));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: SideSwapColors.chathamsBlue,
        child: InkWell(
          onTap: widget.onTap ??
              () {
                ref
                    .read(walletProvider)
                    .setOrderRequestView(widget.requestOrder);
              },
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isToken) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: deliverIcon,
                              ),
                            ),
                          ],
                          Text(
                            isToken
                                ? deliverTicker
                                : (isAmp
                                    ? '$assetTicker / $bitcoinTicker'
                                    : '$bitcoinTicker / $assetTicker'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (isAmp) const AmpFlag()
                        ],
                      ),
                      if (widget.useTokenMarketView) ...[
                        ColoredContainer(
                          horizontalPadding: 8,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.watch_later,
                                  size: 14,
                                  color: SideSwapColors.brightTurquoise,
                                ),
                              ),
                              Text(
                                expire,
                                style: coloredContainerStyle,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        ColoredContainer(
                          child: Text(
                            isToken ? 'Token market'.tr() : 'Swap market'.tr(),
                            style: coloredContainerStyle,
                          ),
                        ),
                      ]
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: SideSwapColors.jellyBean,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount'.tr(),
                        style: descriptionStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.requestOrder.marketType ==
                                    MarketType.stablecoin
                                ? '$bitcoinAmountStr $kLiquidBitcoinTicker'
                                : '$assetAmountStr $assetTicker',
                            style: amountStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: widget.requestOrder.marketType ==
                                      MarketType.stablecoin
                                  ? bitcoinIcon
                                  : assetIcon,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price per unit'.tr(),
                          style: descriptionStyle,
                        ),
                        Row(
                          children: [
                            Text(
                              '$priceAmount $priceTicker',
                              style: amountStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: priceIcon,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isToken) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total price'.tr(),
                            style: descriptionStyle,
                          ),
                          Row(
                            children: [
                              Text(
                                '$totalPriceStr $receiveTicker',
                                style: amountStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: receiveIcon,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (widget.useTokenMarketView) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: descriptionStyle,
                          ),
                          Row(
                            children: [
                              Text(
                                '≈ $dollarConversionRecv',
                                style: amountStyle.copyWith(
                                    color: const Color(0xFF709EBA)),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(
                        thickness: 1,
                        height: 1,
                        color: SideSwapColors.jellyBean,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.requestOrder.indexPrice != 0) ...[
                          ColoredContainer(
                            backgroundColor: alternativeBackground,
                            borderColor: alternativeBackground,
                            child: Text(
                              'Tracking'.tr(),
                              style: coloredContainerStyle,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              if (!isToken) ...[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ColoredContainer(
                                    backgroundColor: alternativeBackground,
                                    borderColor: alternativeBackground,
                                    child: Text(
                                      'Limit'.tr(),
                                      style: coloredContainerStyle,
                                    ),
                                  ),
                                ),
                              ],
                              ColoredContainer(
                                backgroundColor: alternativeBackground,
                                borderColor: alternativeBackground,
                                child: Text(
                                  widget.requestOrder.private
                                      ? 'Private'.tr()
                                      : 'Public'.tr(),
                                  style: coloredContainerStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                        Row(
                          children: [
                            if (!isToken) ...[
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: sendBitcoins != isAmp
                                    ? ColoredContainer(
                                        backgroundColor: SideSwapColors
                                            .bitterSweet
                                            .withOpacity(0.14),
                                        borderColor: SideSwapColors.bitterSweet,
                                        child: Text(
                                          'Sell'.tr(),
                                          style: coloredContainerStyle,
                                        ),
                                      )
                                    : ColoredContainer(
                                        backgroundColor: SideSwapColors
                                            .turquoise
                                            .withOpacity(0.14),
                                        borderColor: SideSwapColors.turquoise,
                                        child: Text(
                                          'Buy'.tr(),
                                          style: coloredContainerStyle,
                                        ),
                                      ),
                              ),
                            ],
                            ColoredContainer(
                              horizontalPadding: 8,
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.watch_later,
                                      size: 14,
                                      color: SideSwapColors.brightTurquoise,
                                    ),
                                  ),
                                  Text(
                                    expire,
                                    style: coloredContainerStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
