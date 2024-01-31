import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/desktop/markets/widgets/order_item.dart';
import 'package:sideswap/providers/markets_provider.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({
    super.key,
    required this.orders,
    required this.isBids,
  });

  final List<RequestOrder> orders;
  final bool isBids;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              isBids ? 'No active bids'.tr() : 'No active offers'.tr(),
              style: const TextStyle(
                color: Color(0xFF87C1E1),
              ),
            ),
          ),
        ),
      );
    }
    return Flexible(
      child: Column(
        children: orders.map((e) => OrderItem(order: e)).toList(),
      ),
    );
  }
}
