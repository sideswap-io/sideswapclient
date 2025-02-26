import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';

class PaymentSendPopupAddressAmountItem extends StatelessWidget {
  const PaymentSendPopupAddressAmountItem({
    super.key,
    required this.address,
    required this.amount,
    this.icon,
    required this.ticker,
    required this.index,
  });

  final String address;
  final String amount;
  final Widget? icon;
  final String ticker;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 79,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            const SizedBox(height: 1),
            switch (index) {
              0 => const SizedBox(),
              _ => const Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.lapisLazuli,
              ),
            },
            const SizedBox(height: 8),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Amount'.tr(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      amount,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: SideSwapColors.bitterSweet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...switch (icon) {
                      final icon? => [icon, const SizedBox(width: 8)],
                      _ => [const SizedBox()],
                    },
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 40),
                      child: Text(
                        ticker,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Text(
                      'Address'.tr(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 180,
                      child: MiddleEllipsisText(
                        text: address,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
