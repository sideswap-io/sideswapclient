import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class DAssetsPanelHeader extends StatelessWidget {
  const DAssetsPanelHeader({
    super.key,
    required this.title,
    required this.totalValueLabel,
    required this.totalValue,
    required this.totalBtcValue,
    required this.walletType,
  });

  final String title;
  final String totalValueLabel;
  final String totalValue;
  final String totalBtcValue;
  final String walletType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
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
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1, color: SideSwapColors.brightTurquoise),
                      borderRadius: BorderRadius.circular(56),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      walletType,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        letterSpacing: -0.2,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
