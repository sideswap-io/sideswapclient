import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class AutoSign extends StatelessWidget {
  const AutoSign({
    super.key,
    this.backgroundColor = SideSwapColors.chathamsBlue,
    required this.autoSign,
    this.onToggle,
  });

  final Color backgroundColor;
  final bool autoSign;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 12, left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Auto-sign'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                SwitchButton(
                  width: 142,
                  height: 35,
                  borderRadius: 8,
                  borderWidth: 2,
                  activeText: 'On'.tr(),
                  inactiveText: 'Off'.tr(),
                  value: autoSign,
                  onToggle: onToggle,
                ),
              ],
            ),
            Text(
              'If someone confirms your order in the order book, SideSwap will automatically confirm the order'
                  .tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: SideSwapColors.hippieBlue,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
