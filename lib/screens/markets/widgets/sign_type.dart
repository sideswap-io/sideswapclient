import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class SignType extends StatelessWidget {
  const SignType({
    super.key,
    this.backgroundColor = SideSwapColors.chathamsBlue,
    required this.twoStep,
    this.onToggle,
  });

  final Color backgroundColor;
  final bool twoStep;
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
              'Sign type:'.tr(),
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
              activeText: 'Online'.tr(),
              inactiveText: 'Offline'.tr(),
              value: !twoStep,
              onToggle:
                  onToggle != null
                      ? (value) {
                        onToggle!(!value);
                      }
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
