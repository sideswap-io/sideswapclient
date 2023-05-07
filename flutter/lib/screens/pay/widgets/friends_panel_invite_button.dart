import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class FriendsPanelInviteButton extends StatelessWidget {
  const FriendsPanelInviteButton({
    super.key,
    this.width,
    this.height,
    this.onPressed,
  });

  final double? width;
  final double? height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SideSwapColors.brightTurquoise,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              'INVITE'.tr(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
