import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';

enum EmptyRequestLogoIcon {
  male,
  ok,
}

class EmptyRequestsLogoContainer extends StatelessWidget {
  const EmptyRequestsLogoContainer({
    super.key,
    this.icon = EmptyRequestLogoIcon.male,
    this.opacity = 1,
  });

  final EmptyRequestLogoIcon icon;
  final double opacity;

  Widget getIcon() {
    Widget internalIcon;
    switch (icon) {
      case EmptyRequestLogoIcon.male:
        internalIcon = ClipOval(
          child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: SvgPicture.asset('assets/avatar.svg'),
          ),
        );
        break;
      case EmptyRequestLogoIcon.ok:
        internalIcon = Center(
          child: SvgPicture.asset(
            'assets/success.svg',
            width: 18.w,
            height: 18.w,
          ),
        );
        break;
    }

    return internalIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 198.w,
        height: 84.h,
        decoration: BoxDecoration(
          color: const Color(0xFF167399),
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF135579),
                  border: Border.all(
                    color: const Color(0xFF00C5FF),
                    width: 2.r,
                  ),
                ),
                child: getIcon(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    EmptyTextContainer(
                      width: 26.w,
                      height: 6.h,
                      color: const Color(0xFF135579),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: EmptyTextContainer(
                        width: 60.w,
                        height: 6.h,
                        color: const Color(0xFF135579),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: EmptyTextContainer(
                    width: 95.w,
                    height: 6.h,
                    color: const Color(0xFF135579),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 11.h),
                  child: Row(
                    children: [
                      EmptyTextContainer(
                        width: 50.w,
                        height: 14.h,
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color(0xFF00C5FF), width: 2.w),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: EmptyTextContainer(
                          width: 50.w,
                          height: 14.h,
                          color: const Color(0xFF00C5FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
