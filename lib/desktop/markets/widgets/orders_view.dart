import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/markets/widgets/d_chart_button.dart';
import 'package:sideswap/desktop/markets/widgets/index_price.dart';
import 'package:sideswap/desktop/markets/widgets/order_item.dart';
import 'package:sideswap/desktop/markets/widgets/orders_title.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key, this.onChartsPressed});

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
                  height: 32,
                  child: DChartButton(onPressed: onChartsPressed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          const Row(
            children: [
              OrdersTitle(isLeft: true),
              SizedBox(width: 7),
              OrdersTitle(isLeft: false),
            ],
          ),
          const SizedBox(height: 7),
          Flexible(child: OrdersScrollView()),
        ],
      ),
    );
  }
}

class OrdersScrollView extends HookConsumerWidget {
  const OrdersScrollView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bids = ref.watch(ordersPanelBidsProvider);
    final asks = ref.watch(ordersPanelAsksProvider);
    final maxItems = asks.length > bids.length ? asks.length : bids.length;
    final itemCount = maxItems == 0 ? 1 : maxItems;

    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemBuilder: (context, index) {
            return Row(
              children: [
                Flexible(
                  child: OrderRowElement(
                    index: index,
                    orders: bids,
                    text: 'No active bids'.tr(),
                  ),
                ),
                Flexible(
                  child: OrderRowElement(
                    index: index,
                    orders: asks,
                    text: 'No active offers'.tr(),
                  ),
                ),
              ],
            );
          },
          itemCount: itemCount,
        ),
      ],
    );
  }
}

class OrderRowElement extends ConsumerWidget {
  const OrderRowElement({
    required this.index,
    required this.orders,
    required this.text,
    super.key,
  });

  final int index;
  final Iterable<InternalUiOrder> orders;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderRowElementTheme =
        Theme.of(context).extension<OrderRowElementTheme>()!;

    return (index == 0 && orders.isEmpty)
        ? Padding(
          padding: orderRowElementTheme.padding,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'No active bids'.tr(),
              style: TextStyle(color: orderRowElementTheme.textColor),
            ),
          ),
        )
        : OrderItem(order: orders.elementAtOrNull(index));
  }
}
