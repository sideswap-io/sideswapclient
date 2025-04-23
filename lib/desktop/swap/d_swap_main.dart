import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/swap/swap.dart';

class DSwapMain extends StatelessWidget {
  const DSwapMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Column(
          children: [
            const SizedBox(height: 28),
            Container(
              width: 570,
              height: 551,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.prussianBlue,
              ),
              child: const SwapMain(),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
