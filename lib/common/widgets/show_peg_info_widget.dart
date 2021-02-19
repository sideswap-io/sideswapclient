import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/models/wallet.dart';

class ShowPegInfoWidget extends StatefulWidget {
  const ShowPegInfoWidget({
    Key key,
    @required this.onChanged,
    @required this.text,
  }) : super(key: key);

  final ValueChanged<bool> onChanged;
  final String text;

  @override
  _ShowPegInfoWidgetState createState() => _ShowPegInfoWidgetState();
}

class _ShowPegInfoWidgetState extends State<ShowPegInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 390.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.w),
        ),
        color: Color(0xFF1C6086),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28.w,
              child: SvgPicture.asset(
                'assets/info.svg',
                width: 13.w,
                height: 32.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Container(
                height: 66.h,
                child: SingleChildScrollView(
                  child: Text(
                    widget.text,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22.h),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFF357CA4),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 11.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomCheckBox(
                    onChanged: widget.onChanged,
                  ),
                  Text(
                    "Don't show again".tr(),
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFF357CA4),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: CustomBigButton(
                width: 295.w,
                height: 54.h,
                text: 'OK'.tr(),
                backgroundColor: Color(0xFF00C5FF),
                onPressed: () {
                  Navigator.of(
                          context
                              .read(walletProvider)
                              .navigatorKey
                              .currentContext,
                          rootNavigator: true)
                      .pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
