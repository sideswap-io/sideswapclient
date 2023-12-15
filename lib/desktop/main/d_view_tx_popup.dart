import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/common/d_text_icon_container.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';

class DViewTxPopup extends StatelessWidget {
  const DViewTxPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return DPopupWithClose(
      width: 580,
      height: 272,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Unsigned transaction (PSET)',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.10,
              ),
            ),
            const SizedBox(height: 28),
            DTextIconContainer(
              trailingIcon: DIconButton(
                icon: SvgPicture.asset(
                  'assets/copy.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                      SideSwapColors.brightTurquoise, BlendMode.srcIn),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DCustomButton(
                  width: 245,
                  height: 44,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('BACK'.tr()),
                ),
                DCustomButton(
                  width: 245,
                  height: 44,
                  isFilled: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('EXPORT FILE'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
