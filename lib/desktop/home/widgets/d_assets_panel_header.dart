import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class DAssetsPanelHeader extends StatelessWidget {
  const DAssetsPanelHeader({
    super.key,
    required this.totalValueLabel,
    required this.totalValue,
    required this.totalBtcValue,
  });

  final String totalValueLabel;
  final String totalValue;
  final String totalBtcValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: const ShapeDecoration(
        color: SideSwapColors.lapisLazuli,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
        child: Row(
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      totalValueLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: SideSwapColors.brightTurquoise,
                        fontSize: 13,
                        letterSpacing: 0.07,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      totalValue,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: SideSwapColors.cornFlower,
                        fontSize: 13,
                        letterSpacing: 0.07,
                      ),
                    ),
                  ],
                ),
                Text(
                  totalBtcValue,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(letterSpacing: -0.2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
