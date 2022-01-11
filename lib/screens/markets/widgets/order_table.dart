import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final wallet = context.read(walletProvider);
    final bitcoinAsset = wallet.assets[wallet.liquidAssetId()]!;
    final asset = wallet.assets[orderDetailsData.assetId]!;
    final sellBitcoin = orderDetailsData.sellBitcoin;
    final sendAsset = sellBitcoin ? bitcoinAsset : asset;
    final recvAsset = sellBitcoin ? asset : bitcoinAsset;
    final deliverAmount = sellBitcoin
        ? (orderDetailsData.bitcoinAmount + orderDetailsData.fee)
        : orderDetailsData.assetAmount;
    final receiveAmount = sellBitcoin
        ? orderDetailsData.assetAmount
        : (orderDetailsData.bitcoinAmount - orderDetailsData.fee);
    final assetAmount = orderDetailsData.assetAmount;
    final bitcoinAmount = orderDetailsData.bitcoinAmount;
    final isStablecoin = asset.swapMarket;
    final priceAsset = isStablecoin ? asset : bitcoinAsset;
    final priceAmount = orderDetailsData.priceAmountStr;
    final priceDollarConversion = !isStablecoin
        ? context.read(requestOrderProvider).dollarConversion(
            bitcoinAsset.assetId, double.tryParse(priceAmount) ?? 0)
        : null;
    final isAmp = wallet.ampAssets.contains(asset.assetId);

    return Column(
      children: [
        if (useTokenView) ...[
          OrderTableRow(
            description: 'Name'.tr(),
            value: asset.name,
            icon: wallet.assetImagesSmall[asset.assetId],
          ),
          OrderTableRow(
            description: 'Ticker'.tr(),
            showAmpFlag: isAmp,
            value: asset.ticker,
            icon: wallet.assetImagesSmall[asset.assetId],
          ),
          OrderTableRow.assetAmount(
            description: 'Amount'.tr(),
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: assetAmount,
            assetId: asset.assetId,
          ),
        ] else ...[
          OrderTableRow.assetAmount(
            description: 'Deliver'.tr(),
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: deliverAmount,
            assetId: sendAsset.assetId,
          ),
        ],
        OrderTableRow(
          description: 'Price'.tr(),
          value: '$priceAmount ${priceAsset.ticker}',
          icon: wallet.assetImagesSmall[priceAsset.assetId]!,
          orderTableRowType: orderTableRowType,
          dollarConversion: priceDollarConversion,
          enabled: enabled,
        ),
        if (useTokenView) ...[
          OrderTableRow.assetAmount(
              description: 'Total price'.tr(),
              displayDivider: false,
              orderTableRowType: orderTableRowType,
              enabled: enabled,
              amount: bitcoinAmount,
              assetId: wallet.liquidAssetId()),
        ] else ...[
          OrderTableRow.assetAmount(
            description: 'Fee'.tr(),
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: orderDetailsData.fee,
            assetId: bitcoinAsset.assetId,
            showDollarConversion: false,
          ),
          OrderTableRow.assetAmount(
            description: 'Receive'.tr(),
            displayDivider: false,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: receiveAmount,
            assetId: recvAsset.assetId,
          ),
        ],
      ],
    );
  }
}
