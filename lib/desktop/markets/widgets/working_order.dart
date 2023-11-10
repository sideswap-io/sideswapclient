import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/markets/widgets/orders_row.dart';
import 'package:sideswap/desktop/markets/widgets/working_order_amount.dart';
import 'package:sideswap/desktop/markets/widgets/working_order_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/timer_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class WorkingOrder extends ConsumerWidget {
  const WorkingOrder({
    super.key,
    required this.order,
  });

  final RequestOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSell =
        order.sendBitcoins == (order.marketType == MarketType.stablecoin);
    final dirStr = isSell ? 'Sell'.tr() : 'Buy'.tr();
    final dirColor = isSell ? sellColor : buyColor;
    final priceType = order.indexPrice == 0 ? 'Limit'.tr() : 'Tracking'.tr();
    final orderType = order.private ? 'Private'.tr() : 'Public'.tr();
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[order.assetId]));
    final priceInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
    final productName = ref.watch(assetUtilsProvider).productName(asset: asset);
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: order.assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final assetAmountStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: order.assetAmount, precision: assetPrecision));
    final bitcoinAmountStr = amountProvider
        .amountToString(AmountToStringParameters(amount: order.bitcoinAmount));
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    return OrdersRow(
      children: [
        Text(productName),
        WorkingOrderAmount(
          assetId: priceInLiquid ? order.assetId : liquidAssetId,
          text: priceInLiquid ? assetAmountStr : bitcoinAmountStr,
        ),
        WorkingOrderAmount(
          assetId: priceInLiquid ? liquidAssetId : order.assetId,
          text: priceStr(order.price, priceInLiquid),
        ),
        WorkingOrderAmount(
          assetId: !priceInLiquid ? order.assetId : liquidAssetId,
          text: !priceInLiquid ? assetAmountStr : bitcoinAmountStr,
        ),
        Text(
          dirStr,
          style: TextStyle(
            color: dirColor,
          ),
        ),
        Text(priceType),
        Text(orderType),
        Row(
          children: [
            SvgPicture.asset(
              'assets/clock.svg',
              width: 14,
              height: 14,
              colorFilter: const ColorFilter.mode(
                  SideSwapColors.brightTurquoise, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            Consumer(builder: (context, ref, _) {
              ref.watch(timerProvider);
              return Text(order.getExpireDuration().toStringCustomShort());
            }),
            const Spacer(),
            if (order.private)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: WorkingOrderButton(
                  icon: 'assets/copy3.svg',
                  onPressed: () {
                    final shareUrl = ref
                        .read(requestOrderProvider)
                        .getAddressToShareById(order.orderId);
                    copyToClipboard(context, shareUrl);
                  },
                ),
              ),
            const SizedBox(width: 4),
            WorkingOrderButton(
              icon: 'assets/edit2.svg',
              onPressed: () {
                ref.read(walletProvider).setOrderRequestView(order);
              },
            ),
            const SizedBox(width: 4),
            WorkingOrderButton(
              icon: 'assets/delete2.svg',
              onPressed: () async {
                ref.read(walletProvider).cancelOrder(order.orderId);
              },
            ),
          ],
        ),
      ],
    );
  }
}
