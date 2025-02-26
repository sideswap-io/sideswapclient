import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class OrdersTitle extends StatelessWidget {
  const OrdersTitle({super.key, required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      color: SideSwapColors.brightTurquoise,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isLeft ? 'Amount'.tr() : 'Offer'.tr(), style: titleStyle),
            Text(isLeft ? 'Bid'.tr() : 'Amount'.tr(), style: titleStyle),
          ],
        ),
      ),
    );
  }
}
