import 'package:flutter/material.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';
import 'package:easy_localization/easy_localization.dart';

enum MarketSelectedType {
  orders,
  token,
  swap,
}

class MarketTypeButtons extends StatefulWidget {
  const MarketTypeButtons({
    Key? key,
    this.onOrdersPressed,
    this.onTokenPressed,
    this.onSwapPressed,
    this.selectedType = MarketSelectedType.orders,
  }) : super(key: key);

  final VoidCallback? onOrdersPressed;
  final VoidCallback? onTokenPressed;
  final VoidCallback? onSwapPressed;
  final MarketSelectedType selectedType;

  @override
  _MarketTypeButtonsState createState() => _MarketTypeButtonsState();
}

class _MarketTypeButtonsState extends State<MarketTypeButtons> {
  final colorToggleBackground = const Color(0xFF043857);
  final colorToggleOn = const Color(0xFF1F7EB1);
  final colorToggleTextOn = const Color(0xFFFFFFFF);
  final colorToggleTextOff = const Color(0xFF709EBA);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 36.h,
      decoration: BoxDecoration(
        color: colorToggleBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Expanded(
            child: SwapButton(
              color: widget.selectedType == MarketSelectedType.token
                  ? colorToggleOn
                  : colorToggleBackground,
              text: 'Token market'.tr(),
              textColor: widget.selectedType == MarketSelectedType.token
                  ? colorToggleTextOn
                  : colorToggleTextOff,
              onPressed: widget.onTokenPressed,
            ),
          ),
          Expanded(
            child: SwapButton(
              color: widget.selectedType == MarketSelectedType.swap
                  ? colorToggleOn
                  : colorToggleBackground,
              text: 'Swap market'.tr(),
              textColor: widget.selectedType == MarketSelectedType.swap
                  ? colorToggleTextOn
                  : colorToggleTextOff,
              onPressed: widget.onSwapPressed,
            ),
          ),
        ],
      ),
    );
  }
}
