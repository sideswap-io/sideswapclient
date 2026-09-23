import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/instant_swap/instant_swap.dart';

/// The height the swap card is designed for.
const double _cardHeight = 561;

/// The height the form above the pinned primary action has at the design
/// window, and the height its scroll owner lays it out at everywhere: the
/// card less the action row that no longer scrolls with it.
const double _bodyDesignHeight = _cardHeight - kInstantSwapActionHeight;

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
            // `Flexible` is what bounds the card on a window shorter than the
            // 28 + 561 px it is designed for: the card takes its design
            // height wherever there is room, and gives the shortfall to its
            // scroll owner instead of overflowing by it.
            Flexible(
              child: Container(
                width: 570,
                height: _cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: SideSwapColors.prussianBlue,
                ),
                child: InstantSwap(pinnedActionBodyHeight: _bodyDesignHeight),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
