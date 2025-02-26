import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/working_order_item.dart';

class WorkingOrdersList extends HookConsumerWidget {
  const WorkingOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiOwnOrders = ref.watch(marketUiOwnOrdersProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverList.separated(
          itemBuilder: (context, index) {
            return WorkingOrderItem(order: uiOwnOrders[index]);
          },
          itemCount: uiOwnOrders.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
        ),
        SliverFillRemaining(hasScrollBody: false, child: SizedBox(height: 10)),
      ],
    );
  }
}
