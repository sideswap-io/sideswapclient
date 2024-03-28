import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class PaymentSendPopupAddressAmountItem extends StatelessWidget {
  const PaymentSendPopupAddressAmountItem({
    super.key,
    required this.address,
    required this.amount,
    this.icon,
    required this.ticker,
    this.onPressed,
    required this.index,
  });

  final String address;
  final String amount;
  final Widget? icon;
  final String ticker;
  final void Function()? onPressed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
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
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: ExtendedText(
                    address,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflowWidget: TextOverflowWidget(
                      position: TextOverflowPosition.middle,
                      align: TextOverflowAlign.center,
                      child: Text(
                        '...',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                ...switch (icon) {
                  final icon? => [
                      icon,
                      const SizedBox(width: 8),
                    ],
                  _ => [
                      const SizedBox(),
                    ],
                },
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: Text(
                    ticker,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...switch (onPressed) {
                  final onPressed? => [
                      const SizedBox(width: 8),
                      IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: SideSwapColors.brightTurquoise,
                            size: 16,
                          ),
                          onPressed: onPressed),
                    ],
                  _ => [
                      const SizedBox(),
                    ],
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
