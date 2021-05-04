import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

enum ShareIconType {
  share,
  link,
}

enum BlindType {
  unblinded,
  both,
}

class ShareExternalExplorerDialog extends StatelessWidget {
  const ShareExternalExplorerDialog({
    Key key,
    this.onBlindedPressed,
    this.onUnblindedPressed,
    this.shareIconType = ShareIconType.share,
    this.blindType = BlindType.both,
  }) : super(key: key);

  final ShareIconType shareIconType;
  final VoidCallback onBlindedPressed;
  final VoidCallback onUnblindedPressed;
  final BlindType blindType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
              height: blindType == BlindType.both ? 165.h : 84.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
                color: Color(0xFF1C6086),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                  child: Column(
                    children: [
                      if (blindType == BlindType.both) ...[
                        BlindedButton(
                          onPressed: onBlindedPressed,
                          shareIconType: shareIconType,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Divider(
                            thickness: 1,
                            height: 1,
                            color: Color(0xFF78AECC),
                          ),
                        ),
                      ],
                      BlindedButton(
                        type: BlindedButtonType.unblinded,
                        onPressed: onUnblindedPressed,
                        shareIconType: shareIconType,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BlindedButtonType {
  blinded,
  unblinded,
}

class BlindedButton extends StatelessWidget {
  const BlindedButton({
    Key key,
    this.type = BlindedButtonType.blinded,
    this.onPressed,
    this.shareIconType,
  }) : super(key: key);

  final BlindedButtonType type;
  final VoidCallback onPressed;
  final ShareIconType shareIconType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        child: Container(
          height: 44.h,
          child: Column(
            children: [
              Spacer(),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: type == BlindedButtonType.blinded
                        ? SvgPicture.asset(
                            'assets/blinded.svg',
                            width: 22.w,
                            height: 20.w,
                          )
                        : SvgPicture.asset(
                            'assets/unblinded.svg',
                            width: 22.w,
                            height: 16.w,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      type == BlindedButtonType.blinded
                          ? 'Blinded data'.tr()
                          : 'Unblinded data'.tr(),
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: shareIconType == ShareIconType.share
                        ? SvgPicture.asset(
                            'assets/share3.svg',
                            width: 24.w,
                            height: 24.w,
                          )
                        : SvgPicture.asset(
                            'assets/link.svg',
                            width: 24.w,
                            height: 24.w,
                          ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
