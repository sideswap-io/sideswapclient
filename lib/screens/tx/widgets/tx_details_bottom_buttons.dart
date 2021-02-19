import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/screen_utils.dart';

class TxDetailsBottomButtons extends StatelessWidget {
  TxDetailsBottomButtons({
    Key key,
    @required this.id,
    @required this.isLiquid,
  }) : super(key: key);

  final String id;
  final bool isLiquid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBigButton(
          width: 251.w,
          text: 'View in external explorer'.tr(),
          icon: Transform(
            transform: Matrix4.rotationY(-2 * pi / 2),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/back_arrow.svg',
              width: 8.16.w,
              height: 14.73.w,
              color: Color(0xFF00C5FF),
            ),
          ),
          onPressed: () async {
            await openTxidUrl(id, isLiquid);
          },
        ),
        CustomBigButton(
          width: 60.w,
          icon: SvgPicture.asset(
            'assets/share2.svg',
            width: 22.w,
            height: 26.w,
            color: Color(0xFF00C5FF),
          ),
          onPressed: () async {
            await shareTxid(id);
          },
        ),
      ],
    );
  }
}
