import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderTable extends ConsumerWidget {
  const OrderTable({
    super.key,
    this.orderTableRowType = OrderTableRowType.normal,
    required this.orderDetailsData,
    this.enabled = true,
    this.useTokenView = false,
  });

  final OrderTableRowType orderTableRowType;
  final OrderDetailsData orderDetailsData;
  final bool enabled;
  final bool useTokenView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liquidAssetId = ref.watch(liquidAssetIdProvider);
    final bitcoinAsset =
        ref.watch(assetsStateProvider.select((value) => value[liquidAssetId]));
    final asset = ref.watch(
        assetsStateProvider.select((value) => value[orderDetailsData.assetId]));
    final assetIcon =
        ref.watch(assetImageProvider).getSmallImage(asset?.assetId);
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
    final isStablecoin = asset?.swapMarket ?? false;
    final priceAsset = isStablecoin ? asset : bitcoinAsset;
    final priceAssetIcon =
        ref.watch(assetImageProvider).getSmallImage(priceAsset?.assetId);
    final priceAmount = orderDetailsData.priceAmountStr;
    final priceDollarConversion = !isStablecoin
        ? ref.read(requestOrderProvider).dollarConversion(
            bitcoinAsset?.assetId, double.tryParse(priceAmount) ?? 0)
        : null;
    final isAmp =
        ref.watch(assetUtilsProvider).isAmpMarket(assetId: asset?.assetId);
    final showOrderType =
        orderDetailsData.orderType == OrderDetailsDataType.quote;

    return Column(
      children: [
        if (useTokenView) ...[
          OrderTableRow(
            description: 'Name'.tr(),
            value: asset?.name ?? '',
            icon: assetIcon,
          ),
          OrderTableRow(
            description: 'Ticker'.tr(),
            showAmpFlag: isAmp,
            value: asset?.ticker ?? '',
            icon: assetIcon,
          ),
          OrderTableRow.assetAmount(
            description: 'Amount'.tr(),
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: assetAmount,
            assetId: asset?.assetId,
          ),
        ] else ...[
          OrderTableRow.assetAmount(
            description: 'Deliver'.tr(),
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: deliverAmount,
            assetId: sendAsset?.assetId,
          ),
        ],
        OrderTableRow(
          description: 'Price'.tr(),
          value: '$priceAmount ${priceAsset?.ticker ?? ''}',
          icon: priceAssetIcon,
          orderTableRowType: orderTableRowType,
          dollarConversion: priceDollarConversion,
          enabled: enabled,
        ),
        if (useTokenView) ...[
          OrderTableRow.assetAmount(
              description: 'Total price'.tr(),
              displayDivider: showOrderType,
              orderTableRowType: orderTableRowType,
              enabled: enabled,
              amount: bitcoinAmount,
              assetId: liquidAssetId),
        ] else ...[
          OrderTableRow.assetAmount(
            description: 'Fee'.tr(),
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: orderDetailsData.fee,
            assetId: bitcoinAsset?.assetId,
            showDollarConversion: false,
          ),
          OrderTableRow.assetAmount(
            description: 'Receive'.tr(),
            displayDivider: showOrderType,
            orderTableRowType: orderTableRowType,
            enabled: enabled,
            amount: receiveAmount,
            assetId: recvAsset?.assetId,
          ),
        ],
        if (showOrderType)
          OrderTableRow(
            description: 'Order Type'.tr(),
            value: orderDetailsData.twoStep ? 'Offline'.tr() : 'Online'.tr(),
            orderTableRowType: orderTableRowType,
            displayDivider: false,
          ),
      ],
    );
  }
}
