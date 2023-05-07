import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class OrderItem extends ConsumerWidget {
  const OrderItem({
    super.key,
    required this.order,
  });

  final RequestOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[order.assetId]));
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: order.assetId);
    final isLeft = order.sendBitcoins == pricedInLiquid;
    final color = isLeft ? buyColor : sellColor;
    final amount = pricedInLiquid ? order.assetAmount : order.bitcoinAmount;
    final amountPrecision = pricedInLiquid ? assetPrecision : 8;
    final amountProvider = ref.watch(amountToStringProvider);
    final amountStr = amountProvider.amountToString(
        AmountToStringParameters(amount: amount, precision: amountPrecision));

    final list = [
      Text(
        amountStr,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      const Spacer(),
      if (order.own)
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      const SizedBox(width: 6),
      Text(
        priceStr(order.price, pricedInLiquid),
        style: TextStyle(
          fontSize: 13,
          color: color,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: DHoverButton(
        builder: (context, states) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: !states.isHovering
                  ? SideSwapColors.chathamsBlue
                  : (isLeft
                      ? const Color(0xFF176683)
                      : const Color(0xFF4C5D79)),
            ),
            child: Row(children: isLeft ? list : list.reversed.toList()),
          );
        },
        onPressed: () {
          if (order.own) {
            ref.read(walletProvider).setOrderRequestView(order);
          } else {
            ref.read(walletProvider).linkOrder(order.orderId);
          }
        },
      ),
    );
  }
}
