import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({
    Key? key,
    this.orderTableRowType = OrderTableRowType.normal,
    required this.orderDetailsData,
    this.enabled = true,
    this.useTokenView = false,
  }) : super(key: key);

  final OrderTableRowType orderTableRowType;
  final OrderDetailsData orderDetailsData;
  final bool enabled;
  final bool useTokenView;

  @override
  Widget build(BuildContext context) {
    final assets = context.read(walletProvider).assets;
    Image? assetIcon, bitcoinIcon;
    var assetTicker = '';
    var isToken = false;

    var bitcoinTicker = '';
    for (var asset in assets.values) {
      if (asset.ticker == kLiquidBitcoinTicker) {
        bitcoinIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        bitcoinTicker = asset.ticker;
      }
      if (asset.assetId == orderDetailsData.assetId) {
        isToken =
            context.read(requestOrderProvider).isAssetToken(asset.assetId);
        assetIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        assetTicker = asset.ticker;
      }
    }

    final sellBitcoin = orderDetailsData.sellBitcoin;
    final deliverAmount = sellBitcoin
        ? orderDetailsData.bitcoinAmount
        : orderDetailsData.assetAmount;
    final deliverTicker = sellBitcoin ? bitcoinTicker : assetTicker;
    final deliverIcon = sellBitcoin ? bitcoinIcon : assetIcon;
    final receiveAmount = sellBitcoin
        ? orderDetailsData.assetAmount
        : orderDetailsData.bitcoinAmount;
    final receiveTicker = sellBitcoin ? assetTicker : bitcoinTicker;
    final receiveIcon = sellBitcoin ? assetIcon : bitcoinIcon;
    final priceTicker = isToken ? bitcoinTicker : assetTicker;
    final priceIcon = isToken ? bitcoinIcon : assetIcon;
    final price = double.tryParse(orderDetailsData.priceAmount)?.toInt() ?? 0;
    var priceAmount =
        isToken ? amountStr(price, precision: 8) : orderDetailsData.priceAmount;

    final receiveAssetId =
        context.read(walletProvider).getAssetByTicker(receiveTicker)?.assetId ??
            '';
    0;
    final dollarConversion = context
        .read(requestOrderProvider)
        .dollarConversion(receiveAssetId, double.tryParse(receiveAmount) ?? 0);

    return Column(
      children: [
        if (useTokenView) ...[
          OrderTableRow(
            description: 'Name'.tr(),
            value: context
                    .read(walletProvider)
                    .assets[orderDetailsData.assetId]
                    ?.name ??
                '',
            icon: deliverIcon,
          ),
          OrderTableRow(
            description: 'Ticker'.tr(),
            customValue: Row(
              children: [
                Text(
                  deliverTicker,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ],
            ),
          ),
          OrderTableRow(
            description: 'Amount'.tr(),
            value: '$deliverAmount $deliverTicker',
            icon: deliverIcon,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
          ),
        ] else ...[
          OrderTableRow(
            description: 'Deliver'.tr(),
            value: '$deliverAmount $deliverTicker',
            icon: deliverIcon,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
          ),
        ],
        OrderTableRow(
          description: 'Price'.tr(),
          value: '$priceAmount $priceTicker',
          icon: priceIcon,
          orderTableRowType: orderTableRowType,
          enabled: enabled,
        ),
        if (useTokenView) ...[
          OrderTableRow(
            description: 'Total price'.tr(),
            value: '$receiveAmount $receiveTicker',
            icon: receiveIcon,
            displayDivider: false,
            dollarConversion: dollarConversion,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
          ),
        ] else ...[
          OrderTableRow(
            description: 'Fee'.tr(),
            value: '${orderDetailsData.fee} $bitcoinTicker',
            icon: bitcoinIcon,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
          ),
          OrderTableRow(
            description: 'Receive'.tr(),
            value: '$receiveAmount $receiveTicker',
            icon: receiveIcon,
            displayDivider: false,
            dollarConversion: dollarConversion,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
          ),
        ],
      ],
    );
  }
}
