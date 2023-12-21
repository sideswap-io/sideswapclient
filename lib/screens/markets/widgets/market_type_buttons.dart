import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';
import 'package:easy_localization/easy_localization.dart';

enum MarketSelectedType {
  swap,
  orders,
}

class MarketTypeButtons extends StatefulWidget {
  const MarketTypeButtons({
    super.key,
    this.onOrdersPressed,
    this.onTokenPressed,
    this.onSwapPressed,
    this.selectedType = MarketSelectedType.swap,
  });

  final VoidCallback? onOrdersPressed;
  final VoidCallback? onTokenPressed;
  final VoidCallback? onSwapPressed;
  final MarketSelectedType selectedType;

  @override
  MarketTypeButtonsState createState() => MarketTypeButtonsState();
}

class MarketTypeButtonsState extends State<MarketTypeButtons> {
  final colorToggleBackground = const Color(0xFF043857);
  final colorToggleOn = const Color(0xFF1F7EB1);
  final colorToggleTextOn = const Color(0xFFFFFFFF);
  final colorToggleTextOff = SideSwapColors.airSuperiorityBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 39,
      decoration: BoxDecoration(
        color: colorToggleBackground,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SwapButton(
              color: widget.selectedType == MarketSelectedType.swap
                  ? colorToggleOn
                  : colorToggleBackground,
              text: 'Markets'.tr(),
              textColor: widget.selectedType == MarketSelectedType.swap
                  ? colorToggleTextOn
                  : colorToggleTextOff,
              onPressed: widget.onSwapPressed,
            ),
          ),
          Expanded(
            child: SwapButton(
              color: widget.selectedType == MarketSelectedType.orders
                  ? colorToggleOn
                  : colorToggleBackground,
              text: 'Orders'.tr(),
              textColor: widget.selectedType == MarketSelectedType.orders
                  ? colorToggleTextOn
                  : colorToggleTextOff,
              onPressed: widget.onOrdersPressed,
            ),
          ),
        ],
      ),
    );
  }
}
