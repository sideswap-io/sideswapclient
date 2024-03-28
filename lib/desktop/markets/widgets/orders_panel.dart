import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/markets/widgets/d_chart_button.dart';
import 'package:sideswap/desktop/markets/widgets/d_orders_sort_button.dart';
import 'package:sideswap/desktop/markets/widgets/index_price.dart';
import 'package:sideswap/desktop/markets/widgets/orders_list.dart';
import 'package:sideswap/desktop/markets/widgets/orders_title.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';

class OrdersPanel extends StatelessWidget {
  const OrdersPanel({
    super.key,
    this.onChartsPressed,
  });

  final VoidCallback? onChartsPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 665,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: SideSwapColors.blumine),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 56,
            child: Row(
              children: [
                Text(
                  'Order book'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const IndexPrice(),
                const Spacer(),
                SizedBox(
                  width: 240,
                  child: Row(
                    children: [
                      const Spacer(),
                      const SizedBox(
                        height: 32,
                        child: DOrdersSortButton(),
                      ),
                      const SizedBox(width: 7),
                      SizedBox(
                        height: 32,
                        child: DChartButton(
                          onPressed: onChartsPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          const Row(children: [
            OrdersTitle(isLeft: true),
            SizedBox(width: 7),
            OrdersTitle(isLeft: false),
          ]),
          const SizedBox(height: 7),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final bids = ref.watch(ordersPanelBidsProvider);
                          return OrdersList(
                            orders: bids,
                            isBids: true,
                          );
                        },
                      ),
                      const SizedBox(width: 7),
                      Consumer(
                        builder: (context, ref, child) {
                          final asks = ref.watch(ordersPanelAsksProvider);
                          return OrdersList(
                            orders: asks,
                            isBids: false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
