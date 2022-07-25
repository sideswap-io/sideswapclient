import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:easy_localization/easy_localization.dart';

class ShareAndCopyButtonsRow extends StatelessWidget {
  const ShareAndCopyButtonsRow({
    super.key,
    this.onShare,
    this.onCopy,
    this.buttonWidth,
  });

  final void Function()? onShare;
  final void Function()? onCopy;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBigButton(
          width: buttonWidth ?? 160,
          height: 54,
          backgroundColor: const Color(0xFF00C5FF),
          onPressed: onShare,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SHARE'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                SvgPicture.asset(
                  'assets/share3.svg',
                  width: 20,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        CustomBigButton(
          width: buttonWidth ?? 160,
          height: 54,
          backgroundColor: const Color(0xFF00C5FF),
          onPressed: onCopy,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'COPY'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                SvgPicture.asset(
                  'assets/copy.svg',
                  width: 20,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
