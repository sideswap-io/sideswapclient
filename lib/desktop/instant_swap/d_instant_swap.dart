import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/instant_swap/instant_swap.dart';

class DInstantSwap extends StatelessWidget {
  const DInstantSwap({super.key});

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
              height: 561,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.prussianBlue,
              ),
              child: InstantSwap(),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
