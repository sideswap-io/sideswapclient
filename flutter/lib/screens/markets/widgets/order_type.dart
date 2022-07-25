import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class OrderType extends StatelessWidget {
  const OrderType({
    super.key,
    this.backgroundColor = const Color(0xFF014767),
    required this.value,
    this.onToggle,
  });

  final Color backgroundColor;
  final bool value;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order type:'.tr(),
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
              activeText: 'Public'.tr(),
              inactiveText: 'Private'.tr(),
              value: value,
              onToggle: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
