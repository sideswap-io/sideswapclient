import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/order_depth_container.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/markets/widgets/d_edit_order_dialog.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class OrderItem extends HookConsumerWidget {
  const OrderItem({super.key, this.order});

  final InternalUiOrder? order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiOwnOrders = ref.watch(marketUiOwnOrdersProvider);
    final color = order?.tradeDir == TradeDir.BUY
        ? Theme.of(context).extension<MarketColorsStyle>()!.buyColor
        : Theme.of(context).extension<MarketColorsStyle>()!.sellColor;

    final list = [
      Text(order?.amountString ?? '', style: const TextStyle(fontSize: 13)),
      const Spacer(),
      if (order?.orderType == InternalUiOrderType.own())
        Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: order == null ? null : color,
              ),
            ),
          ],
        ),
      const SizedBox(width: 6),
      Text(
        order?.priceString ?? '',
        style: TextStyle(fontSize: 13, color: color),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: DHoverButton(
        builder: (context, states) {
          final percent = order?.amountPercent ?? .0;
          return CustomPaint(
            painter: OrderDepthContainerPainer(
              drawEmpty: order == null,
              depthPercent: percent,
              backgroundColor: !states.isHovering
                  ? SideSwapColors.chathamsBlue
                  : (order?.tradeDir == TradeDir.BUY
                        ? const Color(0xFF176683)
                        : const Color(0xFF4C5D79)),
              depthColor: order?.tradeDir == TradeDir.BUY
                  ? Theme.of(context)
                        .extension<MarketColorsStyle>()!
                        .buyColor!
                        .withValues(alpha: 0.2)
                  : Theme.of(context)
                        .extension<MarketColorsStyle>()!
                        .sellColor!
                        .withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: order?.orderType == InternalUiOrderType.own()
                  ? order?.tradeDir == TradeDir.BUY
                        ? Border.all(
                            color: Theme.of(
                              context,
                            ).extension<MarketColorsStyle>()!.buyColor!,
                          )
                        : Border.all(
                            color: Theme.of(
                              context,
                            ).extension<MarketColorsStyle>()!.sellColor!,
                          )
                  : null,
              side: order?.tradeDir == TradeDir.BUY
                  ? OrderDepthSide.right()
                  : OrderDepthSide.left(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Row(
                children: order?.tradeDir == TradeDir.BUY
                    ? list
                    : list.reversed.toList(),
              ),
            ),
          );
        },
        onPressed: () async {
          if (order == null) {
            return;
          }

          final uiOrder = uiOwnOrders.firstWhereOrNull(
            (e) => e.orderId == order?.orderId,
          );

          // if it's desktop and it's own order then open edit dialog
          // * Mobile can't edit orders!
          if (FlavorConfig.isDesktop) {
            if (uiOrder != null &&
                uiOrder.offlineSwapType != OfflineSwapType.twoStep()) {
              ref
                  .read(marketEditDetailsOrderNotifierProvider.notifier)
                  .setState(uiOrder);

              await showDialog<void>(
                context: context,
                builder: (context) {
                  return DEditOrderDialog();
                },
                routeSettings: RouteSettings(name: orderEditRouteName),
                useRootNavigator: false,
              );

              ref.invalidate(marketEditDetailsOrderNotifierProvider);
              return;
            }
          }

          // otherwise start public order
          ref.invalidate(marketTypeSwitchStateNotifierProvider);

          if (order?.orderId != null) {
            ref.invalidate(marketQuoteNotifierProvider);
            final msg = To();
            msg.startOrder = To_StartOrder(
              orderId: order!.orderId!.id,
              privateId: null,
            );
            ref.read(walletProvider).sendMsg(msg);
          }
        },
      ),
    );
  }
}
